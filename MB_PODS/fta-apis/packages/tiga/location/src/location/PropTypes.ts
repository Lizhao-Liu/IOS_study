import { TigaGeneral } from '@fta/tiga-util'

export interface LocationProps extends TigaGeneral.Option<LocationInfoCallbackResult> {
  /** 时间间隔范围, 单位 s
   * @default 120
   */
  timeInterval?: number
  /** 是否请求定位权限
   * @default false
   */
  permissionRequest?: boolean
  /** 自定义弹窗文案, permissionRequest 为 true 时必传 */
  rationale?: string
  /** 顶部提示, permissionRequest 为 true 时必传, 只支持 Android */
  topHint?: string
}

export interface WebGeocoderProps extends TigaGeneral.Option<WebLocationInfoCallbackResult> {
  /** 定位经度 gcj02 */
  lon: number
  /** 定位纬度 gcj02 */
  lat: number
}

export interface GeocoderProps extends TigaGeneral.Option<LocationInfoCallbackResult> {
  /** 敏感地址偏移范围，单位 m
   * @default 100
   */
  sensitiveOffset?: number
  /** 定位经度 gcj02 */
  longitude: number
  /** 定位纬度 gcj02 */
  latitude: number
}

export interface LocationInfoCallbackResult extends TigaGeneral.CallbackResult {
  // 匹配城市信息
  /** 城市名 */
  name?: string
  /** 城市全称 */
  fullName?: string
  /** 城市code */
  regionCode?: number
  /** 父级城市code */
  superCode?: number
  /** 城市等级	1：省 2：市 3：区 */
  level?: number
  /** 城市数据库中的经度 */
  regionLongitude?: number
  /** 城市数据库中的纬度 */
  regionLatitude?: number
  /** 城市拼音 */
  pyName?: string
  /** 1可用 0禁用 */
  status?: number
  /** 定位时间,单位 s, 用与判断时间差, getCacheLocationInfo 时值存在 */
  locationTime?: number

  // 定位信息
  /** 定位经度 */
  longitude?: number
  /** 定位纬度 */
  latitude?: number
  /** 地址 */
  address?: string
  /** 省名 */
  province?: string
  /** 市名 */
  city?: string
  /** 区名 */
  district?: string
  /** 门牌号 */
  streetNumber?: string
  /** poi 名称 */
  poi?: string
  /** 街道 */
  street?: string
  /** 地址偏移状态码  1 未处理  2  地址剔除省市区替换名称 3  地址中敏感词替换为空	 */
  sensitiveHandleResultCode?: number
  /** 地址偏移文字描述，与sensitiveHandleResultCode对应	 */
  sensitiveHandleResultDesc?: string

  // 构造信息
  /** 拼接的城市名字,例: 上海市 长宁区, 江苏省 南京市 雨花台区 */
  formatName?: string
  /** 区 id */
  districtId?: number
  /** 市 id */
  cityId?: number
  /** 省 id */
  provinceId?: number

  // 定位附加信息
  /** 位置的精确度，反应与真实位置之间的接近程度，可以理解成10即与真实位置相差10m，越小越精确, 1.3.0 开始支持 */
  accuracy: number
  /** 高度，单位 m, 1.3.0 开始支持 */
  altitude: number
  /** 垂直精度，单位 m（Android 无法获取，返回 0）, 1.3.0 开始支持 */
  verticalAccuracy: number
  /** 水平精度，单位 m, 1.3.0 开始支持 */
  horizontalAccuracy: number
  /** 速度，单位 m/s, 1.3.0 开始支持 */
  speed: number
}

/** 服务端返回的数据 */
export interface WebLocationInfoCallbackResult extends TigaGeneral.CallbackResult {
  /** 经度 */
  lon?: number
  /** 纬度 */
  lat?: number
  /** 结构化地址	 */
  formattedAddress?: string
  /** 省名 */
  provinceName?: string
  /** 省 id */
  provinceId?: number
  /** 市名 */
  cityName?: string
  /** 市 id */
  cityId?: number
  /** 区名 */
  districtName?: string
  /** 区 id */
  districtId?: number
  /** 镇名 */
  town?: string
  /** 镇 id */
  townId?: number
  /** 街道 */
  street?: string
  /** 街道门牌号 */
  streetNumber?: string
  /** poi name */
  poiName?: string
  /** 地址偏移状态码 */
  sensitiveHandleResultCode?: number
  /** 地址偏移文字描述 */
  sensitiveHandleResultDesc?: string
}
