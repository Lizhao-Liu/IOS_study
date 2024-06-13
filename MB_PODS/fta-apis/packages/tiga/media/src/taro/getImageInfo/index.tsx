import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function getImageInfo(
  opts: Taro.getImageInfo.Option
): Promise<Taro.getImageInfo.SuccessCallbackResult> {
  const { src, context, success, fail, complete } = opts
  try {
    const params = {
      imagePath: src,
    }
    const response = await TigaBridge.call(context, 'app.image.getInfo', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const { width, height, orientation, type, size, timestamp, location } = response.data
      const res: Taro.getImageInfo.SuccessCallbackResult = {
        width: width,
        height: height,
        orientation: orientation ?? 'up',
        type: type,
        path: src,
        size: size,
        timestamp: timestamp,
        location: location,
        errMsg: null,
      }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `getImageInfo: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `getImageInfo: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
