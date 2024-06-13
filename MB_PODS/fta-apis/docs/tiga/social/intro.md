---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 社会化功能
  order: 170
title: 总览
order: 0
---

# 社会化功能

<Platform name="social" version="1.1.0"></Platform>

## 介绍

app 社会化行为组件，包括分享、打开第三方小程序等

| 功能                                                | 具体功能描述                          |
| --------------------------------------------------- | ------------------------------------- |
| [打开小程序](./launchMiniProgram.md)                | 打开微信、支付宝小程序                |
| [单渠道分享](./share.md)                            | 分享给指定渠道                        |
| [获取当前应用支持的分享渠道](./getShareChannels.md) | 获取当前应用支持的分享渠道            |
| [弹起分享菜单](./showShareMenu.md)                  | 弹起底部分享菜单                      |
| [多渠道分享](./menuShare.md)                        | 弹起菜单并分享给指定渠道 （组合 API） |

## 作者

<Author name="lizhao.liu"></Author>

## 引用

```jsx | pure
// Tiga Social API 调用
import Tiga from '@fta/tiga'

// 使用 Tiga.Social.xx 调用 social apis
Tiga.Social

// Taro Social API 调用
import Taro from '@tarojs/taro'
```
