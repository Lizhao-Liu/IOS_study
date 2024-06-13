const { readFileSync, readdirSync, statSync, writeFileSync } = require('fs')
const { resolve } = require('path')
const cwd = process.cwd()
const styleMdPath = resolve(cwd, 'docs/components/style.md')
const mixinsPath = resolve(cwd, 'packages/components-basic/style/mixins/index.scss')
const mixinsLibsPath = resolve(mixinsPath, '../libs')
const remarkReg = /\/\*\s[A-Z][a-z]+([A-Z][a-z]+)?\s\*\//g

let styleMdContent

/**
 * 编译时自动在markdown添加scss变量
 */
function copyScssVariables() {
  const { componentMap: varMap, commonVars } = generateVariablesMap()
  const paths = walk(resolve(cwd, './docs/components'))
  paths.forEach(({ path, name }, i) => {
    writeVariables(path, name, varMap)
  })
  // console.log(commonVars, 'commonvars');
  processCommonVars(commonVars)
  console.log('SCSS变量写入markdown成功')
}

/**
 * 生成变量映射
 * @returns
 */
function generateVariablesMap() {
  let lines = readFileSync(
    resolve(cwd, './packages/components-basic/style/variables/default.scss')
  ).toString()
  // 去除zoom函数
  lines = lines.replace(/zoom\((\d+px)\)/g, ($, $1) => $1)
  const idx = lines.indexOf('组件变量')
  let commonVars = lines.slice(0, idx).replace(/@import\s+\'.*\';/g, '')
  const lidx = commonVars.lastIndexOf('!default;')
  commonVars = commonVars.slice(0, lidx) + ' !default;'
  lines = lines.slice(idx + 8)
  // 去除注释
  lines = lines.replace(/\/\/\s*.*/g, '')
  // 多个换行转换为一个换行
  lines = lines.replace(/(\n)+|(\r\n)+/g, '\n')
  let result
  const matchedList = []
  const componentMap = {}
  while ((result = remarkReg.exec(lines))) {
    const match = result[0].slice(3, -3)
    const index = result.index
    // console.log('match', match, index);
    matchedList.push({
      match,
      index,
      offset: index + result[0].length,
    })
  }
  matchedList.forEach(({ match, index, offset }, i, list) => {
    const end = list[i + 1] ? list[i + 1].index : Number.POSITIVE_INFINITY
    componentMap[match] = lines.slice(offset, end)
  })

  return { componentMap, commonVars }
}

function processCommonVars(vars) {
  const idx = styleMdContent.indexOf('## 默认全局样式\n')
  if (idx > -1) {
    styleMdContent = styleMdContent.slice(0, idx)
  }
  styleMdContent += '## 默认全局样式\n' + '```scss\n' + vars + '\n```\n'
}

// function readCachedFile(path){
//   return readCachedFile[path] || (readCachedFile[path] = readFileSync(path).toString())
// }

/**
 * 遍历markdown文件
 */
function walk(dir) {
  const results = []
  const list = readdirSync(dir)
  list.forEach(function (file) {
    const name = file
    file = dir + '/' + file
    const stat = statSync(file)
    if (stat && stat.isDirectory()) {
      /* Recurse into a subdirectory */
      results.push(...walk(file))
    } else if (endsWithMD(name)) {
      /* Is a file */
      results.push({
        path: file,
        name: hydrate(name),
      })
    }
  })
  return results
}

function writeVariables(path, name, map) {
  const varString = map[name]

  if (!varString) return path.includes('pro/') || console.log(`${name}组件未支持SCSS变量`)
  const fileString = readFileSync(path).toString()
  const index = fileString.indexOf('\n## SCSS 变量')
  writeFileSync(
    path,
    fileString.slice(0, index === -1 ? void 0 : index) +
      '\n## SCSS 变量\n' +
      '```scss' +
      varString.replace(/\s?!default/g, '') +
      '\n```'
  )
}

/**
 *
 * @param {string} name
 * @returns
 */
function endsWithMD(name) {
  return name.endsWith('.md')
}

/**
 * 变量名转大写
 * @param {string} name
 * @returns
 */
function hydrate(name) {
  const str = name.slice(0, -3)
  return str[0].toUpperCase() + str.slice(1).replace(/-([a-z])/g, (match, $) => $.toUpperCase())
}

/**
 * 拷贝mixins到style.md
 */
function copyScssMixins() {
  const importedMixins = readFileSync(mixinsPath).toString()
  styleMdContent +=
    '\n## Mixins & Functions' +
    '\n' +
    `
  \`\`\`scss
  /* mixins/index.scss */
  ${importedMixins}
  \`\`\`
  `
  const list = readdirSync(mixinsLibsPath)
  for (const name of list) {
    const filePath = mixinsLibsPath + '/' + name
    const fileString = readFileSync(filePath).toString()
    styleMdContent += `\n### ${name}
  \`\`\`scss
  ${fileString}
  \`\`\`
    `
  }
  writeFileSync(styleMdPath, styleMdContent)
}

function main() {
  styleMdContent = readFileSync(styleMdPath)
  copyScssVariables()
  copyScssMixins()
}

main()
