import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()

  function showShareMenuAndShare() {
    Tiga.Social.showShareMenu({
      title: '分享到',
      channels: [
        Tiga.Social.ShareChannelType.WeChatTimeLine,
        Tiga.Social.ShareChannelType.WeChatSession,
        Tiga.Social.ShareChannelType.PhoneCall,
      ],
      context,
    })
      .then((res: Tiga.Social.ShowShareMenuSuccessCallbackResult) => {
        let channel = res.selectedChannel
        if (channel == Tiga.Social.ShareChannelType.WeChatSession) {
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
          })
        } else {
          Tiga.Social.share({
            channel,
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
          })
        }
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

  function menuShare() {
    Tiga.Social.menuShare({
      title: 'Share this content',
      channels: {
        wechatSession: {
          type: Tiga.Social.ShareObjectType.WEB,
          title: '分享标题',
          content: '分享内容',
          href: 'https://home.amh-group.com/#/home',
          imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
        },
        wechatTimeline: {
          type: Tiga.Social.ShareObjectType.IMAGE,
          imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
        },
      },
      shareTrack: {
        shareScene: 'fta-tiga-demo',
        shareParams: { isTest: true },
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

  function showShareImageMenu() {
    Tiga.Social.menuShare({
      title: 'Share this content',
      channels: {
        wechatSession: {
          type: Tiga.Social.ShareObjectType.WEB,
          title: '分享标题',
          content: '分享内容',
          href: 'https://home.amh-group.com/#/home',
          imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
        },
        wechatTimeline: {
          type: Tiga.Social.ShareObjectType.IMAGE,
          imageUrl: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
        },
      },
      shareTrack: {
        shareScene: 'article-read',
        shareParams: { articleId: '12345' },
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
    <Layout title='social' qrcode='components/tiga/social/menushare/index'>
      <DemoBlock label='弹起分享菜单并分享' pure>
        <List>
          <ListItem
            title='调用两步API(showShareMenu + share)'
            arrow='right'
            onClick={showShareMenuAndShare}
          />
          <ListItem title='调用组合API(menuShare)' arrow='right' onClick={menuShare} />
          <ListItem title='Taro.showShareImageMenu' arrow='right' onClick={showShareImageMenu} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
