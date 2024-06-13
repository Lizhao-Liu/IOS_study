import Taro from '@tarojs/taro'
import { TigaGeneral } from '@fta/tiga-util'

export function onNetworkStatusChange(
  callback: (result: Taro.onNetworkStatusChange.CallbackResult) => void
) {
  TigaGeneral.eventCenter.on(TigaGeneral.MBEVENT_NETWORK_STATUS_CHANGE, callback)
}
