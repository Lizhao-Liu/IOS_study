import { errorHandler, successHandler, TigaBridge } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getGroup, parseData, STRATEGY_PERMANENT } from '../../utils'

export async function getStorage<T = any>(
  option: Taro.getStorage.Option<T>
): Promise<Taro.getStorage.SuccessCallbackResult<T>> {
  const { code, reason, data }: any = await TigaBridge.call(option.context, 'app.storage.get', {
    group: getGroup(),
    key: option.key,
    strategy: STRATEGY_PERMANENT,
  })

  if (code == 0) {
    const result: Taro.getStorage.SuccessCallbackResult<T> = {
      data: data.value && parseData(data.value),
      errMsg: 'getStorage:ok',
    }
    return successHandler(option.success, option.complete)(result)
  } else {
    const result: Taro.getStorage.SuccessCallbackResult<T> = {
      data: null,
      errMsg: 'getStorage:fail:' + reason,
    }
    return errorHandler(option.fail, option.complete)(result)
  }
}
