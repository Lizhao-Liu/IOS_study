import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { getParameterError, shouldBeObject } from '../../paramsChecker'

async function showActionSheet(
  options: Partial<Taro.showActionSheet.Option> = {}
): Promise<Taro.showActionSheet.SuccessCallbackResult> {
  // 参数校验
  const isObject = shouldBeObject(options)
  if (!isObject.res) {
    const res = { errMsg: `showActionSheet${isObject.msg}` }
    console.error(res.errMsg)
    return Promise.reject(res)
  }

  const { itemList, itemColor, alertText, success, fail, complete, context, ...others } =
    options || {}

  if (!Array.isArray(itemList)) {
    return errorHandler(
      fail,
      complete
    )({
      errMsg: getParameterError({
        para: 'itemList',
        correct: 'Array',
        wrong: itemList,
      }),
    })
  }

  if (itemList.length < 1) {
    return errorHandler(
      fail,
      complete
    )({
      errMsg:
        'showActionSheet:fail parameter error: parameter.itemList should have at least 1 item',
    })
  }

  if (itemList.length > 6) {
    return errorHandler(
      fail,
      complete
    )({
      errMsg:
        'showActionSheet:fail parameter error: parameter.itemList should not be larger than 6',
    })
  }

  // bridge调用
  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.showActionSheet', {
      items: itemList,
      itemColor: itemColor,
      title: alertText,
      ...others,
    })
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ errMsg: 'showActionSheet:fail ' + reason })
    } else {
      const res = { errMsg: 'showActionSheet:ok', tapIndex: data?.index }
      return successHandler(success, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: 'showActionSheet:fail' }
    return errorHandler(fail, complete)(res)
  }
}

export { showActionSheet }
