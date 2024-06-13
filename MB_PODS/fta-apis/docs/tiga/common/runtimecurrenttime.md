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
title: 设备校准时间
order: 2
---

# 设备校准时间

:::info{title=说明}
客户端发起网络请求时，网关会携带当前网关的时间给到客户端，结合本次请求时长，客户端再计算出最终的校准时间
1. 如果校准时间和设备时间差值小于本次请求时长，则判断时间差可能是因为网络请求耗时导致，本次不做校准
2. 如果本地网络请求耗时超过5秒，则判断本次校准可能导致误差变大，本次不做校准
:::

## getCurrentTime

<Platform name="common" version="1.2.0"></Platform>

#### 介绍

获取当前校准时间，用网关时间做校准

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getCurrentTime
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<CurrentTimeCallbackResult>): Promise<CurrentTimeCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;CurrentTimeCallbackResult&gt;

<API id="Common_TigaGeneralOption_CurrentTimeCallbackResult"></API>

### 返回
#### CurrentTimeCallbackResult

<API id="Common_CurrentTimeCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.getCurrentTime({
  context,
  success: (res) => {
    console.log('getCurrentTime-success', res)
  },
  fail: (res) => {
    console.log('getCurrentTime-fail', res)
  },
})
```
