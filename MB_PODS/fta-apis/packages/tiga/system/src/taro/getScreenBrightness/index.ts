import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function getScreenBrightness(
  options: Partial<Taro.getScreenBrightness.Option> = {}
): Promise<Taro.getScreenBrightness.SuccessCallbackOption> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.base.getScreenBrightness', {})
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(
        options.fail,
        options.complete
      )({ errMsg: 'getScreenBrightness:fail ' + reason })
    }
    let res: Taro.getScreenBrightness.SuccessCallbackOption = { value: data.value, errMsg: null }
    return successHandler(options.success, options.complete)(res)
  } catch (e) {
    return errorHandler(
      options.fail,
      options.complete
    )({ errMsg: 'getScreenBrightness:fail ' + e.message })
  }
}

export { getScreenBrightness }
