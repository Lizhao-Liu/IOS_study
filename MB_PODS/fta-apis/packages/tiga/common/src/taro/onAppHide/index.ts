import Taro from '@tarojs/taro'
import { TigaGeneral } from '@fta/tiga-util'

export function onAppHide(callback: (result: Taro.onAppShow.CallbackResult) => void) {
  const taskId = TigaGeneral.eventCenter.on(
    TigaGeneral.MBEVENT_LIFECYCLE_ONAPPHIDE,
    (eventData) => {
      const res: Taro.onAppShow.CallbackResult = {
        path: '',
        query: undefined,
        shareTicket: '',
        scene: undefined,
        referrerInfo: undefined,
      }
      const cacheFunc = TigaGeneral.eventcallbackManager.getListenerCallback(
        TigaGeneral.MBEVENT_LIFECYCLE_ONAPPHIDE,
        taskId
      )
      if (callback && cacheFunc) {
        callback(res)
      }
    }
  )

  TigaGeneral.eventcallbackManager.add(TigaGeneral.MBEVENT_LIFECYCLE_ONAPPHIDE, taskId, callback)
}
