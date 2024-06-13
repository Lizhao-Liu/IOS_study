/**
 * title: '电话'
 * componentName: 'System'
 * des: '系统设置'
 * previewUrl: 'components/tiga/system'
 * materialType: 'component'
 * package: '@fta/components-system'
 */
import { Button, DemoBlock, Gap, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { View } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  const listener: Tiga.System.PhoneObserverCallBack = function (res: any) {
    console.log(`第一个：${JSON.stringify(res)}`)
  }
  const listener2: Tiga.System.PhoneObserverCallBack = function (res: any) {
    console.log(`第二个：${JSON.stringify(res)}`)
  }
  return (
    <Layout title='phone' qrcode='components/tiga/system/phone' style={{ flex: 1 }}>
      <DemoBlock label='Taro.makePhoneCall' pure>
        <Button
          onClick={() => {
            Taro.makePhoneCall({
              context: context,
              phoneNumber: '911',
              directCall: true,
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
          拨打电话
        </Button>
      </DemoBlock>
      <DemoBlock label='电话状态监听' pure>
        <View style={{ display: 'flex', flexDirection: 'column' }}>
          <View style={{ display: 'flex', flexDirection: 'row' }}>
            <Button
              onClick={() => {
                Tiga.System.onCallStatusChange({
                  context: context,
                  callback: listener,
                })
                  .then((res) => {
                    console.log(res)
                  })
                  .catch((err) => {
                    console.log(err)
                  })
              }}>
              添加电话状态监听
            </Button>
            <Button
              onClick={() => {
                Tiga.System.onCallStatusChange({
                  context: context,
                  callback: listener2,
                })
                  .then((res) => {
                    console.log(res)
                  })
                  .catch((err) => {
                    console.log(err)
                  })
              }}>
              添加电话状态监听2
            </Button>
          </View>
          <Gap></Gap>
          <View style={{ display: 'flex', flexDirection: 'row', top: 10 }}>
            <Button
              onClick={() => {
                Tiga.System.offCallStatusChange({
                  context: context,
                  callback: listener,
                })
                  .then((res) => {
                    console.log(res)
                  })
                  .catch((err) => {
                    console.log(err)
                  })
              }}>
              移除电话监听
            </Button>
            <Button
              onClick={() => {
                Tiga.System.offCallStatusChange({
                  context: context,
                  callback: listener2,
                })
                  .then((res) => {
                    console.log(res)
                  })
                  .catch((err) => {
                    console.log(err)
                  })
              }}>
              移除电话监听2
            </Button>
          </View>
        </View>
      </DemoBlock>
    </Layout>
  )
}
