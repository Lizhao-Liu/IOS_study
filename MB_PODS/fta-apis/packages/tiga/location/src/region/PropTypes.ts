import { TigaGeneral } from '@fta/tiga-util'

export interface ChildrenProps extends TigaGeneral.Option<RegionsCallbackResult> {
  /** 行政区 code */
  code: number
  /** 行政区层级 1 省 2 市 3区 */
  deep: number
}

export interface CodeProps extends TigaGeneral.Option<RegionCallbackResult> {
  /** 行政区 code */
  code: number
}

export interface NameProps extends TigaGeneral.Option<RegionCallbackResult> {
  /** 省名 */
  province?: string
  /** 市名 */
  city?: string
  /** 区名 */
  district?: string
}

export interface RegionsCallbackResult extends TigaGeneral.CallbackResult {
  list: Array<RegionCallbackResult>
}
export interface RegionCallbackResult extends TigaGeneral.CallbackResult {
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
  /** 子级别城市列表 */
  children?: Array<RegionCallbackResult>
}
