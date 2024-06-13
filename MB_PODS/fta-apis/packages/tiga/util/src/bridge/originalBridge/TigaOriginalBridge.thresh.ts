import { Bridge } from '@thresh/thresh-lib'

interface Result {
  code: number
  reason?: string
  data?: any
}

interface MBBridgeParams {
  module: string
  business?: string
  method: string
  params?: any
}

const TigaOriginalBridge = {
  call: async function (context: any, bridgeName: string, params: any = {}): Promise<Result> {
    const bridgeInfo: string[] = bridgeName.split('.')
    const module: string = bridgeInfo[0]
    const method: string = bridgeInfo[bridgeInfo.length - 1]
    const business = bridgeInfo.length > 2 ? bridgeInfo[1] : undefined
    const res: unknown = TigaOriginalBridge.invoke(context, {
      module,
      business,
      method,
      params,
    })
    return res as Result
  },

  invoke: function (context: any, bridgeParams: MBBridgeParams): Promise<any> {
    return Bridge.invokeV2(context, bridgeParams)
  },
}

export { TigaOriginalBridge }
