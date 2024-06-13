import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function addPhoneRepeatCalendar(
  options: Partial<Taro.addPhoneRepeatCalendar.Option> = {}
): Promise<Taro.addPhoneRepeatCalendar.SuccessCallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.base.addCalendarEvent', {
      ...validParams(options),
    })
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(
        options.fail,
        options.complete
      )({ errMsg: 'addPhoneRepeatCalendar:fail ' + reason })
    }
    let res: Taro.addPhoneRepeatCalendar.SuccessCallbackResult = {
      eventKey: data?.eventKey,
      errMsg: 'addPhoneRepeatCalendar:ok',
    }
    return successHandler(options.success, options.complete)(res)
  } catch (e) {
    return errorHandler(
      options.fail,
      options.complete
    )({ errMsg: 'addPhoneRepeatCalendar:fail' + e.message })
  }
}

function validParams(options: Partial<Taro.addPhoneCalendar.Option> = {}): any {
  let res: any = options
  if (res.hasOwnProperty('alarm')) {
    res.alarm = Number(!!options.alarm)
  }
  if (res.hasOwnProperty('allDay')) {
    res.allDay = Number(!!options.allDay)
  }
  if (res.hasOwnProperty('endTime')) {
    res.endTime = Number(options.endTime)
  }
  if (res.hasOwnProperty('alarmOffset')) {
    res.alarmOffset = Math.round(options.alarmOffset / 60) //秒转换为分，因为native bridge 提前提醒量参数单位为分钟
  }
  res.repeat = 1
  return res
}

export { addPhoneRepeatCalendar }
