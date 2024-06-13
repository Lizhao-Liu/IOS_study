import Taro from '@tarojs/taro'
import { pop } from '../../index'
import { withCallback } from '../../util/callbacks'
import { nonNullContext } from '../../util/contexts'

export function navigateBack(
  option?: Taro.navigateBack.Option
): Promise<TaroGeneral.CallbackResult> {
  console.log('navigateBack called')
  nonNullContext(option.context)
  const promise = new Promise<TaroGeneral.CallbackResult>((resolve, reject) => {
    pop({
      delta: option?.delta ? option.delta : 1,
      context: option?.context,
    })
      .then(() => resolve({ errMsg: 'navigateBack:ok' }))
      .catch((err) => reject({ errMsg: err }))
  })
  return withCallback(promise, option)
}
