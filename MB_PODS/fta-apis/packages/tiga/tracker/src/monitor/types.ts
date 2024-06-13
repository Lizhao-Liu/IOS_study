import { Bundle } from '../trackParams'

export interface HubbleMetricData {
  /** 指标名 */
  name: string
  /** 指标数据, 比如: 网络耗时时长 */
  value?: number
  /** 指标tags, tags的值必须保证可穷举 */
  tags?: { [key: string]: number | string | boolean }
  /** 监控数据(多个数据时使用) */
  sections?: { [key: string]: number }
}

export interface HubbleErrorData {
  /** 错误标签，用来标识错误 */
  errorTag: string
  /**
   * 错误特征，用来聚合某一个错误，比如调A.b()方法是发生异常，那errorFeature就是由异常信息和此堆栈A.b()构成，这样就能统计调用A.b()发生此异常的次数，也方便hubble聚合
   */
  errorFeature: string
  /** 错误详情，上报不带堆栈的错误使用 */
  errorDetail?: string
}

export interface HubbleNetworkData {
  /** 接口url */
  url: string
  /**
   * http code
   * 如果需要上报业务code可以放扩展业务字段extraDict里上报
   * */
  code: number
  /** 是否成功 */
  success: boolean
  /** 请求耗时，单位：毫秒 */
  responseTime: number
  /** 网关链路id */
  traceID?: string
  /** 请求唯一id */
  requestID?: string
  /** 业务 code，如： ymm 接口 response body 中的 result 字段 */
  bCode?: string
  /** 请求异常 */
  exception?: string
  /**
   * 分段时间
   * @see https://wiki.amh-group.com/pages/viewpage.action?pageId=480628818
   */
  timeSections?: { [key: string]: number }
}

export interface HubbleStackData {
  /**
   * 堆栈信息
   */
  stack: string
  /**
   * 堆栈混淆mapping类型
   */
  mappingType: string
  /**
   * 堆栈解析 - 堆栈类型，解析脚本使用
   */
  stackType: string
  /**
   * bundles信息 - 堆栈解析时需要用到
   */
  bundles?: Bundle[]
}

export interface ApmResourceQuery {
  /**
   * CPU 使用情况
   * - duration 传值表示需要指定在最近一段时间内的使用情况，单位 s，最大值 120
   * - duration 传 0 表示获取最近一次记录的数据
   */
  cpu?: {
    duration?: number
  }

  /**
   * 内存使用情况
   * - duration 传值表示需要指定在最近一段时间内的使用情况，单位 s，最大值 120
   * - duration 传 0 表示仅需要当前时刻的数据
   */
  memory?: {
    duration?: number
  }

  /**
   * 存储空间使用情况
   */
  storage?: boolean
}

export enum MonitorEventReportPriority {
  Normal = 0,
  High = 1,
}

export enum CosmosEventLevel {
  Info = 0,
  Warning = 1,
  Error = 2,
}

export interface CosmosEventData {
  /** 模块信息 */
  model: string
  /** 监控场景信息 */
  scenario: string
  /**
   * 监控级别
   * @link CosmosEventLevel
   * @default CosmosEventLevel.Info
   */
  event?: CosmosEventLevel
}

export interface HubbleEventData {
  /**
   * hubble 指标监控数据
   * @link HubbleMetricData
   *  */
  metric: HubbleMetricData
  /**
   * 堆栈信息
   * @link HubbleStackData
   * */
  stack?: HubbleStackData
  /** hubble 指标公共字段 */
  attrs?: { [key: string]: any }
}

export interface DualReportData {
  /**
   * 上报到 hubble 的数据
   * @link HubbleEventData
   * */
  hubble: HubbleEventData
  /**
   * 上报到 cosmos 大数据平台 的数据
   * @link CosmosEventData
   * */
  cosmos: CosmosEventData
}
