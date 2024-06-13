import { GlobalSystemInfo } from './systemtype'
import Thresh, { Dimensions, Platform } from '@thresh/thresh-lib'

export function parseSysteminfo(): GlobalSystemInfo {
  const systeminfo = Thresh.MBGlobalSystemInfo
  if (!systeminfo) {
    return
  }
  const res: GlobalSystemInfo = {
    ...systeminfo,
  }

  const system =
    systeminfo.platform == 'ios'
      ? 'iOS ' + systeminfo.systemVersion
      : 'Android ' + systeminfo.systemVersion
  systeminfo.system = system
  systeminfo.language = 'zh_CN'

  const window = Dimensions.get('window')
  const screen = Dimensions.get('screen')
  // TODO: 由于安卓返回的高度缺少状态栏高度，临时兼容
  const _mediaQuery_height = global.mediaQuery_height || 667
  const _mediaQuery_statusBarHeight = global.mediaQuery_statusBarHeight || 0
  const mediaQuery_height =
    Platform.OS == 'android'
      ? Number(_mediaQuery_height) + Number(_mediaQuery_statusBarHeight)
      : _mediaQuery_height

  const screenWidth = +screen.width
  // Todo: 定义是否和 rn 一致
  const screenHeight = +mediaQuery_height
  // TODO: window dimensions 定义可能不一致
  const windowWidth = +window.width
  const windowHeight = +mediaQuery_height
  const statusBarHeight = +screen.statusBarHeight
  const bottomBarHeight = +screen.bottomBarHeight

  res.screenWidth = screenWidth
  res.screenHeight = screenHeight
  res.statusBarHeight = statusBarHeight
  res.bottomBarHeight = bottomBarHeight

  res.windowWidth = windowWidth
  res.windowHeight = windowHeight

  const safeArea = {
    left: 0,
    right: res.windowWidth,
    top: res.statusBarHeight,
    bottom: res.bottomBarHeight,
    height: res.screenHeight,
    width: res.windowWidth,
  }
  res.safeArea = safeArea

  // res.fontSizeSetting =+ res.pixelRatio

  console.log('微容器读取原生注入对象: ', res)
  return res
}
