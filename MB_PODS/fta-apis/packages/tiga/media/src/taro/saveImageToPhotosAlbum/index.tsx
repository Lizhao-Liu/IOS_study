import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function saveImageToPhotosAlbum(
  opts: Taro.saveImageToPhotosAlbum.Option
): Promise<TaroGeneral.CallbackResult> {
  const { filePath, context, success, fail, complete } = opts
  try {
    const params = {
      imagePath: filePath,
    }
    const response = await TigaBridge.call(context, 'app.image.saveToAlbum', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const res = { errMsg: null }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `saveImageToPhotosAlbum: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `saveImageToPhotosAlbum: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
