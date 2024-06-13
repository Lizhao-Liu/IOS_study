import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as TabBadge from '../../types'

async function showTabBarBadge(
  option: TabBadge.ShowTabBarBadgeOption
): Promise<TabBadge.TabOperationSuccessResult> {
  const failRes = {
    code: 100,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName || !option.text) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName和text字段不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
    text: option.text,
  }
  try {
    const bridgeResult = await TigaBridge.call(
      option.context,
      'app.maintab.showTabBarBadge',
      params
    )

    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabBadge.TabOperationSuccessResult = {
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

async function hideTabBarBadge(
  option: TabBadge.HideTabBarBadgeOption
): Promise<TabBadge.TabOperationSuccessResult> {
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
      'app.maintab.removeTabBarBadge',
      params
    )
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabBadge.TabOperationSuccessResult = {
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

async function showTabBarRedDot(
  option: TabBadge.ShowTabBarRedDotOption
): Promise<TigaGeneral.CallbackResult> {
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
      'app.maintab.showTabBarBadge',
      params
    )
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabBadge.TabOperationSuccessResult = {
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

async function removeTabBarRedDot(
  option: TabBadge.RemoveTabBarRedDotOption
): Promise<TigaGeneral.CallbackResult> {
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
      'app.maintab.removeTabBarBadge',
      params
    )
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }
    const res: TabBadge.TabOperationSuccessResult = {
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

export { hideTabBarBadge, removeTabBarRedDot, showTabBarBadge, showTabBarRedDot }

