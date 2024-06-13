import { errorHandler, successHandler, TigaBridge } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getGroup, STRATEGY_PERMANENT } from '../../utils'

export async function clearStorage(
  option?: Taro.clearStorage.Option | undefined
): Promise<TaroGeneral.CallbackResult> {
  const { code, reason }: any = await TigaBridge.call(option?.context, 'app.storage.clear', {
    group: getGroup(),
    strategy: STRATEGY_PERMANENT,
  })

  if (code == 0) {
    return successHandler(option?.success, option?.complete)({ errMsg: 'clearStorage:ok' })
  } else {
    return errorHandler(
      option?.fail,
      option?.complete
    )({ errMsg: "failed in bridge 'app.storage.clear': " + reason })
  }
}
