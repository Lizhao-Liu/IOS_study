import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function checkIsOpenAccessibility(
  opts: Taro.checkIsOpenAccessibility.Option
): Promise<Taro.checkIsOpenAccessibility.SuccessCallbackResult> {
  const { context, success, fail, complete } = opts
  try {
    const response = await TigaBridge.call(context, 'app.system.checkIsOpenAccessibility')
    if (response?.code == TigaGeneral.SUCCESS) {
      const res: Taro.checkIsOpenAccessibility.SuccessCallbackResult = {
        open: response.data?.open === 1,
        errMsg: 'checkIsOpenAccessibility: ok',
      }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `checkIsOpenAccessibility: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `checkIsOpenAccessibility: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
