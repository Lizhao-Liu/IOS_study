import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function hideLoading(
  options: Partial<Taro.hideLoading.Option> = {}
): Promise<TaroGeneral.CallbackResult> {
  const { success, fail, complete, context } = options || {}

  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.hideLoading', {})
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ errMsg: 'hideLoading:fail ' + reason })
    }
    return successHandler(success, complete)({ errMsg: 'hideLoading:ok' })
  } catch (e) {
    return errorHandler(fail, complete)({ errMsg: 'hideLoading:fail' })
  }
}

export { hideLoading }
