/**
 * title: 'Apm APM'
 * componentName: 'Apm'
 * des: 'APM'
 * previewUrl: 'components/tiga/apm'
 * materialType: 'component'
 * package: '@fta/components-apm'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  const listener = function (res: any) {
    Taro.showModal({
      context,
      content: JSON.stringify(res, null, 2).substring(1, JSON.stringify(res).length - 1),
      title: '内存告警',
      showCancel: false,
    })
  }
  return (
    <Layout title='APM' qrcode='components/tiga/APM/index'>
      <DemoBlock label='Memory Warning' pure>
        <Button style={{ margin: 8 }} onClick={() => Taro.onMemoryWarning(listener)}>
          on Memory Warning
        </Button>
        <Button style={{ margin: 8 }} onClick={() => Taro.offMemoryWarning(listener)}>
          off Memory Warning
        </Button>
      </DemoBlock>

      {/* <DemoBlock label='CPU Usage' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() =>
            Tiga.APM.getCPUUsage({ context })
              .then((res: any) => {
                Taro.showModal({
                  context,
                  content: JSON.stringify(res, null, 2).replace('{', '').replace('}', ''),
                  title: 'cpu 使用信息',
                  showCancel: false,
                })
              })
              .catch((e: any) => {
                Taro.showModal({
                  context,
                  content: e.reason ? e.reason : '',
                  title: '失败',
                  showCancel: false,
                })
              })
          }>
          CPU Usage
        </Button>
      </DemoBlock> */}

      <DemoBlock label='Memory Usage' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() =>
            Tiga.APM.getMemoryUsage({ context })
              .then((res: any) => {
                Taro.showModal({
                  context,
                  content: JSON.stringify(res, null, 2).replace('{', '').replace('}', ''),
                  title: '内存使用信息',
                  showCancel: false,
                })
              })
              .catch((e: any) => {
                Taro.showModal({
                  context,
                  content: e.reason ? e.reason : '',
                  title: '失败',
                  showCancel: false,
                })
              })
          }>
          Memory Usage
        </Button>
      </DemoBlock>
      <DemoBlock label='Storage Usage' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() =>
            Tiga.APM.getStorageUsage({ context })
              .then((res: any) => {
                Taro.showModal({
                  context,
                  content: JSON.stringify(res, null, 2).replace('{', '').replace('}', ''),
                  title: '存储空间使用信息',
                  showCancel: false,
                })
              })
              .catch((e: any) => {
                Taro.showModal({
                  context,
                  content: e.reason ? e.reason : '',
                  title: '失败',
                  showCancel: false,
                })
              })
          }>
          Storage Usage
        </Button>
      </DemoBlock>
    </Layout>
  )
}
