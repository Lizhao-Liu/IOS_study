import { successHandler, errorHandler } from '@fta/tiga-util'
import { getNetworkInfo, NetworkInfoCallbackResult } from '@fta/tiga-common'
import Taro from '@tarojs/taro'

export async function getNetworkType(
  opts: Taro.getNetworkType.Option
): Promise<Taro.getNetworkType.SuccessCallbackResult> {
  const { context, success, fail, complete } = opts

  try {
    const networkInfo: NetworkInfoCallbackResult = await getNetworkInfo({ context })
    const networkType = !networkInfo.status ? 'none' : networkInfo.type
    const res: Taro.getNetworkType.SuccessCallbackResult = {
      networkType: networkType as keyof Taro.getNetworkType.NetworkType,
      errMsg: null,
    }
    return successHandler(success, complete)(res)
  } catch (e) {
    const res = { errMsg: `getNetworkType: fail, errorMsg: ${e?.reason}` }
    return errorHandler(fail, complete)(res)
  }
}
