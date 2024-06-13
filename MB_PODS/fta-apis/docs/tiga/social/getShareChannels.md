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
title: 获取当前应用支持的分享渠道
order: 1
---

# 获取当前应用支持的分享渠道

:::info{title=说明}

此方法用于获取当前应用支持的所有分享渠道名称。在返回结果中，会过滤掉以下情况：

- 当前设备上未安装的分享平台
- 当前设备上已安装但版本过低不支持分享的分享平台
- 当前应用未注册的分享平台
  :::

## getShareChannels

<Platform name="social" version="1.1.0"></Platform>

### 介绍

获取当前支持的所有分享渠道

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Social.getShareChannels
```

### 类型

```jsx | pure
(opts: GetShareChannelsOption): Promise<GetShareChannelsCallbackResult>
```

### 参数

#### GetShareChannelsOption

<API id='Social_GetShareChannelsOption'></API>

### 返回

#### GetShareChannelsCallbackResult

| 属性名        | 描述                        | 类型                                           |
| ------------- | --------------------------- | ---------------------------------------------- |
| shareChannels | 当前 app 支持的所有分享渠道 | [ShareChannelType](./share#sharechanneltype)[] |

### 示例

```jsx | pure
Tiga.Social.getShareChannels({
  context,
})
  .then((res: Tiga.Social.GetShareChannelsCallbackResult) => {
    console.log(res.shareChannels)
    // 输出支持的分享渠道名称数组
    // [motorcade,wechatSession,saveImage,wechatTimeline,saveVideo,kwai,sms,phoneCall]
  })
  .catch((e: any) => {
    console.log('错误码 【' + e.code + '】 错误原因:' + e.reason)
  })
```
