import {
  BundleParam,
  getBundleInfo,
  GetBundleInfoCallbackResult,
  getTigaSDKVersion,
} from '@fta/tiga-common'
import * as TigaModules from './tiga-submodules'

export interface CanIUseTigaOption {
  /** 页面context */
  context?: any
  /**
   * Tiga 目标版本号，用于检查当前 app 是否支持兼容此版本
   * 版本号判断规则：app 中 Tiga 版本号和目标版本号逐段比较，如：app中Tiga版本: a.b.c，目标版本: A.B.C
   *  1. 第一段a和A不相同时，则代表不兼容
   *  2. 若第一段相同，b和B、c和C再逐段比较，相等则比较下一段，大于或者小于则结束比较，若app中Tiga版本大于等于目标版本则代表兼容
   * 注：Tiga SDK 版本号不支持四段
   * @since 1.4.0
   */
  tigaSDKVersion?: string
  /**
   * Tiga 模块，Common/Media等，注：moduleName & api 需同时指定
   */
  moduleName?: string
  /**
   * Tiga 方法名，request/checkPermission等，注：moduleName & api 需同时指定
   */
  api?: string
}

export interface CanIUseBizModuleOption {
  /** 页面context */
  context?: any
  /**
   * xray对应的技术栈类型，flutter/rn/plugin等
   */
  moduleType: string
  /**
   * xray对应的项目名
   */
  moduleName: string
  /**
   * 目标版本号，支持 xx.xx.xx 三段，也支持 xx.xx.xx.xx 四段
   * 规则：xray当前版本和目标版本号逐段比较，比如：当前版本 a.b.c、目标版本 A.B.C.D，a和A、b和B、c和C逐段比较，相等则比较下一段，大于或者小于则结束比较，若当前版本大于等于目标版本号则认为当前版本是可用的
   * 注：三段和四段比较时，如果前三段都相同，三段版本号是小于四段版本号的
   */
  moduleVersion: string
}

export interface CanIUseTigaResult {
  /**
   * 是否可用
   */
  res: boolean
  /**
   * 不可用时的原因
   */
  reason?: string
}

export interface CanIUseBizModuleResult {
  /**
   * 是否可用
   */
  res: boolean
  /**
   * 不可用时的原因
   */
  reason?: string
}

export async function canIUseTiga(opts: CanIUseTigaOption): Promise<CanIUseTigaResult> {
  const res: CanIUseTigaResult = {
    res: true,
  }
  // 缺少参数，则返不可用
  if (!opts || ((!opts.moduleName || !opts.api) && !opts.tigaSDKVersion)) {
    res.res = false
    res.reason = 'canIUseTiga方法的参数设置不正确'
    return Promise.reject(res)
  }
  // 当参数有 moduleName 和 api 时，判断基座是否可用此api
  if (opts.moduleName && opts.api) {
    try {
      if (typeof TigaModules?.[opts.moduleName]?.[opts.api] === 'function') {
        res.res = true
      } else {
        res.res = false
        res.reason = '基座中不存在此方法'
      }
    } catch (ignored) {
      res.res = false
      res.reason = '基座中不存在此方法'
    }
  }

  if (!res.res) {
    return Promise.reject(res)
  }

  // 当参数有 tigaSDKVersion 时，判断当前 app 是否可用此 Tiga 版本
  if (opts.tigaSDKVersion) {
    try {
      const tigaSDKResult = await getTigaSDKVersion({ context: opts.context })
      const curTigaSDKVersion = tigaSDKResult?.SDKVersion
      const isCompatible = compatibilityCheck(curTigaSDKVersion, opts.tigaSDKVersion, true)

      if (isCompatible) {
        res.res = true
        return Promise.resolve(res)
      } else {
        res.res = false
        res.reason = `current version: ${curTigaSDKVersion}, target version: ${opts.tigaSDKVersion}`
        return Promise.reject(res)
      }
    } catch (error) {
      res.res = false
      res.reason = '当前app版本不支持此方法'
      return Promise.reject(res)
    }
  }
  return Promise.resolve(res)
}

export async function canIUseBizModule(
  opts: CanIUseBizModuleOption
): Promise<CanIUseBizModuleResult> {
  const bundles: BundleParam[] = [
    {
      bundleType: opts.moduleType,
      bundleNames: [opts.moduleName],
    },
  ]

  const res: CanIUseBizModuleResult = {
    res: false,
  }
  try {
    const getBundleInfoRes: GetBundleInfoCallbackResult = await getBundleInfo({
      context: opts.context,
      bundles: bundles,
    })
    const currentBundleVersion = getBundleInfoRes?.bundles?.[0].bundleList?.[0].bundleVersion
    const isCompatible = compatibilityCheck(currentBundleVersion, opts.moduleVersion, false)

    if (isCompatible) {
      res.res = true
      return Promise.resolve(res)
    } else {
      res.res = false
      res.reason = `${opts.moduleName} current version: ${currentBundleVersion}, target version: ${opts.moduleVersion}`
      return Promise.reject(res)
    }
  } catch (error) {
    res.res = false
    res.reason = `${opts.moduleName} current version: unknown, target version: ${opts.moduleVersion}`
    return Promise.reject(res)
  }
}

/**
 * SDK 兼容性判断，第一位不一致则不兼容，其他位版本号逐段比较，当前版本大于目标版本则代表可用
 * @param curVersion
 * @param targetVersion
 * @returns
 */
function compatibilityCheck(
  curVersion: string,
  targetVersion: string,
  supportIncompatibleUpgrade: boolean
): boolean {
  try {
    const curVersionInfo = curVersion.split('.')
    const targetVersionInfo = targetVersion.split('.')

    if (curVersionInfo && targetVersionInfo) {
      // 当版本号支持不兼容性升级时，第一位不一致则表示不兼容
      if (supportIncompatibleUpgrade) {
        if (curVersionInfo[0] != targetVersionInfo[0]) {
          return false
        }
      }
      for (let i = 0; i < targetVersionInfo.length; i++) {
        // 当目标版本号长于当前版本号，并且前面都一致时，则不兼容
        if (i >= curVersionInfo.length) {
          return false
        }
        if (parseInt(targetVersionInfo[i]) > parseInt(curVersionInfo[i])) {
          return false
        } else if (parseInt(targetVersionInfo[i]) < parseInt(curVersionInfo[i])) {
          return true
        } else if (i == targetVersionInfo.length - 1) {
          return true
        }
      }
    }
  } catch (error) {}
  return false
}
