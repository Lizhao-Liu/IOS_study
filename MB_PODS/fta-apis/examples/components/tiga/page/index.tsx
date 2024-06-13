import { Button, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='Page' qrcode='components/${type}/${name}/index' style={{ flex: 1 }}>
      <Button
        onClick={() => {
          Taro.navigateTo({
            url: '/components/tiga/page/lifecycleReact/index',
            context,
          })
        }}>
        lifecycle React
      </Button>

      <Button
        onClick={() => {
          Taro.navigateTo({
            url: '/components/tiga/page/lifecycleMiniProgram/index',
            context,
          })
        }}>
        lifecycle Mini Program
      </Button>

      <Button
        onClick={() => {
          Taro.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: '#888888',
          })
        }}>
        Taro.setNavigationBarColor
      </Button>
    </Layout>
  )
}
