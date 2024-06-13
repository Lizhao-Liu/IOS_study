import Taro from '@tarojs/taro'
import { FLAG_KEEP_CONTAINER, SCHEME_THIS, navigate } from '../../index'
import { withCallback } from '../../util/callbacks'
import { nonNullContext } from '../../util/contexts'

export function redirectTo(option: Taro.redirectTo.Option): Promise<TaroGeneral.CallbackResult> {
  nonNullContext(option.context)
  const promise = new Promise<TaroGeneral.CallbackResult>((resolve, reject) => {
    console.log('redirectTo called')
    const path = option.url.startsWith('/') ? option.url.substring(1) : option.url
    navigate({
      pop: { delta: 1 },
      push: {
        url: `${SCHEME_THIS}///${path}`,
        flag: FLAG_KEEP_CONTAINER,
      },
      context: option.context,
    })
      .then(() => resolve({ errMsg: 'redirectTo:ok' }))
      .catch((err) => reject({ errMsg: err }))
  })
  return withCallback(promise, option)
}
