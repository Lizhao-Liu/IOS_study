import { errorHandler, successHandler, TigaBridge } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getGroup, STRATEGY_PERMANENT } from '../../utils'

export async function removeStorage(
  option: Taro.removeStorage.Option
): Promise<TaroGeneral.CallbackResult> {
  const { code, reason }: any = await TigaBridge.call(option.context, 'app.storage.remove', {
    group: getGroup(),
    key: option.key,
    strategy: STRATEGY_PERMANENT,
  })

  console.log('app.storage.remove code: ' + code + ' reason: ' + reason)
  if (code == 0) {
    return successHandler(option.success, option.complete)({ errMsg: 'removeStorage:ok' })
  } else {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: "failed in bridge 'app.storage.remove': " + reason })
  }
}
