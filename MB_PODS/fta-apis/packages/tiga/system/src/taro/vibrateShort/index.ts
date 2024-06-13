import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function vibrateShort(
  option: Taro.vibrateShort.Option
): Promise<TaroGeneral.CallbackResult> {
  const params = {
    type: option.type,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.base.vibrateShort',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { errMsg: null }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { errMsg: `vibrateShort fail, error msg: ${reason}` }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: `vibrateShort fail, error msg: ${error.message}` })
  }
}
