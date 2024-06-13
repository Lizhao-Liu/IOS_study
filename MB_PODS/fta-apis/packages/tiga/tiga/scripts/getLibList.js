/* eslint-disable @typescript-eslint/no-var-requires */
// 依据目录结构生成 libList.js，该文件下的 api，会通过 babel plugin 替换到 Taro 的 api 中

const { readdirSync, readFileSync, writeFileSync } = require('fs')
const fs = require('fs-extra')
const minimist = require('minimist')
const path = require('path')
const getDirectories = (source) =>
  readdirSync(source, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory())
    .map((dirent) => dirent.name)

const exclude = ['style', 'types', 'utils']

const args = minimist(process.argv.slice(2), {
  api: ['api'],
})

const pkgRoot = path.resolve(__dirname, '../')

const dependencies = JSON.parse(
  readFileSync(path.resolve(__dirname, '../package.json'), 'utf8')
).dependencies

let subModules = ''
Object.keys(dependencies)
  .filter((key) => key.startsWith('@fta/tiga-'))
  .forEach((dependency) => {
    subModules += 'try {\n'
    subModules += `  module.exports['${dependency}'] = require('${dependency}/libList')\n`
    subModules += '} catch (ignored) {}\n'
  })

const info = '// 由 getLibList.js 脚本生成, 不要进行手动修改, 请不要手动修改'
const taroSrcPath = path.join(pkgRoot, 'src/taro')
dirs = []
if (fs.existsSync(taroSrcPath)) {
  dirs = getDirectories(taroSrcPath).filter((dir) => !exclude.includes(dir))
}
console.log(`dirs: ${dirs}\n`)
const fileString = `${info}
module.exports = {
  '@fta/tiga': ${JSON.stringify(dirs, null, 2).replace(/"/g, "'")}
}\n
${subModules}`

// todo
const filePath = path.join(pkgRoot, 'libList.js')
fs.ensureFileSync(filePath)

writeFileSync(filePath, fileString)

console.log('done: echo native lib list tolibList.js\n')
