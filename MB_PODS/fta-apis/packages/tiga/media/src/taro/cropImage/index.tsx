import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function cropImage(
  opts: Taro.cropImage.Option
): Promise<Taro.cropImage.SuccessCallbackResult> {
  const { src, cropScale, context, success, fail, complete } = opts
  try {
    const params = {
      imagePath: src,
      cropScale: cropScale,
    }
    const response = await TigaBridge.call(context, 'app.image.crop', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const { tempImagePath } = response.data
      const res: Taro.cropImage.SuccessCallbackResult = {
        tempFilePath: tempImagePath,
        errMsg: null,
      }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `cropImage: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `cropImage: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
