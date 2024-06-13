---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
type: 通用业务埋点
title: 点击埋点
order: 3
---

## tap

<Platform name="tracker" version="1.0.0"></Platform>

### 介绍

控件点击埋点

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.tap
```

### 类型

```javascript
((opts: TapTrackParam)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### TapTrackParam

<API id='Tracker_TapTrackParam'></API>

### 示例

```javascript
Tiga.Tracker.tap({
  context,
  pageName: 'test',
  elementId: 'button',
  region: 'top',
  pageSessionId: 'psi1234',
  referSpm: 'login',
})
```
