import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getParameterError, shouldBeObject } from '../../paramsChecker'
const successIconUrl =
  'https://imagecdn.ymm56.com/ymmfile/static/image/tiga/toast/v1/tiga_toast_success.png'
const errorIconUrl =
  'https://imagecdn.ymm56.com/ymmfile/static/image/tiga/toast/v1/tiga_toast_error.png'
const warningIconUrl =
  'https://imagecdn.ymm56.com/ymmfile/static/image/tiga/toast/v1/tiga_toast_warning.png'
const loadingIconUrl =
  'https://imagecdn.ymm56.com/ymmfile/static/image/tiga/toast/v1/tiga_toast_loading.png'

async function showToast(options: Taro.showToast.Option): Promise<TaroGeneral.CallbackResult> {
  // 参数校验
  const isObject = shouldBeObject(options)
  if (!isObject.res) {
    const res = { errMsg: `showToast${isObject.msg}` }
    console.error(res.errMsg)
    return Promise.reject(res)
  }
  let {
    title,
    duration = 1500,
    mask,
    image,
    icon,
    toastType,
    gravity = 0,
    multilineTextAlignment,
    context,
    success,
    fail,
    complete,
  } = options || {}

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

  let iconUrl: string

  if (typeof image !== 'undefined') {
    if (typeof image !== 'string') {
      return errorHandler(
        complete,
        fail
      )({
        errMsg: getParameterError({
          para: 'image',
          correct: 'String',
          wrong: image,
        }),
      })
    } else {
      iconUrl = image
    }
  } else if (typeof icon !== 'undefined') {
    if (icon === 'success') {
      iconUrl = successIconUrl
    } else if (icon === 'error') {
      iconUrl = errorIconUrl
    } else if (icon === 'warning') {
      iconUrl = warningIconUrl
    } else if (icon === 'loading') {
      console.warn('请调用Taro.showLoading方法')
      iconUrl = undefined
      toastType = 0
    } else if (icon === 'none') {
      iconUrl = undefined
      toastType = 0
    }
  }
  if (typeof iconUrl === 'undefined') {
    toastType = 0
  } else if (typeof toastType == 'undefined') {
    toastType = 2
  }

  // 当toast为上icon下文字时，多行文本默认居中对齐，其他情况默认居左对齐
  if (typeof multilineTextAlignment === 'undefined') {
    multilineTextAlignment = toastType === 2 ? 1 : 0
  }

  // bridge 调用
  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.showToast', {
      title: title,
      mask: mask,
      duration: duration,
      image: iconUrl,
      toastType: toastType,
      gravity: gravity,
      textAlignment: multilineTextAlignment,
      maxLines: 0, //兼容iOS maxLines 参数
    })
    const { code, reason } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ errMsg: 'showToast:fail ' + reason })
    }
    return successHandler(success, complete)({ errMsg: 'showToast:ok' })
  } catch (e) {
    return errorHandler(fail, complete)({ errMsg: 'showToast:fail' })
  }
}

export { showToast }
