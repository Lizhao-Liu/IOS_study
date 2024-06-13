import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function compressImage(
  opts: Taro.compressImage.Option
): Promise<Taro.compressImage.SuccessCallbackResult> {
  const {
    src,
    quality,
    maxSize,
    compressedWidth,
    compressHeight,
    context,
    success,
    fail,
    complete,
  } = opts
  try {
    const params = {
      imagePath: src,
      quality: quality,
      maxSize: maxSize,
      compressedWidth: compressedWidth,
      compressedHeight: compressHeight,
    }
    const response = await TigaBridge.call(context, 'app.image.compress', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const { tempImagePath } = response.data
      const res: Taro.compressImage.SuccessCallbackResult = {
        tempFilePath: tempImagePath,
        errMsg: null,
      }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `compressImage: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `compressImage: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
