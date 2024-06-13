import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function getClipboardData(
  option: Taro.getClipboardData.Option
): Promise<Taro.getClipboardData.Promised> {
  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.base.getClipboardData'
    )
    if (code == TigaGeneral.SUCCESS) {
      const res: Taro.getClipboardData.Promised = { data: data?.content, errMsg: null }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { errMsg: `getClipboardData fail, error msg: ${reason}` }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: `getClipboardData fail, error msg: ${error.message}` })
  }
}
