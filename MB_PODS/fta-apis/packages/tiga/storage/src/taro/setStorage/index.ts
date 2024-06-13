import { errorHandler, successHandler, TigaBridge } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getGroup, parseString, STRATEGY_PERMANENT } from '../../utils'

export async function setStorage(
  option: Taro.setStorage.Option
): Promise<TaroGeneral.CallbackResult> {
  const { code, reason }: any = await TigaBridge.call(option.context, 'app.storage.set', {
    group: getGroup(),
    key: option.key,
    value: parseString(option.data),
    strategy: STRATEGY_PERMANENT,
  })

  if (code == 0) {
    const res: TaroGeneral.CallbackResult = {
      errMsg: 'setStorage:ok',
    }
    return successHandler(option.success, option.complete)(res)
  } else {
    const res: TaroGeneral.CallbackResult = {
      errMsg: 'setStorage:fail:' + reason,
    }
    return errorHandler(option.fail, option.complete)(res)
  }
}
