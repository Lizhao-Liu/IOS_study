import { TigaBridge, TigaGeneral, errorHandler, successHandler, uuid } from '@fta/tiga-util'

export type ErrorCallback = (result: any) => void
export type FinishCallback = (result: any) => void

export class RecordOption {
  // 录音时长 ms
  duration: number
  sampleRate: number
  numberOfChannels: number
  encodeBitRate: number
  format: string
  constructor() {
    this.duration = 60000
    this.sampleRate = 8000
    this.numberOfChannels = 2
    this.encodeBitRate = 48000
    this.format = 'aac'
  }
}

interface RecordStatus {
  RecordStatusNone
  RecordStatusIng
  RecordStatusPause
  RecordStatusFinish
  RecordStatusError
}

export class AVAudioRecorder {
  /** 容器上下文实例 */
  private context: any
  /** 实例标识 */
  private token: string
  /** 录音状态 */
  private status: keyof RecordStatus

  /** 发生错误回调 */
  public errorCallback: ErrorCallback
  /** 录音结束回调 */
  public finishCallback: FinishCallback

  constructor() {
    this.token = uuid()
    if (!this.token) {
      this.token = '1'
    }
    this.status = 'RecordStatusNone'
  }

  async start(context: any, option: RecordOption): Promise<TigaGeneral.CallbackResult> {
    if (this.status != 'RecordStatusNone') {
      return Promise.resolve({ code: 1001, reason: '正在录音或录音实例已失效' })
    }
    this.context = context

    this.startListenerStatusChange()

    this.status = 'RecordStatusIng'
    const params = {
      token: this.token,
      duration: option.duration,
      sampleRate: option.sampleRate,
      encodeBitRate: option.encodeBitRate,
      numberOfChannels: option.numberOfChannels,
      format: option.format,
    }
    try {
      console.log('开始录音。。。。。')
      const res = await TigaBridge.call(context, 'app.record.start', params)
      console.log('开始录音结果: ', res)
      if (res?.code == TigaGeneral.SUCCESS) {
        return Promise.resolve({ code: res.code })
      } else {
        this.status = 'RecordStatusError'
        return Promise.resolve({ code: res.code, reason: res.reason })
      }
    } catch (error) {
      console.log('开始录音失败: ', error)
      this.status = 'RecordStatusError'
      return Promise.resolve({ code: 2000, reason: '录音失败' })
    }
  }

  async stop(): Promise<TigaGeneral.CallbackResult> {
    try {
      const params = {
        token: this.token,
      }
      const res = await TigaBridge.call(this.context, 'app.record.stop', params)
      if (res?.code == TigaGeneral.SUCCESS) {
        this.status = 'RecordStatusFinish'
        return Promise.resolve({ code: res.code })
      } else {
        return Promise.resolve({ code: res.code, reason: res.reason })
      }
    } catch (error) {
      return Promise.resolve({ code: 2000, reason: '停止失败' })
    }
  }

  startListenerStatusChange() {
    TigaGeneral.eventCenter.on('MBAudioRecordEventOccurError', (eventData: any) => {
      // console.log('监听MBAudioRecordEventOccurError消息: ', eventData)
      if (this.errorCallback) {
        this.errorCallback(eventData)
      }
    })

    TigaGeneral.eventCenter.on('MBAudioRecordEventStop', (eventData: any) => {
      // console.log('监听MBAudioRecordEventStop消息: ', eventData)
      if (this.finishCallback) {
        this.finishCallback(eventData)
      }
    })
  }
}
