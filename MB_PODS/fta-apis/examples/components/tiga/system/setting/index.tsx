/**
 * title: '系统'
 * componentName: 'System'
 * des: '系统设置'
 * previewUrl: 'components/tiga/system'
 * materialType: 'component'
 * package: '@fta/components-system'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'
import SystemInfoBlock from '../systeminfoDemo'

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='setting' qrcode='components/tiga/system/setting' style={{ flex: 1 }}>
      <DemoBlock label='app.base.openSystemSetting' pure>
        <Button
          onClick={() => {
            console.log('打开设置页面')
            Tiga.System.openSystemSetting({
              context: context,
              type: 'push',
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
          打开设置页面
        </Button>
      </DemoBlock>
      <SystemInfoBlock></SystemInfoBlock>
    </Layout>
  )
}
