---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 自定义数据
type: 监控上报
order: 3
---

# 自定义数据监控上报

:::info{title=说明}

为了实现自定义数据监控上报，需要通过链式调用方式组装埋点数据，最终使用 track 方法触发原生埋点上报到 Hubble、Cosmos 大数据平台。

请确保在调用 track 方法之前，所有必要的埋点信息都已设置。

:::

## metricMonitor

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报 Metric 数据至 Hubble 平台

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.metricMonitor
```

### 类型

```javascript
Tiga.Tracker.metricMonitor(options: HubbleMetricData)
  .attrs(attrs: { [key: string]: any }) // 设置指标通用属性参数，可选
  .stack(stack: HubbleStackData) // 设置堆栈信息，可选
  .reportSuccessRate(isSuccess: boolean) // 开启成功率上报并设置是否成功，可选
  .reportApmResourceInfo(apmResourceQuery?: ApmResourceQuery)  // 资源使用情况数据埋入，可选, 1.4.0 版本新增
  .extra(ext: { [key: string]: any }) // 设置自定义业务参数，可选
  .priority(priority: MonitorEventReportPriority) //设置上报优先级，可选 （不建议设置为高优先级）
  .track(params?: TigaGeneral.Option) : Promise<TigaGeneral.CallbackResult> // 触发数据上报
```

### 参数

#### HubbleMetricData

<API id='Tracker_HubbleMetricData'></API>

#### HubbleStackData

<API id='Tracker_HubbleStackData'></API>

#### Bundle

<API id='Tracker_Bundle'></API>

#### MonitorEventReportPriority

| 枚举值 | 描述                              |
| ------ | --------------------------------- |
| Normal | 默认                              |
| High   | 立即上传 非必须不要设置为立即上传 |

#### ApmResourceQuery<Badge type="warning">1.4.0 版本新增</Badge>

<API id='Tracker_ApmResourceQuery'></API>
传参示例：

```javascript
{
  memory: { duration: 5 }, // 表示埋点需要携带最近5s内memory数据
  cpu: { duration: 5 }, // 表示埋点需要携带最近5s内cpu数据
  storage: true, // 表示埋点需要携带存储空间数据
}
```

对应 apm 性能数据添加到埋点的 attrs 字段格式如下：

```javascript
attrs: {
  {
    "cpu": {
      "totalCpuUsage": [
        14.6,
        36.5
      ],
      "appCpuUsage": [
        47.5,
        15.6
      ],
      "timeInterval": 2 // 表示记录数据的时间间隔，单位s
    },
    "memory": {
      "totalMemoryUsage": [
        4164,
        4106
      ],
      "availableMemory": [
        1467,
        1504
      ],
      "timeInterval": 2, // 表示记录数据的时间间隔，单位s
      "appMemoryUsage": [
        14,
        120
      ],
      "totalMemory": 2973
    },
    "storage": {
      "availableStorage": 18964,
      "totalStorageForDevice": 61005,
    }
  }
}

```

#### TigaGeneral.Option

<API id='TigaGeneralOption_CallbackResult'></API>

### 示例

```javascript
Tiga.Tracker.metricMonitor({
  name: 'your_metric_name',
  /* other parameters */
})
  .attrs({ key: 'value' })
  .stack({
    stack: 'stack_string',
    mappingType: 'mapping_type',
    stackType: 'stack_type',
  })
  .reportApmResourceInfo({
    memory: { duration: 100 },
    cpu: { duration: 100 },
    storage: true,
  })
  .reportSuccessRate(true)
  .extra({ metric_extra_key: 'metric_extra_value' })
  .track({ context })
```

## cosmosMonitor

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报数据至 Cosmos 大数据平台

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.cosmosMonitor
```

### 类型

```javascript
Tiga.Tracker.cosmosMonitor(options: CosmosEventData)
  .extra(ext: { [key: string]: any }) // 设置自定义业务参数，可选
  .priority(priority: MonitorEventReportPriority) //设置上报优先级，可选 （不建议设置为高优先级）
  .track(params?: TigaGeneral.Option) : Promise<TigaGeneral.CallbackResult> // 触发数据上报
```

### 参数

#### CosmosEventData

<API id='Tracker_CosmosEventData'></API>

#### CosmosEventLevel

| 枚举值  | 描述     |
| ------- | -------- |
| Info    | 信息类型 |
| Warning | 警告类型 |
| Error   | 错误类型 |

#### MonitorEventReportPriority

| 枚举值 | 描述                              |
| ------ | --------------------------------- |
| Normal | 默认                              |
| High   | 立即上传 非必须不要设置为立即上传 |

#### TigaGeneral.Option

<API id='TigaGeneralOption_CallbackResult'></API>

### 示例

```javascript
Tiga.Tracker.cosmosMonitor({
  model: 'your_model',
  scenario: 'your_scenario',
  event: Tiga.Tracker.CosmosEventLevel.Error,
})
  .extra({ cosmos_extra_key: 'cosmos_extra_value' })
  .priority(Tiga.Tracker.MonitorEventReportPriority.High)
  .track({ context })
```

## hubbleAndCosmosMonitor

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报 监控 数据至 Hubble 和 Cosmos 大数据平台

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.hubbleAndCosmosMonitor
```

### 类型

```javascript
Tiga.Tracker.hubbleAndCosmosMonitor(options: DualReportData)
  .extra(ext: { [key: string]: any }) // 设置自定义业务参数，可选
  .priority(priority: MonitorEventReportPriority) //设置上报优先级，可选 （不建议设置为高优先级）
  .track(params?: TigaGeneral.Option) : Promise<TigaGeneral.CallbackResult> // 触发数据上报
```

### 参数

#### DualReportData

<API id='Tracker_DualReportData'></API>

#### HubbleEventData

<API id='Tracker_HubbleEventData'></API>

#### MonitorEventReportPriority

| 枚举值 | 描述                              |
| ------ | --------------------------------- |
| Normal | 默认                              |
| High   | 立即上传 非必须不要设置为立即上传 |

#### TigaGeneral.Option

<API id='TigaGeneralOption_CallbackResult'></API>

### 示例

```javascript
Tiga.Tracker.hubbleAndCosmosMonitor({
  hubble: {
    metric: { name: 'metric_name', value: 123 },
    attrs: { testKey: 'testValue' },
  },
  cosmos: {
    model: 'your_model',
    scenario: 'your_scenario',
    event: Tiga.Tracker.CosmosEventLevel.Warning,
  },
})
  .priority(Tiga.Tracker.MonitorEventReportPriority.Normal)
  .extra({ hubble_cosmos_extra_key: 'hubble_cosmos_extra_value' })
  .track({ context })
```
