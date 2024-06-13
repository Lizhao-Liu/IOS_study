import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { ChooseMediaFile } from '../../mediaType'

export async function chooseMedia(
  opts: Taro.chooseMedia.Option
): Promise<Taro.chooseMedia.SuccessCallbackResult> {
  const {
    count,
    maxSize,
    cropScale,
    cameraType,
    mediaType,
    sourceType,
    maxDuration,
    sizeType,
    camera,
    context,
    success,
    fail,
  } = opts
  try {
    const params = {
      count: count,
      mediaType: mediaType,
      sourceType: sourceType,
      compressConfig: {
        maxSize: maxSize,
      },
      cropConfig: {
        cropScale: cropScale,
      },
      maxVideoDuration: maxDuration,
      cameraFacing: camera,
      camera: cameraType,
    }
    const response = await TigaBridge.call(context, 'app.media.choose', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const files: Taro.chooseMedia.ChooseMedia[] = response.data?.files?.map(
        (file: ChooseMediaFile) => {
          let tempFilePath
          let size
          if (
            sizeType &&
            sizeType.length == 1 &&
            sizeType[0] == 'original' &&
            (file.originalImagePath?.length ?? 0) > 0
          ) {
            tempFilePath = file.originalImagePath
            size = file.originalImageFileSize
          } else {
            tempFilePath = file.filePath
            size = file.size
          }
          if (file.fileType === 'video') {
            return {
              tempFilePath: tempFilePath,
              originalFilePath: file.originalImagePath,
              fileType: file.fileType,
              size: size,
              thumbTempFilePath: file.videoThumbPath,
              duration: file.duration,
              width: file.width,
              height: file.height
            }
          } else {
            return {
              tempFilePath: tempFilePath,
              originalFilePath: file.originalImagePath,
              fileType: file.fileType,
              size: size
            }
          }
        }
      )
      const res: Taro.chooseMedia.SuccessCallbackResult = {
        tempFiles: files,
        type: null,
        errMsg: null,
      }
      return successHandler(success)(res)
    } else {
      const res = { errMsg: `chooseMedia: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail)(res)
    }
  } catch (e) {
    const res = { errMsg: `chooseMedia: fail, errorMsg: ${e.message}` }
    return errorHandler(fail)(res)
  }
}
