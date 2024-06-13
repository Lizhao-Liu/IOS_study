import { TigaGeneral } from '@fta/tiga-util'

export const ERROR_CODE = 1

export interface BaseTrackParam extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 埋点上报优先级
   * 0: 默认 1: 立即上传 (非必须不要立即上传)
   */
  priority?: number
  /**
   * 扩展业务字段
   */
  extraDict?: { [key: string]: any }
}

export interface BaseUITrackParam extends BaseTrackParam {
  /**
   * 页面名称
   */
  pageName: string
  /**
   * 页面会话ID，标识一个页面对象
   * 一个pageSessionId可能对应多个pageLifecycleId
   */
  pageSessionId: string
  /**
   * 来自页面跳转位置信息
   * @see https://wiki.amh-group.com/pages/viewpage.action?pageId=252646537
   */
  referSpm: string
  /**
   * tag的值必须保证可穷举，tag的值类型只支持boolean、string、number
   */
  metricTags?: { [key: string]: number | string | boolean }
}

export interface PageviewTrackParam extends BaseUITrackParam {}

export interface PageviewDurationTrackParam extends BaseUITrackParam {
  /**
   * 页面停留时长 单位: 毫秒
   */
  duration: number
}

export interface TapTrackParam extends BaseUITrackParam {
  /**
   * 控件名
   */
  elementId: string
  /**
   * 区块
   * @see https://wiki.amh-group.com/pages/viewpage.action?pageId=252646537
   */
  region: string
}

export interface ExposureTrackParam extends BaseUITrackParam {
  /**
   * 控件名
   */
  elementId: string
  /**
   * 区块
   * @see https://wiki.amh-group.com/pages/viewpage.action?pageId=252646537
   */
  region: string
  /**
   * 控件唯一ID，做曝光去重使用
   */
  elementUniqueKey?: string
}

export interface RegionExposureParam extends BaseUITrackParam {
  /**
   * 区块
   * @see https://wiki.amh-group.com/pages/viewpage.action?pageId=252646537
   */
  region: string
  /**
   * 控件唯一ID，做曝光去重使用
   */
  elementUniqueKey?: string
}

export interface RegionDurationParam extends RegionExposureParam {
  /**
   * 停留时长 单位: 毫秒
   */
  duration: number
}

export interface ClearTrackCacheParam extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 缓存类型，控件曝光埋点使用 exposure
   */
  type: string
  /**
   * 控件曝光因子
   */
  exposureFactors: {
    pageName: string
    pageSessionId: string
    region?: string
    elementId?: string
  }
}

export interface MonitorTrackParam extends BaseTrackParam {
  metric?: MetricData
  category?: string
  attrs?: { [key: string]: any }
  model?: string
  scenario?: string
  event?: EventLevel
}

export interface MetricData {
  name: string
  type: MetricType
  value: number
  tags?: { [key: string]: number | string | boolean }
  sections?: { [key: string]: number }
}

export enum MetricType {
  Counter = 0,
  Gauge = 1,
}

export enum EventLevel {
  Info = 0,
  Warning = 1,
  Error = 2,
}

export enum LogLevel {
  Debug = 1,
  Info = 2,
  Warning = 3,
  Error = 4,
}

export interface LogParam extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  level: LogLevel
  tag: string
  message: string
}

export interface NetworkTrackParam extends BaseTrackParam {
  url: string
  isSuccess: boolean
  code: number
  responseTime: number
  bCode?: number
  timeSections?: { [key: string]: number }
  traceId?: string
  requestId?: string
  exception?: string
  metricTags?: { [key: string]: number | string | boolean }
}

export interface ErrorTrackParam extends BaseTrackParam {
  errorTag: string
  errorFeature: string
  stack?: string
  errorDetail?: string
  mappingType?: string
  stackType?: string
  metricTags?: { [key: string]: number | string | boolean }
}

export interface TransactionTrackParam extends BaseTrackParam {
  action: string
  begin?: TransactionTrackBeginAction
  section?: TransactionTrackSectionAction
  beginIsolatedSection?: TransactionTrackCommonAction
  endIsolatedSection?: TransactionTrackCommonAction
  end?: TransactionTrackCommonAction
}

export interface TransactionTrackCommonAction {
  trackId?: string
  /**
   * 分段名称
   */
  sectionName: string
  /**
   * 路径
   */
  path?: string
  /**
   * tag 的值必须保证可穷举
   */
  tags?: { [key: string]: number | string | boolean }
}

export interface TransactionTrackSectionAction extends TransactionTrackCommonAction {
  /**
   * 自定义开始点
   */
  beginAt?: number
  /**
   * 自定义结束点
   */
  endAt?: number
}

export interface TransactionTrackBeginAction {
  /**
   * 分段埋点metricName
   */
  metricName: string
  /**
   * 若有不使用track id，埋点框架内部映射track id追踪
   */
  path: string
  /**
   * 此分段耗时埋点进入大数据时，必传，如果只需进入hubble则可不传
   */
  scenario?: string
  /**
   * tag的值必须保证可穷举，tag的值类型只支持boolean、string、number
   */
  tags?: { [key: string]: number | string | boolean }
}

export interface TransactionTrackBeginCallbackResult extends TigaGeneral.CallbackResult {
  transactionTrackId: string
}

export interface TransactionTracker extends Promise<TransactionTrackBeginCallbackResult> {
  section(action: TransactionTrackSectionAction, trackParam?: Partial<BaseTrackParam>): Promise<any>
  beginIsolatedSection(
    action: TransactionTrackCommonAction,
    trackParam?: Partial<BaseTrackParam>
  ): Promise<any>
  endIsolatedSection(
    action: TransactionTrackCommonAction,
    trackParam?: Partial<BaseTrackParam>
  ): Promise<any>
  end(action: TransactionTrackCommonAction, trackParam?: Partial<BaseTrackParam>): Promise<any>
}

export interface Bundle {
  /**
   * bundle 类型 (h5, rn, flutter, thresh,  davinci, logic)
   */
  type: string
  /**
   * bundle 名
   */
  name: string
  /**
   * bundle 版本号
   */
  version: string
  /**
   * 标识一次构建，埋点和上传mapping时需要一一对应
   */
  uuid?: string
}

export interface TrackerGlobalConfigParams {
  /**
   * bundle信息
   */
  bundle?: Bundle // tracker内部自动获取
  /**
   * 公用自定义埋点业务参数，自动添加埋点当中
   */
  extraDict?: { [key: string]: any }
}
