import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()

  function redirectToOverall () {
    Taro.redirectTo({ url: '/components/overall/overall', context }).catch((err) =>
    console.error(err)
  )
  }

  return (
    <Layout title='Navigator' qrcode='components/tiga/navigator/redirect/index'>
      <DemoBlock label='页面重定向' pure>
        <Button onClick={redirectToOverall}>
          页面重定向到overall总览页
        </Button>
      </DemoBlock>
    </Layout>
  )
}
