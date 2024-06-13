import { getEngineContext, TigaGeneral } from '@fta/tiga-util'
import { InnerAudioContext } from '@tarojs/taro'
import { Bridges } from '../../audio/player/bridges'
import Tiga from '@fta/tiga'

const STATE_CREATED = 1
const STATE_PREPARED = 2
const STATE_PLAYBACK_STARTED = 11
const STATE_PLAYBACK_PAUSED = 12
const STATE_PLAYBACK_COMPLETED = 13
const STATE_PLAYBACK_STOPPED = 14
const STATE_ERROR = -1
const STATE_DESTROYED = -2

class MyInnerAudioContext implements InnerAudioContext {
  private state: number = STATE_CREATED

  private context: any
  private token: Promise<string>
  private commitPlaybackParamsId: number
  private commitSourceId: number
  private commitingSrc: string
  private commitingVolume: number
  private commitingRate: number

  private onCanplayCallbacks: Set<() => void> = new Set()
  private onPlayCallbacks: Set<() => void> = new Set()
  private onPauseCallbacks: Set<() => void> = new Set()
  private onStopCallbacks: Set<() => void> = new Set()
  private onEndedCallbacks: Set<() => void> = new Set()
  private onErrorCallbacks: Set<(res: InnerAudioContext.onErrorDetail) => void> = new Set()

  _src: string
  _autoplay: boolean = false
  _volume: number = 1
  _playbackRate: number = 1

  src: string
  startTime: number
  autoplay: boolean
  loop: boolean
  obeyMuteSwitch: boolean
  volume: number
  playbackRate: number
  referrerPolicy?: string

  // read only
  duration: number
  currentTime: number
  paused: boolean
  buffered: number

  constructor() {
    this.token = getEngineContext()
      .then((context) => {
        this.context = context
        return Bridges.create(context)
      })
      .then((token) => {
        TigaGeneral.eventCenter.on(`app.audioPlayer.${token}`, (eventData) => {
          if (eventData.what == 'onError') {
            this.onEventError(eventData.errCode, eventData.errMsg)
          } else if (eventData.what == 'onPlaybackComplete') {
            this.onEventPlaybackComplete()
          }
        })
        return token
      })

    Object.defineProperty(this, 'src', {
      get: () => this._src,
      set: (value) => {
        if (this._src != value) {
          this._src = value
          this.prepareSource()
        }
      },
    })
    Object.defineProperty(this, 'autoplay', {
      get: () => this._autoplay,
      set: (value) => {
        this._autoplay = value
        this.checkAutoPlay()
      },
    })
    Object.defineProperty(this, 'playbackRate', {
      get: () => this._playbackRate,
      set: (value) => {
        this._playbackRate = value
        this.commitPlaybackParams()
      },
    })
    Object.defineProperty(this, 'volume', {
      get: () => this._volume,
      set: (value) => {
        this._volume = value
        this.commitPlaybackParams()
      },
    })
    Object.defineProperty(this, 'duration', {
      get: () => this.getDuration(),
      set: () => {
        throw new Error('"duration" attribute is read only')
      },
    })
    Object.defineProperty(this, 'currentTime', {
      get: () => this.getCurrentTime(),
      set: () => {
        throw new Error('"currentTime" attribute is read only')
      },
    })
    Object.defineProperty(this, 'paused', {
      get: () => this.isPaused(),
      set: () => {
        throw new Error('"paused" attribute is read only')
      },
    })
    Object.defineProperty(this, 'buffered', {
      get: () => this.getBuffered(),
      set: () => {
        throw new Error('"buffered" attribute is read only')
      },
    })
  }

  private dispatchCallbacks(callbacks: Set<() => void>) {
    callbacks.forEach((callback) => {
      try {
        callback?.()
      } catch (err) {
        console.error('dispatchCallbacks', callback, err)
      }
    })
  }

  private dispatchOnError(error: InnerAudioContext.onErrorDetail) {
    this.onErrorCallbacks.forEach((callback) => {
      try {
        callback?.(error)
      } catch (err) {
        console.error('dispatchOnError', callback, err)
      }
    })
  }

  private commitPlaybackParams(): void {
    let commitId: number
    this.token
      .then((token) => {
        if (this.commitingVolume != this._volume || this.commitingRate != this._playbackRate) {
          this.commitingVolume = this._volume
          this.commitingRate = this._playbackRate
          commitId = Ids.newId()
          this.commitPlaybackParamsId = commitId
          return Bridges.setPlaybackParams(token, this._volume, this._playbackRate, this.context)
        }
      })
      .catch((err) => {
        this.dispatchOnError({ errCode: err.code, errMsg: err.reason })
      })
      .then(() => {
        if (this.commitPlaybackParamsId == commitId) {
          this.commitingVolume = undefined
          this.commitingRate = undefined
        }
      })
  }

  private prepareSource(): void {
    let commitId: number
    const beforeCommit = Promise.resolve()
      .then(() => {
        if (this._src != this.commitingSrc) {
          this.commitingSrc = this._src
          commitId = Ids.newId()
          this.commitSourceId = commitId
          return this._src
        } else {
          throw IGNORED
        }
      })
      .then((src) => {
        if (src.startsWith('http:') || src.startsWith('https:')) {
          return src
        } else {
          return Tiga.Storage.sandboxDir.decodeToAbsolutePath(this.context, src)
        }
      })
    Promise.all([this.token, beforeCommit])
      .then(([token, src]) => {
        return Bridges.prepareSource(token, src, this.context)
      })
      .then(() => {
        if (commitId == this.commitSourceId) {
          this.state = STATE_PREPARED
          this.dispatchCallbacks(this.onCanplayCallbacks)
          this.checkAutoPlay()
        }
      })
      .catch((err) => {
        if (err === IGNORED) {
          return
        }
        if (commitId == this.commitSourceId) {
          this.state = STATE_ERROR
          this.dispatchOnError({ errCode: err.code, errMsg: err.reason })
        }
      })
      .then(() => {
        if (commitId == this.commitSourceId) {
          this.commitingSrc = undefined
        }
      })
  }

  private checkAutoPlay(): void {
    if (this.state == STATE_PREPARED && this._autoplay) {
      this.play()
    }
  }

  play(): void {
    switch (this.state) {
      case STATE_PREPARED:
      case STATE_PLAYBACK_PAUSED:
      case STATE_PLAYBACK_COMPLETED:
      case STATE_PLAYBACK_STOPPED:
        this.state = STATE_PLAYBACK_STARTED
        this.token
          .then((token) => Bridges.play(token, this.context))
          .then(() => {
            this.dispatchCallbacks(this.onPlayCallbacks)
          })
          .catch((err) => {
            this.dispatchOnError({ errCode: err.code, errMsg: err.reason })
          })
        break
      default:
      // do nothing
    }
  }

  pause(): void {
    if (this.state == STATE_PLAYBACK_STARTED) {
      this.state = STATE_PLAYBACK_PAUSED
      this.token
        .then((token) => Bridges.pause(token, this.context))
        .then(() => {
          this.dispatchCallbacks(this.onPauseCallbacks)
        })
        .catch((err) => {
          this.dispatchOnError({ errCode: err.code, errMsg: err.reason })
        })
    }
  }

  stop(): void {
    switch (this.state) {
      case STATE_PLAYBACK_STARTED:
      case STATE_PLAYBACK_PAUSED:
      case STATE_PLAYBACK_COMPLETED:
        this.state = STATE_PLAYBACK_STOPPED
        this.token
          .then((token) => Bridges.stop(token, this.context))
          .then(() => {
            this.dispatchCallbacks(this.onStopCallbacks)
          })
          .catch((err) => {
            this.dispatchOnError({ errCode: err.code, errMsg: err.reason })
          })
        break
      default:
      // do nothing
    }
  }

  seek(position: number): void {
    throw new Error('Method not implemented.')
  }

  destroy(): void {
    this.state = STATE_DESTROYED
    this.token.then((token) => Bridges.destroy(token, this.context))
  }

  private getDuration(): number {
    throw new Error('Method not implemented.')
  }

  private getCurrentTime(): number {
    throw new Error('Method not implemented.')
  }

  private isPaused(): boolean {
    return this.state != STATE_PLAYBACK_STARTED
  }

  private getBuffered(): number {
    throw new Error('Method not implemented.')
  }

  private onEventError(errCode: number, errMsg: string): void {
    this.state = STATE_ERROR
    this.dispatchOnError({ errCode, errMsg })
  }

  private onEventPlaybackComplete() {
    if (this.state == STATE_PLAYBACK_STARTED) {
      this.state = STATE_PLAYBACK_COMPLETED
      this.dispatchCallbacks(this.onEndedCallbacks)
      if (this.loop) {
        this.play()
      }
    } else {
      console.warn('ignored playback complete event')
    }
  }

  onCanplay(callback?: () => void): void {
    this.onCanplayCallbacks.add(callback)
  }

  onPlay(callback?: () => void): void {
    this.onPlayCallbacks.add(callback)
  }

  onPause(callback?: () => void): void {
    this.onPauseCallbacks.add(callback)
  }

  onStop(callback?: () => void): void {
    this.onStopCallbacks.add(callback)
  }

  onEnded(callback?: () => void): void {
    this.onEndedCallbacks.add(callback)
  }

  onTimeUpdate(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  onError(callback?: (res: InnerAudioContext.onErrorDetail) => void): void {
    this.onErrorCallbacks.add(callback)
  }

  onWaiting(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  onSeeking(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  onSeeked(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  offCanplay(callback?: () => void): void {
    this.onCanplayCallbacks.delete(callback)
  }

  offPlay(callback?: () => void): void {
    this.onPlayCallbacks.delete(callback)
  }

  offPause(callback?: () => void): void {
    this.onPauseCallbacks.delete(callback)
  }

  offStop(callback?: () => void): void {
    this.onStopCallbacks.delete(callback)
  }

  offEnded(callback?: () => void): void {
    this.onEndedCallbacks.delete(callback)
  }

  offTimeUpdate(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  offError(callback?: () => void): void {
    this.onErrorCallbacks.delete(callback)
  }

  offWaiting(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  offSeeking(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }

  offSeeked(callback?: () => void): void {
    throw new Error('Method not implemented.')
  }
}

export function createInnerAudioContext(): InnerAudioContext {
  return new MyInnerAudioContext()
}

let id = 1

namespace Ids {
  export function newId() {
    return id++
  }
}

const IGNORED = {}
