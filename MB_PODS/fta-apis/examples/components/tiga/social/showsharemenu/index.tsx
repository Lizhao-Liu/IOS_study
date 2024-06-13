import { Checkbox } from '@fta/components'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { RadioOption } from '@fta/components/types/radio'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()

  const [checkedList, setCheckedList] = useState<Array<Tiga.Social.ShareChannelType>>([])
  const [checkboxOptions, setCheckboxOptions] = useState<RadioOption<string>[]>([
    { value: Tiga.Social.ShareChannelType.WeChatSession, label: '微信聊天' },
    { value: Tiga.Social.ShareChannelType.WeChatTimeLine, label: '微信朋友圈' },
    { value: Tiga.Social.ShareChannelType.QQ, label: 'qq聊天' },
    { value: Tiga.Social.ShareChannelType.QZone, label: 'qq空间' },
    { value: Tiga.Social.ShareChannelType.Douyin, label: '抖音' },
    { value: Tiga.Social.ShareChannelType.Kwai, label: '快手' },
    { value: Tiga.Social.ShareChannelType.PhoneCall, label: '打电话' },
    { value: Tiga.Social.ShareChannelType.SMS, label: '发短信' },
    { value: Tiga.Social.ShareChannelType.SaveImage, label: '保存图片' },
    { value: Tiga.Social.ShareChannelType.SaveVideo, label: '保存视频' },
    { value: Tiga.Social.ShareChannelType.Motorcade, label: '分享到app内车队' },
  ])

  const handleSelection = (value: Tiga.Social.ShareChannelType[]): void => {
    setCheckedList(value)
  }

  function showShareMenu() {
    Tiga.Social.showShareMenu({
      title: '分享到',
      channels: checkedList,
      context,
    })
      .then((res: any) => {
        Taro.showModal({
          context,
          content: res.selectedChannel,
          title: '选择分享渠道',
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

  function showShareMenuWithPreviewImage() {
    Tiga.Social.showShareMenu({
      title: '分享到',
      channels: checkedList,
      previewImage: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    })
      .then((res: any) => {
        Taro.showModal({
          context,
          content: res.selectedChannel,
          title: '选择分享渠道',
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
    <Layout title='social' qrcode='components/tiga/social/miniprogram/index'>

      <DemoBlock label='弹起分享菜单' pure>
        <Checkbox
          type='inline'
          options={checkboxOptions}
          value={checkedList}
          onChange={handleSelection}
        />
        <Button style={{ margin: 8 }} onClick={showShareMenu}>
          显示分享菜单
        </Button>
        <Button style={{ margin: 8 }} onClick={showShareMenuWithPreviewImage}>
          显示分享菜单(带预览图片)
        </Button>
      </DemoBlock>
    </Layout>
  )
}
