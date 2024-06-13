import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function vibrateLong(
  option: Taro.vibrateLong.Option
): Promise<TaroGeneral.CallbackResult> {
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.base.vibrateLong',
      null
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { errMsg: null }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { errMsg: `vibrateLong fail, error msg: ${reason}` }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: `vibrateLong fail, error msg: ${error.message}` })
  }
}
