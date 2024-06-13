import { TigaBridge, errorHandler, successHandler } from '@fta/tiga-util'
import * as TabData from '../../types'

async function getTabDataList(
  options: TabData.TabDataListOption
): Promise<TabData.TabDataListResult> {
  const { complete, fail, success } = options
  const failRes = {
    code: 100,
    reason: 'some unknow exception!',
  }
  try {
    const bridgeResult = await TigaBridge.call(options.context, 'app.maintab.getTabDataList', {})
    const { code, reason, data } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TabData.TabDataListResult = {
      code: code,
      reason: reason,
      currentSelectedPos: data.currentSelectedPos,
      tabList: data.tabList,
    }
    console.log('tabdata.res', res)
    return successHandler(success, complete)(res)
  } catch (error) {
    console.log('tabdata.error, ', error, failRes)
    return errorHandler(fail, complete)(failRes)
  }
}

export { getTabDataList }
