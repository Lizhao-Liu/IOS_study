/**
 * title: '联系人'
 * componentName: 'System'
 * des: '系统设置'
 * previewUrl: 'components/tiga/system'
 * materialType: 'component'
 * package: '@fta/components-system'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='contact' qrcode='components/tiga/system/contact' style={{ flex: 1 }}>
      <DemoBlock style={{ flex: 1, flexDirection: 'row' }} label='联系人' pure>
        <Button
          onClick={() => {
            Taro.chooseContact({
              context: context,
              permissionRequest: true,
              rationale: '请在设置页中打开该权限',
              topHint: '666',
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
          选择联系人
        </Button>
        <Button
          onClick={() => {
            Tiga.System.getAllContacts({
              context: context,
              permissionRequest: true,
              rationale: '请在设置页中打开该权限',
              topHint: '666',
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
          获取所有联系人
        </Button>
      </DemoBlock>
    </Layout>
  )
}
