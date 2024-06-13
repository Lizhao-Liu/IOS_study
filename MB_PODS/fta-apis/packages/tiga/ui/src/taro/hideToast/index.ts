import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function hideToast(
  options: Partial<Taro.hideToast.Option> = {}
): Promise<TaroGeneral.CallbackResult> {
  const { success, fail, complete, context } = options || {}
  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.hideToast', {})
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ errMsg: 'hideToast:fail ' + reason })
    }
    return successHandler(success, complete)({ errMsg: 'hideToast:ok' })
  } catch (e) {
    return errorHandler(fail, complete)({ errMsg: 'hideToast:fail' })
  }
}

export { hideToast }
