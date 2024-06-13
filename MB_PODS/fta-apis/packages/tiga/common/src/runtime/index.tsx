import { TigaGeneral, TigaBridge, successHandler, errorHandler } from '@fta/tiga-util'

export interface ProcessInfoCallbackResult extends TigaGeneral.CallbackResult {
  /** 进程名 */
  processName: string
  /** 进程Id */
  processId: string
  /**
   * 进程启动时间戳
   * @since 1.3.0
   */
  processStartTime: number
}

export interface SessionInfoCallbackResult extends TigaGeneral.CallbackResult {
  /** 本次 session 的开始时间 */
  sessionStartTime: number
  /** session唯一标识 */
  sessionId: string
}

export interface AppLaunchTimeCallbackResult extends TigaGeneral.CallbackResult {
  /** app启动时间（时间戳） */
  appLaunchTime: number
}

export interface CurrentTimeCallbackResult extends TigaGeneral.CallbackResult {
  /** 校准时间（时间戳） */
  currentTime: number
}

export interface NetworkInfoCallbackResult extends TigaGeneral.CallbackResult {
  /** 0：无网络  1: 有网络 */
  status: number
  /** wifi、5g、4g、3g、2g、unknown */
  type: string
  /** 移动、联通、电信、其他 */
  isp: string
}

export interface IsAppForegroundCallbackResult extends TigaGeneral.CallbackResult {
  /** 是否在前台 */
  isAppForeground: boolean
}

export interface IsAppOpenedViaSchemeCallbackResult extends TigaGeneral.CallbackResult {
  /** 是否外链启动 */
  isAppOpenedViaScheme: boolean
}

export async function getProcessInfo(
  opts: TigaGeneral.Option<ProcessInfoCallbackResult>
): Promise<ProcessInfoCallbackResult> {
  const { context, success, fail, complete } = opts

  try {
    const res = await TigaBridge.call(context, 'app.runtime.process')

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res.data)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getProcessInfo: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function getSessionInfo(
  opts: TigaGeneral.Option<SessionInfoCallbackResult>
): Promise<SessionInfoCallbackResult> {
  const { context, success, fail, complete } = opts
  try {
    const res = await TigaBridge.call(context, 'app.runtime.appSession')

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res.data)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getSessionInfo: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function getAppLaunchTime(
  opts: TigaGeneral.Option<AppLaunchTimeCallbackResult>
): Promise<AppLaunchTimeCallbackResult> {
  const { context, success, fail, complete } = opts

  try {
    const processInfoRes = await getProcessInfo({ context })
    if (processInfoRes?.processStartTime) {
      const res: AppLaunchTimeCallbackResult = {
        appLaunchTime: processInfoRes?.processStartTime,
      }
      return successHandler(success, complete)(res)
    } else {
      const res: TigaGeneral.CallbackResult = {
        code: processInfoRes?.code || 1,
        reason: processInfoRes?.reason || '获取进程信息失败',
      }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    if (e?.code) {
      return errorHandler(fail, complete)(e)
    }
    const res = {
      code: 1,
      reason: `getAppLaunchTime: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function getCurrentTime(
  opts: TigaGeneral.Option<CurrentTimeCallbackResult>
): Promise<CurrentTimeCallbackResult> {
  const { context, success, fail, complete } = opts
  try {
    const res = await TigaBridge.call(context, 'app.runtime.currentTime')

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res.data)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getCurrentTime: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function getNetworkInfo(
  opts: TigaGeneral.Option<NetworkInfoCallbackResult>
): Promise<NetworkInfoCallbackResult> {
  const { context, success, fail, complete } = opts
  try {
    const res = await TigaBridge.call(context, 'app.runtime.networkInfo')

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res.data)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getNetworkInfo: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function isAppForeground(
  opts: TigaGeneral.Option<IsAppForegroundCallbackResult>
): Promise<IsAppForegroundCallbackResult> {
  const { context, success, fail, complete } = opts

  try {
    const response = await TigaBridge.call(context, 'app.runtime.isAppForeground')

    if (response?.code == TigaGeneral.SUCCESS) {
      const res: IsAppForegroundCallbackResult = {
        isAppForeground: response.data?.isAppForeground === 1,
      }
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `isAppForeground: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function isAppOpenedViaScheme(
  opts: TigaGeneral.Option<IsAppOpenedViaSchemeCallbackResult>
): Promise<IsAppOpenedViaSchemeCallbackResult> {
  const { context, success, fail, complete } = opts

  try {
    const response = await TigaBridge.call(context, 'app.runtime.isAppOpenedViaScheme')

    if (response?.code == TigaGeneral.SUCCESS) {
      const res: IsAppOpenedViaSchemeCallbackResult = {
        isAppOpenedViaScheme: response.data?.isAppOpenedViaScheme === 1,
      }
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(response)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `isAppOpenedViaScheme: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export async function exitApp(
  opts: TigaGeneral.Option<TigaGeneral.CallbackResult>
): Promise<TigaGeneral.CallbackResult> {
  const { context, success, fail, complete } = opts

  try {
    const res = await TigaBridge.call(context, 'app.runtime.exitApp')

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `exitApp: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}
