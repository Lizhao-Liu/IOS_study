import chalk from 'chalk'
import ejs from 'ejs'
import fse from 'fs-extra'
import * as inquirer from 'inquirer'
import klaw from 'klaw'
import ora from 'ora'
import pascalCase from 'pascalCase'
import path, { resolve } from 'path'
// @ts-ignore
import prettier from 'prettier'
// @ts-ignore
import overview from '../assets/overview.json'

const cwd = process.cwd()

type Question = inquirer.QuestionCollection<inquirer.Answers>

type ComponentType = keyof typeof overview.components

/** overview.json中可能已经声明过组件信息 */
let componentInfo: any

/** 检查组件是否已经存在 */
function checkIfComponentExist(name: string) {
  const componentList = Object.values(overview.components).reduce(
    (prev, cur) => prev.concat(cur.list as typeof overview.components.tiga.list),
    [] as typeof overview.components.tiga.list
  )
  componentInfo = componentList.find((c) => c.name.toLowerCase() === name.toLowerCase())
  return componentInfo?.author
}

/** 检查作者是否已经存在 */
function checkIfContributorExist(author: string) {
  return overview.contributors[author as 'official']
}

/** 获取组件类型中文名 */
function getComponentZhType(type: ComponentType) {
  return overview.components[type].name
}

type Contributor = {
  name: string
  dingTalk: string
  avatar: string
}

/** 增加新的contributor */
function joinNewContributor(key: string, contributor: Contributor) {
  //@ts-ignore
  overview.contributors[key] = contributor
}

/** 增加新的组件 */
function joinNewComponent(type: ComponentType, info: any) {
  if (componentInfo) {
    // 如果json文件已经有改组件信息，merge即可
    Object.assign(componentInfo, info)
  } else {
    // 新建组件信息
    overview.components[type].list.push(info)
  }
  rewriteOverview(overview)
}
/** 更新overview.json */
function rewriteOverview(overviewJson: typeof overview) {
  const jsonString = prettier.format(JSON.stringify(overviewJson), {
    parser: 'json',
    ...prettierConfig,
  })
  fse.writeFileSync(resolve('./assets/overview.json'), jsonString)
}

type Support = 'h5' | 'rn' | 'alipay' | 'toutiao' | 'weapp' | 'thresh' | 'mw' | 'logic'

/** 是否是跨端组件，只要支持rn，并且包含其他任一端，默认标记为跨端组件 */
function isCrossComponent(supports: Support[]) {
  return supports.length >= 2 && supports.includes('rn')
}

const prettierConfig = fse.readJSONSync(resolve(cwd, '.prettierrc')) as object
const tigaPackagePath = path.join(cwd, 'packages/tiga')
const proPackagesPath = path.join(cwd, 'packages/components-profession')
const miniPackagePath = path.join(cwd, 'packages/components-mini')
const basicPackagePath = path.join(cwd, 'packages/components-basic')

const docsPath = path.join(cwd, 'docs', 'components')
const examplesPath = path.join(cwd, 'examples/components')
const appConfigPath = path.join(cwd, 'examples/app.config.ts')

const tigaUtilVersion = require('@fta/tiga-util/package.json').version

async function ask() {
  const prompts: Question[] = []

  prompts.push({
    type: 'input',
    name: 'name',
    message: '请输 tiga 模块名称！(不需要包括@fta/tiga)',
    validate(input: string) {
      if (!input) {
        return 'tiga module 名不能为空！'
      }
      if (checkIfComponentExist(input)) {
        return '已经存在同名 tiga 模块，请换一个模块名！'
      }
      return true
    },
  })

  prompts.push({
    type: 'input',
    name: 'zh_name',
    message: '请输入 tiga 模块中文名！',
  })

  prompts.push({
    type: 'input',
    name: 'desc',
    message: '请输入 tiga 模块介绍！',
  })

  const supports: { name: string; value: Support }[] = [
    {
      name: 'H5',
      value: 'h5',
    },
    {
      name: '微信小程序',
      value: 'weapp',
    },
    {
      name: '阿里系小程序',
      value: 'alipay',
    },
    {
      name: '字节系小程序',
      value: 'toutiao',
    },
    {
      name: '满帮React Native',
      value: 'rn',
    },
    {
      name: '满帮Thresh',
      value: 'thresh',
    },
    {
      name: '微前端',
      value: 'mw',
    },
    {
      name: 'Global Logic',
      value: 'logic',
    },
  ]

  prompts.push({
    type: 'checkbox',
    name: 'support',
    message: '请选择 tiga 模块支持的平台',
    choices: supports,
  })

  prompts.push({
    type: 'input',
    name: 'author',
    message: '请输入您的邮箱前缀（如jian.sun1）',
  })

  const answers: TAnswer = (await inquirer.prompt(prompts)) as TAnswer

  answers.type = 'tiga'

  let authorInfo = checkIfContributorExist(answers.author)
  if (!authorInfo) {
    authorInfo = (await askForNewContributorInfo()) as Contributor
    joinNewContributor(answers.author, authorInfo as Contributor)
  }

  const upName = pascalCase(answers.name)
  const cross = isCrossComponent(answers.support)
  joinNewComponent(answers.type as ComponentType, {
    cross,
    name: upName,
    remark: answers.zh_name,
    author: answers.author,
    snapshot: '',
    support: answers.support,
  })

  const result = {
    ...answers,
    cross, // 是否跨端
    authorInfo, // 作者信息
    type: answers.type,
    tigaUtilVersion: tigaUtilVersion,
    upname: upName,
    zh_cn_type: getComponentZhType(answers.type as ComponentType),
  }
  return result
}

async function askForNewContributorInfo() {
  const questions: Question[] = [
    {
      type: 'input',
      name: 'name',
      message: '检测到您是位新人，请输入真实姓名',
    },
    {
      type: 'input',
      name: 'avatar',
      message:
        '请输入您的头像CDN地址(可选上传地址：https://boss.amh-group.com/public-service-admin/?#/fileCenter/upload)',
    },
    {
      type: 'input',
      name: 'dingTalk',
      message: '请输入您的钉钉号（个人资料页查看）',
    },
  ]
  return await inquirer.prompt(questions)
}

function generateTigaModule(options: TOptions) {
  return new Promise((resolve, reject) => {
    klaw(path.join(__dirname, 'tpl', 'components'))
      .on('data', (item) => {
        if (item.stats.isFile()) {
          ejs.renderFile(item.path, options, (err: any, result: any) => {
            const relativePath = path.relative(
              path.join(__dirname, 'tpl', 'components'),
              item.path.replace('.ejs', '')
            )
            const targetPath = path.join(tigaPackagePath, options.name, relativePath)
            fse.ensureFileSync(targetPath)
            fse.writeFile(targetPath, result)
          })
        }
      })
      .on('end', async () => {
        resolve('generateTigaModule end')
      })
  })
}

function generateBasicComponent(options: TOptions) {
  return new Promise((resolve, reject) => {
    klaw(path.join(__dirname, 'tpl', 'basic-components'))
      .on('data', (item) => {
        if (item.stats.isFile()) {
          ejs.renderFile(item.path, options, (err: any, result: any) => {
            const relativePath = path.relative(
              path.join(__dirname, 'tpl', 'basic-components'),
              item.path.replace('.ejs', '')
            )
            const targetPath = path.join(basicPackagePath, 'components', options.name, relativePath)
            fse.ensureFileSync(targetPath)
            fse.writeFile(targetPath, result)
          })
        }
      })
      .on('end', async () => {
        // 重命名
        const pathname = path.resolve(basicPackagePath, 'components', options.name)
        fse.renameSync(pathname + '/index.tsx', pathname + '/' + options.name + '.tsx')
        // 追加dts文件和ts文件导出
        const dtsPath = path.resolve(basicPackagePath, 'types/index.d.ts')
        const entryPath = path.resolve(basicPackagePath, 'index.ts')
        fse.appendFileSync(
          dtsPath,
          `export { default as ${options.upname} } from './${options.name}'`
        )
        fse.appendFileSync(
          entryPath,
          `export { default as ${options.upname} } from './components/${options.name}'`
        )
        resolve('generateBasicComponent end')
      })
  })
}

function generateSingleFile(options: TOptions, tplPath: string, targetPath: string) {
  return new Promise((resolve, reject) => {
    const _tplPath = path.join(__dirname, tplPath)
    ejs.renderFile(_tplPath, options, (err: any, result: any) => {
      fse.ensureFileSync(targetPath)
      fse.writeFile(targetPath, result)
      resolve('generateSingleFile end')
    })
  })
}

function generateDocs(options: TOptions) {
  return new Promise((resolve, reject) => {
    const tplPath = path.join(__dirname, 'tpl', 'docs.ejs')
    ejs.renderFile(tplPath, options, (err: any, result: any) => {
      const targetPath = path.join(
        docsPath,
        options.type,
        // `${options.name}${path.parse(tplPath).ext}`
        `${options.name}.md`
      )
      fse.ensureFileSync(targetPath)
      fse.writeFile(targetPath, result)
      resolve('generateDocs end')
    })
  })
}

function generateExample(options: TOptions) {
  const relativePath = path.relative(docsPath, path.join(docsPath, options.type))
  return new Promise((resolve, reject) => {
    const tplPath = path.join(__dirname, 'tpl', 'example.ejs')
    ejs.renderFile(tplPath, options, (err: any, result: any) => {
      const targetPath = path.join(
        examplesPath,
        relativePath,
        // `${options.name}/index${path.parse(tplPath).ext}`
        `${options.name}/index.tsx`
      )
      fse.ensureFileSync(targetPath)
      fse.writeFile(targetPath, result)
      resolve('generateExample end')
    })
    const configPath = path.join(examplesPath, relativePath, `${options.name}/index.config.ts`)
    fse.ensureFileSync(configPath)
    const configContent = `export default {
      disableScroll: true,
      navigationStyle: 'custom',
    }`
    fse.writeFileSync(configPath, configContent)
  })
}

/** 追加组件路径到app.config.ts */
function appendAppConfig(ans: TAnswer) {
  const { type, name, cross } = ans
  const comment = `/** ${cross ? 'cross' : 'mini'} flag */`
  const path = `    'components/${type}/${name}/index',`
  const str = fse.readFileSync(appConfigPath).toString()
  const idx = str.indexOf(comment)
  if (idx > -1) {
    const trunkIdx = idx + comment.length
    fse.writeFileSync(appConfigPath, str.slice(0, trunkIdx) + '\n' + path + str.slice(trunkIdx))
  }
}

function appendModuleDependency(options: TOptions) {
  const tigaPackageJsonFilePath = path.join(tigaPackagePath, 'tiga/package.json')
  const tigaPackageJsonStr = fse.readFileSync(tigaPackageJsonFilePath, 'utf8')
  const packageJson = JSON.parse(tigaPackageJsonStr)

  const tigaSubModule = {
    [`@fta/tiga-${options.name}`]: `${tigaUtilVersion}`,
  }

  packageJson.dependencies = {
    ...packageJson.dependencies,
    ...tigaSubModule,
  }

  fse.writeFileSync(tigaPackageJsonFilePath, JSON.stringify(packageJson, null, 2))

  const tigaEntranceFile = path.join(tigaPackagePath, 'tiga/src/tiga-submodules.ts')
  fse.appendFileSync(
    tigaEntranceFile,
    `export * as ${options.upname} from '@fta/tiga-${options.name}'`
  )
}

async function create() {
  const answers = await ask()
  const options: TOptions = {
    ...answers,
  }
  const spinner = ora(`初始化 tiga 模块:${options.zh_name}`).start()
  if (answers.type === 'tiga' || !answers.cross) {
    // tiga模块初始化
    await generateTigaModule(options)
  } else {
    // 基础组件初始化
    await generateBasicComponent(options)
    // 生成scss文件
    await generateSingleFile(
      options,
      'tpl/index.scss.ejs',
      basicPackagePath + '/style/components/' + options.name + '/index.scss'
    )
    // 生成dts文件
    await generateSingleFile(
      options,
      'tpl/index.d.ts.ejs',
      basicPackagePath + '/types/' + options.name + '.d.ts'
    )
  }
  await generateDocs(options)
  await generateExample(options)
  // 将组件加入app.config.ts
  appendAppConfig(options)
  // 往Tiga module中添加新增 module 依赖
  appendModuleDependency(options)

  spinner.succeed(`
  ${chalk.green(`模块 ${options.zh_name} 生成完成`)}

  Tiga模块路径：${chalk.yellow(getComponentPath(answers))}

  请在首次启动FTA View之前运行 ${chalk.red('`yarn bootstrap:lerna`')} 来关联依赖
  `)
}

/**
 * 获取生成组件的路径
 */
function getComponentPath(ans: TAnswer) {
  const { cross, type, name } = ans
  const prefix = 'packages/'
  let path
  if (type === 'tiga') {
    path = `tiga/${name}/`
  } else if (type === 'pro') {
    path = `components-profession/${name}/`
  } else if (cross) {
    path = `components-basic/components/${name}/`
  } else {
    path = `components-mini/${name}/`
  }
  return prefix + path
}

module.exports = create

type TAnswer = {
  type: string
  name: string
  upname: string
  zh_name: string
  author: string
  desc: string
  cross: boolean
  support: Support[]
}

type TOptions = TAnswer & {
  examplePath?: string
  docsPath?: string
}
