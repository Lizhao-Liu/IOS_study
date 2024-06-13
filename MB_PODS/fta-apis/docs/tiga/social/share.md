---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 社会化功能
  order:  170
type:
  title: 分享
title: 单渠道分享
order: 0
---

# 单渠道分享

:::info{title=说明}

分享给指定渠道，目前支持以下三种类型分享渠道：

- 第三方平台： 包括微信、QQ、快手、抖音等
- 系统内置分享渠道： 包括打电话、发短信、保存到相册等
- 车队分享： 跳转到指定车队页面链接

集团 app 与第三方分享平台支持度、分享平台与分享内容类型支持度等分享常见问题，请查看 FAQ 板块

:::

:::warning{title=注意事项}

- 请确保在调用此方法之前检查相应渠道的可用性，可通过 [getShareChannels](./getShareChannels.md) 获取当前应用支持的分享渠道。
- 支持的分享内容类型因渠道而异，请查看 FAQ 板块。

:::

## share

<Platform name="social" version="1.1.0"></Platform>

### 介绍

指定分享渠道直接分享

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Social.share
```

### 类型

```jsx | pure
(opts: DirectShareOption | DirectMotorcadeShareOption): Promise<ShareSuccessCallbackResult>
```

### 参数

##### DirectShareOption

当分享的目标渠道为 第三方 app / 系统内置的渠道时，share 函数接受 DirectShareOption 类型的参数。

| 属性名      | 描述                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 类型                                                          | 默认值   |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------- | -------- |
| channel     | 分享渠道名称, 可使用 ShareChannelType 枚举值                                                                                                                                                                                                                                                                                                                                                                                                                                         | [ShareChannelType](#sharechanneltype)                         | `(必选)` |
| type        | 分享内容类型, 可使用 ShareObjectType 枚举值 <br>- 对应分享渠道支持的分享内容类型 请参考 [表格](#sharechanneltype)<br>- 分享到打电话渠道时, type 可不传                                                                                                                                                                                                                                                                                                                               | [ShareObjectType](#shareobjecttype)                           | `--`     |
| title       | 分享内容的标题 <br>- type 为网页类型、小程序类型时必填<br>-【注意】不支持 emoji 等特殊符号                                                                                                                                                                                                                                                                                                                                                                                           | `string`                                                      | `--`     |
| content     | 分享的文字内容 <br>- type 为文字类型、网页类型、小程序类型时必填<br>-【注意】不支持 emoji 等特殊符号                                                                                                                                                                                                                                                                                                                                                                                 | `string`                                                      | `--`     |
| href        | 分享的网页链接 <br>- type 为网页类型时必填                                                                                                                                                                                                                                                                                                                                                                                                                                           | `string`                                                      | `--`     |
| imageUrl    | 分享的图片链接, 支持本地路径和网络链接<br>- type 为图片类型时必填，表示分享的图片地址<br>- type 为网页类型时必填，表示网页链接缩略图地址(推荐图片小于 20Kb)<br>- type 为小程序类型时必填，表示小程序封面图地址(推荐图片小于 128K, 图片长宽比为 5:4)<br>【注意】如果使用的图片过大，会自动压缩图片大小，此时可能引起图片质量下降                                                                                                                                                      | `string`                                                      | `--`     |
| videoUrl    | 分享的视频地址, 仅支持本地路径 <br>- type 为视频类型时必填                                                                                                                                                                                                                                                                                                                                                                                                                           | `string`                                                      | `--`     |
| miniProgram | 分享的小程序参数 <br>- type 为小程序类型时必填                                                                                                                                                                                                                                                                                                                                                                                                                                       | [MiniProgram](#miniprogram)                                   | `--`     |
| shareTrack  | 分享埋点数据                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [ShareTrackOption](#sharetrackoption)                         | `--`     |
| fail        | 接口调用失败的回调函数<br>错误码：<br>- 1: 分享失败（未知错误或三方返回错误）<br>- 2: 分享取消【注意】从 APP 分享到微信时，无法判断用户是否点击取消分享，因为微信官方禁掉了分享取消的返回值 <br>- 3: 参数错误 <br>- 10: 相关分享平台未安装 <br>- 11: 相关分享平台版本不支持或设备不支持分享 <br>- 12: 未向相关平台注册当前 app <br>- 20: 分享内容参数错误或缺失 <br>- 21: 指定的分享渠道不支持传入的分享内容类型 <br>- 30: 无相册访问权限（适用于保存图片到本地/保存视频到本地场景） | `(res: CallbackResult) => void`                               | `--`     |
| complete    | 接口调用结束的回调函数（调用成功、失败都会执行）                                                                                                                                                                                                                                                                                                                                                                                                                                     | `(res: CallbackResult ｜ ShareSuccessCallbackResult) => void` | `--`     |
| success     | 接口调用成功的回调函数                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `(res: ShareSuccessCallbackResult) => void`                   | `--`     |
| context     | 页面 context                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `any`                                                         | `--`     |

##### DirectMotorcadeShareOption

当分享的目标渠道为 app 内车队 (Motorcade) 时，share 函数接受 DirectMotorcadeShareOption 类型的参数。

<API id='Social_DirectMotorcadeShareOption'></API>

##### MiniProgram

分享小程序参数信息，用于配置分享小程序的参数，如小程序标识、页面路径等
注意： 
分享微信小程序时，webUrl不能为空（Android端），这是Android微信的设定。
<API id='Social_MiniProgram'></API>

##### ShareTrackOption

分享埋点信息

> 参考[分享埋点](https://dt.amh-group.com/#/metadata/bury-point-management/element-management/1912811)

<API id='Social_ShareTrackOption'></API>

##### ShareObjectType

分享内容类型枚举

| 枚举值      | 实际取值 | 描述       | 类型     | 必填属性名                            |
| ----------- | -------- | ---------- | -------- | ------------------------------------- |
| TEXT        | 0        | 文字类型   | `number` | content                               |
| IMAGE       | 1        | 图片类型   | `number` | imageUrl                              |
| WEB         | 2        | 网页类型   | `number` | title、content、imageUrl、href        |
| VIDEO       | 3        | 视频类型   | `number` | videoUrl                              |
| MINIPROGRAM | 4        | 小程序类型 | `number` | title、content、imageUrl、miniProgram |

##### ShareChannelType

分享渠道类型枚举

| 枚举值         | 实际取值         | 描述       | 类型     | 支持分享内容类型                         |
| -------------- | ---------------- | ---------- | -------- | ---------------------------------------- |
| WeChatSession  | `wechatSession`  | 微信聊天   | `string` | 文字类型、图片类型、网页类型、小程序类型 |
| WeChatTimeLine | `wechatTimeline` | 微信朋友圈 | `string` | 文字类型、图片类型、网页类型             |
| QQ             | `qq`             | qq 聊天    | `string` | 文字类型、图片类型、网页类型             |
| QZone          | `qzone`          | qq 空间    | `string` | 文字类型、图片类型、网页类型             |
| Kwai           | `kwai`           | 快手       | `string` | 视频类型                                 |
| Douyin         | `douyin`         | 抖音       | `string` | 视频类型                                 |
| Motorcade      | `motorcade`      | 车队       | `string` | `--`                                     |
| PhoneCall      | `phoneCall`      | 打电话     | `string` | `--`                                     |
| SMS            | `sms`            | 发短信     | `string` | 文字类型                                 |
| SaveImage      | `saveImage`      | 保存图片   | `string` | 图片类型                                 |
| SaveVideo      | `saveVideo`      | 保存视频   | `string` | 视频类型                                 |

### 返回

#### ShareSuccessCallbackResult

| 属性名  | 描述     | 类型                                                                                                                                                |
| ------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| channel | 分享渠道 | `"wechatSession" \| "wechatTimeline" \| "qq" \| "qzone" \| "kwai" \| "douyin" \| "motorcade" \| "phoneCall" \| "sms" \| "saveImage" \| "saveVideo"` |

### 示例

```javascript
// 分享网页到微信聊天
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
  console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
})

// 分享小程序到微信聊天
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
  console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
})

// 分享图片到微信朋友圈
Tiga.Social.share({
  channel: Tiga.Social.ShareChannelType.WeChatTimeLine,
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
  console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
})

// 分享视频到抖音
Tiga.Social.share({
  channel: Tiga.Social.ShareChannelType.Douyin,
  type: Tiga.Social.ShareObjectType.VIDEO,
  videoUrl: '/path/to/local/video/file',
  shareTrack: {
    shareScene: 'fta-tiga-demo',
    shareParams: {
      isTest: true,
    },
  },
  context,
}).catch((e) => {
  console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
})

// 分享到端内车队页面
Tiga.Social.share({
  channel: Tiga.Social.ShareChannelType.Motorcade,
  pageUrl:
    'ymm://app/web?immersive=true&useMBWebView=true&url=https%3A%2F%2Fstatic.ymm56.com%2Fmicroweb%2F%23%2Fmw-fleet%2FfleetSlect%2Findex%3Fselect%3D1%2526content%253Dxxxx',
  shareTrack: {
    shareScene: 'article-read',
    shareParams: { articleId: '12345' },
  },
  success: (result) => {
    console.log(`Shared successfully to in-app motorcade.`)
  },
  fail: (error) => {
    console.error(`Failed to share to motorcade because: ${error.reason}`)
  },
  complete: () => {
    console.log('Share to motorcade operation completed.')
  },
})
```

<code src='@examples/components/tiga/social/share/index.tsx'></code>
