import Taro from '@tarojs/taro'

import * as Audio from '../../../src/recorder'
import { TigaGeneral } from '@fta/tiga-util'

class RecorderManager {
  private recorder: Audio.AVAudioRecorder
  private onStartCallback
  private onStopCallback
  private onErrorCallback

  static createInstance(): RecorderManager {
    return new RecorderManager()
  }

  async start(option: Taro.RecorderManager.StartOption): Promise<TaroGeneral.CallbackResult> {
    if (this.recorder) {
      return
    }

    const recordParams = new Audio.RecordOption()
    if (option.duration) {
      if (option.duration > 600000 || option.duration < 0) {
        recordParams.duration = 60000
      } else {
        recordParams.duration = option.duration
      }
    }
    if (option.sampleRate) {
      recordParams.sampleRate = option.sampleRate
    }
    if (option.encodeBitRate) {
      recordParams.encodeBitRate = option.encodeBitRate
    }
    if (option.numberOfChannels) {
      recordParams.numberOfChannels = option.numberOfChannels
    }
    if (option.format) {
      recordParams.format = option.format
    }

    this.recorder = new Audio.AVAudioRecorder()
    this.recorder.errorCallback = (result: any) => {
      if (this.onErrorCallback) {
        this.onErrorCallback(result)
      }
    }
    this.recorder.finishCallback = (result: any) => {
      if (this.onStopCallback) {
        this.onStopCallback(result)
      }
    }
    try {
      const res = await this.recorder.start(option.context, recordParams)
      if (res.code == TigaGeneral.SUCCESS) {
        if (this.onStartCallback) {
          this.onStartCallback({ errMsg: '开始录音成功' })
        }
        return Promise.resolve({ errMsg: '开始录音成功' })
      } else {
        if (this.onErrorCallback) {
          this.onErrorCallback({ errMsg: res.reason ? res.reason : '开始录音失败' })
        }
        return Promise.reject({ errMsg: res.reason ? res.reason : '开始录音失败' })
      }
    } catch (error) {
      return Promise.reject({ errMsg: error.message ? error.message : '调用录音bridge失败' })
    }
  }

  /**
   * 停止录音
   */
  async stop() {
    try {
      if (this.recorder) {
        await this.recorder.stop()
      }
    } catch (error) {
      this.onErrorCallback && this.onErrorCallback({ errMsg: error.message })
    }
  }

  /**
   * 监听录音失败事件
   * @param {function} callback
   */
  onError(callback) {
    this.onErrorCallback = callback
  }

  /**
   * 监听录音开始事件
   * @param {function} callback
   */
  onStart(callback) {
    this.onStartCallback = callback
  }

  /**
   * 监听录音结束事件
   * @param {function} callback
   */
  onStop(callback) {
    this.onStopCallback = callback
  }
}

function getRecorderManager(): any {
  return RecorderManager.createInstance()
}

export { getRecorderManager }
