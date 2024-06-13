import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function setClipboardData(
  option: Taro.setClipboardData.Option
): Promise<Taro.setClipboardData.Promised> {
  const params = {
    data: option.data,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.base.setClipboardData',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res: Taro.setClipboardData.Promised = {
        errMsg: null,
        data: option.data,
      }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { errMsg: `setClipboardData fail, error msg: ${reason}` }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: `setClipboardData fail, error msg: ${error.message}` })
  }
}
