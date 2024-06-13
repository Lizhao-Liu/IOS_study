import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import {
  AdDataCallback,
  GetAdProps,
  LogProps,
  PopupProps,
  RefreshProps,
  RefreshTextCallback,
  StayLogProps,
} from '../propTypes'

// 弹出广告弹窗
const popup = async (option: PopupProps): Promise<TigaGeneral.CallbackResult> => {
  const params: PopupProps = {
    positionCode: option.positionCode,
    popupCode: option.popupCode,
    sceneCodes: option.sceneCodes,
    cityId: option.cityId,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.ad.popup', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `popup fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 获取刷新文案
const getRefreshInfo = async (option: RefreshProps): Promise<RefreshTextCallback> => {
  const params: RefreshProps = {
    pageName: option.pageName,
  }
  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.ad.getPageRefreshInfo',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(data)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRefreshText fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 根据广告 id 获取广告数据
const getAdData = async (option: GetAdProps): Promise<AdDataCallback> => {
  const params: GetAdProps = {
    positionCode: option.positionCode,
    sceneCodes: option.sceneCodes,
    cityId: option.cityId,
  }
  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.ad.getAdData',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(data)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `getAdData fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// (埋点)展示广告
const show = async (option: LogProps): Promise<TigaGeneral.CallbackResult> => {
  const params: LogProps = {
    adId: option.adId,
    positionCode: option.positionCode,
    utmCampaign: option.utmCampaign,
    advertMetricInfo: option.advertMetricInfo,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.ad.show', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `show fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// (埋点)点击广告
const tap = async (option: LogProps): Promise<TigaGeneral.CallbackResult> => {
  const params: LogProps = {
    adId: option.adId,
    positionCode: option.positionCode,
    utmCampaign: option.utmCampaign,
    advertMetricInfo: option.advertMetricInfo,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.ad.tap', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `tap fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// (埋点)关闭广告
const close = async (option: LogProps): Promise<TigaGeneral.CallbackResult> => {
  const params: LogProps = {
    adId: option.adId,
    positionCode: option.positionCode,
    utmCampaign: option.utmCampaign,
    advertMetricInfo: option.advertMetricInfo,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.ad.close', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `close fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// (埋点)广告停留时长
const stay = async (option: StayLogProps): Promise<TigaGeneral.CallbackResult> => {
  const params: StayLogProps = {
    adId: option.adId,
    positionCode: option.positionCode,
    utmCampaign: option.utmCampaign,
    advertMetricInfo: option.advertMetricInfo,
    duration: option.duration,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.ad.stay', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = {
      code: 1,
      reason: `stay fail, errorMsg: ${error.message}`,
    }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export { close, getAdData, getRefreshInfo, popup, show, stay, tap }
