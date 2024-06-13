declare namespace Taro {
  namespace addPhoneCalendar {
    interface Option {
      /** 日历事件标题
       * @default (必选)
       */
      title: string
      /** 开始时间的 unix 时间戳 (1970年1月1日开始所经过的秒数)
       * @default (必选)
       */
      startTime: number
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 接口调用结束的回调函数（调用成功、失败都会执行）    */
      complete?: (res: TaroGeneral.CallbackResult | SuccessCallbackResult) => void
      /** 接口调用成功的回调函数 */
      success?: (res: SuccessCallbackResult) => void
    }
    interface SuccessCallbackResult extends TaroGeneral.CallbackResult {
      /** 【APP 端内生效】日历事件标识 */
      eventKey?: string
    }
  }

  namespace addPhoneRepeatCalendar {
    interface Option {
      /** 日历事件标题
       * @default (必选)
       */
      title: string
      /** 开始时间的 unix 时间戳 (1970年1月1日开始所经过的秒数)
       * @default (必选)
       */
      startTime: number
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 接口调用结束的回调函数（调用成功、失败都会执行）    */
      complete?: (res: TaroGeneral.CallbackResult | SuccessCallbackResult) => void
      /** 接口调用成功的回调函数 */
      success?: (res: SuccessCallbackResult) => void
    }
    interface SuccessCallbackResult extends TaroGeneral.CallbackResult {
      /** 【APP 端内生效】日历事件标识 */
      eventKey?: string
    }
  }
}
