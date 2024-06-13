import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
// import { App } from '@ymm/rn-lib'
import * as PropTypes from '../types'

export * from '../types'
// 添加自定义弹窗数据
const bridgeInsert = 'app.popup.insertData'
// 弹窗埋点
const bridgeTrack = 'app.popup.track'
// 弹窗结束事件
const bridgeFinish = 'app.popup.finish'
// 注册弹窗信息监听（单个）
const bridgeRegister = 'app.popup.registerDialogMonitor'
// 移除弹窗信息监听
const bridgeRemove = 'app.popup.removeDialogMonitor'
// 更新弹窗实例的请求参数
const bridgeUpdate = 'app.popup.updateDialogRequestParams'

// 监听对象实例
let popups: Array<Popup> = []

// 是否注册过弹窗通知，注册上以后不需要移除
let isRegisteredEvent = false

// 弹窗监听对象
class Popup {
  // 弹窗唯一标识
  dialogId: string
  show?: (data: PropTypes.ShowCallBack) => void

  constructor(dialogId: string, show?: (data: PropTypes.ShowCallBack) => void) {
    this.dialogId = dialogId
    this.show = show
  }
}

function registerEvent() {
  if (isRegisteredEvent) {
    console.log("事件总线已经注册过了")
    return
  }
  // 接受原生展示弹窗通知
  TigaGeneral.eventCenter.on('MBDialogNoticeMsg', (res) => {
    console.log('展示弹窗通知' + JSON.stringify(JSON.stringify(res)))
    if (!res) {
      return
    }
    const { dialogId, data, popupCode } = res
    if (dialogId) {
      const popup: Popup = findPopup(dialogId)
      if (popup != null) {
        const res: PropTypes.ShowCallBack = { popupCode: popupCode, data: data }
        popup.show(res)
      }
    }
  })

  // 接受原生展示弹窗通知, 移除弹窗储存对象
  TigaGeneral.eventCenter.on('MBDialogNoticeRemove', (res) => {
    console.log('移除弹窗通知' + JSON.stringify(JSON.stringify(res)))
    if (!res) {
      return
    }
    const { dialogId } = res
    if (dialogId) {
      console.log(`移除之前 count:${popups.length} 数组:${JSON.stringify(popups)} id:${dialogId}`)
      popups = popups.filter((popup) => {
        return popup.dialogId != dialogId
      })
      console.log(`移除之后 count:${popups.length} 数组:${JSON.stringify(popups)}`)
    }
  })

  // 标记注册事件
  isRegisteredEvent = true
}


function findPopup(id: string): Popup {
  let pop = null
  popups.forEach((popup) => {
    console.log(popup.dialogId)
    if (popup.dialogId == id) {
      pop = popup
    }
  })
  return pop
}

// isRegisterDialog 为 true 的情况下, show 才会回调
export const insertData = async (
  option: PropTypes.InsertProps
): Promise<TigaGeneral.CallbackResult> => {
  const params: PropTypes.InsertProps = {
    popupCode: option.popupCode,
    pageList: option.pageList,
    interfaceName: option.interfaceName,
    data: option.data,
    pageInfoList: option.pageInfoList,
    availableSeconds: option.availableSeconds,
  }

  try {
    const { code, reason }: any = await TigaBridge.call(option.context, bridgeInsert, params)
    if (code == TigaGeneral.SUCCESS) {
      if (option.isRegisterDialog) {
        try {
          const registerParams: PropTypes.RegisterProps = {
            interfaceName: option.interfaceName,
            pageList: option.pageList,
          }
          const response = await TigaBridge.call(option.context, bridgeRegister, registerParams)
          console.log(JSON.stringify(response))
          if (response?.code == TigaGeneral.SUCCESS) {
            const res = { code: TigaGeneral.SUCCESS, reason: reason, data: response?.data }
            return successHandler(option.success, option.complete)(res)
          } else {
            const res = {
              code: TigaGeneral.SUCCESS,
              reason: reason,
              data: { code: response?.code, reason: response?.reason },
            }
            return successHandler(option.success, option.complete)(res)
          }
        } catch (error) {
          const resData = {
            code: 1,
            reason: `registerDialogMonitor fail, error msg: ${error.message} `,
          }
          const res = { code: TigaGeneral.SUCCESS, reason: reason, data: resData }
          return successHandler(option.success, option.complete)(res)
        }
      } else {
        const res = { code: TigaGeneral.SUCCESS, reason: reason }
        return successHandler(option.success, option.complete)(res)
      }
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `insertData fail, error msg: ${error.message} ` })
  }
}

export const finish = async (
  option: PropTypes.FinishProps
): Promise<TigaGeneral.CallbackResult> => {
  const params: PropTypes.FinishProps = {
    popupCode: option.popupCode,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, bridgeFinish, params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `finish fail, error msg: ${error.message} ` })
  }
}

export const track = async (option: PropTypes.TrackProps): Promise<TigaGeneral.CallbackResult> => {
  const params: PropTypes.TrackProps = {
    type: option.type,
    popupCode: option.popupCode,
    otherParams: option.otherParams,
  }

  try {
    const { code, reason }: any = await TigaBridge.call(option.context, bridgeTrack, params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({
      code: 1,
      reason: `track fail, error msg: ${error.message} `,
    })
  }
}

export const registerDialogMonitor = async (
  option: PropTypes.RegisterProps
): Promise<PropTypes.RegisterDialogMonitorCallBack> => {
  const params: PropTypes.RegisterProps = {
    interfaceName: option.interfaceName,
    requestParams: option.requestParams,
    pageList: option.pageList,
  }
  // 注册原生通知
  registerEvent()
  try {
    const { code, reason, data } = await TigaBridge.call(option.context, bridgeRegister, params)
    if (code == TigaGeneral.SUCCESS) {
      const dialogId = data['dialogId']
      if (dialogId) {
        // 先取到 dialogId, 数据通过事件总线传过来
        const popup = new Popup(dialogId, option.show)
        popups = popups.concat(popup)
        console.log('添加弹窗对象' + JSON.stringify(popup) + `count: ${popups.length} `)
      }
      // test
      // const popup = new Popup(dialogId, option.show)
      // popups.concat(popup)
      return successHandler(option.success, option.complete)(data)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.success, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({
      code: 1,
      reason: `registerDialogMonitor fail, error msg: ${error.message}`,
    })
  }
}

export const removeDialogMonitor = async (
  option: PropTypes.RemoveProps
): Promise<TigaGeneral.CallbackResult> => {
  const params: PropTypes.RemoveProps = {
    dialogId: option.dialogId,
    pageList: option.pageList,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, bridgeRemove, params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({
      code: 1,
      reason: `removeDialogMonitor fail, error msg: ${error.message}`,
    })
  }
}

export const updateDialogRequestParams = async (
  option: PropTypes.UpdateProps
): Promise<TigaGeneral.CallbackResult> => {
  const params: PropTypes.UpdateProps = {
    dialogId: option.dialogId,
    requestParams: option.requestParams,
    page: option.page,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, bridgeUpdate, params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({
      code: 1,
      reason: `updateDialogRequestParams fail, error msg: ${error.message}`,
    })
  }
}
