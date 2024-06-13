import Taro from '@tarojs/taro'

export const SUCCESS = 0

export interface CallbackResult {
  /** 返回码 */
  code?: number
  /** 错误信息 */
  reason?: string
}

export interface Option<T extends TaroGeneral.CallbackResult | CallbackResult> {
  /** 页面context */
  context?: any
  /** 接口调用成功的回调函数 */
  success?: (res: T) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: T) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: T) => void
}
