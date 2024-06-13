import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import GlobalParamsManager from '../GlobalParamsManager'
import {
  ApmResourceQuery,
  CosmosEventData,
  CosmosEventLevel,
  HubbleErrorData,
  HubbleEventData,
  HubbleMetricData,
  HubbleNetworkData,
  HubbleStackData,
  MonitorEventReportPriority,
} from './types'

abstract class MonitorEventBuilderBase {
  protected _extraDict?: { [key: string]: any } = {}
  protected _priority: MonitorEventReportPriority = MonitorEventReportPriority.Normal

  // 设置额外的自定义业务参数
  extra(ext: { [key: string]: any }): this {
    this._extraDict = { ...this._extraDict, ...ext }
    return this
  }

  /**
   * 设置事件上报的优先级。
   * 注意：不建议将优先级设置为 high，因为这可能会导致事件的重复上报。
   *
   * @param priority 事件的上报优先级
   * @returns 返回当前实例以支持方法链式调用
   */
  priority(priority: MonitorEventReportPriority): this {
    //默认为normal，不建议设置为high（可能会出现重复上报）
    this._priority = priority
    return this
  }

  // 调用bridge，上报埋点数据
  track(
    params?: TigaGeneral.Option<TigaGeneral.CallbackResult>
  ): Promise<TigaGeneral.CallbackResult> {
    const { context, success, fail, complete } = params || {}
    try {
      return TigaBridge.call(
        context,
        this.getBridgeCallIdentifier(),
        this.getBridgeCallParams()
      ).then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          return successHandler(success, complete)(res)
        } else {
          return errorHandler(fail, complete)(res)
        }
      })
    } catch (e) {
      const res = {
        code: 1,
        reason: `errorMsg: ${e.message}`,
      }
      return errorHandler(fail, complete)(res)
    }
  }

  protected getMergedParams(localParams: any): any {
    const { extraDict, ...rest } = localParams
    const mergedExtraDict = {
      ...GlobalParamsManager.getInstance().getGlobalConfig().extraDict,
      ...extraDict,
    }

    return {
      ...rest,
      bundle: GlobalParamsManager.getInstance().getGlobalConfig().bundle,
      extraDict: mergedExtraDict,
    }
  }

  // 抽象方法，每个子类都需要提供最终调用bridge的方法名称
  protected abstract getBridgeCallIdentifier(): string

  // 抽象方法，每个子类都需要提供最终调用bridge传递参数的数据结构
  protected abstract getBridgeCallParams(): any
}

export class HubbleMetricBuilder extends MonitorEventBuilderBase {
  protected _metric: HubbleMetricData
  protected _stack: HubbleStackData
  protected _attrs: { [key: string]: any }
  protected _reportSuccessRate: boolean = false // 默认不上报成功率
  protected _isSuccess?: boolean // 用于存储操作是否成功的状态
  protected _apmResourceQuery: ApmResourceQuery

  static metric(metricData: HubbleMetricData): HubbleMetricBuilder {
    let hubbleMetric = new HubbleMetricBuilder()
    hubbleMetric._metric = metricData
    return hubbleMetric
  }

  // 通用指标属性
  attrs(attrs: { [key: string]: any }): this {
    this._attrs = { ...this.attrs, ...attrs }
    return this
  }

  // 堆栈信息
  stack(stack: HubbleStackData): this {
    this._stack = stack
    return this
  }

  // 标记为成功或失败
  // 设置成功失败状态后默认开启成功率上报
  reportSuccessRate(isSuccess: boolean): this {
    this._reportSuccessRate = true // 开启成功率上报
    this._isSuccess = isSuccess
    return this
  }

  reportApmResourceInfo(apmResourceQuery?: ApmResourceQuery): this {
    const defaultQuery: ApmResourceQuery = {
      cpu: { duration: 0 },
      memory: { duration: 0 },
      storage: true,
    }

    this._apmResourceQuery = apmResourceQuery ?? defaultQuery
    return this
  }

  protected getBridgeCallParams(): any {
    // 如果设置了堆栈信息，将 stack 信息合并为 attrs 上报
    this._attrs = Object.assign(this._attrs || {}, this._stack)

    // 如果需要上报成功率，向 _metric 中的 tags 字段添加一个 'success' key
    if (this._reportSuccessRate && typeof this._isSuccess !== 'undefined') {
      this._metric.tags = this._metric.tags || {} // 确保 tag 字段存在
      this._metric.tags.success = this._isSuccess ? 1 : 0
    }

    const localParams = {
      metric: getValidHubbleMetricData(this._metric),
      attrs: this._attrs,
      category: this.getBridgeCallMonitorCategory(),
      priority: this._priority,
      apmResourceQuery: this._apmResourceQuery,
      extraDict: this._extraDict,
    }

    return this.getMergedParams(localParams)
  }

  protected getBridgeCallMonitorCategory(): string {
    return 'custom'
  }

  protected getBridgeCallIdentifier(): string {
    return 'app.track.monitor'
  }
}

export class HubblePerformanceMetricBuilder extends HubbleMetricBuilder {
  static performance(performanceMetricData: HubbleMetricData): HubblePerformanceMetricBuilder {
    let hubbleMetric = new HubblePerformanceMetricBuilder()
    hubbleMetric._metric = performanceMetricData
    return hubbleMetric
  }

  protected getBridgeCallMonitorCategory(): string {
    return 'performance'
  }
}

export class HubbleErrorMetricBuilder extends MonitorEventBuilderBase {
  protected _error: HubbleErrorData
  protected _stack: HubbleStackData
  protected _apmResourceQuery: ApmResourceQuery

  static error(errorData: HubbleErrorData): HubbleErrorMetricBuilder {
    let hubbleMetric = new HubbleErrorMetricBuilder()
    hubbleMetric._error = errorData
    return hubbleMetric
  }

  // 错误堆栈信息
  stack(stack: HubbleStackData): this {
    this._stack = stack
    return this
  }

  reportApmResourceInfo(apmResourceQuery?: ApmResourceQuery): this {
    const defaultQuery: ApmResourceQuery = {
      cpu: { duration: 0 },
      memory: { duration: 0 },
      storage: true,
    }

    this._apmResourceQuery = apmResourceQuery ?? defaultQuery
    return this
  }

  protected getBridgeCallIdentifier(): string {
    return 'app.track.error'
  }

  protected getBridgeCallParams(): any {
    const localParams = {
      ...this._error,
      ...this._stack,
      apmResourceQuery: this._apmResourceQuery,
      priority: this._priority,
      extraDict: this._extraDict,
    }
    return this.getMergedParams(localParams)
  }
}

export class NetworkMonitorEventBuilder extends MonitorEventBuilderBase {
  protected _network: HubbleNetworkData

  static network(networkData: HubbleNetworkData): NetworkMonitorEventBuilder {
    let hubbleMetric = new NetworkMonitorEventBuilder()
    hubbleMetric._network = networkData
    return hubbleMetric
  }

  protected getBridgeCallIdentifier(): string {
    return 'app.track.network'
  }

  protected getBridgeCallParams(): any {
    let network: any = this._network
    if (network.hasOwnProperty('success')) {
      network.success = Number(!!network.success) //boolean 转换为number
    }
    const localParams = {
      ...network,
      priority: this._priority,
      extraDict: this._extraDict,
    }
    return this.getMergedParams(localParams)
  }
}

export class BigDataMonitorEventBuilder extends MonitorEventBuilderBase {
  protected _event: CosmosEventData

  static event(eventData: CosmosEventData): BigDataMonitorEventBuilder {
    let cosmosEvent = new BigDataMonitorEventBuilder()
    cosmosEvent._event = eventData
    return cosmosEvent
  }

  protected getBridgeCallIdentifier(): string {
    return 'app.track.monitor'
  }

  protected getBridgeCallParams(): any {
    const localParams = {
      ...getValidCosmosEventData(this._event),
      priority: this._priority,
      extraDict: this._extraDict,
    }
    return this.getMergedParams(localParams)
  }
}

export class DualMonitorEventBuilder extends MonitorEventBuilderBase {
  private _hubbleData: HubbleEventData
  private _cosmosData: CosmosEventData

  constructor(hubbleData: HubbleEventData, cosmosData: CosmosEventData) {
    super()
    this._hubbleData = hubbleData
    this._cosmosData = cosmosData
  }

  protected getBridgeCallIdentifier(): string {
    return 'app.track.monitor'
  }

  protected getBridgeCallParams(): any {
    if (this._hubbleData.hasOwnProperty('stack')) {
      this._hubbleData.attrs = Object.assign(this._hubbleData?.attrs || {}, this._hubbleData?.stack)
      delete this._hubbleData.stack
    }
    const localParams = {
      metric: getValidHubbleMetricData(this._hubbleData?.metric),
      attrs: this._hubbleData?.attrs,
      ...getValidCosmosEventData(this._cosmosData),
      category: 'custom',
      priority: this._priority,
      extraDict: this._extraDict,
    }
    return this.getMergedParams(localParams)
  }
}

function getValidHubbleMetricData(data: HubbleMetricData): any {
  let metric: any = data
  metric.type = metric.hasOwnProperty('value') ? 1 : 0
  metric.value = metric.hasOwnProperty('value') ? metric.value : 1
  return metric
}

function getValidCosmosEventData(data: CosmosEventData): any {
  let eventData: any
  const { model, scenario, event = CosmosEventLevel.Info } = data
  eventData = { model, scenario, event }
  return eventData
}
