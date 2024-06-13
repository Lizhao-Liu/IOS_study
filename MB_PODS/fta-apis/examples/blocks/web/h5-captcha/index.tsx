import Captcha from '@fta/blocks-web-captcha'
import { captchaPayload } from '@fta/blocks-web-captcha/src/mock'
import React, { useEffect } from 'react'
import { AtButton } from 'taro-ui'

function initCaptcha() {
  Captcha.init({
    env: 'beta',
    enableMouse: true,
    payload: captchaPayload,
    identity: 'captcha',
    throttle: 30,
  }).then(() => {
    console.log('验证成功')
  })
}

export default () => {
  useEffect(initCaptcha, [])
  return (
    <AtButton customStyle='margin-top:40vh' onClick={initCaptcha}>
      点击触发风控验证码
    </AtButton>
  )
}
