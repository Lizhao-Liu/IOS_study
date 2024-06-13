import { TigaBridge, TigaGeneral, getEngineContext } from '@fta/tiga-util'

export interface Speaker {
  /**
   * 提交音频播放任务，播放内容为输入的文本
   */
  speak: (option: Speaker.speak.Option) => Promise<Speaker.speak.CallbackResult>

  /**
   * 终止指定播放任务
   */
  stop: (option: Speaker.stop.Option) => Promise<TigaGeneral.CallbackResult>
}

export declare namespace Speaker {
  namespace speak {
    interface Option {
      /**
       * 待合成文本
       */
      text: string
      /**
       * 任务执行策略
       * 1: 加入任务队列
       * 2: 立即执行：取消其他进行中、等待中任务
       * @default 1
       */
      taskStrategy?: number
      /**
       * 距上一条播放任务的停顿间隔时长，单位 s，精度 0.1
       * @default 0.5
       */
      interval?: number

      /**
       * 开始播放回调
       * @param token
       */
      onStart?: (token: string)=>void

      /**
       * 开始播放回调
       * @param token
       */
      onEnded?: (token: string)=>void

      /**
       * 播放出错回调
       * @param token
       * @param errorMsg
       */
      onError?: (token: string, errorMsg?: string)=>void
    }

    interface CallbackResult extends TigaGeneral.CallbackResult {
      /**
       * 用于 stop 终止本次任务
       */
      token: string
    }
  }

  namespace stop {
    interface Option {
      /* 任务 token，详见 CallbackResult */
      token: string
    }
  }
}

let speaker = null

export function getSpeaker(): Speaker {
  if (speaker == null) {
    speaker = new MySpeaker()
  }
  return speaker
}

class MySpeaker implements Speaker {
  private onStartMap = new Map<string, ((token: string) => void)>()
  private onEndedMap = new Map<string, ((token: string) => void)>()
  private onErrorMap = new Map<string, ((token: string, errorMsg?: string) => void)>()

  constructor() {
    getEngineContext()
      .then(() => {
        console.log('eventcent on app.textPlayer.callback')
        TigaGeneral.eventCenter.on(`app.textPlayer.callback`, (eventData) => {
          // console.log('receive event: ', eventData)
          if (eventData.what == 'onStart') {
            this.onStartEvent(eventData.token)
          } else if (eventData.what == 'onEnded') {
            this.onEndedEvent(eventData.token)
            this.offCallbackEvent(eventData.token)
          } else if (eventData.what == 'onError') {
            this.onErrorEvent(eventData.token, eventData.errMsg)
            this.offCallbackEvent(eventData.token)
          }
        })
      })
  }

  speak(option: Speaker.speak.Option): Promise<Speaker.speak.CallbackResult> {
    const { text } = option
    const taskStrategy = option.taskStrategy ?? 2
    const interval = option.interval ?? 0.5
    return getEngineContext()
      .then((context) =>
        TigaBridge.call(context, 'app.tts.speak', { text, taskStrategy, interval })
      )
      .then(compat)
      .then((res) => {
        // console.log("text play: ", res)
        if (option.onStart && res.data.token) {
          this.onStartMap.set(res.data.token, option.onStart)
        }
        if (option.onError && res.data.token) {
          this.onErrorMap.set(res.data.token, option.onError)
        }
        if (option.onEnded && res.data.token) {
          this.onEndedMap.set(res.data.token, option.onEnded)
        }
        return ({ code: 0, reason: 'speak:ok', token: res.data.token })
      })
      .catch((err) => {
        throw { code: 10, reason: 'speak:fail:' + err.reason }
      })
  }

  stop(option: Speaker.stop.Option): Promise<TigaGeneral.CallbackResult> {
    const { token } = option
    return getEngineContext()
      .then((context) => TigaBridge.call(context, 'app.tts.stopSpeaking', { token }))
      .then(compat)
      .then(() => {
        this.offCallbackEvent(option.token)
        return ({ code: 0, reason: 'stop:ok' })
      })
      .catch((err) => {
        throw { code: 10, reason: 'stop:fail:' + err.reason }
      })
  }

  private onStartEvent(token: string) {
    const callback = this.onStartMap.get(token)
    // console.log("onStartEvent: ", callback)
    if (callback) {
      callback(token)
    }
  }

  private onEndedEvent(token: string) {
    const callback = this.onEndedMap.get(token)
    // console.log("onEndedEvent: ", callback)
    if (callback) {
      callback(token)
    }
  }

  private onErrorEvent(token: string, errorMsg?: string) {
    const callback = this.onErrorMap.get(token)
    if (callback) {
      callback(token, errorMsg)
    }
  }

  private offCallbackEvent(token: string) {
    this.onStartMap.delete(token)
    this.onEndedMap.delete(token)
    this.onErrorMap.delete(token)
  }

}

function compat<T>(res: T): T {
  if (res['code'] === 0) {
    return res
  } else {
    throw res
  }
}
