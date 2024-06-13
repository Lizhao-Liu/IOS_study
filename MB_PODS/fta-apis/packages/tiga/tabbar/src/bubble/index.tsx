import { TigaBridge, errorHandler, successHandler } from '@fta/tiga-util'
import * as TabBubble from '../../types'

async function showTabBubble(
  option: TabBubble.ShowTabBubbleOption
): Promise<TabBubble.TabOperationSuccessResult> {
  const failRes = {
    code: 100,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName || !option.text) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName和text字段都不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
    text: option.text,
    showCloseBtn: option.showCloseBtn,
  }
  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.maintab.showTabBubble', params)
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabBubble.TabOperationSuccessResult = {
      code: code,
      reason: reason,
    }

    return successHandler(option.success, option.complete)(res)
  } catch (error) {
    if (error.code) {
      failRes.code = error.code
    }
    if (error.reason) {
      failRes.reason = error.reason
    }
    return errorHandler(option.fail, option.complete)(failRes)
  }
}

async function removeTabBubble(
  option: TabBubble.RemoveTabBubbleOption
): Promise<TabBubble.TabOperationSuccessResult> {
  const failRes = {
    code: 100,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName字段不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
  }
  try {
    const bridgeResult = await TigaBridge.call(
      option.context,
      'app.maintab.removeTabBubble',
      params
    )
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabBubble.TabOperationSuccessResult = {
      code: code,
      reason: reason,
    }

    return successHandler(option.success, option.complete)(res)
  } catch (error) {
    if (error.code) {
      failRes.code = error.code
    }
    if (error.reason) {
      failRes.reason = error.reason
    }
    return errorHandler(option.fail, option.complete)(failRes)
  }
}

export { removeTabBubble, showTabBubble }

