import Taro from '@tarojs/taro'
import { TigaGeneral } from '@fta/tiga-util'

export function onAppShow(callback: (result: Taro.onAppShow.CallbackResult) => void) {
  const taskId = TigaGeneral.eventCenter.on(
    TigaGeneral.MBEVENT_LIFECYCLE_ONAPPSHOW,
    (eventData) => {
      const res: Taro.onAppShow.CallbackResult = {
        path: undefined,
        query: undefined,
        shareTicket: undefined,
        scene: undefined,
        referrerInfo: undefined,
      }
      const cacheFunc = TigaGeneral.eventcallbackManager.getListenerCallback(
        TigaGeneral.MBEVENT_LIFECYCLE_ONAPPSHOW,
        taskId
      )
      if (callback && cacheFunc) {
        callback(res)
      }
    }
  )

  TigaGeneral.eventcallbackManager.add(TigaGeneral.MBEVENT_LIFECYCLE_ONAPPSHOW, taskId, callback)
}
