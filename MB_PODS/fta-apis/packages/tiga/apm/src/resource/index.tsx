import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface GetCPUUsageCallbackResult extends TigaGeneral.CallbackResult {
  /**
   * 获取应用当前的 CPU 使用率
   */
  appCpuUsagePercentage?: number
  /**
   * 获取整个设备的总 CPU 使用率, 仅 iOS 支持
   */
  totalCpuUsagePercentage?: number
}

export interface GetMemoryUsageCallbackResult extends TigaGeneral.CallbackResult {
  /**
   * 当前应用使用的内存, 单位(MB)
   */
  appMemoryUsage?: number
  /**
   * 设备上所有应用和系统进程使用的总内存, 单位(MB)
   */
  totalMemoryUsage?: number
  /**
   * 剩余可用内存, 单位(MB)
   */
  availableMemory?: number
  /**
   * 获取设备的总物理内存, 单位(MB)
   */
  totalMemoryForDevice?: number
}

export interface GetStorageUsageCallbackResult extends TigaGeneral.CallbackResult {
  /**
   * 获取设备总存储空间， 单位MB
   */
  totalStorageForDevice?: number
  /**
   * 获取设备的可用存储空间，单位MB
   */
  availableStorage?: number
  /**
   * 获取整个设备的使用的存储空间，单位MB
   */
  totalStorageUsage?: number
}

export interface GetMemoryUsageOption extends TigaGeneral.Option<GetMemoryUsageCallbackResult>{
  /** 接口调用结束的回调函数（调用成功、失败都会执行)
   * @link GetMemoryUsageCallbackResult */
  complete?: (res: TigaGeneral.CallbackResult | GetMemoryUsageCallbackResult) => void
  /** 接口调用成功的回调函数
   * @link GetMemoryUsageCallbackResult  */
  success?: (result: GetMemoryUsageCallbackResult) => void
}

export interface GetStorageUsageOption extends TigaGeneral.Option<GetStorageUsageCallbackResult>{
  /** 接口调用结束的回调函数（调用成功、失败都会执行)
   * @link GetStorageUsageCallbackResult */
  complete?: (res: TigaGeneral.CallbackResult | GetStorageUsageCallbackResult) => void
  /** 接口调用成功的回调函数
   * @link GetStorageUsageCallbackResult  */
  success?: (result: GetStorageUsageCallbackResult) => void
}

async function getMemoryUsage(
  options: GetMemoryUsageOption
): Promise<GetMemoryUsageCallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.apm.getMemoryUsage', {})
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(options.fail, options.complete)({ code, reason })
    }

    let res: GetMemoryUsageCallbackResult = data
    return successHandler(options.success, options.complete)(res)
  } catch (e) {
    return errorHandler(options.fail, options.complete)({ reason: e.message, code: 1 })
  }
}

async function getStorageUsage(
  options: GetStorageUsageOption
): Promise<GetStorageUsageCallbackResult> {
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.apm.getStorageUsage', {})
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(options.fail, options.complete)({ code, reason })
    }

    let res: GetStorageUsageCallbackResult = data
    return successHandler(options.success, options.complete)(res)
  } catch (e) {
    return errorHandler(options.fail, options.complete)({ reason: e.message, code: 1 })
  }
}

export { getMemoryUsage, getStorageUsage }
