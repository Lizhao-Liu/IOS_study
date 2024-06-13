import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function setKeepScreenOn(
  options: Partial<Taro.setKeepScreenOn.Option> = {}
): Promise<TaroGeneral.CallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.base.setKeepScreenOn', {
      keepScreenOn: !!options.keepScreenOn ? 1 : 0,
    })
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(
        options.fail,
        options.complete
      )({ errMsg: 'setKeepScreenOn:fail ' + reason })
    }
    return successHandler(options.success, options.complete)({ errMsg: 'setKeepScreenOn:ok' })
  } catch (e) {
    return errorHandler(
      options.fail,
      options.complete
    )({ errMsg: 'setKeepScreenOn:fail ' + e.message })
  }
}

export { setKeepScreenOn }
