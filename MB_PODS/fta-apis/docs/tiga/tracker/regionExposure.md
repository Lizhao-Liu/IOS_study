---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
type: 通用业务埋点
title: 区块曝光
order: 1
---

## regionExposure

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

区块曝光埋点 (如弹窗曝光)

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.regionExposure
```

### 类型

```javascript
((opts: RegionExposureParam)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### RegionExposureParam

<API id="Tracker_RegionExposureParam"></API>

### 示例

```javascript
Tiga.Tracker.regionExposure({
  context,
  pageName: 'test',
  pageSessionId: 'psi1234',
  referSpm: 'login',
  region: 'top',
})
```

## regionDuration

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

区块停留时长埋点 (如弹窗离开)

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.regionDuration
```

### 类型

```javascript
((opts: RegionDurationParam)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### RegionDurationParam

<API id="Tracker_RegionDurationParam"></API>

### 示例

```javascript
Tiga.Tracker.regionDuration({
  context,
  pageName: 'test',
  pageSessionId: 'psi1234',
  duration: 16000,
  region: 'top',
  referSpm: 'login',
})
```
