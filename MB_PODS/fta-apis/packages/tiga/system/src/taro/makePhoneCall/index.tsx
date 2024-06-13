import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function makePhoneCall(
  option: Taro.makePhoneCall.Option
): Promise<TaroGeneral.CallbackResult> {
  const params = {
    phone: option.phoneNumber,
    directCall: option.directCall ? 1 : 0,
  }
  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.base.makeCall',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      // const res = {
      //   code: TigaGeneral.SUCCESS,
      //   reason: reason,
      //   directCall: data && data.directCall ? true : false,
      // }
      const res: Taro.makePhoneCall.PhoneCallbackResult = {
        errMsg: null,
        directCall: data && data.directCall ? true : false,
      }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { errMsg: `makeCall fail, error msg: ${reason}` }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: `makeCall fail, error msg: ${error.message}` })
  }
}
