import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface PluginInfoOption extends TigaGeneral.Option<PluginInfoResult> {
  /** 页面context */
  context?: any
  /** 插件名 */
  pluginName: string
}

export interface PluginInfoResult extends TigaGeneral.CallbackResult {
  /** 插件名 */
  pluginName: string
  /** 插件版本 */
  pluginVersion: string
  /** 插件版本数字型 */
  pluginVersionCode: number
  /** 是否已启动 */
  started: boolean
}

async function getPluginInfo(option: PluginInfoOption): Promise<PluginInfoResult> {
  const { context, pluginName, complete, fail, success } = option

  try {
    const params = {
      pluginName: pluginName,
    }
    const res = await TigaBridge.call(context, 'app.system.getPluginInfo', params)

    if (res?.code == TigaGeneral.SUCCESS) {
      const data: PluginInfoResult = {
        pluginName: res?.data?.pluginName,
        pluginVersion: res?.data?.pluginVersion,
        pluginVersionCode: res?.data?.pluginVersionCode,
        started: res?.data?.started == 1,
      }
      return successHandler(success, complete)(data)
    } else {
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = {
      code: 1,
      reason: `getPluginInfo: fail, errorMsg: ${e.message}`,
    }
    return errorHandler(fail, complete)(res)
  }
}

export { getPluginInfo }
