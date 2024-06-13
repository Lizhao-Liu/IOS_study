import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface GetCalendarEventOption {
  /** 日历事件标识，可通过新增日历事件方法返回值获取 */
  eventKey: string
  /** 页面context */
  context?: any
  /** 接口调用成功的回调函数
   * @link GetPhoneCalendarEventSuccessCallbackResult
   **/
  success?: (res: GetPhoneCalendarEventSuccessCallbackResult) => void
  /** 接口调用失败的回调函数
   * 错误码:
   * - 1: 参数错误
   * - 2: 无权限
   * - 3: 查找失败
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行
   * @link GetPhoneCalendarEventSuccessCallbackResult
   * */
  complete?: (res: GetPhoneCalendarEventSuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export interface GetPhoneCalendarEventSuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 日历事件标题 */
  title: string
  /** 开始时间的 unix 时间戳 (1970年1月1日开始所经过的秒数) */
  startTime: number
  /** 结束时间的 unix 时间戳 (1970年1月1日开始所经过的秒数) */
  endTime?: number
  /** 是否全天事件 */
  allDay?: boolean
  /** 事件说明 */
  description?: string
  /** 事件位置 */
  location?: string
  /** 是否提醒 */
  alarm?: boolean
  /** 提醒提前量，单位分钟 */
  alarmOffset?: number
  /** 是否重复 */
  repeat: boolean
  /** 重复周期
   * 可选值:
   * - 'day'
   * - 'week'
   * - 'month'
   * - 'year'
   */
  repeatInterval?: string
  /** 重复周期结束时间的 unix 时间戳 */
  repeatEndTime?: number
}

export interface RemovePhoneCalendarEventOption
  extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 日历事件标识，可通过新增日历事件方法返回值获取 */
  eventKey: string
  /** 接口调用失败的回调函数
   * 错误码:
   * - 1: 参数错误
   * - 2: 无权限
   * - 3: 删除失败
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

/**
 * 获取日历事件
 */
async function getPhoneCalendarEvent(
  options: GetCalendarEventOption
): Promise<GetPhoneCalendarEventSuccessCallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.base.getCalendarEvent', {
      eventKey: options.eventKey,
    })
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(options.fail, options.complete)({ code, reason })
    }

    let res: GetPhoneCalendarEventSuccessCallbackResult = data
    // Convert 'allDay' , 'alarm' , 'repeat' to boolean
    if (res.hasOwnProperty('allDay')) {
      res.allDay = !!res.allDay
    }
    if (res.hasOwnProperty('alarm')) {
      res.alarm = !!res.alarm
    }
    if (res.hasOwnProperty('repeat')) {
      res.repeat = !!res.repeat
    }
    return successHandler(options.success, options.complete)(res)
  } catch (e) {
    return errorHandler(options.fail, options.complete)({ reason: e.message, code: 3 })
  }
}

/**
 * 删除日历事件
 */
async function removePhoneCalendarEvent(
  options: RemovePhoneCalendarEventOption
): Promise<TigaGeneral.CallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.base.removeCalendarEvent', {
      eventKey: options.eventKey,
    })
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(options.fail, options.complete)({ code, reason })
    }
    return successHandler(options.success, options.complete)({})
  } catch (e) {
    return errorHandler(options.fail, options.complete)({ reason: e.message, code: 3 })
  }
}

/**
 * 新增日历事件参考使用 taro.addPhoneCalendar 或者 taro.addPhoneRepeatCalendar 方法
 */

export { getPhoneCalendarEvent, removePhoneCalendarEvent }
