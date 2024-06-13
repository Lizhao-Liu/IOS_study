import Taro from '@tarojs/taro'
import { FLAG_KEEP_CONTAINER, SCHEME_THIS, push } from '../../index'
import { withCallback } from '../../util/callbacks'
import { nonNullContext } from '../../util/contexts'

export function navigateTo(option: Taro.navigateTo.Option): Promise<TaroGeneral.CallbackResult> {
  nonNullContext(option.context)
  const promise = new Promise<TaroGeneral.CallbackResult>((resolve, reject) => {
    console.log('navigateTo called')
    const path = option.url.startsWith('/') ? option.url.substring(1) : option.url
    push({
      url: `${SCHEME_THIS}///${path}`,
      flag: FLAG_KEEP_CONTAINER,
      context: option.context,
    })
      .then(() => resolve({ errMsg: 'navigateTo:ok' }))
      .catch((err) => reject({ errMsg: err }))
  })
  return withCallback(promise, option)
}
