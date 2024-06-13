import { TigaGeneral } from '@fta/tiga-util'

/**
 * 分享渠道定义
 */
export enum ShareChannelType {
  /**
   * 微信聊天
   * 支持分享内容类型：文字类型、图片类型、网页类型、小程序类型
   */
  WeChatSession = 'wechatSession',
  /**
   * 微信朋友圈
   * 支持分享内容类型：文字类型、图片类型、网页类型
   */
  WeChatTimeLine = 'wechatTimeline',
  /**
   * qq聊天
   * 支持分享内容类型：文字类型、图片类型、网页类型
   */
  QQ = 'qq',
  /**
   * qq空间
   * 支持分享内容类型：文字类型、图片类型、网页类型
   */
  QZone = 'qzone',
  /**
   * 快手
   * 支持分享内容类型：视频类型
   */
  Kwai = 'kwai',
  /**
   * 抖音
   * 支持分享内容类型：视频类型
   */
  Douyin = 'douyin',
  /**
   * 车队
   */
  Motorcade = 'motorcade',
  /**
   * 打电话
   */
  PhoneCall = 'phoneCall',
  /**
   * 发短信
   * 支持分享内容类型：文字类型
   */
  SMS = 'sms',
  /**
   * 保存图片
   * 支持分享内容类型：图片类型
   */
  SaveImage = 'saveImage',
  /**
   * 保存视频
   * 支持分享内容类型：视频类型
   */
  SaveVideo = 'saveVideo',
}

export enum ShareObjectType {
  // 分享文字类型 content（必填）属性值有效；
  TEXT = 0,
  // 分享图片类型 imageUrl（必填）属性值有效；
  IMAGE = 1,
  // 分享网页类型 title（必填）、content（必填）、imageUrl（必填）、href（必填）属性值有效；
  WEB = 2,
  // 分享视频类型 videoUrl（必填）属性有效；
  VIDEO = 3,
  // 分享小程序类型 title（必填）、content（必填）、imageUrl（必填）、miniProgram（必填）属性值有效；
  MINIPROGRAM = 4,
}

export interface MiniProgram {
  /** 微信小程序ID
   * 注意：是微信小程序的原始ID（"g_"开头的字符串）
   */
  userName: string
  /**
   * 微信小程序打开的页面路径
   */
  path?: string
  /**
   * 兼容低版本的网页链接
   */
  webUrl?: string

  /**
   * 小程序版本
   * @since 1.3.0
   * @default 正式环境release/测试环境preview
   */
  type?: 'release' | 'test' | 'preview'
}

/**
 * 分享内容参数
 */
export interface BaseShareObject {
  /** 分享内容的类型, 可使用 ShareObjectType 枚举值
   * @link ShareObjectType
   */
  type: ShareObjectType
  /** 分享内容的标题
   * 【注意】不支持 emoji 等特殊符号
   */
  title?: string
  /** 分享的文字内容
   * 【注意】不支持 emoji 等特殊符号
   */
  content?: string
  /** 分享的网页链接 */
  href?: string
  /** 分享的图片链接 支持本地图片路径及网络图片路径
   * - type 为图片类型时表示分享的图片地址
   * - type 为网页类型时表示网页链接缩略图地址(推荐图片小于 20Kb)
   * - type 为小程序类型时表示小程序封面图地址(推荐图片小于 128K, 图片长宽比为 5:4)
   * - 【注意】如果使用的图片过大，会自动压缩图片大小，此时可能引起图片质量下降
   */
  imageUrl?: string
  /** 视频地址 仅支持本地路径*/
  videoUrl?: string
  /** 分享小程序必要参数
   * 用于配置分享小程序的参数，如小程序标识、页面路径等
   * @link MiniProgram
   */
  miniProgram?: MiniProgram
}

/**
 * 分享内容参数-端内车队
 */
export interface MotorcadeShareInfo {
  /** 端内页面链接，适用于分享至app内车队渠道场景
   * 需调用方传入携带分享内容参数的车队页面跳转链接, 方法内部通过路由跳转到链接
   * 参考链接：ymm://app/web?immersive=true&useMBWebView=true&url=https%3A%2F%2Fstatic.ymm56.com%2Fmicroweb%2F%23%2Fmw-fleet%2FfleetSlect%2Findex%3Fselect%3D1%2526content%253Dxxxx
   */
  pageUrl?: string
}

/**
 * 分享埋点参数
 */
export interface ShareTrackOption {
  /**
   * 分享业务场景名称
   * 如果业务传入了分享场景名称，则作为埋点的拓展参数 "share_scene"埋入
   */
  shareScene: string
  /**
   * 分享自定义埋点参数
   * 如果业务需要添加其他自定义埋点参数的需求，通过trackParams传入, 作为埋点的其他拓展参数
   */
  shareParams?: { [key: string]: any }
}

export interface ShowShareMenuOption {
  /**
   * 分享弹窗标题
   */
  title: string
  /**
   * 需要展示在分享弹窗上的渠道数组
   * 传入则展示当前app支持的指定分享渠道
   * 不传则展示当前app支持的所有分享渠道
   */
  channels?: ShareChannelType[]
  /**
   * 分享菜单上方预览图url
   */
  previewImage?: string

  /**
   * 分享弹窗埋点自定义参数
   * @link ShareTrackOption
   */
  shareTrack?: ShareTrackOption

  /** 页面context */
  context?: any
  /**
   * 分享弹窗弹起失败的回调函数
   * 错误码:
   *  - 1: 未知原因失败，详见reason
   *  - 2: 分享菜单取消，用户点击了关闭
   *  - 3: 参数错误
   *  - 9: 未发现可用分享渠道（指定的分享渠道当前app不支持分享）
   * */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行)
   * @link ShowShareMenuSuccessCallbackResult */
  complete?: (res: TigaGeneral.CallbackResult | ShowShareMenuSuccessCallbackResult) => void
  /** 分享弹窗弹起成功的回调函数，返回用户选择的分享渠道名称
   * @link ShowShareMenuSuccessCallbackResult  */
  success?: (result: ShowShareMenuSuccessCallbackResult) => void
}

export interface ShowShareMenuSuccessCallbackResult extends TigaGeneral.CallbackResult {
  selectedChannel: ShareChannelType
}

export interface DirectShareOption extends BaseShareObject {
  /** 分享渠道名称，可使用 ShareChannelType 枚举值
   * @link ShareChannelType
   */
  channel: ShareChannelType
  /** 分享埋点
   * @link ShareTrackOption
   */
  shareTrack?: ShareTrackOption
  /** 页面context */
  context?: any
  /** 接口调用失败的回调函数
   *  错误码:
   * - 1: 分享失败（未知错误或三方返回错误）
   * - 2: 分享取消【注意】从 APP 分享到微信时，无法判断用户是否点击取消分享，因为微信官方禁掉了分享取消的返回值
   * - 3: 参数错误
   * - 10: 相关分享平台未安装
   * - 11: 相关分享平台版本不支持或设备不支持分享
   * - 12: 未向相关平台注册当前 app
   * - 20: 分享内容参数错误或缺失
   * - 21: 指定的分享渠道不支持传入的分享内容类型
   * - 30: 无相册访问权限（适用于保存图片到本地/保存视频到本地场景）
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）
   * @link ShareSuccessCallbackResult */
  complete?: (res: TigaGeneral.CallbackResult | ShareSuccessCallbackResult) => void
  /** 接口调用成功的回调函数
   * @link ShareSuccessCallbackResult */
  success?: (result: ShareSuccessCallbackResult) => void
}

export interface DirectMotorcadeShareOption extends MotorcadeShareInfo {
  /** 分享渠道名称 需传入车队分享渠道 ShareChannelType.Motorcade
   * @link ShareChannelType
   */
  channel: ShareChannelType
  /** 分享埋点
   * @link ShareTrackOption
   */
  shareTrack?: ShareTrackOption
  /** 页面context */
  context?: any
  /** 接口调用失败的回调函数
   *  返回错误码:
   * - 1: 分享失败
   * - 3: 参数错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）
   * @link ShareSuccessCallbackResult */
  complete?: (res: TigaGeneral.CallbackResult | ShareSuccessCallbackResult) => void
  /** 接口调用成功的回调函数
   * @link ShareSuccessCallbackResult */
  success?: (result: ShareSuccessCallbackResult) => void
}

export enum ShareErrorCodeEnum {
  // 分享成功
  ShareSuccess = 0,
  // 分享失败（未知错误或三方返回错误，具体原因查看reason）
  ShareFail = 1,
  // 分享取消
  // 【注意】从APP分享到微信时，无法判断用户是否点击取消分享，因为微信官方禁掉了分享成功的返回值
  ShareCancel = 2,
  // 参数错误
  ShareParamsInvalid = 3,
  // 分享渠道不可用（适用于弹起弹窗分享，指定的分享渠道当前app全部不支持分享）
  ShareChannelsNotAvailable = 9,
  // 相关分享平台未安装
  ShareChannelNotInstall = 10,
  // 相关分享平台版本不支持 或设备不支持分享
  ShareChannelNotSupport = 11,
  // 未向相关平台注册当前app
  ShareChannelNotRegister = 12,
  // 分享内容参数错误或缺失
  ShareObjectParamsIncomplete = 20,
  // 指定的分享渠道不支持传入的分享内容类型
  ShareObjectTypeIllegal = 21,
  // 无相册访问权限（适用于保存图片到本地/保存视频到本地场景）
  PhotoAlbumAccessNoPermission = 30,
}

type ShareChannelsConfig = {
  [K in ShareChannelType]?: K extends ShareChannelType.Motorcade
    ? MotorcadeShareInfo
    : BaseShareObject
}

export interface MenuShareOption {
  /**
   * 分享弹窗标题
   * @default 分享到
   */
  title?: string

  /**
   * 分享弹窗上方预览图url
   */
  previewImage?: string

  /**
   * 表示不同分享渠道的内容配置
   */
  channels: ShareChannelsConfig

  /**
   * 分享埋点信息
   * @link ShareTrackOption
   */
  shareTrack?: ShareTrackOption

  /** 页面context */
  context?: any
  /**
   * 接口调用失败的回调函数
   * 错误码:
   *  - 1: 分享失败 （未知错误或三方返回错误，具体原因查看reason）
   *  - 2: 分享取消 【注意】从APP分享到微信时，无法判断用户是否点击取消分享，因为微信官方禁掉了分享取消的返回值
   *  - 3: 参数错误
   *  - 9: 分享渠道不可用（指定的分享渠道当前app全部不支持分享）
   * */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行)
   * @link ShareSuccessCallbackResult
   *  */
  complete?: (res: TigaGeneral.CallbackResult | ShareSuccessCallbackResult) => void
  /** 接口调用成功的回调函数
   * @link ShareSuccessCallbackResult
   *  */
  success?: (result: ShareSuccessCallbackResult) => void
}

export interface ShareSuccessCallbackResult extends TigaGeneral.CallbackResult {
  channel: ShareChannelType
}

export interface GetShareChannelsOption {
  /** 页面context */
  context?: any
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行））
   * @link GetShareChannelsCallbackResult */
  complete?: (res: GetShareChannelsCallbackResult | TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数
   * @link GetShareChannelsCallbackResult  */
  success?: (result: GetShareChannelsCallbackResult) => void
}

export interface GetShareChannelsCallbackResult extends TigaGeneral.CallbackResult {
  /** 返回当前支持的所有分享渠道名称数组 */
  shareChannels: Array<ShareChannelType>
}
