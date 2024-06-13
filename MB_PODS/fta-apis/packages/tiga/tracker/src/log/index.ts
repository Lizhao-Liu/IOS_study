import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import GlobalParamsManager from '../GlobalParamsManager'

export interface LogOptions extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 日志标签 */
  tag: string
  /** 日志信息 */
  message: string
}

/** 上报debug类型的log日志 */
export function debugLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return _log(params, 1)
}

/** 上报info类型的log日志 */
export function infoLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return _log(params, 2)
}

/** 上报warning类型的log日志 */
export function warningLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return _log(params, 3)
}

/** 上报error类型的log日志 */
export function errorLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return _log(params, 4)
}

/** 上报fatal类型的log日志*/
export function fatalLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return _log(params, 5)
}

async function _log(params: LogOptions, level: number) {
  const { context, success, fail, complete, tag, message } = params || {}
  try {
    let bridgeParams = {
      tag,
      message,
      level,
      bundle: GlobalParamsManager.getInstance().getGlobalConfig().bundle,
    }
    const res = await TigaBridge.call(context, 'app.track.log', bridgeParams)

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}
