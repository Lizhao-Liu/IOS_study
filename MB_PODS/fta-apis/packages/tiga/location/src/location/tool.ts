import { Permissions, checkPermission, checkService } from '@fta/tiga-permission'
import { TigaGeneral } from '@fta/tiga-util'
import MD5 from 'md5'
import { getRegionParent } from '../region'
import { RegionCallbackResult } from '../region/PropTypes'
import { LocationInfoCallbackResult, WebGeocoderProps } from './PropTypes'

export async function isHaveLocationService(option: TigaGeneral.Option<any>): Promise<Boolean> {
  try {
    const { status } = await checkService({
      context: option.context,
      service: Permissions.location,
    })
    return status == 1
  } catch (error) {
    return true
  }
}

export async function isHaveLocationPermission(option: TigaGeneral.Option<any>): Promise<Boolean> {
  try {
    const { status } = await checkPermission({
      context: option.context,
      permission: Permissions.location,
    })
    return status == 1
  } catch (error) {
    return true
  }
}

// 直辖市
const municipalities = ['北京', '上海', '天津', '重庆']
// 港澳台
const specialRegions = ['香港', '澳门', '台湾']

export async function constructResponseData(
  context?: any,
  regionRes?: RegionCallbackResult,
  locationRes?: any
): Promise<LocationInfoCallbackResult> {
  if (regionRes?.level == 3) {
    const cityRegion = await getRegionParent({ context: context, code: regionRes?.regionCode })
    const provinceRegion = await getRegionParent({ context: context, code: cityRegion?.regionCode })
    const formatName = isSpecialRegion(cityRegion.name)
      ? cityRegion?.fullName + ' ' + regionRes?.fullName
      : provinceRegion?.fullName + ' ' + cityRegion?.fullName + ' ' + regionRes?.fullName
    return {
      provinceId: provinceRegion?.regionCode,
      cityId: cityRegion?.regionCode,
      districtId: regionRes?.regionCode,
      formatName: formatName,
      ...regionRes,
      ...locationRes,
      name: regionRes?.name,
    }
  } else if (regionRes?.level == 2) {
    const provinceRegion = await getRegionParent({ context: context, code: regionRes?.regionCode })
    const formatName = isSpecialRegion(regionRes.name)
      ? provinceRegion?.fullName + ' ' + regionRes?.fullName
      : regionRes?.fullName
    return {
      provinceId: provinceRegion?.regionCode,
      cityId: regionRes?.regionCode,
      formatName: formatName,
      ...regionRes,
      ...locationRes,
      name: regionRes?.name,
    }
  } else {
    return {
      provinceId: regionRes?.regionCode,
      formatName: regionRes?.fullName,
      ...regionRes,
      ...locationRes,
      name: regionRes?.name,
    }
  }
}

function isSpecialRegion(name: string): boolean {
  return municipalities.includes(name) || specialRegions.includes(name)
}

export function buildParams(props: WebGeocoderProps): any {
  const params = {
    callerFlag: 'UmV2ZXJzZUdlb0NvZGUtQXBwQ2xpZW50',
    coordinateSystem: 'gcj02ll',
    lat: props.lat,
    lon: props.lon,
    // 暂时先写死线上的，后续支持测试环境
    token: 'acdc77b3ced2cd9ba3d2ad4db9bf05e0',
    wantId: 'true',
  }

  let str = ''

  for (let p in params) {
    str += `${p}=${params[p]}&`
  }
  str = str.substring(0, str.length - 1)
  console.log(str)
  const sign = MD5(str + 'dY1yV8qW2mY0nM3t').toUpperCase()
  console.log(sign)

  const lastParams = {
    ...params,
    sign: sign ? sign : '',
  }
  console.log(lastParams)
  return lastParams
}
