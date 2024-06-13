import { TigaGeneral } from '@fta/tiga-util'

export interface SettingProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 设置的页面, iOS 只支持打开设置页面,Android 支持打开到具体的页面, 通知:push, 定位:location */
  type: string
  /**
   * 接口调用失败的回调函数
   * 错误码：1：失败 2：参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export interface ClipboardProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 设置粘贴板的内容 */
  data: string
  /**
   * 接口调用失败的回调函数
   * 错误码：1：失败 2：参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export interface CallProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 手机号 */
  phone: string
  /**【android使用字段】是否直接拨出，true: 是，false: 否，默认值为false，注: 当用户未授予拨打电话权限的情况下仍然进拨号界面，涉及权限：Tiga.Permission.Permissions.phone */
  directCall?: boolean
  /**
   * 接口调用失败的回调函数
   * 错误码：1：失败 2：参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export interface SmsProps extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 手机号 */
  phone: string
  /** 发送内容 */
  content: string
  /**
   * 接口调用失败的回调函数
   * 错误码：1：失败 2：参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export interface CallResult extends TigaGeneral.CallbackResult {
  /** 【android使用字段】是否直接拨出，true: 是，false: 否 */
  directCall: boolean
}

export interface GetClipboardDataResult extends TigaGeneral.CallbackResult {
  /** 粘贴板内容 */
  content: string
}

export type PhoneObserverCallBack = (res: PhoneObserverResult) => void

export interface PhoneObserverResult extends TigaGeneral.CallbackResult {
  /** 0: 挂断 1： 接通 2： 来电话了 3： 播出电话 */
  status: number
}

export interface PhoneObserverOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 页面context */
  context?: any
  /** 电话监听回调函数, 0: 挂断 1： 接通 2： 来电话了 3： 播出电话
   * @link PhoneObserverCallBack
   */
  callback: PhoneObserverCallBack
}
