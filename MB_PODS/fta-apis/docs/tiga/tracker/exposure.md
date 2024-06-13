---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
type: 通用业务埋点
title: 元素曝光
order: 2
---

## exposure

<Platform name="tracker" version="1.0.0"></Platform>

### 介绍

控件曝光埋点

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.exposure
```

### 类型

```javascript
((opts: ExposureTrackParam)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### ExposureTrackParam

<API id="Tracker_ExposureTrackParam"></API>

### 示例

```javascript
Tiga.Tracker.exposure({
  context,
  pageName: 'test',
  elementId: 'button',
  region: 'top',
  pageSessionId: 'psi1234',
  elementUniqueKey: 'uniqueKey123',
  referSpm: 'login',
})
```
