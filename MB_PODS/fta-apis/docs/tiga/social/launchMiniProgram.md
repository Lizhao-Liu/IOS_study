---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 社会化功能
  order: 170
title: 打开小程序
order: 1
---

# 打开小程序

:::info{title=说明}

该 API 用于打开并跳转到第三方平台指定小程序，目前支持微信和支付宝。

通过此方法，可以直接打开第三方 app 与对应小程序，若未安装对应 app，则会返回对应错误。

:::

## launchWXMiniProgram

<Platform name="social" version="1.1.0"></Platform>

### 介绍

打开微信小程序

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Social.launchWXMiniProgram
```

### 类型

```jsx | pure
(option: WXMiniProgramOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### WXMiniProgramOption

<API id='Social_LaunchWXMiniProgramOption'></API>

### 示例

```jsx | pure
Tiga.Social.launchWXMiniProgram({
  userName: 'gh_54e9dea35b85',
  context,
}).catch((e: any) => {
  console.log('错误码 ' + e.code + ' 错误原因 ' + e.reason)
})
```

## launchAlipayMiniProgram

<Platform name="social" version="1.1.0"></Platform>

### 介绍

打开支付宝小程序

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Social.launchAlipayMiniProgram
```

### 类型

```jsx | pure
(option: AlipayMiniProgramOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### AlipayMiniProgramOption

<API id='Social_LaunchAlipayMiniProgramOption'></API>

### 示例

```jsx | pure
Tiga.Social.launchAlipayMiniProgram({
  appId: '60000002',
  context,
}).catch((e: any) => {
  console.log('错误码 ' + e.code + ' 错误原因 ' + e.reason)
})
```
