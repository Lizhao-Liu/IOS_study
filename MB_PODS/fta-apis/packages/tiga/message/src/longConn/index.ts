import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as LongConn from './type'
import * as Cache from './longConnCache'

async function registerLongConnListen(
  option: LongConn.MBLongConnHandleOption
): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.opType || !option.receiveMessageCallback) {
    failRes.code = 1
    failRes.reason = '缺少参数opType或receiveMessageCallback'
    return errorHandler(fail, complete)(failRes)
  }

  const token = Cache.longConnCache.getListenerToken(option.opType)
  if (token) {
    Cache.longConnCache.setCache(option.receiveMessageCallback, option.opType, token)

    failRes.code = 0
    failRes.reason = '注册成功'
    return successHandler(success, complete)(failRes)
  }

  const params = {
    opType: option.opType,
  }

  try {
    const bridgeResult = await TigaBridge.call(
      option.context,
      'app.push.registerLongConnect',
      params
    )
    const { code, reason, data } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0 || !data.token) throw new Error()

    // 监听长链消息成功，加入缓存
    Cache.longConnCache.setCache(option.receiveMessageCallback, option.opType, data.token)

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function removeLongConnListen(
  option: LongConn.MBRemoveLongConnListenOption
): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.opType) {
    failRes.code = 1
    failRes.reason = '缺少参数opType'
    return errorHandler(fail, complete)(failRes)
  }

  const token = Cache.longConnCache.getListenerToken(option.opType)

  // 移除回调缓存
  Cache.longConnCache.removeListener(option.opType, option.receiveMessageCallback)

  if (Cache.longConnCache.haveListener(option.opType)) {
    failRes.code = 0
    failRes.reason = '监听移除成功'
    return successHandler(success, complete)(failRes)
  }

  if (!token) {
    failRes.code = 0
    failRes.reason = '监听移除成功'
    return successHandler(success, complete)(failRes)
  }

  const params = {
    opType: option.opType,
    token: token,
  }

  try {
    const bridgeResult = await TigaBridge.call(
      option.context,
      'app.push.removeLongConnectListen',
      params
    )
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

export { registerLongConnListen, removeLongConnListen }
