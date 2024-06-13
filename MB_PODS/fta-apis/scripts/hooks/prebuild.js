const chalk = require('chalk')
const { getCurrentGitBranch } = require('./version-control')

function prebuild() {
  const deployEnv = process.env.DEPLOY_ENV || 'dev'
  const branch = getCurrentGitBranch()
  if ((deployEnv === 'dev' && branch == 'master') || (deployEnv === 'prod' && branch == 'dev')) {
    // dev分支不能运行生产构建，master分支不能运行dev构建
    console.log(
      chalk.red(`
    当前git分支为${branch}，不能打包${deployEnv}环境的代码！

    请切换到指定分支进行打包
    `)
    )

    throw new Error(
      'Current git branch is not compatible with its deploy environment, please checkout the right branch'
    )
  }
}

prebuild()
