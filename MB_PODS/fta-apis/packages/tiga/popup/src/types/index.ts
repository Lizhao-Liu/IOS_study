import { TigaGeneral } from '@fta/tiga-util'

export interface ShowCallBack {
  /** 弹窗展示的 code */
  popupCode: number
  /** 弹窗展示的数据 */
  data: string
}

export interface PageInfo {
  /** 弹窗支持展示的页面 */
  page: string
  /** 弹窗的 code */
  popupCode: number
}
export interface InsertProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 弹窗 code */
  popupCode: number
  /** 支持的页面 */
  pageList?: Array<string>
  /** 弹窗的 interfaceName */
  interfaceName: string
  /** 弹窗数据 */
  data: string
  /** 弹窗支持展示的页面 */
  pageInfoList?: Array<PageInfo>
  /** 超时时长 */
  availableSeconds?: number
  /** 业务展示弹窗回调
   * @link ShowCallBack
   */
  show?: (data: ShowCallBack) => void
  /** 是否注册弹窗协议,默认为 false, 多次注册,第一次会注册成功,后续不在进行注册
   * @default false
   */
  isRegisterDialog?: boolean
}

export interface TrackProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 埋点类型 0:无展示， 1：展示，2：点击，3：关闭  */
  type: number
  /** 弹窗 code */
  popupCode: number
  /** 其他的埋点参数 */
  otherParams?: object
}

export interface FinishProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 弹窗 code */
  popupCode: number
}

export interface RegisterProps extends TigaGeneral.Option<RegisterDialogMonitorCallBack> {
  /** 弹窗的 interfaceName */
  interfaceName: string
  /** 请求参数, key 为业务定位的页面，value 为 map 类型，用作该页面聚合接口请求的参数
   * {'maincargo': {'a1': 'b1'}, 'mainservice': {'a2': 'b2'}}
   */
  requestParams?: { [key: string]: { [key: string]: any } }
  /** 支持的页面 */
  pageList?: Array<string>
  /** 业务展示弹窗回调
   * @link ShowCallBack
  */
  show?: (data: ShowCallBack) => void
}

export interface RemoveProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 约定的弹窗唯一标识 */
  dialogId: string
  /** 约定弹窗页面 */
  pageList?: Array<string>
}

export interface UpdateProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 约定的弹窗唯一标识 */
  dialogId: string
  /** 请求参数 */
  requestParams: { [key: string]: any }
  /** 约定的 page */
  page: string
}

export interface RegisterDialogMonitorCallBack extends TigaGeneral.CallbackResult {
  dialogId?: string
}
