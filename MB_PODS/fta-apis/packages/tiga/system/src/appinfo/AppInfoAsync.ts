import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { AppBaseInfo } from '../systemtype'
import DataCache from '../DataCache'

const APP_TYPE_DRIVER = 'driver'
const APP_TYPE_SHIPPER = 'shipper'

export interface GetDriverAppTypeOption {
  /** 页面context */
  context?: any
  /** 接口调用成功的回调函数 */
  success?: (isDriver: boolean) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: boolean | TigaGeneral.CallbackResult) => void
}

export interface GetShipperAppTypeOption {
  /** 页面context */
  context?: any
  /** 接口调用成功的回调函数 */
  success?: (isShipper: boolean) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: boolean | TigaGeneral.CallbackResult) => void
}

export interface GetAppBrandOption {
  /** 页面context */
  context?: any
  /** 接口调用成功的回调函数 */
  success?: (appBrand: string) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: string | TigaGeneral.CallbackResult) => void
}

/** @returns Promise, 发生错误时会reject 实例为CallbackResult */
async function isDriverAppAsync(
  option: GetDriverAppTypeOption
): Promise<boolean | TigaGeneral.CallbackResult> {
  const { context, success, complete, fail } = option
  if (DataCache.appInfo) {
    if (DataCache.appInfo.appType) {
      let isDriver = false
      if (DataCache.appInfo.appType == APP_TYPE_DRIVER) {
        isDriver = true
      }

      success && success(isDriver)
      complete && complete(isDriver)
      return Promise.resolve(isDriver)
    } else {
      const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
      fail && fail(result)
      complete && complete(result)
      return Promise.reject(result)
    }
  }

  try {
    const res = await TigaBridge.call(context, 'app.system.getAppBaseInfo', {})
    if (res?.code == TigaGeneral.SUCCESS) {
      DataCache.appInfo = res.data
      if (DataCache.appInfo?.appType) {
        let isDriver = false
        if (DataCache.appInfo.appType == APP_TYPE_DRIVER) {
          isDriver = true
        }
        success && success(isDriver)
        complete && complete(isDriver)
        return Promise.resolve(isDriver)
      } else {
        const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
        fail && fail(result)
        complete && complete(result)
        return Promise.reject(result)
      }
    } else {
      const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
      fail && fail(result)
      complete && complete(result)
      return Promise.reject(result)
    }
  } catch (error) {
    const result: TigaGeneral.CallbackResult = { code: 1002, reason: '调用bridge异常' }
    fail && fail(result)
    complete && complete(result)
    return Promise.reject(result)
  }
}

/** @returns Promise, 发生错误时会reject 实例为CallbackResult */
async function isShipperAppAsync(
  option: GetShipperAppTypeOption
): Promise<boolean | TigaGeneral.CallbackResult> {
  const { context, success, complete, fail } = option
  if (DataCache.appInfo) {
    if (DataCache.appInfo.appType) {
      let isShipper = false
      if (DataCache.appInfo.appType == APP_TYPE_SHIPPER) {
        isShipper = true
      }

      success && success(isShipper)
      complete && complete(isShipper)
      return Promise.resolve(isShipper)
    } else {
      const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
      fail && fail(result)
      complete && complete(result)
      return Promise.reject(result)
    }
  }

  try {
    const res = await TigaBridge.call(context, 'app.system.getAppBaseInfo', {})
    if (res?.code == TigaGeneral.SUCCESS) {
      DataCache.appInfo = res.data
      if (DataCache.appInfo?.appType) {
        let isShipper = false
        if (DataCache.appInfo.appType == APP_TYPE_SHIPPER) {
          isShipper = true
        }
        success && success(isShipper)
        complete && complete(isShipper)
        return Promise.resolve(isShipper)
      } else {
        const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
        fail && fail(result)
        complete && complete(result)
        return Promise.reject(result)
      }
    } else {
      const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
      fail && fail(result)
      complete && complete(result)
      return Promise.reject(result)
    }
  } catch (error) {
    const result: TigaGeneral.CallbackResult = { code: 1002, reason: '调用bridge异常' }
    fail && fail(result)
    complete && complete(result)
    return Promise.reject(result)
  }
}

async function getAppBrandAsync(
  option: GetAppBrandOption
): Promise<string | TigaGeneral.CallbackResult> {
  const { context, success, complete, fail } = option
  if (DataCache.appInfo) {
    if (DataCache.appInfo.appBrand) {
      success && success(DataCache.appInfo.appBrand)
      complete && complete(DataCache.appInfo.appBrand)
      return Promise.resolve(DataCache.appInfo.appBrand)
    } else {
      const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
      fail && fail(result)
      complete && complete(result)
      return Promise.reject(result)
    }
  }

  try {
    const res = await TigaBridge.call(context, 'app.system.getAppBaseInfo', {})
    if (res?.code == TigaGeneral.SUCCESS) {
      DataCache.appInfo = res.data
      if (DataCache.appInfo?.appBrand) {
        success && success(DataCache.appInfo?.appBrand)
        complete && complete(DataCache.appInfo?.appBrand)
        return Promise.resolve(DataCache.appInfo?.appBrand)
      } else {
        const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
        fail && fail(result)
        complete && complete(result)
        return Promise.reject(result)
      }
    } else {
      const result: TigaGeneral.CallbackResult = { code: 1001, reason: '获取不支持的api字段' }
      fail && fail(result)
      complete && complete(result)
      return Promise.reject(result)
    }
  } catch (error) {
    const result: TigaGeneral.CallbackResult = { code: 1002, reason: '调用bridge异常' }
    fail && fail(result)
    complete && complete(result)
    return Promise.reject(result)
  }
}

export { isDriverAppAsync, isShipperAppAsync, getAppBrandAsync }
