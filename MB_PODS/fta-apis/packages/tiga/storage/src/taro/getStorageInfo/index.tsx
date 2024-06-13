import { TigaBridge } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getGroup, STRATEGY_PERMANENT } from '../../utils'

export async function getStorageInfo(
  options?: Taro.getStorageInfo.Option | undefined
): Promise<TaroGeneral.CallbackResult> {
  const { complete, fail, success }: any = options

  const params = {
    group: getGroup(),
    strategy: STRATEGY_PERMANENT,
  }

  const { code, reason, data }: any = await TigaBridge.call(
    options?.context,
    'app.storage.info',
    params
  )

  let p = new Promise<TaroGeneral.CallbackResult>(function (resolve, reject) {
    if (code == 0) {
      const res: TaroGeneral.CallbackResult = {
        errMsg: 'getStoargeInfo:ok',
      }
      const successCallbackOption: Taro.getStorageInfo.SuccessCallbackOption = {
        currentSize: data.totalBytes - data.availableBytes,
        keys: data.keys,
        limitSize: data.totalBytes,
      }
      success && success(successCallbackOption)
      complete && complete(res)
      resolve(res)
    } else {
      const res: TaroGeneral.CallbackResult = {
        errMsg: 'getStoargeInfo:fail:' + reason,
      }
      fail && fail(res)
      complete && complete(res)
      reject(res)
    }
  })

  return p
}
