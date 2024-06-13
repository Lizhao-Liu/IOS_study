/**
 * title: '剪贴板'
 * componentName: 'System'
 * des: '系统设置'
 * previewUrl: 'components/tiga/system'
 * materialType: 'component'
 * package: '@fta/components-system'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='clipboard' qrcode='components/tiga/system/clipboard' style={{ flex: 1 }}>
      <DemoBlock style={{ flex: 1, flexDirection: 'row' }} label='粘贴板' pure>
        <Button
          onClick={() => {
            Taro.setClipboardData({
              context: context,
              data: 'hello world',
              success(res) {
                console.log('success' + JSON.stringify(res))
              },
              fail(res) {
                console.log('fail' + JSON.stringify(res))
              },
              complete(res) {
                console.log('complete' + JSON.stringify(res))
              },
            })
          }}>
          设置粘贴板内容
        </Button>
        <Button
          onClick={() => {
            Taro.getClipboardData({
              context: context,
              success: (res) => {
                console.log('success' + JSON.stringify(res))
              },
              fail: (res) => {
                console.log('fail' + JSON.stringify(res))
              },
              complete: (res) => {
                console.log('complete' + JSON.stringify(res))
              },
            })
          }}>
          获取粘贴板内容
        </Button>
      </DemoBlock>
    </Layout>
  )
}
