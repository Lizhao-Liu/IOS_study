import { TigaGeneral } from '@fta/tiga-util'

export interface TabDataListOption {
  /** 页面context */
  context?: any
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabDataListResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabDataListResult) => void
}

export interface TabDataListResult extends TigaGeneral.CallbackResult {
  /** 当前选中tab位置索引, 从0开始 */
  currentSelectedPos: number
  /** tab数据列表 */
  tabList: TabDataInfo[]
}

export interface TabDataInfo {
  /** tab页面唯一标识, 可以用来做逻辑交互 */
  tabPageName: string
  /** [iOS]tab页面路由 */
  tabPageUrl: string
  /** [Android]获取tab服务名 */
  packageName: string
  /** [Android]获取tab方法名 */
  methodName: string
  /** tabitem标题 */
  tabName: string
  /** 扩展参数，json字符串 */
  extParam: string
}

export interface TabOperationSuccessResult extends TigaGeneral.CallbackResult {}

/** Badge和RedDot不能同时存在 */
export interface ShowTabBarBadgeOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 显示内容, 必填 不能为空或空字符串 */
  text: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

export interface HideTabBarBadgeOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

/** Badge和RedDot不能同时存在 */
export interface ShowTabBarRedDotOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

export interface RemoveTabBarRedDotOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

export interface ShowTabBarHintOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 显示内容 */
  text: string
  /** Hint背景色 */
  backgroundColor?: string
  /** 文本颜色 */
  textColor?: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

export interface RemoveTabBarHintOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

export interface ShowTabBubbleOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 气泡显示内容, 必填 不能为空或空字符串 */
  text: string
  /**
   * 是否显示关闭按钮, 默认否
   * @since 1.4.0
  */
  showCloseBtn?: boolean
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

export interface RemoveTabBubbleOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

/** 持久化修改tabbarItem, App下次启动依旧有效 */
export interface UpdateTabbarItemOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** item标题内容 */
  text?: string
  /** item未选中图片网络路径 */
  iconPath?: string
  /** item选中图片网络路径 */
  selectIconPath?: string
  /** 是否需要动画, 默认false */
  iconAnimate?: boolean
  /** tab埋点参数 */
  bizStatInfo?: string
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

/** 重置持久化tabbarItem修改 */
export interface ResetTabBarItemOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 可以用来做逻辑交互 */
  tabPageName: string
  /** 是否需要动画, 默认false */
  iconAnimate?: boolean
  /** 是否立即生效, 默认false */
  immediately?: boolean
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

/** 临时修改tabbarItem */
export interface UpdateTempTabBarItemOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** item标题内容 */
  text?: string
  /** item未选中图片网络路径 */
  iconPath?: string
  /** item选中图片网络路径 */
  selectIconPath?: string
  /** 是否需要动画, 默认false */
  iconAnimate?: boolean
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}

/** 重置临时tabbarItem修改 */
export interface ResetTempTabBarItemOption {
  /** 页面context */
  context?: any
  /** tab页面唯一标识, 必填 不能为空或空字符串 */
  tabPageName: string
  /** 是否需要动画, 默认false */
  iconAnimate?: boolean
  /** 接口调用结束的回调函数（调用成功、失败都会执行 */
  complete?: (res: TigaGeneral.CallbackResult | TabOperationSuccessResult) => void
  /** 接口调用失败的回调函数 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: TabOperationSuccessResult) => void
}
