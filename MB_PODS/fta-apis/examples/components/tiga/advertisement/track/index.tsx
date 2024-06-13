/**
 * title: '埋点'
 * componentName: 'Advertisement'
 * des: '营销广告'
 * previewUrl: 'components/tiga/advertisement'
 * materialType: 'component'
 * package: '@fta/components-advertisement'
 */
import { Gap, Textarea } from '@fta/components'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React, { useState } from 'react'

export default function Index() {
  const [result, setResult] = useState('')
  const context = useThreshContext()

  function getResult(res: string) {
    setResult(JSON.stringify(res))
  }

  return (
    <Layout title='营销广告' style={{ flex: 1 }}>
      <DemoBlock label='广告' pure>
        <Button
          onClick={() => {
            Tiga.Advertisement.show({
              context: context,
              adId: 2333,
              positionCode: 255655,
              success(res) {
                setResult(JSON.stringify(res))
                console.log(res)
              },
              fail(err) {
                setResult(JSON.stringify(err))
                console.log(err)
              },
            })
          }}>
          (埋点)展示广告
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.tap({
              context: context,
              adId: 2333,
              positionCode: 255655,
              success(res) {
                setResult(JSON.stringify(res))
                console.log(res)
              },
              fail(err) {
                setResult(JSON.stringify(err))
                console.log(err)
              },
            })
          }}>
          (埋点)点击广告
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.close({
              context: context,
              adId: 2333,
              positionCode: 255655,
              success(res) {
                setResult(JSON.stringify(res))
                console.log(res)
              },
              fail(err) {
                setResult(JSON.stringify(err))
                console.log(err)
              },
            })
          }}>
          (埋点)关闭广告
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.stay({
              context: context,
              adId: 2333,
              positionCode: 255655,
              duration: 23,
              success(res) {
                setResult(JSON.stringify(res))
                console.log(res)
              },
              fail(err) {
                setResult(JSON.stringify(err))
                console.log(err)
              },
            })
          }}>
          (埋点)广告停留时长
        </Button>
      </DemoBlock>
      <DemoBlock
        label='result'
        pure
        onLongPress={() => {
          Taro.setClipboardData({ context: context, data: result })
        }}>
        <Textarea value={result} onChange={() => { }}></Textarea>
      </DemoBlock>
    </Layout>
  )
}
