import { TigaGeneral } from '@fta/tiga-util'

export function onUserCaptureScreen(callback: Taro.onUserCaptureScreen.Callback) {
  const taskId = TigaGeneral.eventCenter.on(
    TigaGeneral.MBEVENT_DEVICE_ONSCREEN_SHOT_EVENT,
    (eventData) => {
      const res: Taro.onUserCaptureScreen.UserCaptureScreenResult = {
        localPath: eventData.localPath ?? '',
        errMsg: 'ok',
      }

      const cacheFunc = TigaGeneral.eventcallbackManager.getListenerCallback(
        TigaGeneral.MBEVENT_DEVICE_ONSCREEN_SHOT_EVENT,
        taskId
      )
      if (callback && cacheFunc) {
        callback(res)
      }
    }
  )

  TigaGeneral.eventcallbackManager.add(
    TigaGeneral.MBEVENT_DEVICE_ONSCREEN_SHOT_EVENT,
    taskId,
    callback
  )
}
