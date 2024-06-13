import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()

  function getShareChannels() {
    Tiga.Social.getShareChannels({
      context,
    })
      .then((res: Tiga.Social.GetShareChannelsCallbackResult) => {
        Taro.showModal({
          context,
          content: res.shareChannels.toLocaleString(),
          title: '当前设备支持分享渠道:',
          showCancel: false,
        })
      })
      .catch((e: any) => {
        Taro.showModal({
          context,
          content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
          title: '分享失败',
          showCancel: false,
        })
      })
  }



  return (
    <Layout title='social' qrcode='components/tiga/social/getsharechannels/index'>
      <DemoBlock label='获取当前设备支持的分享渠道' pure>
        <Button style={{ margin: 8 }} onClick={getShareChannels}>
          获取分享渠道
        </Button>
      </DemoBlock>
    </Layout>
  )
}
