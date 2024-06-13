---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 社会化功能
  order: 170
type:
  title: 分享
title: 弹起分享菜单
order: 2
---

# 弹起分享菜单

:::info{title=说明}

- 默认分享菜单上展示的分享渠道最多四个为一行，使用默认的分享渠道 icon 展示, 用户点击渠道 icon 后分享菜单自动关闭，并返回用户选择的渠道名称<br>
- 默认分享菜单只会展示当前 app 支持的分享渠道，未安装的/未注册的/版本过低/设备不支持的都过滤掉不展示, 如果指定的分享渠道全部被过滤掉，则会返回错误<br>
- 可通过 组合调用 [showShareMenu](#showsharemenu) + [share](./share#share) 实现先弹起分享菜单，然后根据用户选择的分享渠道分享给指定渠道功能
  :::

## showShareMenu

<Platform name="social" version="1.3.0"></Platform>

### 介绍

弹出底部分享弹窗

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Social.showShareMenu
```

### 类型

```jsx | pure
(opts: ShowShareMenuOption): Promise<ShowShareMenuSuccessCallbackResult>
```

### 参数

#### ShowShareMenuOption

<API id='Social_ShowShareMenuOption'></API>

#### ShareTrackOption

分享埋点信息

> 参考[分享埋点](https://dt.amh-group.com/#/metadata/bury-point-management/element-management/1912811)

<API id='Social_ShareTrackOption'></API>

### 返回

#### ShowShareMenuSuccessCallbackResult

| 属性名          | 描述                   | 类型                                                                                                                                                |
| --------------- | ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| selectedChannel | 用户选择的分享渠道名称 | `"wechatSession" \| "wechatTimeline" \| "qq" \| "qzone" \| "kwai" \| "douyin" \| "motorcade" \| "phoneCall" \| "sms" \| "saveImage" \| "saveVideo"` |

### 示例

- 显示分享菜单示例

```javascript
Tiga.Social.showShareMenu({
  title: 'Share this content',
  channels: [
    Tiga.Social.ShareChannelType.WeChatSession,
    Tiga.Social.ShareChannelType.WeChatTimeLine,
  ],
  previewImage: 'https://example.com/preview.jpg',
  shareTrack: {
    shareScene: 'article-read',
    shareParams: { articleId: '12345' },
  },
})
  .then((res: any) => {
    console.log('已选分享渠道:' + res.selectedChannel) // wechatSession
  })
  .catch((e: any) => {
    console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
  })
```

- 组合调用展示分享菜单 + 分享 示例

```javascript
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
      //当选择了微信聊天，分享小程序
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
      // 选择了其他渠道，分享文字
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
    console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
  })
```
