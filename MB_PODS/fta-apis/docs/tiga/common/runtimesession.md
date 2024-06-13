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
title: 应用Session
order: 1
---

# 应用Session

## getSessionInfo

<Platform name="common" version="1.2.0"></Platform>

### 介绍

获取 APP 使用的 Session 信息，此 Session 标识用户一次 APP 使用，Session 刷新时机为 冷启动 和 退后台超过 1 分钟后的热启动

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getSessionInfo
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<SessionInfoCallbackResult>): Promise<SessionInfoCallbackResult>
```

### 参数
#### TigaGeneral.Option&lt;SessionInfoCallbackResult&gt;

<API id="Common_TigaGeneralOption_SessionInfoCallbackResult"></API>

### 返回
#### SessionInfoCallbackResult

<API id="Common_SessionInfoCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Common.getSessionInfo({
  context,
  success: (res) => {
    console.log('getSessionInfo-success', res)
  },
  fail: (res) => {
    console.log('getSessionInfo-fail', res)
  },
})
```
