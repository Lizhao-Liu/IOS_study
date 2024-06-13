import { request } from '@fta/tiga-network'
import { PermissionStatus, Permissions, requestPermission } from '@fta/tiga-permission'
import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { getRegionWithName } from '../region'
import {
  GeocoderProps,
  LocationInfoCallbackResult,
  LocationProps,
  WebGeocoderProps,
  WebLocationInfoCallbackResult,
} from './PropTypes'
import {
  buildParams,
  constructResponseData,
  isHaveLocationPermission,
  isHaveLocationService,
} from './tool'

export const getCacheLocationInfo = async (
  option: TigaGeneral.Option<LocationInfoCallbackResult>
): Promise<LocationInfoCallbackResult> => {
  // 判断定位服务
  const isHaveService = await isHaveLocationService(option)
  if (!isHaveService) {
    return errorHandler(option.fail, option.complete)({ code: 3, reason: '无定位服务' })
  }

  // 判断定位权限
  const isHavePermission = await isHaveLocationPermission(option)
  if (!isHavePermission) {
    return errorHandler(option.fail, option.complete)({ code: 2, reason: '无定位权限' })
  }

  try {
    const response = await TigaBridge.call(option.context, 'app.lbs.getCacheLocationInfo', null)
    if (response?.code == TigaGeneral.SUCCESS) {
      // 获取数据之后组装完整数据
      const regionData = await getRegionWithName({
        context: option.context,
        province: response?.data?.province,
        city: response?.data?.city,
        district: response?.data?.district,
      })
      // 判断是否获取到了城市数据
      if (regionData?.regionCode > 0) {
        const res = await constructResponseData(option.context, regionData, response?.data)
        return successHandler(option.success, option.complete)(res)
      } else {
        return errorHandler(option.fail, option.complete)({ code: 4, reason: '获取城市数据失败' })
      }
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionParent fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export const getLocationInfo = async (
  option: TigaGeneral.Option<LocationInfoCallbackResult>
): Promise<LocationInfoCallbackResult> => {
  // 判断定位服务
  const isHaveService = await isHaveLocationService(option)
  if (!isHaveService) {
    return errorHandler(option.fail, option.complete)({ code: 3, reason: '无定位服务' })
  }

  // 判断定位权限
  const isHavePermission = await isHaveLocationPermission(option)
  if (!isHavePermission) {
    return errorHandler(option.fail, option.complete)({ code: 2, reason: '无定位权限' })
  }

  try {
    const response = await TigaBridge.call(option.context, 'app.lbs.getLocationInfo', null)
    if (response?.code == TigaGeneral.SUCCESS) {
      // 获取城市数据
      const regionData = await getRegionWithName({
        context: option.context,
        province: response?.data?.province,
        city: response?.data?.city,
        district: response?.data?.district,
      })
      // 判断是否获取到了城市数据
      if (regionData?.regionCode > 0) {
        const res = await constructResponseData(option.context, regionData, response?.data)
        return successHandler(option.success, option.complete)(res)
      } else {
        return errorHandler(option.fail, option.complete)({ code: 4, reason: '获取城市数据失败' })
      }
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionParent fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export const getLocationInfoAttach = async (
  option: LocationProps
): Promise<LocationInfoCallbackResult> => {
  const { timeInterval, permissionRequest, rationale, topHint } = option
  // 先检查权限
  if (permissionRequest) {
    // 判断定位服务
    const isHaveService = await isHaveLocationService(option)
    if (!isHaveService) {
      // 无服务的时候直接返回,无法请求,可以提示用户.
      return errorHandler(option.fail, option.complete)({ code: 3, reason: '无定位服务' })
    }

    // 判断定位权限
    const isHavePermission = await isHaveLocationPermission(option)
    if (!isHavePermission) {
      const { status } = await requestPermission({
        context: option?.context,
        permission: Permissions.location,
        rationale: rationale,
        topHint: topHint,
      })
      if (status != PermissionStatus.granted) {
        // 请求之后依然无权限直接返回
        return errorHandler(option.fail, option.complete)({ code: 2, reason: '无定位权限' })
      }
    }
  }

  // 有权限的情况下先取缓存
  const cacheData = await getCacheLocationInfo({ context: option?.context })
  const curDate = new Date().getTime() / 1000
  console.log(`cur: ${curDate} cache: ${cacheData?.locationTime} interval: ${timeInterval}`)
  // 判断时间差
  if (
    curDate - (cacheData?.locationTime ? cacheData?.locationTime : 0) <=
    (timeInterval ? timeInterval : 120)
  ) {
    console.log('get cache data')
    return successHandler(option.success, option.complete)(cacheData)
  } else {
    // 触发定位
    console.log('locate now')
    const res = await getLocationInfo({ context: option?.context })
    if (res?.code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(res)
    } else {
      return errorHandler(option.fail, option.complete)(res)
    }
  }
}

export const geocoder = async (option: GeocoderProps): Promise<LocationInfoCallbackResult> => {
  // 判断定位服务
  const isHaveService = await isHaveLocationService(option)
  if (!isHaveService) {
    return errorHandler(option.fail, option.complete)({ code: 3, reason: '无定位服务' })
  }

  // 判断定位权限
  const isHavePermission = await isHaveLocationPermission(option)
  if (!isHavePermission) {
    return errorHandler(option.fail, option.complete)({ code: 2, reason: '无定位权限' })
  }

  try {
    const params = {
      longitude: option.longitude,
      latitude: option.latitude,
      sensitiveOffset: option.sensitiveOffset,
    }
    const response = await TigaBridge.call(option.context, 'app.lbs.geocoder', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      // 获取数据之后组装完整数据
      const regionData = await getRegionWithName({
        context: option.context,
        province: response?.data?.province,
        city: response?.data?.city,
        district: response?.data?.district,
      })
      // 判断是否获取到了城市数据
      if (regionData?.regionCode > 0) {
        const res = await constructResponseData(option.context, regionData, response?.data)
        return successHandler(option.success, option.complete)(res)
      } else {
        return errorHandler(option.fail, option.complete)({ code: 4, reason: '获取城市数据失败' })
      }
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionParent fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export const webGeocoder = async (
  option: WebGeocoderProps
): Promise<WebLocationInfoCallbackResult> => {
  try {
    const res = await request({
      context: option.context,
      url: '/ymm-map-app/map/getReverseGeoCode',
      data: buildParams(option),
      responseType: 'data',
    })
    return successHandler(option.success, option.complete)(res)
  } catch (error) {
    console.log(error)
    return errorHandler(option.fail, option.complete)({ code: error.code, reason: error.reason })
  }
}

export * from './PropTypes'
