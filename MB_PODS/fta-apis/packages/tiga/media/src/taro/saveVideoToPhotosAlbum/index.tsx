import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function saveVideoToPhotosAlbum(
  opts: Taro.saveVideoToPhotosAlbum.Option
): Promise<TaroGeneral.CallbackResult> {
  const { filePath, context, success, fail, complete } = opts
  try {
    const params = {
      filePath: filePath,
    }
    const response = await TigaBridge.call(context, 'app.video.saveToAlbum', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const res = { errMsg: null }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `saveVideoToPhotosAlbum: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `saveVideoToPhotosAlbum: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
