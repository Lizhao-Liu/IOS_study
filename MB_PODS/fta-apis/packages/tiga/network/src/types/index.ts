import { TigaGeneral } from '@fta/tiga-util'

export interface SuccessCallbackResult extends TigaGeneral.CallbackResult {
  /* 开发者服务器返回的数据 */
  data: any
  /* 开发者服务器返回的 HTTP Response Header  */
  header: any
  /* 开发者服务器返回的 HTTP 状态码 */
  statusCode: number

  /* cookies web 中使用 */
  // cookies?: string[]
}

export interface RequestTask extends Promise<SuccessCallbackResult | any> {
  abort: () => void

  // offHeadersReceived(
  //   /** HTTP Response Header 事件的回调函数 */
  //   callback: (res: TigaGeneral.CallbackResult) => void
  // ): void
}
export interface Option extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 请求的 url */
  url: string
  /** 请求的参数 */
  data?: object
  /** 请求的 header */
  header?: object
  /** 超时时间 */
  timeout?: number
  /** 请求方法 GET, POST, 默认为 POST
   * @link Method
   *  @default POST
   */
  method?: keyof Method
  /**  是否加密, 默认不加密
   * @default false
   */
  encrypted?: boolean
  /** 网络库类型， YMM：运满满， HCB：货车帮， 默认为 YMM
   * @default YMM
   */
  type?: keyof RequestType
  /** 是否使用 dispatch 形式请求,货车帮网络库支持, 默认为 false
   * @link RequestType
   * @default false
   */
  useDispatch?: boolean
  /** 返回数据的解析格式, 默认为 normal，按照规范返回，其他类型会解析业务错误
   * @link ResponseType
   * @default normal
   */
  responseType?: keyof ResponseType
}

export interface Method {
  /** HTTP 请求 GET */
  GET
  /** HTTP 请求 HEAD */
  POST
}

export interface RequestType {
  /** HTTP 请求 GET */
  YMM
  /** HTTP 请求 HEAD */
  HCB
}

export interface ResponseType {
  /** 通用的网络数据返回，包含 header，data，statusCode */
  normal
  /** 数据格式为：（原运满满业务）
   * 1. result == 1
   * 2. data字段有值且类型是字典
   * 存在逻辑判断，result 为 1 返回正确的数据，否则返回失败，code 取值为 result，reason 取值为 errorMsg
   */
  data
  /** 数据格式为：（原货车帮业务）
   * 1. status == 'OK' || success == 1
   * 2. content字段有值且类型是字典
   * 存在逻辑判断，status 为 ok || 1 返回正确的数据，否则返回失败，code 取值为 errorCode，reason 取值为 errorMsg
   */
  content
}
