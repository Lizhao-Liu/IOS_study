import { uuid } from '../utils'
import { tigaBridgeErrorLog } from './TigaBridgeLogger'
import { TigaOriginalBridge } from './originalBridge/TigaOriginalBridge'

interface Result {
  code: number
  reason?: string
  data?: any
}

export const TigaBridge = {
  call: async function (context: any, bridgeName: string, params: any = {}): Promise<Result> {
    const requestId = uuid() // bridge调用标识ID
    const requestStartTime = new Date().toISOString() // bridge调用请求开始时间

    const logWithRequestIdAndStartTime = (result: any) => {
      const logMessage = {
        bridge: bridgeName,
        requestParams: params,
        requestId,
        requestStartTime,
        context,
        result,
      }
      tigaBridgeErrorLog({ tag: 'tiga_error', message: JSON.stringify(logMessage), context })
    }

    let timeoutHandle

    try {
      timeoutHandle = setTimeout(() => {
        if (!bridgeWhiteList.includes(bridgeName)) {
          const result = { reason: 'bridge调用30秒未返回结果回调(可能为正常现象)' }
          logWithRequestIdAndStartTime(result) // 在30秒内未返回结果回调，触发超时错误日志
        }
      }, 30000)

      const result = await TigaOriginalBridge.call(context, bridgeName, params)

      clearTimeout(timeoutHandle) // 清除超时函数

      if (result?.code !== 0 && !bridgeWhiteList.includes(bridgeName)) {
        logWithRequestIdAndStartTime(result) // 结果状态码返回错误，触发错误日志
      }

      return result
    } catch (error) {
      clearTimeout(timeoutHandle) // 清除超时函数
      if (!bridgeWhiteList.includes(bridgeName)) {
        const result = { reason: error.message }
        logWithRequestIdAndStartTime(result) // 捕获到异常，触发错误日志
      }
      throw error
    }
  },
}

const bridgeWhiteList = [
  'app.track.log',
  'app.track.monitor',
  'app.track.pageview',
  'app.track.pageviewDuration',
  'app.track.tap',
  'app.track.exposure',
  'app.track.error',
  'app.track.network',
  'app.track.transaction',
  'app.track.clearCache',
]
