/**
 * title: 'canIUse 可用性检查'
 */
import { Input, Textarea, Text } from '@fta/components'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'

export default () => {
  const context = useThreshContext()
  const [tigaModule, setTigaModule] = useState('Common')
  const [tigaApi, setTigaApi] = useState('isAppForeground')
  const [tigaSDKVersion, setTigaSDKVersion] = useState('')

  // const [taroApi, setTaroApi] = useState('chooseMedia')

  const [bizModuleName, setBizModuleName] = useState('fta-tiga-demo')
  const [bizModuleVersion, setBizModuleVersion] = useState('1.0.0')
  const [bizModuleType, setBizModuleType] = useState('flutter')

  return (
    <Layout title='canIUse' qrcode='components/${type}/${name}/index' style={{ flex: 1 }}>
      <DemoBlock label='canIUseTiga' pure>
        <Input
          className='tigaModule'
          placeholder='请输入TigaModule'
          value={tigaModule}
          onInput={(e) => setTigaModule?.(e.detail.value)}
        />
        <Input
          className='tigaApi'
          placeholder='请输入TigaApi'
          value={tigaApi}
          onInput={(e) => setTigaApi?.(e.detail.value)}
        />
        <Input
          className='tigaSDKVersion'
          placeholder='请输入tigaSDKVersion'
          value={tigaSDKVersion}
          onInput={(e) => setTigaSDKVersion?.(e.detail.value)}
        />

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.canIUseTiga({
              context,
              moduleName: tigaModule,
              api: tigaApi,
              tigaSDKVersion: tigaSDKVersion,
            })
              .then((res) => {
                Taro.showToast({
                  context,
                  title: res?.res
                    ? `Tiga.${tigaModule}.${tigaApi} 可用`
                    : `Tiga.${tigaModule}.${tigaApi} 不可用`,
                })
              })
              .catch((e) => {
                Taro.showToast({
                  context,
                  title: `Tiga.${tigaModule}.${tigaApi} 不可用，errMsg: ${e.reason || e.message}`,
                })
              })
          }}>
          canIUseTiga
        </Button>
      </DemoBlock>
      <DemoBlock label='canIUseBizModule' pure>
        <Input
          className='bizModuleType'
          placeholder='请输入业务模块类型'
          value={bizModuleType}
          onInput={(e) => setBizModuleType?.(e.detail.value)}
        />

        <Input
          className='bizModuleName'
          placeholder='请输入业务模块名'
          value={bizModuleName}
          onInput={(e) => setBizModuleName?.(e.detail.value)}
        />

        <Input
          className='bizModuleVersion'
          placeholder='请输入业务模块版本'
          value={bizModuleVersion}
          onInput={(e) => setBizModuleVersion?.(e.detail.value)}
        />

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.canIUseBizModule({
              context,
              moduleType: bizModuleType,
              moduleName: bizModuleName,
              moduleVersion: bizModuleVersion,
            })
              .then((res) => {
                Taro.showToast({
                  context,
                  title: `兼容的`,
                })
              })
              .catch((res) => {
                Taro.showToast({
                  context,
                  title: `当前业务模块是不兼容的，原因：${res.reason}`,
                })
              })
          }}>
          canIUseBizModule
        </Button>
      </DemoBlock>
    </Layout>
  )
}
