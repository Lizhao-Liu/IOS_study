import Taro from '@tarojs/taro'
import { TigaGeneral } from '@fta/tiga-util'

export function offAppShow(callback: (result: Taro.onAppShow.CallbackResult) => void) {
  const removes = TigaGeneral.eventcallbackManager.remove(
    TigaGeneral.MBEVENT_LIFECYCLE_ONAPPSHOW,
    callback
  )

  if (removes) {
    removes.forEach((element) => {
      TigaGeneral.eventCenter.off(TigaGeneral.MBEVENT_LIFECYCLE_ONAPPSHOW, element)
    })
  }
}
