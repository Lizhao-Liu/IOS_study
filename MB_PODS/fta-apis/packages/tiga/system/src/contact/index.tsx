import {
  PermissionStatus,
  Permissions,
  checkPermission,
  requestPermission,
} from '@fta/tiga-permission'
import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { ContactResult, ContactsProps, ContactsResult } from './PropTypes'

export async function getAllContacts(option: ContactsProps): Promise<ContactsResult> {
  const isHavePermission = await isHaveContactPermission(option)
  if (!isHavePermission) {
    if (option.permissionRequest) {
      try {
        const { status } = await requestPermission({
          context: option?.context,
          permission: Permissions.contacts,
          rationale: option?.rationale,
          topHint: option?.topHint,
        })
        if (status != PermissionStatus.granted) {
          // 请求之后依然无权限直接返回
          return errorHandler(option.fail, option.complete)({ code: 2, reason: '无权限' })
        }
      } catch (error) {
        return errorHandler(option.fail, option.complete)({ code: 1, reason: '请求权限失败' })
      }
    } else {
      return errorHandler(option.fail, option.complete)({ code: 2, reason: '无权限' })
    }
  }

  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.base.getAllContacts',
      null
    )
    if (code == TigaGeneral.SUCCESS) {
      let listArray = []
      data?.forEach((element) => {
        const { nickName, name, phoneNumberList } = element
        const contact: ContactResult = {
          nickName: nickName ? nickName : name,
          phoneNumberList: phoneNumberList,
        }
        listArray = listArray.concat(contact)
      })
      const res: ContactsResult = { list: listArray }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `getAllContacts fail, error msg: ${error.message}` })
  }
}

export async function isHaveContactPermission(option: TigaGeneral.Option<any>): Promise<Boolean> {
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

export * from './PropTypes'
