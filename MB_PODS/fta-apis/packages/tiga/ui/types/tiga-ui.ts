import { TigaGeneral } from '@fta/tiga-util'

export interface DialogOption {
  /** 弹窗的标题 */
  title: string
  /** 弹窗的内容 */
  content?: string
  /** 弹窗的内容样式
   * @link DialogContentStyle
   */
  contentStyle?: DialogContentStyle
  /** 弹窗的按钮数组
   * @link DialogButton
   */
  buttons: DialogButton[]
  /** 弹窗的按钮排列方式
   * 可选值:
   * - 0: 横向排列
   * - 1: 纵向排列
   * @default 0(buttons数量<=2)/1(buttons数量>2)
   */
  buttonOrientation?: 0 | 1
  /**
   * 是否显示弹窗右上角关闭按钮
   * @default false
   *  */
  showCloseBtn?: boolean
  /**
   * 点击外部区域是否可以关闭弹窗
   * @default false
   * */
  canceledOnTouchOutside?: boolean

  /**
   * 背景蒙层透明度
   * 不传默认读取当前app端配置
   * @since 1.7.0
   */
  mask?: 'light' | 'dark'

  /** 页面context */
  context?: any
  /** 接口调用失败的回调函数
   * 错误码:
   * - 1: 参数错误
   * - 99: 未知错误
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行）
   * @link DialogSuccessCallbackResult
   */
  complete?: (res: DialogSuccessCallbackResult | TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数
   * @link DialogSuccessCallbackResult
   */
  success?: (result: DialogSuccessCallbackResult) => void
}

export interface DialogSuccessCallbackResult extends TigaGeneral.CallbackResult {
  /** 为 true 时，表示弹窗被关闭 */
  dismissed: boolean
  /** 表示用户点击的按钮index */
  index: number
}
export interface StatusDialogOption extends DialogOption {
  /** 反馈类弹窗icon url */
  statusIcon?: string
}

export interface DialogButton {
  /** 按钮的文字 */
  text: string
  /** 按钮的颜色
   * @default #576B95(主按钮)/#000000(副按钮)
   */
  color?: string
}

export interface DialogContentStyle {
  /** 弹窗的内容颜色16进制字符串
   * @default #666666
   */
  contentColor?: string
  /** 弹窗内容的横向对齐方式
   * @default 0
   */
  contentAlignment?: DialogContentAlignment
  /** 弹窗的内容最大行数
   * @default 3
   */
  maxLinesOfContent?: number
}

export enum DialogContentAlignment {
  Center = 0,
  Left = 1,
  Right = 2,
}
export enum DialogButtonOrientation {
  Horizontal = 0,
  Vertical = 1,
}
