import { getSandboxPath, sandboxDir } from '@fta/tiga-storage'
import { TigaBridge, TigaGeneral, errorHandler, successHandler, uuid } from '@fta/tiga-util'

export interface ChooseFileOption {
  /** 页面context */
  context?: any
  /**【android使用字段】格式支持 * /* 、image/* 、video/mp4，注: 为了 android 和 iOS 能正常使用，mimeTypes 和 uniformTypes都需要指定 */
  mimeTypes?: Array<string>
  /** 【iOS 使用字段】使用参考，从如下文档中第一列（Identifier (Constant)）找到需要设置的类型。 https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1
例如，设置 ["public.audio"] 支持选择所有音频，或设置 ["public.mp3", "public.mpeg-4-audio"] 选择指定类型的音频文件。注: 为了 android 和 iOS 能正常使用，mimeTypes 和 uniformTypes都需要指定 */
  uniformTypes?: Array<string>
  /**
   * 可选择的文件数
   * @default 1
   */
  count?: number
  /**
   * 文件大小上限，单位 B
   * @default 512M
   */
  maxSize?: number
  /** 接口调用成功的回调函数 */
  success?: (res: ChooseFileSuccessCallbackResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: ChooseFileSuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export interface FileInfo {
  /** 文件路径 */
  filePath: string
  /** 文件大小 */
  size: number
}

export interface ChooseFileSuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 选择的文件信息 */
  files: Array<FileInfo>
}

export async function chooseFile(opts: ChooseFileOption): Promise<ChooseFileSuccessCallbackResult> {
  const { count, maxSize, mimeTypes, uniformTypes, context, success, fail, complete } = opts
  try {
    const params = {
      count: count,
      maxSize: maxSize,
      mimeTypes: mimeTypes,
      uniformTypes: uniformTypes,
    }
    const response = await TigaBridge.call(context, 'app.file.choose', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(response.data)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `chooseFile: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export interface ChooseAudioOption {
  /** 页面context */
  context?: any
  /** 指定支持的音频格式，如: mp3, ogg */
  types?: Array<string>
  /**
   * 可选择的音频文件数
   * @default 1
   */
  count?: number
  /**
   * 文件大小上限，单位 B
   * @default 512M
   */
  maxSize?: number
  /** 接口调用成功的回调函数 {@link ChooseFileSuccessCallbackResult} */
  success?: (res: ChooseFileSuccessCallbackResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）{@link ChooseFileSuccessCallbackResult} */
  complete?: (res: ChooseFileSuccessCallbackResult | TigaGeneral.CallbackResult) => void
}

export async function chooseAudio(
  opts: ChooseAudioOption
): Promise<ChooseFileSuccessCallbackResult> {
  const { count, maxSize, types, context, success, fail, complete } = opts
  try {
    const params = {
      count: count,
      maxSize: maxSize,
      mimeTypes: ['audio/*'],
      uniformTypes: ['public.audio'],
    }
    const response = await TigaBridge.call(context, 'app.file.choose', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      if (types && types.length > 0) {
        const validFiles = response.data?.files?.filter((file) => {
          const dotIndex = file.filePath.lastIndexOf('.')
          if (dotIndex !== -1 && file.filePath.length > dotIndex + 1) {
            return types.includes(file.filePath.slice(dotIndex + 1))
          }
          return false
        })
        if (!validFiles || validFiles.length == 0) {
          const res = {
            code: 100,
            reason: `当前支持的格式${types.toString()}`,
          }
          return errorHandler(fail, complete)(res)
        } else {
          response.data.files = validFiles
        }
      }
      return successHandler(success, complete)(response.data)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `chooseFile: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export interface FileTransferResult extends TigaGeneral.CallbackResult {
  /** 如果传入了目标路径，该字段和传入值一样，否则为临时目录下文件路径 */
  dstPath?: string
}

/** 目前仅iOS支持该API */
export interface FileTransferOption {
  /** 页面context */
  context?: any
  /** 源文件本地路径 */
  srcPath: string
  /** 如果不传目标路径，将以随机字符串为文件名，存储到临时文件目录(临时文件目录，手机系统会自动清理) */
  dstPath?: string
  /** 源文件格式，目前只支持amr和wav互转 */
  srcFormat: 'amr' | 'wav'
  /** 目标文件格式，目前只支持amr和wav互转 */
  dstFormat: 'amr' | 'wav'
  /** 接口调用成功的回调函数 {@link FileTransferResult} */
  success?: (res: FileTransferResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）{@link FileTransferResult} */
  complete?: (res: FileTransferResult | TigaGeneral.CallbackResult) => void
}

export async function filetransfer(opts: FileTransferOption): Promise<FileTransferResult> {
  const { success, fail, complete } = opts

  try {

    if (!opts || !opts.srcPath || !opts.srcFormat || !opts.dstFormat) {
      const res = {
        code: 1001,
        reason: "缺少必填字段",
      }
      return errorHandler(fail, complete)(res)
    }

    if (opts.srcFormat === 'amr' && opts.dstFormat != 'wav') {
      const res = {
        code: 1002,
        reason: "不支持目标文件格式",
      }
      return errorHandler(fail, complete)(res)
    }

    if (opts.srcFormat === 'wav' && opts.dstFormat != 'amr') {
      const res = {
        code: 1002,
        reason: "不支持目标文件格式",
      }
      return errorHandler(fail, complete)(res)
    }

    const srcPath = await sandboxDir.decodeToAbsolutePath(opts.context, opts.srcPath)
    if (!srcPath || srcPath === null || srcPath === undefined) {
      const res = {
        code: 1002,
        reason: "源文件绝对路径错误",
      }
      return errorHandler(fail, complete)(res)
    }

    var dstPath = opts.dstPath
    if (!opts.dstPath ||
      opts.dstPath === null ||
      opts.dstPath === undefined) {
        const dir = await getSandboxPath({ context: opts.context })
        const tmpdir = dir.tempPath
        if (!tmpdir) {
          const res = {
            code: 1002,
            reason: "生成目标文件路径失败",
          }
          return errorHandler(fail, complete)(res)
        }
        if (tmpdir.endsWith('/')) {
          dstPath = tmpdir + uuid() + '.' + opts.dstFormat
        } else {
          dstPath = tmpdir + '/' + uuid() + '.' + opts.dstFormat
        }
    } else {
      dstPath = await sandboxDir.decodeToAbsolutePath(opts.context, opts.dstPath)
    }

    const params = {
      srcPath: srcPath,
      dstPath: dstPath,
      srcFormat: opts.srcFormat,
      dstFormat: opts.dstFormat
    }
    const response = await TigaBridge.call(
      opts.context,
      'app.file.transfer',
      params
    )

    if (response?.code == TigaGeneral.SUCCESS) {
      const result: FileTransferResult = {
        ...response.data
      }
      result.dstPath = dstPath
      return successHandler(success, complete)(result)
    } else {
      return errorHandler(fail, complete)(response)
    }

  } catch (e) {
    const res = {
      code: 1003,
      reason: `filetransfer: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

