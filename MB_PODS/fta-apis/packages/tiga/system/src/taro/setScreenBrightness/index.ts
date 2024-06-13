import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function setScreenBrightness(
  options: Partial<Taro.setScreenBrightness.Option> = {}
): Promise<TaroGeneral.CallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.base.setScreenBrightness', {
      value: options.value,
    })
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(
        options.fail,
        options.complete
      )({ errMsg: 'setScreenBrightness:fail ' + reason })
    }
    return successHandler(options.success, options.complete)({ errMsg: 'setScreenBrightness:ok' })
  } catch (e) {
    return errorHandler(
      options.fail,
      options.complete
    )({ errMsg: 'setScreenBrightness:fail ' + e.messages })
  }
}

export { setScreenBrightness }
