import { TigaGeneral } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export function offMemoryWarning(callback: (result: Taro.onMemoryWarning.CallbackResult) => void) {
  TigaGeneral.eventCenter.off(TigaGeneral.MBEVENT_MEMORY_WARNING_NOTIFICATION, callback)
}
