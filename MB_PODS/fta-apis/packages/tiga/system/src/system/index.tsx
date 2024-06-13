import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { PhoneObserverOption, SettingProps, SmsProps } from './PropTypes'

let phoneCallBackArray = []

const MBPhoneState = 'MBPhoneState'

export async function openSystemSetting(option: SettingProps): Promise<TigaGeneral.CallbackResult> {
  const params = {
    type: option.type,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.base.openSystemSetting',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `openSystemSetting fail, error msg: ${error.message}` })
  }
}

export async function sendSms(option: SmsProps): Promise<TigaGeneral.CallbackResult> {
  const params = {
    phone: option.phone,
    content: option.content,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.base.sendSms', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `sendSms fail, error msg: ${error.message}` })
  }
}

export async function onCallStatusChange(
  option: PhoneObserverOption
): Promise<TigaGeneral.CallbackResult> {
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.base.onCallStatusChange',
      null
    )
    if (code == TigaGeneral.SUCCESS) {
      // 添加监听
      const index = phoneCallBackArray.indexOf(option.callback)
      if (index == -1) {
        // 说明未添加过，进行添加
        TigaGeneral.eventCenter.on(MBPhoneState, option.callback)
      } else {
        console.log('已经添加过该监听了')
        const res = { code: 3, reason: '已经添加过该监听了' }
        return errorHandler(option.fail, option.complete)(res)
      }
      phoneCallBackArray = phoneCallBackArray.concat(option.callback)
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `onCallStatusChange fail, error msg: ${error.message}` })
  }
}

export async function offCallStatusChange(
  option: PhoneObserverOption
): Promise<TigaGeneral.CallbackResult> {
  const index = phoneCallBackArray.indexOf(option.callback)
  console.log('count' + phoneCallBackArray.length + 'index: ' + index)
  // 匹配到当前的 callBack， 再去做业务处理，未匹配到说明已经移除过了
  if (index != -1) {
    // 包含
    phoneCallBackArray = phoneCallBackArray.filter((callback) => {
      return callback !== option.callback
    })
    // 移除监听
    TigaGeneral.eventCenter.off(MBPhoneState, option.callback)

    // 说明所有的业务都已经移除了
    if (phoneCallBackArray.length == 0) {
      try {
        const { code, reason }: any = await TigaBridge.call(
          option.context,
          'app.base.offCallStatusChange',
          null
        )
        if (code == TigaGeneral.SUCCESS) {
          const res = { code: TigaGeneral.SUCCESS, reason: reason }
          return successHandler(option.success, option.complete)(res)
        } else {
          const res = { code: code, reason: reason }
          return errorHandler(option.fail, option.complete)(res)
        }
      } catch (error) {
        return errorHandler(
          option.fail,
          option.complete
        )({ code: 1, reason: `offCallStatusChange fail, error msg: ${error.message}` })
      }
    } else {
      const res = { code: TigaGeneral.SUCCESS, reason: '成功' }
      return successHandler(option.success, option.complete)(res)
    }
  } else {
    const res = { code: 3, reason: '已经移除过该监听了' }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export * from './PropTypes'
