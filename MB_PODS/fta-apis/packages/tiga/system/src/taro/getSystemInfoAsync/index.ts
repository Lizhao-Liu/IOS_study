import { TigaBridge, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function getSystemInfoAsync(
  option: Taro.getSystemInfoAsync.Option = {}
): Promise<Taro.getSystemInfoAsync.Result> {
  const { success, fail, complete }: any = option

  try {
    const failRes = {
      code: 2,
      reason: 'some unknow exception!',
    }

    const appInfoResult = await TigaBridge.call(option.context, 'app.system.getAppBaseInfo', {})
    failRes.code = appInfoResult.code
    failRes.reason = appInfoResult.reason
    if (appInfoResult.code !== 0) throw new Error(failRes.reason)

    const deviceResult = await TigaBridge.call(option.context, 'app.system.getDeviceInfo', {})
    failRes.code = deviceResult.code
    failRes.reason = deviceResult.reason
    if (deviceResult.code !== 0) throw new Error(failRes.reason)

    const res = {
      ...appInfoResult.data,
      ...deviceResult.data,
      errMsg: 'getSystemInfoAsync: ok',
    }

    if (res.pixelRatio && res.screenWidth) {
      res.screenWidth = res.screenWidth / res.pixelRatio
      res.screenHeight = res.screenHeight / res.pixelRatio
      res.statusBarHeight = res.statusBarHeight / res.pixelRatio
      if (res.bottomBarHeight) {
        res.bottomBarHeight = res.bottomBarHeight / res.pixelRatio
      }
    }
    if (!res.windowWidth) {
      res.windowWidth = res.screenWidth
      res.windowHeight = res.screenHeight
    }
    if (res.platform == 'ios') {
      res.system = 'iOS ' + res.systemVersion
    } else if (res.platform == 'android') {
      res.system = 'Android ' + res.systemVersion
    }

    res.benchmarkLevel = -1

    return successHandler(success, complete)(res)
  } catch (err) {
    const res = { errMsg: err.message }
    return errorHandler(fail, complete)(res)
  }
}
