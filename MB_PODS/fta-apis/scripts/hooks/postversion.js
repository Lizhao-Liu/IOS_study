const notifier = require('node-notifier')

function notice() {
  notifier.notify({
    title: 'FTA View版本升级成功',
    message: '请及时进行发布并回合DEV分支',
  })
  console.log('Tip：版本升级成功，请及时进行发布并回合DEV分支')
}

notice()
