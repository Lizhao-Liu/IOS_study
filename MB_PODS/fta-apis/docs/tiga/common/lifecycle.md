---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
title: App 生命周期
order: 1
---

# App 生命周期

## isAppForeground

<Platform name="common" version="1.3.0"></Platform>

### 介绍

获取 APP 是否在前台

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.isAppForeground
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<IsAppForegroundCallbackResult>): Promise<IsAppForegroundCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;IsAppForegroundCallbackResult&gt;

<API id="Common_TigaGeneralOption_IsAppForegroundCallbackResult"></API>

### 返回
#### IsAppForegroundCallbackResult

| 属性名          | 描述           | 类型    | 默认值 |
| --------------- | -------------- | ------- | ------ |
| isAppForeground | app 是否在前台 | boolean | --     |

### 示例

```jsx | pure
Tiga.Common.isAppForeground({
  context,
  success: (res) => {
    console.log('isAppForeground-success', res)
  },
  fail: (res) => {
    console.log('isAppForeground-fail', res)
  },
})
```

## exitApp

<Platform name="common" version="1.3.0"></Platform>

### 介绍

退出 App (关闭所有页面，并杀掉进程)

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.exitApp
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;TigaGeneral.CallbackResult&gt;

<API id="TigaGeneralOption_CallbackResult"></API>

### 返回
#### TigaGeneral.CallbackResult

<API id="TigaGeneral_CallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.exitApp({
  context,
  success(res) {
    console.log('exitApp-success', res)
  },
  fail(res) {
    console.log('exitApp-fail', res)
  },
})
```

## [onAppShow](https://docs.taro.zone/docs/apis/base/weapp/app-event/onAppShow)

<Platform support="thresh,mw,weapp" version="1.1.0"></Platform>

### 介绍

监听 App 切前台事件

:::warning{title=说明}
注意：App 端内不支持回调参数， CallbackResult 中字段值为 undefined
注意：务必在合适时机(离开页面等)调用取消监听 API，Taro.offAppShow
:::

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.onAppShow
```

### 类型

```jsx | pure
(callback: (res: Taro.onAppShow.CallbackResult) => void): void
```

### 参数
#### callback

| 参数     | 类型                                         | 说明                   |
| -------- | -------------------------------------------- | ---------------------- |
| callback | (res: Taro.onAppShow.CallbackResult) => void | App 切前台事件回调函数 |

#### [Taro.onAppShow.CallbackResult](https://docs.taro.zone/docs/apis/base/weapp/app-event/onAppShow#callbackresult)

`详见 Taro 文档, 注意 App端内 result内部字段全部为undefined `
| 属性名 | 描述 | 类型 |
| --------- | --------------------------------- | -------- |
| path | 【注：App 端内返回 undefined】App 切前台的路径 | `string` |
| query | 【注：App 端内返回 undefined】App 切前台的 query 参数 | `TaroGeneral.IAnyObject` |
| shareTicket | 【注：App 端内返回 undefined】 | `string` |
| scene | 【注：App 端内返回 undefined】App 切前台的场景值 | `number` |
| referrerInfo | 【注：App 端内返回 undefined】来源信息。从另一个小程序、公众号或 App 进入小程序时返回。 | `ResultReferrerInfo` |
| forwardMaterials | 【注：App 端内返回 undefined】打开的文件信息数组，只有从聊天素材场景打开（scene 为 1173）才会携带该参数 | `ForwardMaterial[]` |
| chatType | 【注：App 端内返回 undefined】从微信群聊/单聊打开小程序时，chatType 表示具体微信群聊/单聊类型 | `keyof ChatType` |
| apiCategory | 【注：App 端内返回 undefined】API 类别 | `keyof ApiCategory` |

### 示例

```jsx | pure
const appShowCallback = (res) => {
  console.log('Taro App进入前台回调: ', res)
}
Taro.onAppShow(appShowCallback)
```

## [offAppShow](https://docs.taro.zone/docs/apis/base/weapp/app-event/offAppShow)

<Platform support="thresh,mw,weapp" version="1.1.0"></Platform>

### 介绍

取消监听 App 切前台事件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.offAppShow
```

### 类型

```jsx | pure
(callback: (res: Taro.offAppShow.CallbackResult) => void): void
```

### 参数
#### callback

| 参数     | 类型                                          | 说明                                                       |
| -------- | --------------------------------------------- | ---------------------------------------------------------- |
| callback | (res: Taro.offAppShow.CallbackResult) => void | App 切前台事件回调函数，注意需要传监听事件时同一个函数实例 |

### 示例

```jsx | pure
Taro.offAppShow(appShowCallback)
```

## [onAppHide](https://docs.taro.zone/docs/apis/base/weapp/app-event/onAppHide)

<Platform support="thresh,mw,weapp" version="1.1.0"></Platform>

### 介绍

监听 App 切后台事件
注意：务必在合适时机(离开页面等)调用取消监听 API，Taro.offAppHide

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.onAppHide
```

### 类型

```jsx | pure
(callback: (res: Taro.onAppHide.CallbackResult) => void): void
```

### 参数
#### callback

| 参数     | 类型                                         | 说明                     |
| -------- | -------------------------------------------- | ------------------------ |
| callback | (res: Taro.onAppHide.CallbackResult) => void | App 切后台事件的回调函数 |

### 示例

```jsx | pure
const appHideCallback = (res) => {
  console.log('Taro App进入后台回调: ', res)
}
Taro.onAppHide(appHideCallback)
```

## [offAppHide](https://docs.taro.zone/docs/apis/base/weapp/app-event/offAppHide)

<Platform support="thresh,mw,weapp" version="1.1.0"></Platform>

### 介绍
取消监听 App 切后台事件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.offAppHide
```

### 类型

```jsx | pure
(callback: (res: Taro.offAppHide.CallbackResult) => void): void
```

### 参数
#### callback

| 参数     | 类型                                          | 说明                                                         |
| -------- | --------------------------------------------- | ------------------------------------------------------------ |
| callback | (res: Taro.offAppHide.CallbackResult) => void | App 切后台事件的回调函数，注意需要传监听事件时同一个函数实例 |

### 示例

```jsx | pure
Taro.offAppHide(appHideCallback)
```
