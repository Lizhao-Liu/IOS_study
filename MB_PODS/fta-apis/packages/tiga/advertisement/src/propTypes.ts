import { TigaGeneral } from '@fta/tiga-util'

/// 埋点参数，附带页面

export interface PageLifeProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面标识，需每个页面全局唯一，可以使用 pageName */
  pageSession: string
}

export interface AdModel {
  /** 广告 id */
  advertId: number
  /** 位置 id */
  positionCode: number
  /** 智能投放埋点字段 */
  advertMetricInfo?: string
  /** 广告图片url, 图片广告必填 */
  pictureUrl?: string
  /** 如果是h5广告表示广告h5页面url, h5广告必填；如果是非h5广告表示广告点击跳转地址 */
  url?: string
  /** 文本广告文本内容, 文本广告必填 */
  text?: string
}

export interface VisibleProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面标识，需每个页面全局唯一，可以使用 pageName */
  pageSession: string
  /** 广告控件类型：1 普通广告控件; 2 banner控件 */
  adviewType: number
  /** 广告模型
   * @link AdModel
   */
  adModel: AdModel
}

export interface InVisibleProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面标识，需每个页面全局唯一，可以使用 pageName */
  pageSession: string
  /** 广告 id */
  advertId: number
}

export interface TapProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面标识，需每个页面全局唯一，可以使用 pageName */
  pageSession: string
  /** 广告 id */
  advertId: number
}

export interface CloseProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面标识，需每个页面全局唯一，可以使用 pageName */
  pageSession: string
  /** 广告 ids */
  advertIds: Array<number>
}

/// 埋点参数

export interface LogProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 广告 id */
  adId: number
  /** 位置 id */
  positionCode: number
  /** UTM 标记 */
  utmCampaign?: string
  /** 智能投放埋点字段 */
  advertMetricInfo?: string
}

export interface StayLogProps extends LogProps {
  /** 停留时长，单位 s */
  duration: number
}

/// 其他参数

export interface GetAdProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 位置 id */
  positionCode: number
  /** 场景码 */
  sceneCodes?: Array<string>
  /** 城市id，如果不传，定位开启情况下内部会自动取定位城市 */
  cityId?: number
}

export interface PopupProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 位置 id */
  positionCode: number
  /** 弹窗管控code */
  popupCode?: number
  /** 场景码 */
  sceneCodes?: Array<string>
  /** 城市id，如果不传，定位开启情况下内部会自动取定位城市 */
  cityId?: number
}

export interface RefreshProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面名称 */
  pageName: string
}

/// 返回

export interface AdvertFrequencyRules {
  /** 显示策略类型 1表示app开启期间，不再重复显示 2表示app间隔value的时间再显示	 */
  ruleType: number
  /** 是否生效 */
  status: number
  /** 时间间隔数目 */
  value: number
}

export interface AdvertActivateRules {
  /** 激活类型【1-进入页面展示，2-离开页面展示，3-未操作浏览页面X秒展示】 */
  activateType: number
  /** 广告 id */
  advertId: number
  /** 激活值【3-300（300秒）】 */
  activateValue: number
}

export interface AdDataCallback extends TigaGeneral.CallbackResult {
  /** 广告 id */
  advertId: number
  /** 广告位 id	 */
  positionCode: number
  /** 开始时间 */
  startTime: number
  /** 结束时间 */
  endTime: number
  /** 测试标记 */
  advertTestFlag: boolean
  /** 更新时间 */
  updateTime: number
  /** 图片地址 */
  pictureUrl: string
  /** url */
  url: string
  /** 文案 */
  text: string
  /** 类型 */
  appType: number
  /** 排序 */
  sort: number
  /** 广告显示次数 -1为无限制 */
  frequency: number
  /** UTM 标记 */
  utmCampaign: string
  /** 智能投放埋点字段 */
  advertMetricInfo: string
  /** 视频 url */
  videoUrl: string
  /** 视频 title */
  videoTitle: string
  /** 广告素材类型：1-图片，2-文字，3-气泡，4-H5 */
  advertElementType: number
  /** 图片宽 */
  width: number
  /** 图片高 */
  height: number
  /** 图片高 */
  advertFrequencyRules: AdvertFrequencyRules
  /** 图片高 */
  advertActivateRules: AdvertActivateRules
}

export interface RefreshTextCallback extends TigaGeneral.CallbackResult {
  /** 营销文案 */
  refreshText: string
  /** 用于加载lottie的远程url链接 */
  lottieUrl: string
}
