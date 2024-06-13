/**
 * title: '短信'
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

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='sms' qrcode='components/tiga/system/sms' style={{ flex: 1 }}>
      <DemoBlock label='app.base.sendSms' pure>
        <Button
          onClick={() => {
            Tiga.System.sendSms({
              context: context,
              phone: '17088843854',
              content: 'hello world, 约基奇',
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
          发送短信
        </Button>
      </DemoBlock>
    </Layout>
  )
}
