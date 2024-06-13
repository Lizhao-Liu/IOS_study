import { TigaBridge, errorHandler, successHandler } from '@fta/tiga-util'
import * as TabItem from '../../types'

async function updateTabbarItem(
  option: TabItem.UpdateTabbarItemOption
): Promise<TabItem.TabOperationSuccessResult> {
  const failRes = {
    code: 1,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName字段不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
    isPersistent: true,
    text: option.text,
    iconPath: option.iconPath,
    selectIconPath: option.selectIconPath,
    bizStatInfo: option.bizStatInfo,
    iconAnimate: option.iconAnimate,
  }
  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.maintab.setTabBarItem', params)
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabItem.TabOperationSuccessResult = {
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

async function resetTabBarItem(
  option: TabItem.ResetTabBarItemOption
): Promise<TabItem.TabOperationSuccessResult> {
  const failRes = {
    code: 1,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName字段不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
    isPersistent: true,
    immediately: option.immediately,
    iconAnimate: option.iconAnimate,
  }
  try {
    const bridgeResult = await TigaBridge.call(
      option.context,
      'app.maintab.resetTabBarItem',
      params
    )
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabItem.TabOperationSuccessResult = {
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

async function updateTempTabBarItem(
  option: TabItem.UpdateTempTabBarItemOption
): Promise<TabItem.TabOperationSuccessResult> {
  const failRes = {
    code: 1,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName字段不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
    isPersistent: false,
    text: option.text,
    iconPath: option.iconPath,
    selectIconPath: option.selectIconPath,
    iconAnimate: option.iconAnimate,
  }
  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.maintab.setTabBarItem', params)
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabItem.TabOperationSuccessResult = {
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

async function resetTempTabBarItem(
  option: TabItem.ResetTempTabBarItemOption
): Promise<TabItem.TabOperationSuccessResult> {
  const failRes = {
    code: 1,
    reason: 'some unknow exception!',
  }

  if (!option || !option.tabPageName) {
    failRes.code = 1
    failRes.reason = '参数错误, tabPageName字段不能为空'
    return errorHandler(option.fail, option.complete)(failRes)
  }

  const params = {
    tabPageName: option.tabPageName,
    isPersistent: false,
    iconAnimate: option.iconAnimate,
  }
  try {
    const bridgeResult = await TigaBridge.call(
      option.context,
      'app.maintab.resetTabBarItem',
      params
    )
    const { code, reason, data } = bridgeResult || {}

    if (code !== 0) {
      failRes.code = code
      failRes.reason = reason
      throw new Error()
    }

    const res: TabItem.TabOperationSuccessResult = {
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

export { resetTabBarItem, resetTempTabBarItem, updateTabbarItem, updateTempTabBarItem }

