import { TigaGeneral } from '@fta/tiga-util'

export interface WXMiniProgramOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 小程序userName
   */
  userName: string
  /**
   * 小程序路径
   * 如果不传，默认跳转到小程序主页
   */
  path?: string
  /**
   * 小程序版本
   * 可选值
   * - 0：正式版
   * - 1：测试版
   * - 2：预览版
   * @default 0
   */
  type?: 0 | 1 | 2

  /**
   * 接口调用失败的回调函数
   * 错误码:
   * - 1: 未知原因失败
   * - 2: 对应平台app 未安装
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export interface AlipayMiniProgramOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 要跳转的目标小程序 APPID
   */
  appId: string
  /**
   * 要跳转到目标小程序的具体 page 页面
   * 该值等于 app.json 里面的配置值
   * 如果不传，默认跳转到小程序首页
   */
  page?: string
  /**
   * 携带的参数，内容按照格式为参数名=参数值&参数名=参数值
   * 按照官方文档，此字段需要进行Encode处理，API 内部已对此进行了默认的Encode处理，不需要调用者自行处理
   */
  query?: string

  /**
   * 接口调用失败的回调函数
   * 错误码:
   * - 1: 未知原因失败
   * - 2: 对应平台app 未安装
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
}

export enum LaunchMiniProgramErrorCode {
  SUCCESS = 0,
  FAIL = 1,
  APP_NOT_INSTALL = 2,
}
