export interface GlobalSystemInfo {
  /** [Android]设备二进制接口类型 */
  deviceAbi: string | undefined
  /** 设备像素比 */
  pixelRatio: number
  /** 屏幕宽，单位px */
  screenWidth: number
  /** 可使用窗口宽度，单位px */
  windowWidth: number
  /** 可使用窗口高度，单位px */
  windowHeight: number
  /** 屏幕高，单位px */
  screenHeight: number
  /** 状态栏高度，单位px，注意状态栏不包括导航栏 */
  statusBarHeight: number
  /** 底部bar安全区域高度，单位px */
  bottomBarHeight: number
  /** 微信设置的语言 */
  language: string
  /** 设备品牌(iPhone, XIAOMI, HUAWEI) */
  brand: string
  /** [iOS]设备型号，如iPhone 14,2 */
  modelNum: string | undefined
  /** 设备型号名。新机型刚推出一段时间会显示unknown。(iPhone 11) */
  model: string
  /** 操作系统版本 (如 10.1.1) */
  systemVersion: string
  /** 客户端平台 取值：android、ios */
  platform: string
  /** [Android]设备 CPU 型号（仅 Android 支持） */
  CPUType: string | undefined
  /** 设备内存大小，单位为 MB */
  memorySize: number
  /** 0：正常 1：Rooted (Android) or Jailbroken (iOS) */
  deviceState: number
  /** [Android] MIUI, Flyme, EMUI, ColorOS, FuntouchOS, SmartisanOS, EUI, Sense, AmigoOS, _360OS, NubiaUI, H2OS, YunOS, YuLong, SamSung, Sony, Lenovo, LG, Google, Other */
  romName: string | undefined
  /** [Android]  */
  romVersionName: string | undefined
  /** App版本号如：6.10.0.1 */
  version: string
  /** 操作系统及版本 */
  system: string
  /** 数字类型App版本号 如：6100001 */
  versionCode: number
  /** 用户字体大小（单位px）。以微信客户端「我-设置-通用-字体大小」中的设置为准 */
  fontSizeSetting?: number
  /** 客户端基础sdk版本号 */
  SDKVersion: string
  /** 包构建类型  0: debug 1: release 2: adhoc */
  buildType: number
  /** app类型  driver： 司机类App shipper：货主类App employee：满帮家 common：暂无分类 */
  appType: string
  /** 应用标识, bundleId */
  appId: string
  /** 设备id */
  deviceId: string
  /** openUUID，金融风控使用 */
  dfp: string
  /** 服务器环境 0: dev 1: QA 3: release */
  serverType: number
  /** 文件host */
  fileUrl: string
  /** 接口baseUrl */
  apiUrl: string
  /** 广告id，iOS取idfa，Android取adid */
  adId: string
  /** 泳道[测试包字段] */
  swimlane: string
  /** 系统当前主题，取值为light或dark；不支持的系统为空 */
  theme: string | undefined
  /** 在竖屏正方向下的安全区域 */
  safeArea?: SafeAreaInfo
}

export interface AppBaseInfo {
  /** App版本号如：6.10.0.1 */
  version: string
  /** 数字类型App版本号 如：6100001 */
  versionCode: number
  /** 用户字体大小（单位px）。以微信客户端「我-设置-通用-字体大小」中的设置为准 */
  fontSizeSetting?: number
  /** 客户端基础sdk版本号 */
  SDKVersion: string
  /** App品牌 不支持的会返回 unknown (8.57/7.57版本新增) */
  appBrand: string
  /** 包构建类型  0: debug 1: release 2: adhoc */
  buildType: number
  /** app类型  driver: 司机类App; shipper: 货主类App; employee: 满帮家; common：暂无分类 */
  appType: string
  /** 应用标识, bundleId */
  appId: string
  /** 设备id */
  deviceId: string
  /** openUUID，金融风控使用 */
  dfp: string
  /** 服务器环境 0: dev 1: QA 3: release */
  serverType: number
  /** 文件host */
  fileUrl: string
  /** 接口baseUrl */
  apiUrl: string
  /** 广告id，iOS取idfa，Android取adid */
  adId: string
  /** 泳道[测试包字段] */
  swimlane: string
  /** 系统当前主题，取值为light或dark；不支持的系统为空 */
  theme: string | undefined
}

/** 在竖屏正方向下的安全区域 */
export interface SafeAreaInfo {
  /** 安全区域右下角纵坐标 */
  bottom: number
  /** 安全区域的高度，单位逻辑像素 */
  height: number
  /** 安全区域左上角横坐标 */
  left: number
  /** 安全区域右下角横坐标 */
  right: number
  /** 安全区域左上角纵坐标 */
  top: number
  /** 安全区域的宽度，单位逻辑像素 */
  width: number
}
