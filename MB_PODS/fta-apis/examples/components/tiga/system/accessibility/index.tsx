/**
 * title: '无障碍'
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
    <Layout title='accessibility' qrcode='components/tiga/system/accessibility' style={{ flex: 1 }}>
      <DemoBlock style={{ flex: 1, flexDirection: 'row' }} label='是否开启辅助模式' pure>
        <Button
          onClick={() => {
            Taro.checkIsOpenAccessibility({
              context: context,
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          是否开启辅助模式
        </Button>
      </DemoBlock>
    </Layout>
  )
}
