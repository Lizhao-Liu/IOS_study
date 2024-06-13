import {
  PermissionStatus,
  Permissions,
  checkPermission,
  requestPermission,
} from '@fta/tiga-permission'
import { getSystemInfoAsync } from '../getSystemInfoAsync'
import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function isAndroid(context: any): Promise<boolean> {
  try {
    const res: Taro.getSystemInfoAsync.Result = await getSystemInfoAsync({ context })
    return Promise.resolve(res?.platform === 'android')
  } catch (error) {}
  return Promise.resolve(false)
}

export async function chooseContact(
  option: Taro.chooseContact.Option
): Promise<Taro.chooseContact.SuccessCallbackResult> {
  if (await isAndroid(option.context)) {
    // 安卓需要权限,ios 不需要
    const isHavePermission = await isHaveContactPermission(option)
    if (!isHavePermission) {
      const { status } = await requestPermission({
        context: option?.context,
        permission: Permissions.contacts,
        rationale: option?.rationale,
        topHint: option?.topHint,
      })
      if (status != PermissionStatus.granted) {
        // 请求之后依然无权限直接返回
        const res = { errMsg: `chooseContact fail, error msg: 无权限` }
        return errorHandler(option.fail, option.complete)(res)
      }
    }
  }

  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.base.chooseContact',
      null
    )
    if (code == TigaGeneral.SUCCESS) {
      if (await isAndroid(option.context)) {
        if (!data) {
          const res = { errMsg: `chooseContact fail, error msg: 用户取消` }
          return errorHandler(option.fail, option.complete)(res)
        }
      }
      const { phoneNumber, nickName, name, phoneNumberList } = data
      const res: Taro.chooseContact.SuccessCallbackResult = {
        phoneNumber: phoneNumber,
        displayName: nickName ? nickName : name,
        phoneNumberList: phoneNumberList,
        errMsg: null,
      }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { errMsg: `chooseContact fail, error msg: ${reason}` }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ errMsg: `chooseContact fail, error msg: ${error.message}` })
  }
}

async function isHaveContactPermission(option: TigaGeneral.Option<any>): Promise<Boolean> {
  try {
    const { status } = await checkPermission({
      context: option.context,
      permission: Permissions.contacts,
    })
    return status == 1
  } catch (error) {
    return true
  }
}
