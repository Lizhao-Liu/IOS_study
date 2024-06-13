import * as LongConn from './type'
import { TigaGeneral } from '@fta/tiga-util'

/**
 * 长链事件名
 */
const MBEVENT_RECEIVE_LONG_CONN_MESSAGE = 'com.event.mblongconn'

// 需要支持一个callback监听多个opType
class LongConnCache {
  // key: opType, value: token
  tokenMap: Map<string, string>
  // key: opType, value: callback[]
  cacheDataMap: Map<string, LongConn.ReceiveLongConnMessageCallback[]>
  haveEvent: boolean

  constructor() {
    this.cacheDataMap = new Map()
    this.tokenMap = new Map()
    this.haveEvent = false
  }

  /**
   * setCache
   */
  public setCache(
    callback: LongConn.ReceiveLongConnMessageCallback,
    opType: string,
    token: string
  ) {
    if (!opType || !callback || !token) {
      return
    }

    const currentToken = this.tokenMap.get(opType)
    if (!currentToken) {
      this.tokenMap.set(opType, token)
    }

    let itemList = this.cacheDataMap.get(opType)
    if (!itemList) {
      itemList = []
      this.cacheDataMap.set(opType, itemList)
    }

    let isExist = false
    itemList.forEach((element) => {
      if (element === callback) {
        isExist = true
        return
      }
    })

    if (!isExist) {
      itemList.push(callback)
    }

    if (!this.haveEvent) {
      this.haveEvent = true
      this.startLongConnMessageListen()
    }
    return true
  }

  /**
   * setCache
   */
  public setCacheForToken(callback: LongConn.ReceiveLongConnMessageCallback, token: string) {
    if (!callback || !token) {
      return
    }

    let itemList = this.cacheDataMap.get(token)
    if (!itemList) {
      itemList = []
      this.cacheDataMap.set(token, itemList)
    }

    itemList.push(callback)

    return
  }

  /**
   * getListener
   */
  public getListenerToken(opType: string): string {
    if (!opType) {
      return
    }

    return this.tokenMap.get(opType)
  }

  /**
   * 是否还有监听
   */
  public haveListener(opType: string): boolean {
    if (!opType) {
      return false
    }
    const token = this.tokenMap.get(opType)
    if (!token) {
      return false
    }

    return true
  }

  /**
   * 删除监听者，如果callback为空则移除opType下所有监听者
   */
  public removeListener(opType: string, callback?: LongConn.ReceiveLongConnMessageCallback) {
    if (!opType) {
      return
    }

    if (!callback) {
      // 移除opType所有监听
      this.tokenMap.delete(opType)
      this.cacheDataMap.delete(opType)
      return
    }

    const itemList = this.cacheDataMap.get(opType)

    const arr = itemList.filter((item) => {
      return item !== callback
    })

    if (!arr || arr.length <= 0) {
      this.tokenMap.delete(opType)
      this.cacheDataMap.delete(opType)
    } else {
      this.cacheDataMap.set(opType, arr)
    }
  }

  /**
   * 开始监听长链事件总线消息
   */
  private startLongConnMessageListen() {
    TigaGeneral.eventCenter.on(MBEVENT_RECEIVE_LONG_CONN_MESSAGE, (eventData: any) => {
      this.longConnHandleCallback(eventData)
    })
  }

  /**
   * 分发事件总线消息，长链消息回调
   */
  private longConnHandleCallback(eventData: any) {
    if (!eventData || !eventData.opType) {
      return
    }
    const opType: string = eventData.opType
    const longConMsg: LongConn.MBLongConnMessage = {
      ...eventData,
    }

    const itemList = this.cacheDataMap.get(opType)
    if (!itemList) {
      return
    }
    itemList.forEach((element) => {
      const receiveCallback = element
      receiveCallback(longConMsg)
    })
  }
}

export const longConnCache: LongConnCache = new LongConnCache()
