/**
 * title: '定位'
 * componentName: 'Location'
 * des: '定位'
 * previewUrl: 'components/tiga/location'
 * materialType: 'component'
 * package: '@fta/components-location'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  return (
    <Layout title='定位服务' style={{ flex: 1 }} qrcode='components/tiga/location/location'>
      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Tiga.Location.getCacheLocationInfo({ context: context })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          获取缓存定位
        </Button>
      </DemoBlock>
      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Tiga.Location.getLocationInfo({ context: context })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          异步获取定位信息
        </Button>
      </DemoBlock>
      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Tiga.Location.getLocationInfoAttach({
              context: context,
              timeInterval: 10,
              permissionRequest: true,
              topHint: '哈哈',
              rationale: '请开启定位权限',
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          异步获取定位信息(带权限申请，带缓存时间间隔)
        </Button>
      </DemoBlock>
      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Tiga.Location.geocoder({
              context: context,
              longitude: 121.408652,
              latitude: 31.209837,
              sensitiveOffset: 1000,
            })
              .then((res) => {
                console.log('成功')
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(err)
              })
          }}>
          反解（系统能力）
        </Button>
      </DemoBlock>
      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Tiga.Location.webGeocoder({
              context: context,
              lon: 121.408652,
              lat: 31.209837,
            })
              .then((res) => {
                console.log('成功')
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(err)
              })
          }}>
          反解(web)
        </Button>
      </DemoBlock>

      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Taro.getLocation({
              context: context,
            })
              .then((res) => {
                console.log('成功')
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(err)
              })
          }}>
          定位(taro)
        </Button>
      </DemoBlock>

      <DemoBlock label='定位' pure>
        <Button
          onClick={() => {
            Taro.getFuzzyLocation({
              context: context,
            })
              .then((res) => {
                console.log('成功')
                console.log(res)
              })
              .catch((err) => {
                console.log('失败')
                console.log(err)
              })
          }}>
          模糊定位（taro）
        </Button>
      </DemoBlock>
    </Layout>
  )
}
