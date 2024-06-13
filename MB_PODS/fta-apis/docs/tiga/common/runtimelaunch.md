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
title: 启动信息
order: 0
---

# 启动信息

:::info{title=说明}
1. app启动进程信息
2. app启动时间
3. app是否是通过外链启动
:::

## getProcessInfo

<Platform name="common" version="1.2.0"></Platform>

### 介绍

获取 APP 本次启动进程信息

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getProcessInfo
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<ProcessInfoCallbackResult>): Promise<ProcessInfoCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;ProcessInfoCallbackResult&gt;

<API id="Common_TigaGeneralOption_ProcessInfoCallbackResult"></API>

### 返回
#### ProcessInfoCallbackResult

<API id="Common_ProcessInfoCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.getProcessInfo({
  context,
  success: (res) => {
    console.log('getProcessInfo-success', res)
  },
  fail: (res) => {
    console.log('getProcessInfo-fail', res)
  },
})
```

## getAppLaunchTime

<Platform name="common" version="1.3.0"></Platform>

### 介绍

获取 APP 本次启动时间

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getAppLaunchTime
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<AppLaunchTimeCallbackResult>): Promise<AppLaunchTimeCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;AppLaunchTimeCallbackResult&gt;

<API id="Common_TigaGeneralOption_AppLaunchTimeCallbackResult"></API>

### 返回
#### AppLaunchTimeCallbackResult

<API id="Common_AppLaunchTimeCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.getAppLaunchTime({
  context,
  success(res) {
    console.log('getAppLaunchTime-success', res)
  },
  complete(res) {},
  fail(res) {
    console.log('getAppLaunchTime-fail', res)
  },
})
```

## isAppOpenedViaScheme

<Platform name="common" version="1.3.0"></Platform>

### 介绍

获取 APP 是否通过外链启动

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.isAppOpenedViaScheme
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<IsAppOpenedViaSchemeCallbackResult>): Promise<IsAppOpenedViaSchemeCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;IsAppOpenedViaSchemeCallbackResult&gt;

<API id="Common_TigaGeneralOption_IsAppOpenedViaSchemeCallbackResult"></API>

### 返回
#### IsAppOpenedViaSchemeCallbackResult

<API id="Common_IsAppOpenedViaSchemeCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.isAppOpenedViaScheme({
  context,
  success(res) {
    console.log('isAppOpenedViaScheme-success', res)
  },
  complete(res) {},
  fail(res) {
    console.log('isAppOpenedViaScheme-fail', res)
  },
})
```
