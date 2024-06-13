---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
type: 通用业务埋点
title: 页面曝光
order: 0
---

## pageview

<Platform name="tracker" version="1.0.0"></Platform>

### 介绍

页面曝光埋点

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.pageview
```

### 类型

```javascript
((opts: PageviewTrackParam)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### PageviewTrackParam

<API id='Tracker_PageviewTrackParam'></API>

### 示例

```javascript
Tiga.Tracker.pageview({
  context,
  pageName: 'test',
  pageSessionId: 'psi1234',
  referSpm: 'login',
})
```

## pageviewDuration

<Platform name="tracker" version="1.0.0"></Platform>

### 介绍

页面停留时长埋点

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.pageviewDuration
```

### 类型

```javascript
((opts: PageviewDurationTrackParam)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### PageviewDurationTrackParam

<API id='Tracker_PageviewDurationTrackParam'></API>

### 示例

```javascript
Tiga.Tracker.pageviewDuration({
  context,
  pageName: 'test',
  pageSessionId: 'psi1234',
  duration: 16000,
  referSpm: 'login',
})
```
