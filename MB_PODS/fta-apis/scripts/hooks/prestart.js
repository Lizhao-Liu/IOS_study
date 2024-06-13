const chalk = require('chalk')
const fse = require('fs-extra')
const resolve = require('path').resolve

const json = fse.existsSync(resolve(__dirname, './.stat.json'))
  ? require('./.stat.json')
  : { count: 0 }

function prestart() {
  if (++json.count < 6) {
    warn()
    notice()
    fse.writeFileSync(resolve(__dirname, './.stat.json'), JSON.stringify(json))
  }
}

function warn() {
  const yellow = chalk.yellow

  console.log(
    chalk.redBright(`
  ${chalk.whiteBright('初次使用或运行报错，请按以下步骤启动FTA View开发环境')}

  # 1. 安装基础依赖
  ${yellow('$ yarn')}

  # 2. 安装组件依赖：
  ${yellow('$ yarn bootstrap')}

  # 3. 构建组件：
  ${yellow('$ yarn build:packages')}

  # 4. 启动服务：
  ${yellow('$ yarn start')}
  `)
  )
}

function notice() {
  const yellow = chalk.yellow
  console.log(
    chalk.cyan(`
  需要创建新组件？运行${yellow('`npm run create`')}或${yellow('`yarn new`')}回车即可
    `)
  )
}

prestart()
