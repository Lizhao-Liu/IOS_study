import { TigaGeneral } from '@fta/tiga-util'

export interface UploadTaskOption {
  /** 页面context */
  context?: any
  /** 上传OSS服务方，默认1，可选1(阿里oss)、2(华为obs)	 */
  ossServer?: number
  /** 超时时间，单位毫秒 */
  timeout?: number
  /** 文件对应的 key，开发者在服务端可以通过这个 key 获取文件的二进制内容 */
  files: UploadFileInfo[]
  /** 接口调用结束的回调函数（调用成功、失败都会执行）
   * @link UploadSuccessResult
   */
  complete?: (res: TigaGeneral.CallbackResult | UploadSuccessResult) => void
  /** 接口调用失败的回调函数 超时: code 1001 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数
   * @link UploadSuccessResult
   */
  success?: (res: UploadSuccessResult) => void
}

export interface UploadSuccessResult extends TigaGeneral.CallbackResult {
  /** 绝对路径url。
   * 该字段废除！！！请使用ossFileList
   * 注意：如果是阿里云私有桶，或者obs通道，该字段是错误的，请使用 ossList 字段。
   */
  ossUrls: string[]
  /**
   * 上传文件结果信息（tiga 1.4.0 版本新增）
   * @since 1.4.0
  */
  ossFileList: OSSFileInfo[]
}

export interface OSSFileInfo {
  /** 文件绝对路径，业务不要存储绝对路径。
   * 例：https://dev-image56-conf-oss.ymm56.com/ymmfile/order-receipt-img/898deb54-73bc-4154-b4e5-c8b9d6191027.jpeg?Expires=1697421950&OSSAccessKeyId=LTAIq0WRi8jPwg5y&Signature=zsebSP%2Bkp5xor0wOTsvhpbkJW3M%3D
   */
  absoluteUrl: string
  /**
   * 相对路径，如果上传时指定了路径specifyKey，则该值为specifyKey字段的值。
   * 例：ymmfile/order-receipt-img/898deb54-73bc-4154-b4e5-c8b9d6191027.jpeg
   */
  ossKey: string
}

export interface UploadFileInfo {
  /** oss bizType */
  bizType: string
  /** 文件本地路径 */
  localPath: string
  /** 上传指定路径（宿主8.55/7.55，tiga 1.3.0 版本新增）,路径必须是完整path，ymmfile/业务oss桶/文件名,
   * 例1：ymmfile/ios-package/68910796-2d36-452f-b6bd-82fe1b7a98e9
   * 例2：ymmfile/ios-package/68910796-2d36-452f-b6bd-82fe1b7a98e9.jpg
   * */
  specifyKey?: string
  /** 文件扩展名 */
  fileExtensionName?: string
}

export interface TaskProgressResult {
  /** 上传进度变化事件的回调函数 progress: 0 ~ 100 */
  percent: number
}

export interface UploadTask extends Promise<UploadSuccessResult> {
  /** 取消上传 */
  abort(): void
  /** 监听上传进度变化事件, 只支持设置一次, 多次设置会覆盖 */
  onProgressUpdate(
    /** 上传进度变化事件的回调函数 progress.percent: 0 ~ 100
     * @link TaskProgressResult
     */
    callback: (progress: TaskProgressResult) => void
  ): void
}

export interface GetAbsoluteOption extends TigaGeneral.Option<GetAbsoluteSuccessResult> {
  /** 页面context */
  context?: any
  /** 批量请求参数 */
  requests: GetAbsoluteRequest[]
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: TigaGeneral.CallbackResult | GetAbsoluteSuccessResult) => void
  /** 接口调用失败的回调函数 超时: code 1001 */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: GetAbsoluteSuccessResult) => void
}

export interface GetAbsoluteRequest {
  /** 相对路径 */
  key: string
  /** oss bizType */
  bizType: string
}

export interface GetAbsoluteSuccessResult extends TigaGeneral.CallbackResult {
  /** 绝对路径集合，key:相对路径(入参key)， value: 绝对路径 */
  model: Map<string, string>
}
