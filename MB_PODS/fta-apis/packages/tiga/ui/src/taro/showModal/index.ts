import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getParameterError, shouldBeObject } from '../../paramsChecker'

const defaultConfirmColor = '#576B95'
const defaultCancelColor = '#000000'

async function showModal(
  options: Taro.showModal.Option = {}
): Promise<Taro.showModal.SuccessCallbackResult> {
  // 参数校验
  const isObject = shouldBeObject(options)
  if (!isObject.res) {
    const res = { errMsg: `showModal${isObject.msg}` }
    console.error(res.errMsg)
    return Promise.reject(res)
  }
  let {
    title,
    content,
    showCancel = true,
    cancelText = '取消',
    cancelColor = defaultCancelColor,
    confirmText = '确定',
    confirmColor = defaultConfirmColor,
    context,
    success,
    fail,
    complete,
    mask
  } = options || {}

  if (typeof title !== 'undefined' && typeof title !== 'string') {
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
  let cancelBtn = {
    text: cancelText,
    color: cancelColor,
  }
  let confirmBtn = {
    text: confirmText,
    color: confirmColor,
  }

  let buttons = showCancel ? [cancelBtn, confirmBtn] : [confirmBtn]

  let contentText
  if (typeof content !== 'undefined') {
    if (typeof content === 'string') {
      contentText = content
    } else {
      return errorHandler(
        complete,
        fail
      )({
        errMsg: getParameterError({
          para: 'content',
          correct: 'String',
          wrong: content,
        }),
      })
    }
  }

  // bridge调用
  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.showDialog', {
      title,
      buttons,
      mask,
      buttonOrientation: 0,
      content: {
        contentText: contentText,
        contentColor: '#666666',
        contentAlignment: 0,
        maxLinesOfContent: 0,
      },
      showCloseBtn: false,
      canceledOnTouchOutside: false,
    })
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ errMsg: 'showModal:fail ' + reason })
    }
    const isConfirmed = data?.index == 1
    const successResult = { errMsg: 'showModal:ok', cancel: !isConfirmed, confirm: isConfirmed }
    return successHandler(success, complete)(successResult)
  } catch (e) {
    return errorHandler(fail, complete)({ errMsg: 'showModal:fail' })
  }
}

export { showModal }
