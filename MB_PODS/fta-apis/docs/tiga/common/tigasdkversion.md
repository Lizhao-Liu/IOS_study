---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
type:
  title: 运行时信息
  order: 0
title: 获取Tiga版本
order: 4
---

# 获取Tiga版本

## getTigaSDKVersion

<Platform name="common" version="1.2.0"></Platform>

### 介绍

获取 Tiga 原生 SDK 版本号，可用于做 api 兼容性校验，也可直接使用 canIUse

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getTigaSDKVersion
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<SDKVersionResult>): Promise<SDKVersionResult>
```

#### TigaGeneral.Option

<API id="Common_TigaGeneralOption_SDKVersionResult"></API>

#### SDKVersionResult

<API id="Common_SDKVersionResult"></API>

### 示例

```jsx | pure
Tiga.Common.getTigaSDKVersion({
  context,
  success(res) {
    console.log('getTigaSDKVersion-success', res)
  },
  complete(res) {},
  fail(res) {
    console.log('getTigaSDKVersion-fail', res)
  },
})
```
