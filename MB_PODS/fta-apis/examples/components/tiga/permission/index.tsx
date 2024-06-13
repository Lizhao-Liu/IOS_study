/**
 * title: 'Permission 权限'
 * componentName: 'Permission'
 * des: '权限检查和申请'
 * previewUrl: 'components/tiga/permission'
 * materialType: 'component'
 * package: '@fta/components-permission'
 */
import { Picker, Text, Textarea } from '@fta/components'
import { Button, DemoBlock, Gap, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { View } from '@tarojs/components'
import React, { useState } from 'react'

const data = [
  'calendar',
  'camera',
  'contacts',
  'location',
  'locationAlways',
  'locationWhenInUse',
  'mediaLibrary',
  'microphone',
  'phone',
  'photos',
  'photosAddOnly',
  'reminders',
  'sensors',
  'sms',
  'speech',
  'storage',
  'ignoreBatteryOptimizations',
  'notification',
  'accessMediaLocation',
  'activityRecognition',
  'manageExternalStorage',
  'systemAlertWindow',
  'requestInstallPackages',
  'appTrackingTransparency',
  'criticalAlerts',
  'accessNotificationPolicy',
  'bluetoothScan',
  'bluetoothAdvertise',
  'bluetoothConnect',
  'nearbyWifiDevices',
  'videos',
  'audio',
  'scheduleExactAlarm',
]

const dataMap: { [key: string]: number } = {
  calendar: 0,
  camera: 1,
  contacts: 2,
  location: 3,
  locationAlways: 4,
  locationWhenInUse: 5,
  mediaLibrary: 6,
  microphone: 7,
  phone: 8,
  photos: 9,
  photosAddOnly: 10,
  reminders: 11,
  sensors: 12,
  sms: 13,
  speech: 14,
  storage: 15,
  ignoreBatteryOptimizations: 16,
  notification: 17,
  accessMediaLocation: 18,
  activityRecognition: 19,
  bluetooth: 21,
  manageExternalStorage: 22,
  systemAlertWindow: 23,
  requestInstallPackages: 24,
  appTrackingTransparency: 25,
  criticalAlerts: 26,
  accessNotificationPolicy: 27,
  bluetoothScan: 28,
  bluetoothAdvertise: 29,
  calebluetoothConnectndar: 30,
  nearbyWifiDevices: 31,
  videos: 32,
  audio: 33,
  scheduleExactAlarm: 34,
}

export default (): JSX.Element => {
  const context = useThreshContext()

  let ref1: any
  const ref2 = React.createRef()

  const [index, setIndex] = useState(0)
  const [result, setResult] = useState('')

  function onChange(newVal: number) {
    console.log('onChange', newVal)
  }

  function onConfirm(newVal: number) {
    console.log('onConfirm', newVal)
    setIndex(newVal)
  }

  return (
    <Layout title='权限' qrcode='components/${type}/${name}/index'>
      <View>
        <Text strong style={{ display: 'flex', alignItems: 'center' }}>
          {data[index]}
        </Text>
        <DemoBlock label='' pure>
          <Button
            onClick={() => {
              console.log('button clicked')
              const per = data[index]
              Tiga.Permission.checkPermission({
                context: context,
                permission: dataMap[per],
              })
                .then((res) => {
                  console.log(JSON.stringify(res))
                  setResult(JSON.stringify(res))
                })
                .catch((err) => {
                  console.log(JSON.stringify(err))
                  setResult(JSON.stringify(err))
                })
            }}>
            检查权限
          </Button>
        </DemoBlock>
        <DemoBlock label='' pure>
          <Button
            onClick={() => {
              console.log('button clicked' + Tiga.Permission.Services.location)
              Tiga.Permission.checkService({
                context: context,
                service: Tiga.Permission.Permissions.location,
              })
                .then((res) => {
                  if (res.status == Tiga.Permission.ServiceStatus.usable) {
                    console.log('定位服务可用')
                  }
                  console.log(JSON.stringify(res))
                  setResult(JSON.stringify(res))
                })
                .catch((err) => {
                  console.log(JSON.stringify(err))
                  setResult(JSON.stringify(err))
                })
            }}>
            服务检查(定位)
          </Button>
        </DemoBlock>
        <DemoBlock label='' pure>
          <Button
            onClick={() => {
              console.log('button clicked' + Tiga.Permission.Services.location)
              Tiga.Permission.checkService({
                context: context,
                service: Tiga.Permission.Permissions.location,
              })
                .then((res) => {
                  if (res.status == Tiga.Permission.ServiceStatus.usable) {
                    console.log('定位服务可用')
                  }
                  console.log(JSON.stringify(res))
                  setResult(JSON.stringify(res))
                })
                .catch((err) => {
                  console.log(JSON.stringify(err))
                  setResult(JSON.stringify(err))
                })
            }}>
            服务检查(无服务)
          </Button>
        </DemoBlock>
        <DemoBlock label='' pure>
          <Button
            onClick={() => {
              console.log('button clicked')

              Tiga.Permission.requestPermission({
                context: context,
                permission: dataMap[data[index]],
                topHint: '测试',
                rationale: '请到设置页面中打开该权限',
              })
                .then((res) => {
                  console.log(JSON.stringify(res))
                  setResult(JSON.stringify(res))
                })
                .catch((err) => {
                  console.log(JSON.stringify(err))
                  setResult(JSON.stringify(err))
                })
            }}>
            权限请求
          </Button>
        </DemoBlock>

        <DemoBlock label='' pure>
          <List>
            <ListItem title='类型选择' onClick={() => ref1.show()} />
          </List>
        </DemoBlock>
        <Textarea value={result} disabled={true} count={false} onChange={() => {}} autoHeight />
        <Gap />
        <Picker
          title='请选择类型'
          ref={(ref: any) => (ref1 = ref)}
          value={0}
          mode='selector'
          range={data}
          onConfirm={onConfirm}
          onChange={onChange}
        />
      </View>
    </Layout>
  )
}
