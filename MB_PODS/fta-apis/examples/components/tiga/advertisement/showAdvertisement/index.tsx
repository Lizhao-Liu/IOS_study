/**
 * title: '弹出广告'
 * componentName: 'Advertisement'
 * des: '营销广告'
 * previewUrl: 'components/tiga/advertisement'
 * materialType: 'component'
 * package: '@fta/components-advertisement'
 */
import { Textarea } from '@fta/components'
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
