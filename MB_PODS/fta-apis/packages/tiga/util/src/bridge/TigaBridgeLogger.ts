import { TigaBridge, errorHandler, successHandler } from '@fta/tiga-util'
import { TigaGeneral } from '../index'

interface LogOptions extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  tag: string
  message: string
}

async function log(params: LogOptions, level: number) {
  const { context, success, fail, complete, tag, message } = params || {}
  try {
    let bridgeParams = {
      tag,
      message,
      level,
      bundle: {
        name: TigaGeneral.getBundleInfo().bundleName,
        type: TigaGeneral.getBundleInfo().bundleType,
        version: TigaGeneral.getBundleInfo().bundleVersion,
      },
    }
    const res = await TigaBridge.call(context, 'app.track.log', bridgeParams)

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

async function tigaBridgeErrorLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return log(params, 4)
}

function tigaBridgeInfoLog(params: LogOptions): Promise<TigaGeneral.CallbackResult> {
  return log(params, 2)
}

export { tigaBridgeErrorLog, tigaBridgeInfoLog }
