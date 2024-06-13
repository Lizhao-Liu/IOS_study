import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface BundleParam {
  bundleType: string
  bundleNames?: string[]
}

export interface GetBundleInfoOption extends TigaGeneral.Option<GetBundleInfoCallbackResult> {
  /** 查询 bundle 的条件信息 */
  bundles: BundleParam[]
  /**
   * 接口调用失败的回调函数
   * 错误码：1：失败 2：参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export interface BundleInfo {
  bundleName: string
  bundleVersion: string
}

export interface BundleResult {
  bundleType: string
  bundleList: BundleInfo[]
}

export interface GetBundleInfoCallbackResult extends TigaGeneral.CallbackResult {
  bundles: BundleResult[]
}

export async function getBundleInfo(
  opts: GetBundleInfoOption
): Promise<GetBundleInfoCallbackResult> {
  const { context, bundles, success, fail, complete } = opts
  try {
    const params = {
      bundles: bundles,
    }
    const res = await TigaBridge.call(context, 'app.common.getBundleInfo', params)

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res.data)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getBundleInfo: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}
