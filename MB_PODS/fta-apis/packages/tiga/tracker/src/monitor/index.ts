import {
  BigDataMonitorEventBuilder,
  DualMonitorEventBuilder,
  HubbleErrorMetricBuilder,
  HubbleMetricBuilder,
  HubblePerformanceMetricBuilder,
  NetworkMonitorEventBuilder,
} from './MonitorEventBuilders'
import {
  CosmosEventData,
  DualReportData,
  HubbleErrorData,
  HubbleMetricData,
  HubbleNetworkData,
} from './types'

// cosmos 大数据平台上报
export function cosmosMonitor(params: CosmosEventData) {
  return BigDataMonitorEventBuilder.event(params)
}

// hubble 平台上报
export function metricMonitor(params: HubbleMetricData): HubbleMetricBuilder {
  return HubbleMetricBuilder.metric(params)
}

export function performanceMonitor(params: HubbleMetricData): HubblePerformanceMetricBuilder {
  return HubblePerformanceMetricBuilder.performance(params)
}

export function errorMonitor(params: HubbleErrorData): HubbleErrorMetricBuilder {
  return HubbleErrorMetricBuilder.error(params)
}

// network 事件默认会同时上报给Hubble和cosmos平台
export function networkMonitor(params: HubbleNetworkData): NetworkMonitorEventBuilder {
  return NetworkMonitorEventBuilder.network(params)
}

// 同时上报给 hubble 和 cosmos
export function hubbleAndCosmosMonitor(options: DualReportData): DualMonitorEventBuilder {
  return new DualMonitorEventBuilder(options.hubble, options.cosmos)
}

export * from './types'
