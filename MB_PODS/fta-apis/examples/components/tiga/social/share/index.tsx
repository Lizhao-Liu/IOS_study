import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()

  function shareToWechatSession() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.WeChatSession,
      type: Tiga.Social.ShareObjectType.TEXT,
      title: '分享标题',
      content: '分享内容',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareToWechatTimeline() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.WeChatTimeLine,
      type: Tiga.Social.ShareObjectType.TEXT,
      title: '分享标题',
      content: '分享内容',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareToQQ() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.QQ,
      type: Tiga.Social.ShareObjectType.TEXT,
      title: '分享标题',
      content: '分享内容',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareToQZone() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.QZone,
      type: Tiga.Social.ShareObjectType.TEXT,
      title: '分享标题',
      content: '分享内容',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareToDY() {
    chooseVideo().then((res) => {
      Tiga.Social.share({
        channel: Tiga.Social.ShareChannelType.Douyin,
        type: Tiga.Social.ShareObjectType.VIDEO,
        videoUrl: res,
        shareTrack: {
          shareScene: 'fta-tiga-demo',
          shareParams: {
            isTest: true,
          },
        },
        context,
      }).catch((e) => {
        Taro.showModal({
          context,
          content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
          title: '分享失败',
          showCancel: false,
        })
      })
    })
  }

  function shareToKS() {
    chooseVideo()
      .then((res) => {
        Tiga.Social.share({
          channel: Tiga.Social.ShareChannelType.Kwai,
          type: Tiga.Social.ShareObjectType.VIDEO,
          videoUrl: res,
          shareTrack: {
            shareScene: 'fta-tiga-demo',
            shareParams: {
              isTest: true,
            },
          },
          context,
        })
      })
      .catch((e) => {
        Taro.showModal({
          context,
          content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
          title: '分享失败',
          showCancel: false,
        })
      })
  }

  function shareToMotorcade() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.Motorcade,
      pageUrl: 'ymm://app/web?immersive=true&useMBWebView=true&url=https%3A%2F%2Fstatic.ymm56.com%2Fmicroweb%2F%23%2Fmw-fleet%2FfleetSlect%2Findex%3Fselect%3D1%2526content%253Dxxxx',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareByPhoneCall() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.PhoneCall,
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareBySMS() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.SMS,
      type: Tiga.Social.ShareObjectType.TEXT,
      content: '分享内容',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareText() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.WeChatSession,
      type: Tiga.Social.ShareObjectType.TEXT,
      title: '分享标题',
      content: '分享内容',
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareImage() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.WeChatSession,
      type: Tiga.Social.ShareObjectType.IMAGE,
      imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareVideo() {
    chooseVideo().then((res) => {
      Tiga.Social.share({
        channel: Tiga.Social.ShareChannelType.Douyin,
        type: Tiga.Social.ShareObjectType.VIDEO,
        videoUrl: res,
        shareTrack: {
          shareScene: 'fta-tiga-demo',
          shareParams: {
            isTest: true,
          },
        },
        context,
      }).catch((e: any) => {
        Taro.showModal({
          context,
          content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
          title: '分享失败',
          showCancel: false,
        })
      })
    })
  }

  async function chooseVideo(): Promise<any> {
    try {
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
      return res.tempFiles[0].tempFilePath
    } catch (e: any) {
      Taro.showModal({
        context,
        title: '视频选择失败',
        showCancel: false,
      })
    }
  }

  function shareWebLink() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.WeChatSession,
      type: Tiga.Social.ShareObjectType.WEB,
      title: '分享标题',
      content: '分享内容',
      href: 'https://home.amh-group.com/#/home',
      imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  function shareMiniProgram() {
    Tiga.Social.share({
      channel: Tiga.Social.ShareChannelType.WeChatSession,
      type: Tiga.Social.ShareObjectType.MINIPROGRAM,
      title: '分享标题',
      content: '分享内容',
      miniProgram: {
        userName: 'gh_54e9dea35b85',
        webUrl: 'https://home.amh-group.com/#/home',
        type: 'release',
      },
      imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: {
          isTest: true,
        },
      },
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: '错误码 【' + e.code + '】 错误原因:' + e.reason,
        title: '分享失败',
        showCancel: false,
      })
    })
  }

  return (
    <Layout title='social' qrcode='components/tiga/social/share/index'>
      <DemoBlock label='分享不同渠道' pure>
        <List>
          <ListItem title='分享到微信聊天' arrow='right' onClick={shareToWechatSession} />
          <ListItem title='分享到微信朋友圈' arrow='right' onClick={shareToWechatTimeline} />
          <ListItem title='分享到QQ' arrow='right' onClick={shareToQQ} />
          <ListItem title='分享到QQ空间' arrow='right' onClick={shareToQZone} />
          <ListItem title='分享到抖音' arrow='right' onClick={shareToDY} />
          <ListItem title='分享到快手' arrow='right' onClick={shareToKS} />
          <ListItem title='分享到app内车队' arrow='right' onClick={shareToMotorcade} />
          <ListItem title='打电话分享' arrow='right' onClick={shareByPhoneCall} />
          <ListItem title='发短信分享' arrow='right' onClick={shareBySMS} />
        </List>
      </DemoBlock>
      <DemoBlock label='分享不同内容类型' pure>
        <List>
          <ListItem title='分享文字' arrow='right' onClick={shareText} />
          <ListItem title='分享图片' arrow='right' onClick={shareImage} />
          <ListItem title='分享网页链接' arrow='right' onClick={shareWebLink} />
          <ListItem title='分享视频' arrow='right' onClick={shareVideo} />
          <ListItem title='分享小程序' arrow='right' onClick={shareMiniProgram} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
