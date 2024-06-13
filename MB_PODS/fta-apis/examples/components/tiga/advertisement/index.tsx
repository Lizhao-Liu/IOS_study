/**
 * title: 'Advertisement 营销广告'
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
import { PageEvent } from './pageEvent'

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
            Tiga.Advertisement.popup({
              context: context,
              positionCode: 171,
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
          弹出广告
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.getRefreshInfo({
              context: context,
              pageName: 'recommend_cargolist',
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
          获取刷新文案
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.getAdData({
              context: context,
              positionCode: 2333,
              success(res) {
                console.log(res)
                setResult(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                setResult(JSON.stringify(err))
              },
            })
          }}>
          根据广告位 id 获取广告数据
        </Button>
        <Gap></Gap>
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
      <PageEvent
        resultCallback={(res) => {
          getResult(res)
        }}></PageEvent>
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
