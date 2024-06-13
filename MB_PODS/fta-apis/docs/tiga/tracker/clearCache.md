---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
type: 通用业务埋点
title: 清除埋点缓存
order: 4
---

## clearCache

<Platform name="tracker" version="1.0.0"></Platform>

### 介绍

清除埋点缓存

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.clearCache
```

### 类型

```javascript
(opts: ClearTrackCacheParam): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### ClearTrackCacheParam

<API id="Tracker_ClearTrackCacheParam"></API>

### 示例

```javascript
Tiga.Tracker.clearCache({
  context,
  type: 'exposure',
  exposureFactors: {
    pageName: 'test',
    elementId: 'button',
    region: 'top',
    pageSessionId: 'psi1234',
  },
})
```
