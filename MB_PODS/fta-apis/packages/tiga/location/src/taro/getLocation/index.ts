import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'
import { isHaveLocationPermission, isHaveLocationService } from '../../location/tool'

export async function getLocation(
  option: Taro.getLocation.Option
): Promise<Taro.getLocation.SuccessCallbackResult> {
  // 判断定位服务
  const isHaveService = await isHaveLocationService(option)
  if (!isHaveService) {
    return errorHandler(option.fail, option.complete)({ errMsg: '无定位服务' })
  }

  // 判断定位权限
  const isHavePermission = await isHaveLocationPermission(option)
  if (!isHavePermission) {
    return errorHandler(option.fail, option.complete)({ errMsg: '无定位权限' })
  }

  try {
    const response = await TigaBridge.call(option.context, 'app.lbs.getLocationInfo', null)
    if (response?.code == TigaGeneral.SUCCESS) {
      const res = {
        ...response?.data,
        errMsg: null,
      }
      return successHandler(option.success, option.complete)(res)
    } else {
      return errorHandler(
        option.fail,
        option.complete
      )({ errMsg: `getLocation fail, errorMsg: ${response?.reason}` })
    }
  } catch (error) {
    const res = { errMsg: `getLocation fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}
