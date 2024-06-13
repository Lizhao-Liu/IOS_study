import { TigaGeneral } from '@fta/tiga-util'

export interface MBPushHandleOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * push业务类型名
   */
  notificationType: string

  /**
   * 收到消息后消费方式
   * 默认 0，
   * 0，消息进入队列
   * 1，消息不进入push消息处理队列 业务直接消费，收到消息后会触发didReceivePushMessage回调。
   * ...后续扩展
   */
  consumeMode?: number

  /**
   * 收到push消息回调 consumeMode=1时触发
   */
  didReceivePushMessage?: ReceivePushMessageCallback

  /**
   * 收到push消息已经从push队列中取出 consumeMode=0时触发
   * 业务有10s 处理逻辑比如请求网络接口等，超时push模块将继续处理下一条push消息；
   * 在该时机业务可以调用 pushConsume 方法来展示横幅；
   * 或者调用 pushQuit 通知push模块已经处理结束，然后可以做逻辑比如弹框等。
   */
  didDequeuePushMessage?: PushMessageDequeueCallback
}

/** 收到push回调 */
export type ReceivePushMessageCallback = (msg: MBPushMessage) => void
/** push从队列取出回调 */
export type PushMessageDequeueCallback = (msg: MBPushMessage) => void

export interface MBPushMessage {
  /** push消息唯一id */
  pushId: string
  /** push通知类型 1通用push消息; 0自定义push, 发给业务侧处理的消息type=0 */
  type: number
  /** push消息业务类型, 作为业务标识使用 */
  notificationType: string
  /** 业务模块名 */
  module?: string
  /** 通知、通用横幅左侧icon图片url, 网络url */
  commonIcon?: string
  /** 通知、通用横幅标题 */
  title: string
  /** 通知、通用横幅显示内容 */
  message: string
  /** 标记位：是否播合成语音，0 不启用（默认），1 启用 */
  voiceTemplate?: number
  /** 语音合成文本 voiceTemplate = 1 时生效 */
  voiceMessage?: string
  /** 在线音频地址 若同时有 voiceMessage 优先使用该字段 */
  soundUrl?: string
  /**
   * 在线音频地址序列，即多个音频片段 若同时有 soundUrl 优先使用该字段
   * 注：由于 iOS 应用外不支持多片段播放，传递该字段时应同时传递 soundUrl 字段作为降级方案
   */
  soundSeg?: string[]
  /** 通知/横幅点击跳转路由 */
  view?: string
  /** 消息服务端时间，毫秒 */
  enqueueTime: number
  /** 自由埋点字段 */
  report?: string
  /** UTM 埋点 */
  utmCampaign?: string
  /** push播报优先级，优先级高的先播报 */
  priority?: number
  /** 该类型在队列中最大缓存条数 */
  maxCount?: number
  /** 消息超时时间长度，秒 */
  timeOutSec?: number
  /** 业务字段 */
  payload?: any
}

export interface MBPushRemoveListenOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * push业务类型名
   */
  notificationType: string
}

export interface MBPushFinishOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** push消息唯一id */
  pushId: string
}

export interface MBPausePushOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {}

export interface MBPausePushResult extends TigaGeneral.CallbackResult {
  /** 暂停push句柄，用于恢复push请求 */
  token: string
}

export interface MBResumePushOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 暂停push时返回的句柄，用于恢复push请求 */
  token: string
}

export interface MBPushConsumeOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** push消息id, 该字段可不处理, 内部会取 MBPushNotifiable.pushId */
  pushId?: string

  /** 展示通知/横幅， 默认true 展示，false 不展示 */
  enableNotifiable?: boolean
  /** 播放语音，默认true 播放，false 不播放*/
  enableAudio?: boolean
  /**
   * 通知内容构造，
   * 如果需要横幅 或者 语音，则该字段必传，不需要自定义内容，可以直接通过传入pushMessage便捷构造实例
   * 如果需要自定义内容 比如横幅标题，或者语音url等，可以自行对参数赋值，具体传值规则可以看字段注释
   * 如果不需要横幅/通知 也需要传入该实例
   */
  notifiable: MBPushNotifiable
}

export class MBPushNotifiable {
  /** push消息id */
  readonly pushId: string
  /** push业务类型名 */
  readonly notificationType: string
  /** utm埋点 */
  readonly utmCampaign: string
  /** report埋点 */
  readonly report: string

  /** 消息标题 */
  public title: string
  /** 消息文本内容 */
  public message: string
  /** 跳转路由 */
  public view?: string
  /**
   * [Android]安卓系统展示方式字段
   * 默认 0 和 不设置，0 默认。原生push模块默认策略：应用内展示端内横幅，应用外展示系统通知
   * 1 展示端内横幅
   * 2 展示系统通知
   */
  public roule?: number = 0
  /** 数组表示多段语音url；tts:// 表示语音文本内容；其它当作网络语音url解析 */
  public sound: string | string[]

  /** 可以根据pushMsg直接构造消费内容 */
  constructor(pushMsg?: MBPushMessage) {
    if (!pushMsg) {
      return
    }
    this.pushId = pushMsg.pushId
    this.notificationType = pushMsg.notificationType
    this.utmCampaign = pushMsg.utmCampaign
    this.report = pushMsg.report
    this.title = pushMsg.title
    this.message = pushMsg.message
    this.view = pushMsg.view
    this.roule = 0
    if (pushMsg.soundSeg) {
      this.sound = pushMsg.soundSeg
    } else if (pushMsg.soundUrl) {
      this.sound = pushMsg.soundUrl
    } else if (pushMsg.voiceTemplate == 1 && pushMsg.voiceMessage) {
      this.sound = 'tts://' + pushMsg.voiceMessage
    }
  }
}

export interface MBNotificationOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** push消息id, 该字段可不处理, 内部会取 MBPushNotifiable.pushId */
  pushId?: string
  /**
   * 通知内容构造
   * 如果不需要自定义内容，可以直接通过传入pushMessage便捷构造实例
   * 如果需要自定义内容 比如横幅标题，或者语音url等，可以自行对参数赋值，具体传值规则可以看字段注释
   */
  notification: MBSystemNotification
}

export class MBSystemNotification {
  /** push消息id */
  readonly pushId: string
  /** push业务类型名 */
  readonly notificationType: string
  /** utm埋点 */
  readonly utmCampaign: string
  /** report埋点 */
  readonly report: string

  /** 消息标题 */
  public title: string
  /** 消息文本内容 */
  public message: string
  /** 跳转路由 */
  public view?: string
  /**
   * 语音字段，不传表示不播语音[注：iOS应用外不支持播放自定义语音]
   * 数组表示多段语音url；tts:// 表示语音文本内容；其它当作网络语音url解析
   */
  public sound?: string | string[]

  /** 可以根据pushMsg直接构造消费内容 */
  constructor(pushMsg?: MBPushMessage) {
    if (!pushMsg) {
      return
    }
    this.pushId = pushMsg.pushId
    this.notificationType = pushMsg.notificationType
    this.utmCampaign = pushMsg.utmCampaign
    this.report = pushMsg.report

    this.title = pushMsg.title
    this.message = pushMsg.message
    this.view = pushMsg.view
    if (pushMsg.soundSeg) {
      this.sound = pushMsg.soundSeg
    } else if (pushMsg.soundUrl) {
      this.sound = pushMsg.soundUrl
    } else if (pushMsg.voiceTemplate == 1 && pushMsg.voiceMessage) {
      this.sound = 'tts://' + pushMsg.voiceMessage
    }
  }
}
