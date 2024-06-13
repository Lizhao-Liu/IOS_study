import { Captcha, Example, mockParams as captchaMockParams } from '@fta/blocks-miniapp-captcha'
import React, { useState } from 'react'
import { AtButton } from 'taro-ui'

export default () => {
  const [visible, toggleVisible] = useState(true)
  const [show, toggleShow] = useState(false)

  return (
    <>
      <AtButton onClick={() => toggleVisible(true)}>点击触发风控验证码</AtButton>
      <div>
        <Captcha
          enableMouse
          env='dev'
          identity='captcha'
          payload={captchaMockParams}
          visible={visible}
          onSuccess={() => toggleVisible(false)}
        />
      </div>

      <AtButton customStyle={{ marginTop: '20vh' }} onClick={() => toggleShow(true)}>
        点击查看Example组件实例
      </AtButton>

      {show ? <Example /> : null}
    </>
  )
}
