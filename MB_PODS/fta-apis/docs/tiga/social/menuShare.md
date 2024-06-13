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
title: 多渠道分享
order: 3
---

# 多渠道分享

:::info{title=说明}

多渠道分享，即先弹起分享菜单，然后根据用户选择的分享渠道分享给指定渠道

- 如果使用默认分享菜单样式，可通过 组合调用 [showShareMenu](./showShareMenu.md) + [share](./share.md) 或者单独调用封装后的 [menuShare](#menushare) 方法实现功能。

- 如果需要自定义分享菜单样式，可自定义生成分享菜单组件后调用 [share](./share.md) 实现功能。

:::

## menuShare

<Platform name="social" version="1.3.0"></Platform>

### 介绍

menuShare 方法内部封装了 showShareMenu 和 share 方法，以用于弹出弹窗并自动分享到用户选择渠道

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Social.menuShare
```

### 类型

```jsx | pure
(opts: MenuShareOption): Promise<ShareSuccessCallbackResult>
```

### 参数

#### MenuShareOption

<API id='Social_MenuShareOption'></API>

#### channels 传参说明

- 参数 Key 为分享的渠道名称，参考[ShareChannelType](./share#sharechanneltype) 取值, value 为对应渠道的分享内容，不同渠道对应支持的分享内容类型参考 [FAQ](./share?tab=FAQ#2-目前-app-内分享渠道分别支持分享哪些内容类型)
- 当 Key 为 `motorcade`, 表示分享到端内车队渠道名称，对应分享内容设置参考[DirectMotorcadeShareOption](./share#directmotorcadeshareoption) 除去公共参数 `context` / `success` / `fail` / `complete` 以及 `channel` 部分, 使用 [示例](#示例))
- 当 Key 为其他分享渠道，对应分享内容设置参考 [DirectShareOption](./share#directshareoption) 除去公共参数 `context` / `success` / `fail` / `complete` 以及 `channel` 部分, 使用 [示例](#示例)

#### ShareTrackOption

分享埋点信息

> 参考[分享埋点](https://dt.amh-group.com/#/metadata/bury-point-management/element-management/1912811)

<API id='Social_ShareTrackOption'></API>

### 返回

#### ShareSuccessCallbackResult

| 属性名  | 描述               | 类型                                                                                                                                                |
| ------- | ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| channel | 用户选择的分享渠道 | `"wechatSession" \| "wechatTimeline" \| "qq" \| "qzone" \| "kwai" \| "douyin" \| "motorcade" \| "phoneCall" \| "sms" \| "saveImage" \| "saveVideo"` |

### 示例

```jsx | pure
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
    motorcade: {
      pageUrl:
        'ymm://app/web?immersive=true&useMBWebView=true&url=https%3A%2F%2Fstatic.ymm56.com%2Fmicroweb%2F%23%2Fmw-fleet%2FfleetSlect%2Findex%3Fselect%3D1%2526content%253Dxxxx',
    },
  },
  shareTrack: {
    shareScene: 'fta-tiga-demo',
    shareParams: { isTest: true },
  },
  context,
})
  .then((res: Tiga.Social.ShareSuccessCallbackResult) => {
    console.log('已分享到渠道:' + res.channel)
  })
  .catch((e: any) => {
    console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
  })
```

## [showShareImageMenu](https://taro-docs.jd.com/docs/apis/share/showShareImageMenu)

<Platform name="social" version="1.1.0"></Platform>

### 介绍

打开分享图片弹窗

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.showShareImageMenu
```

### 类型

```jsx | pure
(opts: Taro.showShareImageMenu.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.showShareImageMenu.Option

<API id='Social_TaroShowShareImageMenuOption'></API>

### 示例

```javascript
Taro.showShareImageMenu({
  context,
  path: 'https://fuss10.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
})
```
