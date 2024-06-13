import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { ChooseMediaFile } from '../../mediaType'

export async function chooseImage(
  opts: Taro.chooseImage.Option
): Promise<Taro.chooseImage.SuccessCallbackResult> {
  const {
    count,
    maxSize,
    cropScale,
    cameraType,
    sourceType,
    sizeType,
    context,
    success,
    fail,
    complete,
  } = opts
  try {
    const params = {
      count: count,
      mediaType: ['image'],
      sourceType: sourceType,
      compressConfig: {
        maxSize: maxSize,
      },
      cropConfig: {
        cropScale: cropScale,
      },
      camera: cameraType,
    }
    const response = await TigaBridge.call(context, 'app.media.choose', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      const tempFilePaths = []
      const tempFiles: Taro.chooseImage.ImageFile[] = response.data?.files?.map(
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
          tempFilePaths.push(tempFilePath)
          return {
            path: tempFilePath,
            originalFilePath: file.originalImagePath,
            size: size,
          } as Taro.chooseImage.ImageFile
        }
      )
      const res: Taro.chooseImage.SuccessCallbackResult = {
        tempFilePaths: tempFilePaths,
        tempFiles: tempFiles,
        errMsg: null,
      }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `chooseImage: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `chooseImage: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}
