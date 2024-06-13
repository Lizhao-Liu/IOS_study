/**
 * title: '行政区'
 * componentName: 'Location'
 * des: '定位'
 * previewUrl: 'components/tiga/location'
 * materialType: 'component'
 * package: '@fta/components-location'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  return (
    <Layout title='定位服务' style={{ flex: 1 }} qrcode='components/tiga/location/region'>
      <DemoBlock label='行政区' pure>
        <Button
          onClick={() => {
            Tiga.Location.getRegionWithName({ context: context, city: '安阳', district: '林州' })
              .then((res) => {
                console.log(JSON.stringify(res))
              })
              .catch((err) => {
                console.log(JSON.stringify(err))
              })
          }}>
          根据省市区名字获取地区信息
        </Button>
      </DemoBlock>

      <DemoBlock label='行政区' pure>
        <Button
          onClick={() => {
            Tiga.Location.getRegionChildren({ context: context, code: 410000, deep: 3 })
              .then((res) => {
                console.log('成功')
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(JSON.stringify(err))
              })
          }}>
          根据 code 获取子级别城市
        </Button>
      </DemoBlock>
      <DemoBlock label='行政区' pure>
        <Button
          onClick={() => {
            Tiga.Location.getRegionParent({ context: context, code: 429005 })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(JSON.stringify(err))
              })
          }}>
          根据 code 获取父级城市
        </Button>
      </DemoBlock>
      <DemoBlock label='行政区' pure>
        <Button
          onClick={() => {
            Tiga.Location.getRegionWithCode({ context: context, code: 429005 })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(JSON.stringify(err))
              })
          }}>
          根据城市 code 获取地区信息
        </Button>
      </DemoBlock>
    </Layout>
  )
}
