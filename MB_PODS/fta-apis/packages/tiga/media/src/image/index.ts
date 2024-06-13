import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'
import { chooseMedia } from '../taro/chooseMedia'
import { getImageInfo } from '../taro/getImageInfo'
import { uploadFiles } from '@fta/tiga-network'
import { getCacheLocationInfo } from '@fta/tiga-location'
import { getCurrentTime } from '@fta/tiga-common'

/**
 * GetImageBase64Option 类型定义
 */
export interface GetImageBase64Option {
  /** 页面context */
  context?: any
  /** 图片文件路径，可以是临时文件路径或永久文件路径，不支持网络图片路径 */
  imagePath: string
  /** 接口调用成功的回调函数 */
  success?: (res: GetImageBase64SuccessCallbackResult) => void
  /**
   * 接口调用失败的回调函数
   * 错误码：1: 失败 2: 参数错误 3: 无图片访问权限
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: GetImageBase64SuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export interface GetImageBase64SuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 图片 base64 */
  base64: string
}

export async function getImageBase64(
  opts: GetImageBase64Option
): Promise<GetImageBase64SuccessCallbackResult> {
  const { imagePath, context, success, fail, complete } = opts
  try {
    const params = {
      imagePath: imagePath,
    }
    const response = await TigaBridge.call(context, 'app.image.getBase64', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(response.data)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getImageBase64: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export interface SaveImageBase64Option {
  /** 页面context */
  context?: any
  /** 图片base64 */
  base64: string
  /** 图片格式，png/jpg等，默认jpg */
  type: string
  /** 接口调用成功的回调函数 */
  success?: (res: SaveImageBase64SuccessCallbackResult) => void
  /**
   * 接口调用失败的回调函数
   * 错误码：1: 失败 2: 参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: SaveImageBase64SuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export interface SaveImageBase64SuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 图片本地路径 */
  imagePath: string
}

export async function saveBase64(
  opts: SaveImageBase64Option
): Promise<SaveImageBase64SuccessCallbackResult> {
  const { base64, type, context, success, fail, complete } = opts
  try {
    const params = {
      base64: base64,
      type: type,
    }
    const response = await TigaBridge.call(context, 'app.image.saveBase64', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(response.data)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `saveBase64: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export interface WatermarkConfig {
  /** 文字水印，注: textMark 或 imageMark 二者选其一设置 */
  textMark?: string
  /** 图片水印，支持本地图片文件路径，注: textMark 或 imageMark 二者选其一设置 */
  imageMark?: string
  /** 水印位置，tiled: 斜 45° 平铺 */
  pos?: 'left-top' | 'left-bottom' | 'right-top' | 'right-bottom' | 'tiled'
}

export interface WatermarkSource {
  /** 待加水印的原图路径，支持本地图片文件路径 */
  imagePath: string
  /** 水印配置 */
  markConfigs: Array<WatermarkConfig>
}

export interface WatermarkOption {
  /** 页面context */
  context?: any
  /** 水印配置信息 */
  sources: Array<WatermarkSource>
  /** 接口调用成功的回调函数 */
  success?: (res: WatermarkSuccessCallbackResult) => void
  /**
   * 接口调用失败的回调函数
   * 错误码：1: 失败 2: 参数错误 3: 无图片访问权限
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）*/
  complete?: (res: WatermarkSuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export interface WatermarkResultImageFile {
  /** 加完水印的图片文件路径 */
  tempImagePath: string
  /** 图片文件大小，单位 B */
  size: number
}

export interface WatermarkSuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 加完水印的图片信息 */
  files: Array<WatermarkResultImageFile>
}

export async function watermark(opts: WatermarkOption): Promise<WatermarkSuccessCallbackResult> {
  const { sources, context, success, fail, complete } = opts
  try {
    const params = {
      sources,
    }
    const response = await TigaBridge.call(context, 'app.image.watermark', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(response.data)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `watermark: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export interface LocationWatermarkSource {
  /** 待加水印的原图路径，支持本地图片文件路径 */
  imagePath: string
  /** 水印位置 */
  pos?: 'left-top' | 'left-bottom' | 'right-top' | 'right-bottom'
}

export interface LocationWatermarkOption {
  /** 页面context */
  context?: any
  /** 水印配置信息 */
  sources: Array<LocationWatermarkSource>
  /** 接口调用成功的回调函数 {@link WatermarkSuccessCallbackResult} */
  success?: (res: WatermarkSuccessCallbackResult) => void
  /**
   * 接口调用失败的回调函数
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）{@link WatermarkSuccessCallbackResult} */
  complete?: (res: WatermarkSuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export async function locationWatermark(
  opts: LocationWatermarkOption
): Promise<WatermarkSuccessCallbackResult> {
  const { sources, context, success, fail, complete } = opts
  if (!sources || sources.length == 0) {
    const res = {
      code: 1,
      reason: `locationWatermark: fail, errorMsg: 参数设置错误`,
    }
    return errorHandler(fail, complete)(res)
  }
  try {
    const watermarkSources: WatermarkSource[] = await Promise.all(
      sources.map(async (src) => {
        let address = ''
        try {
          const imageInfo = await getImageInfo({
            context: context,
            src: src.imagePath,
          })
          if (imageInfo && imageInfo.location) {
            address = imageInfo.location
          }
        } catch (ignored) {}
        if (!address || address.length === 0) {
          try {
            const locationInfo = await getCacheLocationInfo({
              context: context,
            })
            if (locationInfo && locationInfo.address) {
              address = locationInfo.address
            }
          } catch (ignored) {}
        }
        let currentTimeStr = ''
        try {
          const currentTimeRes = await getCurrentTime({
            context: context,
          })
          currentTimeStr = dateFormat(currentTimeRes.currentTime)
        } catch (ignored) {}

        if (!currentTimeStr) {
          currentTimeStr = dateFormat(new Date())
        }

        const separator =
          currentTimeStr && currentTimeStr.length > 0 && address && address.length > 0 ? '\n' : ''

        return {
          imagePath: src.imagePath,
          markConfigs: [
            {
              textMark: `${currentTimeStr}${separator}${address}`,
              pos: src.pos,
            },
          ],
        }
      })
    )
    const params = {
      sources: watermarkSources,
    }
    const response = await TigaBridge.call(context, 'app.image.watermark', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(response.data)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `locationWatermark: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

function dateFormat(timestamp: number|string|Date): string {
  const date = new Date(timestamp)

  const padZero = (num: number) => (num < 10 ? `0${num}` : num.toString())

  const formatOptions: { [key: string]: string } = {
    'yyyy': `${date.getFullYear()}`,
    'MM': padZero(date.getMonth() + 1),
    'dd': padZero(date.getDate()),
    'HH': padZero(date.getHours()),
    'mm': padZero(date.getMinutes()),
    'ss': padZero(date.getSeconds()),
  }

  return 'yyyy-MM-dd HH:mm:ss'.replace(/yyyy|MM|dd|HH|mm|ss/g, (match) => formatOptions[match])
}


export interface ChooseAndUploadImageOption {
  /** 页面context */
  context?: any
  /** 上传文件对应的 bizType，详情查看: https://boss.amh-group.com/public-service-admin/#/fileCenter/upload */
  bizType: string
  /**
   * 可选择的图片数
   * @default 1
   */
  count?: number
  /** 文件大小上限，单位 B */
  maxSize?: number
  /**
   * 是否支持 相册选择、相机拍摄
   * @default ["album", "camera"]
   */
  sourceType?: Array<'album' | 'camera'>
  /** 图片裁剪比例，如: 1:1，设置了会进入裁剪页面，未设置则不裁剪，图片多选的情况下不支持图片裁剪 */
  cropScale?: string
  /**
   * 使用 自定义相机或者系统拍摄
   * @default "system"
   */
  cameraType?: 'custom' | 'system'
  /**
   * 默认 前置或者后置摄像头，未设置默认为后置摄像头
   * @default "back"
   */
  camera?: 'font' | 'back'
  /** 接口调用成功的回调函数 */
  success?: (res: ChooseAndUploadImageSuccessCallbackResult) => void
  /**
   * 接口调用失败的回调函数
   * 错误码：1: 失败 2: 参数错误 3: 用户未授予权限 4: 用户取消
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: ChooseAndUploadImageSuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export interface ChooseAndUploadImageSuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 上传完阿里云的url */
  ossUrls: string[]
}

export async function chooseAndUploadImage(
  opts: ChooseAndUploadImageOption
): Promise<ChooseAndUploadImageSuccessCallbackResult> {
  const {
    count,
    maxSize,
    sourceType,
    cropScale,
    cameraType,
    camera,
    bizType,
    context,
    success,
    fail,
    complete,
  } = opts

  try {
    const chooseResult = await chooseMedia({
      context: context,
      count: count,
      maxSize: maxSize,
      sourceType: sourceType,
      cropScale: cropScale,
      cameraType: cameraType,
      camera: camera,
      mediaType: ['image'],
    })
    if (!chooseResult?.tempFiles || chooseResult?.tempFiles.length == 0) {
      const res = {
        code: 1,
        reason: `chooseAndUploadImage: fail`,
      }
      return errorHandler(fail, complete)(res)
    }

    const files = chooseResult.tempFiles.map((file) => {
      return {
        bizType: bizType,
        localPath: file.tempFilePath,
      }
    })

    const uploadResult = await uploadFiles({
      context: context,
      files: files,
    })

    if (uploadResult?.ossUrls && uploadResult.ossUrls.length > 0) {
      const res = {
        code: 0,
        ossUrls: uploadResult.ossUrls,
      }
      return successHandler(success, complete)(res)
    } else {
      const res = {
        code: uploadResult.code,
        ossUrls: uploadResult.reason,
      }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    if (e?.code) {
      return errorHandler(fail, complete)(e)
    }
    const res = {
      code: 1,
      reason: `chooseAndUploadImage: fail, errorMsg: ${e?.errMsg || e?.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}
