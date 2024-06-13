/**
 * title: '震动'
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
    <Layout title='vibrate' qrcode='components/tiga/system/vibrate' style={{ flex: 1 }}>
      <DemoBlock style={{ flex: 1, flexDirection: 'row' }} label='震动' pure>
        <Button
          onClick={() => {
            Taro.vibrateLong({
              context: context,
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          长震动
        </Button>
        <Button
          onClick={() => {
            Taro.vibrateShort({
              context: context,
              type: 'light', //heavy medium light
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          短震动
        </Button>
      </DemoBlock>
    </Layout>
  )
}
