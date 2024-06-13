/**
 * title: 'Common 通用工具'
 * componentName: 'Common'
 * des: '通用工具'
 * previewUrl: 'components/tiga/common'
 * materialType: 'component'
 * package: '@fta/components-common'
 */
import { Input, Textarea, Text } from '@fta/components'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React, { useState } from 'react'
import Taro from '@tarojs/taro'
import RuntimeDemoBlock from './runtimeDemoBlock'
import DynamicActionBlock from './dynamicActionBlock'
interface IndexState {
  groupName: string
  keyName: string
  defaultName: string
}

export default () => {
  const context = useThreshContext()

  const [group, setGroup] = useState('')
  const [key, setKey] = useState('')
  const [def, setDef] = useState('')

  const [result, setResult] = useState('')
  const disabled = true

  const appShowCallback = (res) => {
    console.log('Taro App进入前台回调+++++++++++++: ', res)
    Taro.showToast({
      title: 'App进入前台',
      context: context,
    })
  }

  const appHideCallback = (res) => {
    console.log('Taro App进入后台回调+++++++++++++: ', res)
    Taro.showToast({
      title: 'App进入后台',
      context: context,
    })
  }

  const appCaptureCallback = (res) => {
    console.log('Taro App截屏事件+++++++++++++: ', res)
    if (res.localPath) {
      console.log('App截屏图片本地绝对路径: ', res.localPath)
    }
    Taro.showToast({
      title: 'App截屏',
      context: context,
    })
  }
  return (
    <Layout title='通用工具' qrcode='components/${type}/${name}/index' style={{ flex: 1 }}>
      <DemoBlock label='获取配置下发(先点击键盘 完成, 再点击获取)' pure>
        <Input
          className='groupname'
          placeholder='请输入group'
          value={group}
          onInput={(evt) => setGroup?.(evt.detail.value)}
        />
        <Input
          className='keyname'
          placeholder='请输入key'
          value={key}
          onInput={(evt) => setKey?.(evt.detail.value)}
        />
        <Input
          className='defaultname'
          placeholder='请输入默认值'
          value={def}
          onInput={(evt) => setDef?.(evt.detail.value)}
        />

        <Textarea
          disabled={false}
          value={result}
          style={{ width: '100%' }}
          maxlength={9999}
          onChange={() => {}}
        />

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('配置下发 点击 ')

            Tiga.Common.getConfig({
              context: context,
              group: group,
              key: key,
              defaultValue: def,
              complete(res) {
                console.log('配置下发 complete: ', res)
              },
              success(res) {
                setResult(res.value)
                console.log('配置下发 success, value: ', res.value)
              },
              fail(res) {
                setResult(res.reason ?? '')
                console.log('配置下发 fail: ', res)
              },
            })
          }}>
          获取配置下发
        </Button>
      </DemoBlock>
      <DemoBlock label='App前后台、截屏事件监听' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('开始监听App进入前台')
            Taro.onAppShow(appShowCallback)
          }}>
          监听App进入前台
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('取消监听App进入前台事件')
            Taro.offAppShow(appShowCallback)
          }}>
          取消监听App进入前台事件
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('开始监听App进入后台事件')

            Taro.onAppHide(appHideCallback)
          }}>
          监听App进入后台
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('取消监听App进入后台事件')
            Taro.offAppHide(appHideCallback)
          }}>
          取消监听App进入后台事件
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('开始监听App截屏')
            Taro.onUserCaptureScreen(appCaptureCallback)
          }}>
          监听App截屏
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('取消监听App截屏事件')
            Taro.offUserCaptureScreen(appCaptureCallback)
          }}>
          取消监听截屏事件
        </Button>
      </DemoBlock>
      <RuntimeDemoBlock></RuntimeDemoBlock>
      <DynamicActionBlock></DynamicActionBlock>
    </Layout>
  )
}
