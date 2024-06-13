import { TigaBridge, TigaGeneral } from '@fta/tiga-util'
import GlobalParamsManager from './GlobalParamsManager'
import * as Tracker from './trackParams'

// 公用业务参数配置
export function setGlobalExtraParams(paramsFunction: () => { [key: string]: any }): void {
  const managerInstance = GlobalParamsManager.getInstance()
  managerInstance.setGlobalExtraParams(paramsFunction)
}

export function getGlobalExtraParams(): { [key: string]: any } {
  const managerInstance = GlobalParamsManager.getInstance()
  return managerInstance.getGlobalExtraParams()
}

export function clearGlobalExtraParams(): void {
  const managerInstance = GlobalParamsManager.getInstance()
  managerInstance.clearGlobalExtraParams()
}

function paramsHandle(param: Tracker.BaseTrackParam): any {
  const { extraDict, ...rest } = param
  const mergedExtraDict = {
    ...GlobalParamsManager.getInstance().getGlobalConfig().extraDict,
    ...extraDict,
  }

  let opts = {
    ...rest,
    bundle: GlobalParamsManager.getInstance().getGlobalConfig().bundle,
    extraDict: mergedExtraDict,
  }

  opts['success'] && delete opts['success']
  opts['fail'] && delete opts['fail']
  opts['complete'] && delete opts['complete']
  return opts
}

function track(method: string, params: Tracker.BaseTrackParam) {
  const { context, success, fail, complete } = params
  const opts = paramsHandle(params)
  TigaBridge.call(context, method, opts)
    .then((res) => {
      if (res?.code == TigaGeneral.SUCCESS) {
        success && success(res?.data)
        complete && complete(res?.data)
      } else {
        fail && fail(res)
        complete && complete(res)
      }
    })
    .catch((error) => {
      const res = {
        code: Tracker.ERROR_CODE,
        reason: error?.message ?? '',
      }
      fail && fail(res)
      complete && complete(res)
    })
}

export function pageview(params: Tracker.PageviewTrackParam) {
  track('app.track.pageview', params)
}

export function pageviewDuration(params: Tracker.PageviewDurationTrackParam) {
  track('app.track.pageviewDuration', params)
}

export function tap(params: Tracker.TapTrackParam) {
  track('app.track.tap', params)
}

export function exposure(params: Tracker.ExposureTrackParam) {
  track('app.track.exposure', params)
}

export function regionExposure(params: Tracker.RegionExposureParam) {
  const bridgeCallParams = {
    ...params,
    elementId: 'regionview',
  }
  track('app.track.exposure', bridgeCallParams)
}

export function regionDuration(params: Tracker.RegionDurationParam) {
  const bridgeCallParams = {
    ...params,
    elementId: 'regionview_stay_duration',
  }
  track('app.track.exposure', bridgeCallParams)
}

export function clearCache(params: Tracker.ClearTrackCacheParam) {
  const { context, success, fail, complete } = params
  const opts = paramsHandle(params)
  TigaBridge.call(context, 'app.track.clearCache', opts)
    .then((res) => {
      if (res?.code == TigaGeneral.SUCCESS) {
        success && success(res?.data)
        complete && complete(res?.data)
      } else {
        fail && fail(res)
        complete && complete(res)
      }
    })
    .catch((error) => {
      const res = {
        code: Tracker.ERROR_CODE,
        reason: error?.message ?? '',
      }
      fail && fail(res)
      complete && complete(res)
    })
}

export function monitor(params: Tracker.MonitorTrackParam) {
  return track('app.track.monitor', params)
}

export function log(params: Tracker.LogParam) {
  const { context, success, fail, complete } = params
  const opts = paramsHandle(params)
  TigaBridge.call(context, 'app.track.log', opts)
    .then((res) => {
      if (res?.code == TigaGeneral.SUCCESS) {
        success && success(res?.data)
        complete && complete(res?.data)
      } else {
        fail && fail(res)
        complete && complete(res)
      }
    })
    .catch((error) => {
      const res = {
        code: Tracker.ERROR_CODE,
        reason: error?.message ?? '',
      }
      fail && fail(res)
      complete && complete(res)
    })
}

export function error(params: Tracker.ErrorTrackParam) {
  return track('app.track.error', params)
}

export function network(params: Tracker.NetworkTrackParam) {
  const { context, success, fail, complete } = params
  const opts = paramsHandle(params)
  opts['success'] = params.isSuccess ? 1 : 0
  delete opts['isSuccess']
  TigaBridge.call(context, 'app.track.network', opts)
    .then((res) => {
      if (res?.code == TigaGeneral.SUCCESS) {
        success && success(res?.data)
        complete && complete(res?.data)
      } else {
        fail && fail(res)
        complete && complete(res)
      }
    })
    .catch((error) => {
      const res = {
        code: Tracker.ERROR_CODE,
        reason: error?.message ?? '',
      }
      fail && fail(res)
      complete && complete(res)
    })
}

export * from './log'
export * from './monitor'
export * from './pagePerformance'
export * from './trackParams'
export * from './transaction'

