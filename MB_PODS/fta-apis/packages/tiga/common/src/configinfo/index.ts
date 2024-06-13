import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface GetConfigOption extends TigaGeneral.Option<GetConfigResult> {
  /** 配置组，必传字段 */
  group: string
  /** 配置项，必传字段 */
  key: string
  /** 默认值，当配置项不存在时返回的值，必传字段 */
  defaultValue: string
  /** 接口调用成功的回调函数 */
  success?: (res: GetConfigResult) => void
  /**
   * 接口调用失败的回调函数
   * 错误码：1: 缺少参数 2: 未知异常
   */
  fail?: (res: TigaGeneral.CallbackResult) => void
  /** 接口调用结束的回调函数（调用成功、失败都会执行） */
  complete?: (res: GetConfigResult | TigaGeneral.CallbackResult) => void
}

export interface GetConfigResult extends TigaGeneral.CallbackResult {
  /** 配置值 */
  value: string
}

async function getConfig(option: GetConfigOption): Promise<GetConfigResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }
  console.log('配置下发.option: ', option)
  if (!option.group || !option.key || !option.defaultValue) {
    failRes.code = 1
    failRes.reason = '缺少参数'
    return errorHandler(fail, complete)(failRes)
  }

  const params = {
    group: option.group,
    key: option.key,
    defaultValue: option.defaultValue,
  }
  try {
    console.log('配置下发.params: ', params)
    const bridgeResult = await TigaBridge.call(option.context, 'app.common.getConfig', params)
    console.log('配置下发.result: ', bridgeResult)
    const { code, reason, data } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: GetConfigResult = {
      code: code,
      reason: reason,
      value: data.value,
    }
    console.log('配置下发.res', res)
    return successHandler(success, complete)(res)
  } catch (error) {
    console.log('配置下发.error, ', error, failRes)
    return errorHandler(fail, complete)(failRes)
  }
}

export { getConfig }
