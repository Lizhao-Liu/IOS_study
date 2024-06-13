import { Button, DemoBlock, Gap } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { View } from '@tarojs/components'
import React from 'react'

function PageEvent({ resultCallback }: { resultCallback: (res: string) => void }) {
  const context = useThreshContext()

  return (
    <DemoBlock label='埋点-绑定页面' pure>
      <View>
        <Button
          onClick={() => {
            Tiga.Advertisement.pageAppear({
              context: context,
              pageSession: 'pageSession',
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          广告所在页面显示-绑定页面
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            const m: Tiga.Advertisement.AdModel = {
              positionCode: 171,
              advertId: 233,
              pictureUrl: '',
              url: '',
              text: '',
              advertMetricInfo: '',
            }
            Tiga.Advertisement.visibleOnPage({
              context: context,
              pageSession: '2222',
              adviewType: 1,
              adModel: m,
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          广告所在视图可见-绑定页面
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.invisibleOnPage({
              context: context,
              pageSession: 'pageSession',
              advertId: 171,
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          广告所在视图不可见-绑定页面
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.pageDisappear({
              context: context,
              pageSession: 'pageSession',
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          广告所在页面离开-绑定页面
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.pageDestroy({
              context: context,
              pageSession: 'pageSession',
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          广告所在页面销毁-绑定页面
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.tapWithPage({
              context: context,
              pageSession: 'pageSession',
              advertId: 171,
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          点击广告-绑定页面
        </Button>
        <Gap></Gap>
        <Button
          onClick={() => {
            Tiga.Advertisement.closeWithPage({
              context: context,
              pageSession: 'pageSession',
              advertIds: [171, 172],
              success(res) {
                console.log(res)
                resultCallback(JSON.stringify(res))
              },
              fail(err) {
                console.log(err)
                resultCallback(JSON.stringify(err))
              },
            })
          }}>
          关闭广告-绑定页面
        </Button>
      </View>
    </DemoBlock>
  )
}

export { PageEvent }
