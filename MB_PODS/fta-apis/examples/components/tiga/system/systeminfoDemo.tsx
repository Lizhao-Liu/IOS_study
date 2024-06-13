import { Textarea } from '@fta/components'
import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'

function SystemInfoBlock() {
  const context = useThreshContext()
  const [getSystemInfoAsync, setSystemASync] = useState('')

  return (
    <>
      <DemoBlock label='App base & 系统信息' pure>
        <Button
          onClick={() => {
            Taro.getSystemInfoAsync({
              context: context,
              success(res) {
                console.log('getSystemInfoAsync success: ', JSON.stringify(res))
                setSystemASync(JSON.stringify(res))
              },
              complete(res) {
                console.log('getSystemInfoAsync complete')
              },
              fail(res) {
                console.log('getSystemInfoAsync fail: ', JSON.stringify(res))
              },
            })
          }}>
          getSystemInfoAsync
        </Button>
        <Textarea
          disabled={false}
          autoHeight={true}
          value={getSystemInfoAsync}
          style={{ margin: 8 }}
          maxLength='9999'
          onChange={() => { }}
        />
      </DemoBlock>

      <DemoBlock label='快捷方法' pure>
        <Button
          onClick={() => {
            Tiga.System.isDriverAppAsync({
              context: context,
              success(isDriver) {
                console.log('isDriverAppAsync success: ', isDriver)
                Taro.showToast({
                  context: context,
                  title: isDriver ? '是司机App' : '不是司机App',
                })
              },
              complete(res) {
                console.log('isDriverAppAsync complete')
              },
              fail(res) {
                console.log('isDriverAppAsync fail: ', JSON.stringify(res))
                Taro.showToast({
                  context: context,
                  title: JSON.stringify(res),
                })
              },
            })
          }}>
          异步判司机端isDriverAppAsync
        </Button>

        <Button
          onClick={() => {
            Tiga.System.isShipperAppAsync({
              context: context,
              success(isShipper) {
                console.log('isShipperAppAsync success: ', isShipper)
                Taro.showToast({
                  context: context,
                  title: isShipper ? '是货主App' : '不是货主App',
                })
              },
              complete(res) {
                console.log('isShipperAppAsync complete')
              },
              fail(res) {
                console.log('isShipperAppAsync fail: ', JSON.stringify(res))
                Taro.showToast({
                  context: context,
                  title: JSON.stringify(res),
                })
              },
            })
          }}>
          异步判货主端isShipperAppAsync
        </Button>

        <Button
          onClick={() => {
            Tiga.System.getAppBrandAsync({
              context: context,
              success(appBrand) {
                console.log('getAppBrandAsync success: ', appBrand)
                Taro.showToast({
                  context: context,
                  title: appBrand,
                })
              },
              complete(res) {
                console.log('getAppBrandAsync complete')
              },
              fail(res) {
                console.log('getAppBrandAsync fail: ', JSON.stringify(res))
                Taro.showToast({
                  context: context,
                  title: JSON.stringify(res),
                })
              },
            })
          }}>
          异步获取App品牌 getAppBrandAsync
        </Button>

        <Button
          onClick={() => {
            const isiOS = Tiga.System.isiOS()
            console.log('isiOS: ', isiOS)
            Taro.showToast({
              context: context,
              title: isiOS ? '是iOS系统' : '不是iOS',
            })
          }}>
          同步获取是否是iOS
        </Button>

        <Button
          onClick={() => {
            const isAndroid = Tiga.System.isAndroid()
            Taro.showToast({
              context: context,
              title: isAndroid ? '是Android系统' : '不是Android',
            })
          }}>
          同步获取是否是Android
        </Button>
      </DemoBlock>
    </>
  )
  // const [getSystemInfoSync, setSystemSync] = useState('')
  // const [getSystemInfoAsync, setSystemASync] = useState('')
  // const [getSystemInfo, setSystemInfo] = useState('')

  // return (
  //   <>
  //     <DemoBlock label='App base & 系统信息' pure>
  //       <Button
  //         onClick={() => {
  //           const res = Taro.getSystemInfoSync()
  //           setSystemSync(JSON.stringify(res))
  //           console.log('getSystemInfoSync: ', res)
  //         }}>
  //         getSystemInfoSync
  //       </Button>
  //       <Textarea
  //         disabled={false}
  //         autoHeight={true}
  //         value={getSystemInfoSync}
  //         style={{ width: '100%' }}
  //         maxLength='9999'
  //         onChange={() => {}}
  //       />

  //       <Button
  //         onClick={() => {
  //           Taro.getSystemInfo({
  //             success(res) {
  //               console.log('getSystemInfo success: ', JSON.stringify(res))
  //               setSystemInfo(JSON.stringify(res))
  //             },
  //             complete(res) {
  //               console.log('getSystemInfo complete')
  //             },
  //             fail(res) {
  //               console.log('getSystemInfo fail: ', JSON.stringify(res))
  //             },
  //           })
  //         }}>
  //         getSystemInfo
  //       </Button>
  //       <Textarea
  //         disabled={false}
  //         autoHeight={true}
  //         value={getSystemInfo}
  //         style={{ width: '100%' }}
  //         maxLength='9999'
  //         onChange={() => {}}
  //       />

  //       <Button
  //         onClick={() => {
  //           Taro.getSystemInfoAsync({
  //             success(res) {
  //               console.log('getSystemInfoAsync success: ', JSON.stringify(res))
  //               setSystemASync(JSON.stringify(res))
  //             },
  //             complete(res) {
  //               console.log('getSystemInfoAsync complete')
  //             },
  //             fail(res) {
  //               console.log('getSystemInfoAsync fail: ', JSON.stringify(res))
  //             },
  //           })
  //         }}>
  //         getSystemInfoAsync
  //       </Button>
  //       <Textarea
  //         disabled={false}
  //         autoHeight={true}
  //         value={getSystemInfoAsync}
  //         style={{ width: '100%' }}
  //         maxLength='9999'
  //         onChange={() => {}}
  //       />
  //     </DemoBlock>
  //   </>
  // )
}

export default SystemInfoBlock
