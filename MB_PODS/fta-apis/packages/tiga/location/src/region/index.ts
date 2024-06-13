import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import {
  ChildrenProps,
  CodeProps,
  NameProps,
  RegionCallbackResult,
  RegionsCallbackResult,
} from './PropTypes'

export const getRegionChildren = async (option: ChildrenProps): Promise<RegionsCallbackResult> => {
  const { code, deep } = option
  try {
    const params = { code: code, deep: deep }
    const response = await TigaBridge.call(option.context, 'app.region.children', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(
        option.success,
        option.complete
      )({ list: convertResponsesToModel(response.data) })
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionChildren fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export const getRegionParent = async (option: CodeProps): Promise<RegionCallbackResult> => {
  const { code } = option
  try {
    const params = { code: code }
    const response = await TigaBridge.call(option.context, 'app.region.parent', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(convertResponseToModel(response.data))
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionParent fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export const getRegionWithCode = async (option: CodeProps): Promise<RegionCallbackResult> => {
  const { code } = option
  try {
    const params = { code: code }
    const response = await TigaBridge.call(option.context, 'app.region.getRegionWithCode', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(convertResponseToModel(response.data))
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionWithCode fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export const getRegionWithName = async (option: NameProps): Promise<RegionCallbackResult> => {
  const { province, city, district } = option
  try {
    const params = { province: province, city: city, district: district }
    const response = await TigaBridge.call(option.context, 'app.region.getRegionWithName', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(convertResponseToModel(response?.data))
    } else {
      return errorHandler(option.fail, option.complete)(response)
    }
  } catch (error) {
    const res = { code: 1, reason: `getRegionWithName fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

function convertResponseToModel(res: any): RegionCallbackResult {
  if (res?.children) {
    const val: RegionCallbackResult = {
      name: res.name,
      fullName: res.fullName,
      regionCode: res?.code,
      superCode: res.superCode,
      level: res.level,
      regionLongitude: res.regionLongitude,
      regionLatitude: res.regionLatitude,
      pyName: res.pyName,
      status: res.status,
      children: res?.children ? convertResponsesToModel(res?.children) : null,
    }
    return val
  } else {
    const val: RegionCallbackResult = {
      name: res.name,
      fullName: res.fullName,
      regionCode: res.code,
      superCode: res.superCode,
      level: res.level,
      regionLongitude: res.regionLongitude,
      regionLatitude: res.regionLatitude,
      pyName: res.pyName,
      status: res.status,
    }
    return val
  }
}

function convertResponsesToModel(res: Array<any>): Array<RegionCallbackResult> {
  const resultArray: Array<RegionCallbackResult> = []
  res.forEach((obj) => {
    const region = convertResponseToModel(obj)
    resultArray.push(region)
  })
  return resultArray
}

export * from './PropTypes'
