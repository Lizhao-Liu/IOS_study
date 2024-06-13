import * as Push from './type'
import { TigaGeneral } from '@fta/tiga-util'

/**
 * push事件名
 */
const MBEVENT_RECEIVE_PUSHMESSAGE = 'com.event.mbpush'

export class PushListener {
  notificationType: string
  useMode?: number
  receiveCallback?: Push.ReceivePushMessageCallback
  dequeueCallback?: Push.PushMessageDequeueCallback

  constructor(
    notificationType: string,
    useMode?: number,
    receiveCallback?: Push.ReceivePushMessageCallback,
    dequeueCallback?: Push.PushMessageDequeueCallback
  ) {
    this.notificationType = notificationType
    this.useMode = useMode
    this.receiveCallback = receiveCallback
    this.dequeueCallback = dequeueCallback
  }
}

interface PushEventInfo {
  stage: string
  notificationType: string
  pushInfo: any
}

class PushCache {
  cacheDataMap: Map<string, PushListener>
  haveEvent: boolean
  constructor() {
    // console.log('PushCache new_++++++++++++++++')
    this.cacheDataMap = new Map()
    this.haveEvent = false
  }

  /**
   * setCache
   */
  public setCache(listener: PushListener, notificationType: string) {
    if (!notificationType || !listener) {
      return
    }

    this.cacheDataMap.set(notificationType, listener)
    console.log(
      '添加缓存: ',
      notificationType,
      ', listener:',
      listener,
      'listeners:',
      this.cacheDataMap
    )
    if (!this.haveEvent) {
      this.haveEvent = true
      this.startPushMessageListen()
    }
  }

  /**
   * getListener
   */
  public getListener(notificationType: string): PushListener {
    if (!notificationType) {
      return
    }
    // console.log('获取监听对象: ', notificationType, ', listeners:', this.cacheDataMap)
    return this.cacheDataMap.get(notificationType)
  }

  /**
   * removeListener
   */
  public removeListener(notificationType: string) {
    if (!notificationType) {
      return
    }
    this.cacheDataMap.delete(notificationType)
  }

  /**
   * 开始监听push事件总线消息
   */
  private startPushMessageListen() {
    // console.log('开始监听push消息回调++++++++++')
    TigaGeneral.eventCenter.on(MBEVENT_RECEIVE_PUSHMESSAGE, (eventData: any) => {
      // console.log('监听push消息: ', eventData)
      this.consumeHandleCallback(eventData)
    })
  }

  /**
   * 分发事件总线消息，push消费阶段回调
   */
  private consumeHandleCallback(eventData: any) {
    if (!eventData || !eventData.stage || !eventData.notificationType || !eventData.pushInfo) {
      return
    }
    const stage: string = eventData.stage
    const notificationType: string = eventData.notificationType
    const listener: PushListener = this.getListener(notificationType)
    const pushMsg: Push.MBPushMessage = {
      ...eventData.pushInfo,
    }
    // console.log('准备分发push消息: ', pushMsg, ', listener:', listener)
    if (!listener) {
      // console.log('未找到对应的监听者: ', notificationType)
      return
    }
    if (!listener || !pushMsg || !pushMsg.pushId || !pushMsg.notificationType) {
      return
    }

    if (stage == 'receive' && listener.receiveCallback) {
      // console.log('收到push消息事件: ', listener.receiveCallback)
      listener.receiveCallback(pushMsg)
    } else if (stage == 'dequeue' && listener.dequeueCallback) {
      // console.log('push消息已出队事件: ', listener.dequeueCallback)
      listener.dequeueCallback(pushMsg)
    }
  }
}

export const pushCache: PushCache = new PushCache()
