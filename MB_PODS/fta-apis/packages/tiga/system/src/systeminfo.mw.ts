import { GlobalSystemInfo } from './systemtype'

export function parseSysteminfo(): GlobalSystemInfo {
  if (!window._MBGlobalSystemInfo || !window._MBGlobalDeviceInfo) {
    console.log('微容器未成功获取window挂载对象')
    return
  }
  const originStr = decodeURI(window._MBGlobalSystemInfo)
  const systeminfo = JSON.parse(originStr)
  systeminfo.language = 'zh_CN'
  console.log('微容器读取window挂载system对象: ', systeminfo)

  const deviceStr = decodeURI(window._MBGlobalDeviceInfo)
  const deviceinfo = JSON.parse(deviceStr)
  const system =
    deviceinfo.platform == 'ios'
      ? 'iOS ' + deviceinfo.systemVersion
      : 'Android ' + deviceinfo.systemVersion
  deviceinfo.system = system
  console.log('微容器读取window挂载device对象: ', deviceinfo)

  const containerStr = decodeURI(window._MBContainerInfo)
  console.log('微容器读取window挂载container对象: ', containerStr)
  const windowinfo = window._MBContainerInfo ? JSON.parse(containerStr) : {}
  console.log('微容器读取window挂载container对象解析: ', windowinfo)

  const res: GlobalSystemInfo = {
    ...systeminfo,
    ...deviceinfo,
    ...windowinfo,
  }

  // 注入的数据是px
  if (res.screenWidth && res.pixelRatio) {
    res.screenWidth = res.screenWidth / res.pixelRatio
    res.screenHeight = res.screenHeight / res.pixelRatio
  }

  if (res.windowWidth && res.pixelRatio) {
    res.windowWidth = res.windowWidth / res.pixelRatio
    res.windowHeight = res.windowHeight / res.pixelRatio
  }

  if (res.statusBarHeight && res.pixelRatio) {
    res.statusBarHeight = res.statusBarHeight / res.pixelRatio
  }

  if (res.bottomBarHeight && res.pixelRatio) {
    res.bottomBarHeight = res.bottomBarHeight / res.pixelRatio
  }

  if (!res.windowHeight || !res.windowWidth) {
    res.windowWidth = document.documentElement.clientWidth
    res.windowHeight = document.documentElement.clientHeight
  }

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

  return res
}
