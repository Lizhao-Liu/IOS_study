import Taro from '@tarojs/taro'
import { TigaGeneral } from '@fta/tiga-util'

export function offAppHide(callback: (result: Taro.onAppShow.CallbackResult) => void) {
  const removes = TigaGeneral.eventcallbackManager.remove(
    TigaGeneral.MBEVENT_LIFECYCLE_ONAPPHIDE,
    callback
  )

  if (removes) {
    removes.forEach((element) => {
      TigaGeneral.eventCenter.off(TigaGeneral.MBEVENT_LIFECYCLE_ONAPPHIDE, element)
    })
  }
}
