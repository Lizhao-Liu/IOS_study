/**
 * title: 'System 系统'
 * componentName: 'System'
 * des: '系统设置'
 * previewUrl: 'components/tiga/system'
 * materialType: 'component'
 * package: '@fta/components-system'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { View } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React from 'react'
import AudioVolumeBlock from './audioVolumeBlock'
import CalendarDemoBlock from './calendarDemo'
import NetworkStatusDemoBlock from './networkStatusDemo'
import ScreenDemoBlock from './screenDemo'
import SystemInfoBlock from './systeminfoDemo'

export default () => {
  const context = useThreshContext()
  const listener: Tiga.System.PhoneObserverCallBack = function (res: any) {
    console.log(`第一个：${JSON.stringify(res)}`)
  }
  const listener2: Tiga.System.PhoneObserverCallBack = function (res: any) {
    console.log(`第二个：${JSON.stringify(res)}`)
  }

  return (
    <Layout title='系统设置' qrcode='components/${type}/${name}/index' style={{ flex: 1 }}>
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
      <NetworkStatusDemoBlock></NetworkStatusDemoBlock>
      <ScreenDemoBlock></ScreenDemoBlock>
      <CalendarDemoBlock></CalendarDemoBlock>
      <SystemInfoBlock></SystemInfoBlock>
      <AudioVolumeBlock />
    </Layout>
  )
}
