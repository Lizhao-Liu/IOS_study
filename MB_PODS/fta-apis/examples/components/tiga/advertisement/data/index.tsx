/**
 * title: '营销数据'
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
