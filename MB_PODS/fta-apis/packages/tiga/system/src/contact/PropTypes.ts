import { TigaGeneral } from '@fta/tiga-util'

export interface ContactResult extends TigaGeneral.CallbackResult {
  /** 名字 */
  nickName?: string
  /** 所有手机号 */
  phoneNumberList?: Array<string>
}

export interface ContactsResult extends TigaGeneral.CallbackResult {
  /** 联系人数组 */
  list: Array<ContactResult>
}

export interface ContactsProps extends TigaGeneral.Option<ContactsResult> {
  /** 是否请求通讯录权限
   * @default false
   */
  permissionRequest?: boolean
  /** 自定义弹窗文案, permissionRequest 为 true 时必传 */
  rationale?: string
  /** 顶部提示, permissionRequest 为 true 时必传, 只支持 Android */
  topHint?: string
  /** 接口调用失败的回调函数
   * 0: 成功, 1: 失败, 2: 无权限
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行)
   * @link ContactsResult
   * */
  complete: (res: ContactsResult | TigaGeneral.CallbackResult) => void
/** 接口调用成功的回调函数
   * @link ContactsResult
   **/
  success: (res:ContactsResult) => void
}

export interface SelectContactProps extends TigaGeneral.Option<ContactResult> {
  /** 是否请求通讯录权限, 注: 仅安卓有效, iOS 选择联系人不需要权限.
   * @default false
   */
  permissionRequest?: boolean
  /** 自定义弹窗文案, permissionRequest 为 true 时必传 */
  rationale?: string
  /** 顶部提示, permissionRequest 为 true 时必传, 只支持 Android */
  topHint?: string
  /** 接口调用失败的回调函数
   * 0: 成功, 1: 失败, 2: 无权限, 3: 用户取消
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}
