import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getParameterError, shouldBeObject } from '../../paramsChecker'

async function showLoading(
  options: Partial<Taro.showLoading.Option> = {}
): Promise<TaroGeneral.CallbackResult> {
  // 参数校验
  const isObject = shouldBeObject(options)
  if (!isObject.res) {
    const res = { errMsg: `showLoading${isObject.msg}` }
    console.error(res.errMsg)
    return Promise.reject(res)
  }
  let { title, mask, delay, success, fail, complete, context, ...others } = options || {}
  if (typeof title !== 'string') {
    return errorHandler(
      complete,
      fail
    )({
      errMsg: getParameterError({
        para: 'title',
        correct: 'String',
        wrong: title,
      }),
    })
  }

  // bridge 调用
  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.showLoading', {
      title,
      mask,
      delay,
      ...others,
    })
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ errMsg: 'showLoading:fail ' + reason })
    }
    return successHandler(success, complete)({ errMsg: 'showLoading:ok' })
  } catch (e) {
    return errorHandler(fail, complete)({ errMsg: 'showLoading:fail' })
  }
}

export { showLoading }
