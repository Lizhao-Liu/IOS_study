import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface SDKVersionResult extends TigaGeneral.CallbackResult {
  /** Tiga原生SDK版本号 */
  SDKVersion: string
}

async function getTigaSDKVersion(
  option: TigaGeneral.Option<SDKVersionResult>
): Promise<SDKVersionResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.system.getAppBaseInfo', {})
    const { code, reason, data } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: SDKVersionResult = {
      code: code,
      reason: reason,
      SDKVersion: data.SDKVersion,
    }
    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

export { getTigaSDKVersion }
