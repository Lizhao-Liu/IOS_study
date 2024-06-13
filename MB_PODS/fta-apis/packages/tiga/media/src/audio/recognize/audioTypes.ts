import { TigaGeneral } from '@fta/tiga-util'

export interface VoiceRecognizeResult {
  /** 识别内容 */
  text?: string
  /**
   *  0 正常
   *  1 识别结束（超时或主动结束之后，会带有 filePath 和 duration 字段）
   *  10 开始检测到声音 > 0，业务可以处理动画
   *  11 检测到的声音为 0
   *  12 取消识别，这个行为一般发生在启动之前，会调用取消。科大讯飞引擎不会自动结束。
   *  20 识别发生错误
   *  21 未检测到用户语音（ios）
   */
  status: number
  /** 原因 */
  reason?: string
  /** 存储音频的本地文件 */
  filePath?: string
  /** 时长 */
  duration?: number
}

export type VoiceRecognizeCallBack = (res: VoiceRecognizeResult) => void

export interface RecognizeOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 录音最大时长 单位：秒，默认60
   * @default 60
   */
  maxTime?: number
  /** 录音文件名称（不需要传入后缀名，会自动添加，例如 传入 test，返回test.wav）	 */
  fileName?: string
  /** N秒后检测不到录音，即认为录音结束 默认60 （ios 1.3.0 开始支持）
   * @since 1.3.0
   * @default 60
   */
  afterOverTime?: number
  /** 是否请求麦克风权限
   * @default false
   */
  permissionRequest?: boolean
  /** 自定义弹窗文案, permissionRequest 为 true 时必传 */
  rationale?: string
  /** 顶部提示, permissionRequest 为 true 时必传, 只支持 Android */
  topHint?: string
  /** 语音识别监听函数
   * @link VoiceRecognizeCallBack
   */
  callBack?: VoiceRecognizeCallBack
}
