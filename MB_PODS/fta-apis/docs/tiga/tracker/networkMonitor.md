---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 网络数据
type: 监控上报
order: 2
---

# 网络数据监控上报

:::info{title=说明}

为了实现网络数据监控上报，需要通过链式调用方式组装埋点数据，最终使用 track 方法触发原生埋点上报到 Hubble、Cosmos 大数据平台。

请确保在调用 track 方法之前，所有必要的埋点信息都已设置。

:::

## networkMonitor

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报 Network 数据至 Hubble 和 Cosmos 大数据平台

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.networkMonitor
```

### 类型

```javascript
Tiga.Tracker.networkMonitor(options: HubbleNetworkData)
  .extra(ext: { [key: string]: any }) // 设置自定义业务参数，可选
  .priority(priority: MonitorEventReportPriority) //设置上报优先级，可选 （不建议设置为高优先级）
  .track(params?: TigaGeneral.Option) : Promise<TigaGeneral.CallbackResult> // 触发数据上报
```

### 参数

#### HubbleNetworkData

<API id='Tracker_HubbleNetworkData'></API>

#### MonitorEventReportPriority

| 枚举值 | 描述                              |
| ------ | --------------------------------- |
| Normal | 默认                              |
| High   | 立即上传 非必须不要设置为立即上传 |

#### TigaGeneral.Option

<API id='TigaGeneralOption_CallbackResult'></API>

### 示例

```javascript
Tiga.Tracker.networkMonitor({
  url: 'your_url',
  code: 200,
  success: true,
  responseTime: 1200,
  /* other parameters */
})
  .extra({ network_extra_key: 'network_extra_value' })
  .track({ context })
```
