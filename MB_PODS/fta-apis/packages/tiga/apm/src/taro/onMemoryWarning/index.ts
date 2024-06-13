import { TigaGeneral } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export function onMemoryWarning(callback: (result: Taro.onMemoryWarning.CallbackResult) => void) {
  TigaGeneral.eventCenter.on(TigaGeneral.MBEVENT_MEMORY_WARNING_NOTIFICATION, callback)
}
