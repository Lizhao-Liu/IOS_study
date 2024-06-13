/**
 * title: 'Social social'
 * componentName: 'Social'
 * des: 'social'
 * previewUrl: 'components/tiga/social'
 * materialType: 'component'
 * package: '@fta/components-social'
 */
import { Checkbox, Radio } from '@fta/components'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { RadioOption } from '@fta/components/types/radio'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'
import './index.scss'

const textObj = {
  title: '分享标题',
  content: '分享内容',
  type: Tiga.Social.ShareObjectType.TEXT,
}

const imageObj = {
  title: '分享标题',
  content: '分享内容',
  imageUrl: 'https://imagecdn.ymm56.com/ymmfile/gas-static/driver/icon_online_service.png',
  type: Tiga.Social.ShareObjectType.IMAGE,
}

const webObj = {
  title: '分享标题',
  content: '分享内容',
  href: 'https://home.amh-group.com/#/home',
  imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
  type: Tiga.Social.ShareObjectType.WEB,
}

let videoObj = {
  title: '分享标题',
  content: '分享内容',
  type: Tiga.Social.ShareObjectType.VIDEO,
}

const miniProgram = {
  title: '分享标题',
  content: '分享内容',
  miniProgram: {
    userName: 'gh_54e9dea35b85',
    webUrl: 'https://home.amh-group.com/#/home',
    type: 'release',
  },
  imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
  type: Tiga.Social.ShareObjectType.MINIPROGRAM,
}

const motorcadeObject = {
  pageUrl: 'ymm://view/chats',
}

const StyledDemoBlock = (props: any) => (
  <DemoBlock
    {...props}
    flexDirection='column'
    alignItems='normal'
    style={{ backgroundColor: '#F5F5F5', paddingTop: 0, paddingBottom: 0 }}
  />
)

interface ShareObjectRatioBlockProps {
  setShareObjectType: React.Dispatch<React.SetStateAction<string>>
}

const ShareObjectRatioBlock: React.FC<ShareObjectRatioBlockProps> = ({ setShareObjectType }) => {
  const [radioValue, setRadioValue] = useState('0')

  const [radioOptions, setRadioOptions] = useState<RadioOption<string>[]>([
    { label: '文字', value: '0' },
    { label: '图片', value: '1' },
    { label: '网页', value: '2' },
    { label: '视频', value: '3' },
    { label: '小程序', value: '4' },
  ])

  const handleRadioChange = (value: string): void => {
    setRadioValue(value)
    setShareObjectType(value)
    console.log('object type clicked!!', value)
  }

  return (
    <>
      <StyledDemoBlock label='选择分享内容类型(单选)'>
        <Radio
          type='inline'
          options={radioOptions}
          value={radioValue}
          onClick={handleRadioChange}
        />
      </StyledDemoBlock>
    </>
  )
}

interface ShareChannelRatioBlockProps {
  setParentCheckedList: React.Dispatch<React.SetStateAction<Tiga.Social.ShareChannelType[]>>
}

const ShareChannelRatioBlock: React.FC<ShareChannelRatioBlockProps> = ({
  setParentCheckedList,
}) => {
  const [checkedList, setCheckedList] = useState<Array<Tiga.Social.ShareChannelType>>([])
  const shareChannelTypeEnum = Tiga.Social.ShareChannelType
  const [checkboxOptions, setCheckboxOptions] = useState<RadioOption<string>[]>([
    { value: shareChannelTypeEnum.WeChatSession, label: '微信聊天' },
    { value: shareChannelTypeEnum.WeChatTimeLine, label: '微信朋友圈' },
    { value: shareChannelTypeEnum.QQ, label: 'qq聊天' },
    { value: shareChannelTypeEnum.QZone, label: 'qq空间' },
    { value: shareChannelTypeEnum.Douyin, label: '抖音' },
    { value: shareChannelTypeEnum.Kwai, label: '快手' },
    { value: shareChannelTypeEnum.PhoneCall, label: '打电话' },
    { value: shareChannelTypeEnum.SMS, label: '发短信' },
    { value: shareChannelTypeEnum.SaveImage, label: '保存图片' },
    { value: shareChannelTypeEnum.SaveVideo, label: '保存视频' },
    { value: shareChannelTypeEnum.Motorcade, label: '分享到app内车队' },
  ])

  const handleSelection = (value: Tiga.Social.ShareChannelType[]): void => {
    setCheckedList(value)
    setParentCheckedList(value)
    console.log('object type clicked!!', value)
  }

  return (
    <>
      <StyledDemoBlock label='选择分享渠道(选择多个渠道默认弹起分享弹窗分享)'>
        <Checkbox
          type='inline'
          options={checkboxOptions}
          selectedList={checkedList}
          onChange={handleSelection}
        />
      </StyledDemoBlock>
    </>
  )
}

export default () => {
  const [shareObjectType, setShareObjectType] = useState('0')
  const [shareChannelTypes, setShareChannelTypes] = useState<Array<Tiga.Social.ShareChannelType>>(
    []
  )
  const context = useThreshContext()
  const shareTrack = {
    shareScene: 'fta-tiga-demo',
    shareParams: {
      isTest: true,
    },
  }

  const shareObjects: { [index: number]: any } = {
    [Tiga.Social.ShareObjectType.TEXT]: textObj,
    [Tiga.Social.ShareObjectType.IMAGE]: imageObj,
    [Tiga.Social.ShareObjectType.WEB]: webObj,
    [Tiga.Social.ShareObjectType.VIDEO]: videoObj,
    [Tiga.Social.ShareObjectType.MINIPROGRAM]: miniProgram,
  }

  const shareObject = (t: number): any => {
    return shareObjects[t]
  }

  const menuShare = async (
    shareOption: any,
    shareChannels: Array<Tiga.Social.ShareChannelType>
  ): Promise<void> => {
    let channels = {}
    shareChannels.forEach((channelType) => {
      let currOption = shareOption
      if (channelType === Tiga.Social.ShareChannelType.Motorcade) {
        currOption = motorcadeObject // 端内车队分享传入pageUrl路由
      } else if (channelType === Tiga.Social.ShareChannelType.PhoneCall) {
        currOption = null // 电话分享无需分享内容
      }
      Object.assign(channels, { [channelType]: currOption })
    })

    Tiga.Social.menuShare({
      context,
      shareTrack,
      title: '分享弹窗标题',
      previewImage: shareOption.imageUrl,
      channels,
    })
      .then((res: any) => {
        console.log('分享渠道' + res.channel)
        Taro.showModal({
          context,
          content: '分享成功',
          title: '分享',
          showCancel: false,
        })
      })
      .catch((e: any) => {
        Taro.showModal({
          context,
          content: e.reason,
          title: '分享',
          showCancel: false,
        })
      })
  }

  const singleChannelShare = async (
    shareOption: any,
    channel: Tiga.Social.ShareChannelType
  ): Promise<void> => {
    if (channel == Tiga.Social.ShareChannelType.Motorcade) {
      shareOption = motorcadeObject
    }
    Tiga.Social.share({
      context,
      shareTrack,
      channel,
      ...shareOption,
    })
      .then(() => {
        Taro.showModal({
          context,
          content: '分享成功',
          title: '分享',
          showCancel: false,
        })
      })
      .catch((e: any) => {
        Taro.showModal({
          context,
          content: e.reason,
          title: '分享',
          showCancel: false,
        })
      })
  }

  const share = async (): Promise<void> => {
    try {
      let shareOption = shareObject(Number(shareObjectType))

      if (Number(shareObjectType) === Tiga.Social.ShareObjectType.VIDEO) {
        const res = await Taro.chooseMedia({
          context: context,
          count: 1,
          mediaType: ['video'],
          sourceType: ['album', 'camera'],
          cameraType: 'custom',
          maxDuration: 20,
          sizeType: ['original'],
          camera: 'front',
        })
        shareOption.videoUrl = res.tempFiles[0].tempFilePath
        console.log('local video url ' + shareOption.videoUrl)
      }

      if (shareChannelTypes.length == 1) {
        // 单渠道分享
        await singleChannelShare(shareOption, shareChannelTypes[0])
      } else {
        // 多渠道分享
        if (shareChannelTypes.length == 0) {
          // 未选择分享渠道, 调用获取当前所有分享渠道bridge
          Taro.showToast({
            title: '获取当前app所有分享渠道',
            mask: false,
            context,
            duration: 1500,
          })
          const res = await Tiga.Social.getShareChannels({
            context,
          })
          menuShare(shareOption, res.shareChannels)
        } else {
          menuShare(shareOption, shareChannelTypes)
        }
      }
      console.log('share clicked!!')
    } catch (e) {
      console.log(e)
    }
  }

  return (
    <Layout title='Social' qrcode='components/tiga/social/index'>
      <ShareObjectRatioBlock setShareObjectType={setShareObjectType} />
      <ShareChannelRatioBlock setParentCheckedList={setShareChannelTypes} />
      <Button style={{ margin: 8 }} onClick={share}>
        分享
      </Button>

      <DemoBlock label='打开小程序' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() =>
            Tiga.Social.launchWXMiniProgram({
              userName: 'gh_54e9dea35b85',
              context,
            }).catch((e: any) => {
              Taro.showModal({
                context,
                content: e.reason,
                title: '小程序跳转失败',
                showCancel: false,
              })
            })
          }>
          打开微信小程序
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() =>
            Tiga.Social.launchAlipayMiniProgram({
              appId: '60000002',
              context,
            }).catch((e: any) => {
              Taro.showModal({
                context,
                content: e.reason,
                title: '小程序跳转失败',
                showCancel: false,
              })
            })
          }>
          打开支付宝小程序
        </Button>
      </DemoBlock>

      <DemoBlock label='taro 分享' pure>
        <Button
          onClick={() => {
            Taro.showShareImageMenu({
              context,
              path: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
            }).then(() => {
              Taro.showModal({
                context,
                content: '分享成功',
                title: '分享',
                showCancel: false,
              })
            })
          }}>
          showImageShareMenu
        </Button>
      </DemoBlock>
    </Layout>
  )
}
