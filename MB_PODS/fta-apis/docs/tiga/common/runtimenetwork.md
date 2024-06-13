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
title: 网络状态
order: 3
---

# 网络状态

## getNetworkInfo

<Platform name="common" version="1.2.0"></Platform>

### 介绍

获取网络状态

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getNetworkInfo
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<NetworkInfoCallbackResult>): Promise<NetworkInfoCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;NetworkInfoCallbackResult&gt;

<API id="Common_TigaGeneralOption_NetworkInfoCallbackResult"></API>

### 返回
#### NetworkInfoCallbackResult

<API id="Common_NetworkInfoCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.getNetworkInfo({
  context,
  success(res) {
    console.log('getNetworkInfo-success', res)
  },
  complete(res) {},
  fail(res) {
    console.log('getNetworkInfo-fail', res)
  },
})
```
