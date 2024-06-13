import { BridgeChannel } from '@nativex/global-logic-lib'

interface Result {
  code: number
  reason?: string
  data?: any
}

const TigaOriginalBridge = {
  call: async function (context: any, bridgeName: string, params: any = {}): Promise<Result> {
    return new Promise(async (resolve, reject) => {
      try {
        const res = await BridgeChannel.invokeV2(bridgeName, params)
        resolve(res)
      } catch (error) {
        if (error?.code) {
          resolve(error)
        } else {
          reject(error)
        }
      }
    })
  },
}

export { TigaOriginalBridge }
