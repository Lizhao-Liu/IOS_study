---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
title: 截屏监听
order: 7
---

# 截屏事件监听

## [onUserCaptureScreen](https://docs.taro.zone/docs/apis/device/screen/onUserCaptureScreen)。

<Platform support="thresh,mw,weapp" version="1.2.0"></Platform>

### 介绍

监听手机截屏事件

注 1：该事件只有 App 在前台才会发送
注 2：端内，Android 端截屏功能依赖存储权限开启，如果无存储权限则监听不到截屏事件，如有强制需求自行申请；iOS 不受存储权限影响。
注 3：务必在合适时机(离开页面等)调用取消监听 API，Taro.offUserCaptureScreen

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.onUserCaptureScreen
```

### 类型

```jsx | pure
(callback: (result: Taro.onUserCaptureScreen.UserCaptureScreenResult) => void): void
```

### 参数
#### callback

| 参数     | 类型                                                               | 说明             |
| -------- | ------------------------------------------------------------------ | ---------------- |
| callback | (result: Taro.onUserCaptureScreen.UserCaptureScreenResult) => void | 截屏事件回调函数 |

#### UserCaptureScreenResult

| 属性名    | 描述                                                                      | 类型     | 默认值 |
| --------- | ------------------------------------------------------------------------- | -------- | ------ |
| localPath | 截屏图片本地路径, 绝对路径 勿缓存；该字段只有端内可用，小程序平台无该字段 | `string` | `--`   |

### 示例

```jsx | pure
const appCaptureCallback = (res) => {
  console.log('Taro App截屏事件: ', res)
  if (res.localPath) {
    console.log('App截屏图片本地绝对路径: ', res.localPath)
  }
}
Taro.onUserCaptureScreen(appCaptureCallback)
```

## [offUserCaptureScreen](https://docs.taro.zone/docs/apis/device/screen/offUserCaptureScreen)

<Platform support="thresh,mw,weapp" version="1.2.0"></Platform>

### 介绍

取消监听手机截屏事件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.offUserCaptureScreen
```

### 类型

```jsx | pure
(callback: (result: Taro.onUserCaptureScreen.UserCaptureScreenResult) => void): void
```

### 参数
#### callback

| 参数     | 类型                                                               | 说明                                                     |
| -------- | ------------------------------------------------------------------ | -------------------------------------------------------- |
| callback | (result: Taro.onUserCaptureScreen.UserCaptureScreenResult) => void | 截屏事件回调函数，注意需要传监听截屏事件时同一个函数实例 |

### 示例

```jsx | pure
Taro.offUserCaptureScreen(appCaptureCallback)
```
