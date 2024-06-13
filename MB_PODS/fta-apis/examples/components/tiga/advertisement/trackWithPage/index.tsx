/**
 * title: '埋点（绑定页面）'
 * componentName: 'Advertisement'
 * des: '营销广告'
 * previewUrl: 'components/tiga/advertisement'
 * materialType: 'component'
 * package: '@fta/components-advertisement'
 */
import { Textarea } from '@fta/components'
import { DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import React, { useState } from 'react'
import { PageEvent } from '../pageEvent'

export default function Index() {
  const [result, setResult] = useState('')
  const context = useThreshContext()

  function getResult(res: string) {
    setResult(JSON.stringify(res))
  }

  return (
    <Layout title='营销广告' style={{ flex: 1 }}>
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
