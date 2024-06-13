const { execSync } = require('child_process')
const ENV = {
  dev: {
    site: 'https://dev-fta.amh-group.com/view/#/',
    name: 'DEV',
  },
  beta: {
    site: 'https://qa-fta.amh-group.com/view/#/',
    name: 'QA',
  },
  prod: {
    site: 'https://fta.amh-group.com/view/#/',
    name: '生产',
  },
}

function postDeploy() {
  const codeEnv = process.argv[2] || 'dev'
  const data = ENV[codeEnv]
  try {
    const log = execSync('git log -3 --pretty=%B').toString()
    execSync(`curl 'https://oapi.dingtalk.com/robot/send?access_token=f06d058044555551c9756e7896cacf3bdb6ac3b7e1434efe0274e045e99a6a15' \
    -H 'Content-Type: application/json' \
    -d '{"msgtype": "text","text": {"content":"FTA View官网${data.name}环境已发布\n访问地址：${data.site}\n近三次git提交记录：\n${log}"},"at": {"isAtAll": false}}'`)
  } catch (e) {
    console.log('广播官网发布失败')
  }
}

postDeploy()
