import { BridgeResult } from '@ymm/rn_channel/src/channel/ProtoType'

export const TigaOriginalBridge = {
  async call(context: any, bridgeName: string, params: any): Promise<BridgeResult> {
    const NativeChannel = require('@ymm/rn_channel/src/channel/NativeChannel')
    const res = NativeChannel.invoke(bridgeName, params)
    return res
  },
}
