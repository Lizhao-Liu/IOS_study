import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function previewImage(
  opts: Taro.previewImage.Option
): Promise<TaroGeneral.CallbackResult> {
  const { urls, current, showmenu, context, success, fail, complete } = opts
  try {
    const files = urls?.map((url) => {
      return {
        filePath: url,
        fileType: 'image',
      }
    })
    const currentIndex = urls.indexOf(current)
    const params = {
      sources: files,
      current: currentIndex < 0 ? 0 : currentIndex,
      showSaveToAlbum: showmenu ? 1 : 0,
    }
    const response = await TigaBridge.call(context, 'app.media.preview', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const res = { errMsg: null }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `previewImage: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `previewImage: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
