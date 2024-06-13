import Taro from '@tarojs/taro'
import { TigaGeneral } from '@fta/tiga-util'

export function offNetworkStatusChange(
  callback: (result: Taro.onNetworkStatusChange.CallbackResult) => void
) {
  TigaGeneral.eventCenter.off(TigaGeneral.MBEVENT_NETWORK_STATUS_CHANGE, callback)
}
