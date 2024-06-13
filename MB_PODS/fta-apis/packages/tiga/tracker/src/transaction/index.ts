import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import GlobalParamsManager from '../GlobalParamsManager'
import * as Tracker from '../trackParams'

export function beginTransactionTrack(
  action: Tracker.TransactionTrackBeginAction,
  trackParam: Tracker.BaseTrackParam
): Tracker.TransactionTracker {
  const { extraDict, priority } = trackParam
  const mergedExtraDict = {
    ...GlobalParamsManager.getInstance().getGlobalConfig().extraDict,
    ...extraDict,
  }

  const reqParams: any = {
    action: 'begin',
    begin: action,
    bundle: GlobalParamsManager.getInstance().getGlobalConfig().bundle,
    priority,
    extraDict: mergedExtraDict,
  }

  const { context, success, fail, complete } = trackParam

  const pro: Promise<any> = TigaBridge.call(context, 'app.track.transaction', reqParams)

  let trackId: string
  async function getTrackId(): Promise<string> {
    if (trackId) {
      return Promise.resolve(trackId)
    }
    try {
      const res = await pro
      if (res?.code == TigaGeneral.SUCCESS) {
        trackId = res?.data?.transactionTrackId
        return Promise.resolve(trackId)
      }
      return Promise.resolve(null)
    } catch (error) {
      return Promise.resolve(null)
    }
  }

  const p: any = new Promise(async (resolve, reject) => {
    const trackId = await getTrackId()

    const res: Tracker.TransactionTrackBeginCallbackResult = {
      code: TigaGeneral.SUCCESS,
      transactionTrackId: trackId,
    }

    if (trackId) {
      success && success(res)
      complete && complete(res)
      resolve(res)
    } else {
      res.code = Tracker.ERROR_CODE
      fail && fail(res)
      complete && complete(res)
      reject(res)
    }
  })

  async function transactionTrackCall(
    actionType: string,
    action: Tracker.TransactionTrackCommonAction,
    trackParam: Tracker.BaseTrackParam
  ) {
    action.trackId = await getTrackId()
    const { extraDict, priority } = trackParam
    const mergedExtraDict = {
      ...GlobalParamsManager.getInstance().getGlobalConfig().extraDict,
      ...extraDict,
    }

    const reqParams: any = {
      action: actionType,
      section: 'section' === actionType ? action : undefined,
      beginIsolatedSection: 'beginIsolatedSection' === actionType ? action : undefined,
      endIsolatedSection: 'endIsolatedSection' === actionType ? action : undefined,
      end: 'end' === actionType ? action : undefined,
      bundle: GlobalParamsManager.getInstance().getGlobalConfig().bundle,
      priority,
      extraDict: mergedExtraDict,
    }

    const { context, success, fail, complete } = trackParam

    const res = await TigaBridge.call(context, 'app.track.transaction', reqParams)

    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  }

  p.end = (action: Tracker.TransactionTrackCommonAction, trackParam: Tracker.BaseTrackParam) => {
    return transactionTrackCall('end', action, trackParam)
  }
  p.section = (
    action: Tracker.TransactionTrackSectionAction,
    trackParam: Tracker.BaseTrackParam
  ) => {
    return transactionTrackCall('section', action, trackParam)
  }
  p.beginIsolatedSection = (
    action: Tracker.TransactionTrackCommonAction,
    trackParam: Tracker.BaseTrackParam
  ) => {
    return transactionTrackCall('beginIsolatedSection', action, trackParam)
  }
  p.endIsolatedSection = (
    action: Tracker.TransactionTrackCommonAction,
    trackParam: Tracker.BaseTrackParam
  ) => {
    return transactionTrackCall('endIsolatedSection', action, trackParam)
  }
  return p
}
