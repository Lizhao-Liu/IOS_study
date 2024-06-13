import { TigaGeneral } from '@fta/tiga-util'

export function offUserCaptureScreen(callback: Taro.onUserCaptureScreen.Callback) {
  const removes = TigaGeneral.eventcallbackManager.remove(
    TigaGeneral.MBEVENT_DEVICE_ONSCREEN_SHOT_EVENT,
    callback
  )

  if (removes) {
    removes.forEach((element) => {
      TigaGeneral.eventCenter.off(TigaGeneral.MBEVENT_DEVICE_ONSCREEN_SHOT_EVENT, element)
    })
  }
}
