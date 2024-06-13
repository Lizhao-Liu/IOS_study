type callbackFunc = (...arr: unknown[]) => void

interface callbackItem {
  callback: callbackFunc
  uniqueId: string
}

class EventCallbackCacheManager {
  callbackMap: Map<string, callbackItem[]>

  constructor() {
    this.callbackMap = new Map()
  }

  add(eventName: string, uniqueId: string, callback: callbackFunc) {
    if (!eventName || !uniqueId || !callback) {
      return
    }
    const item: callbackItem = {
      callback: callback,
      uniqueId: uniqueId,
    }

    let itemList = this.callbackMap.get(eventName)
    if (!itemList) {
      itemList = []
      this.callbackMap.set(eventName, itemList)
    }

    itemList.push(item)
  }

  /**
   *
   * @param eventName  监听事件名
   * @param uniqueId 监听唯一标识
   * @returns
   */
  getListenerCallback(eventName: string, uniqueId: string): callbackFunc {
    if (!eventName || !uniqueId) {
      return
    }

    let callback
    const itemList = this.callbackMap.get(eventName)
    for (let index = 0; index < itemList.length; index++) {
      const item: callbackItem = itemList[index]
      if (item.uniqueId == uniqueId) {
        callback = item.callback
        break
      }
    }

    return callback
  }

  /**
   * 移除监听者
   * @param eventName 监听事件名
   * @param callback 监听回调函数实例, callback 为空表示移除所有该eventName的监听者
   * @return string 事件唯一标识
   */
  remove(eventName: string, callback: callbackFunc): string[] {
    if (!eventName) {
      return
    }

    const itemList = this.callbackMap.get(eventName)
    const deleteIdList = []
    // callback 为空表示移除所有该eventName的监听者
    if (!callback) {
      for (let index = 0; index < itemList.length; index++) {
        const item: callbackItem = itemList[index]
        if (item.uniqueId) {
          deleteIdList.push(item.uniqueId)
        }
      }
      this.callbackMap.delete(eventName)
      return deleteIdList
    }
    if (!itemList) {
      return deleteIdList
    }
    const arr = itemList.filter((item) => {
      if (item.callback == callback) {
        deleteIdList.push(item.uniqueId)
      }
      return item.callback !== callback
    })

    // console.log('剩下数组: ', arr)
    this.callbackMap.set(eventName, arr)
    // for (let index = 0; index < itemList.length; index++) {
    //   const item: callbackItem = itemList[index]
    //   if (item.callback == callback) {
    //     deleteIdList.push(item.uniqueId)
    //     itemList.splice(index, 1)
    //     break
    //   }
    // }
    // console.log('需要删除ids: ', deleteIdList)
    return deleteIdList
  }
}

export const eventcallbackManager: EventCallbackCacheManager = new EventCallbackCacheManager()
