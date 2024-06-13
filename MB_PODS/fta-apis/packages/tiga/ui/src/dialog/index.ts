import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as UI from '../../types/tiga-ui'
import { shouldBeObject } from '../paramsChecker'

const defaultMainButtonColor = '#576B95'
const defaultButtonColor = '#000000'
const unknownErrorCode = 99
const paramsErrorCode = 1

async function showDialog(
  options: UI.DialogOption | UI.StatusDialogOption,
  dialogType: 'Info' | 'Status'
): Promise<UI.DialogSuccessCallbackResult> {
  // 参数校验
  const isObject = shouldBeObject(options)
  if (!isObject.res) {
    const res = { reason: `show${dialogType}Dialog${isObject.msg}`, code: paramsErrorCode }
    console.error(res.reason)
    return Promise.reject(res)
  }

  // 参数解析
  const {
    title,
    content,
    contentStyle,
    buttons,
    buttonOrientation,
    showCloseBtn,
    canceledOnTouchOutside,
    success,
    fail,
    complete,
    context,
    statusIcon,
    mask
  } = parseParams(options)

  // bridge调用
  try {
    const bridgeResult = await TigaBridge.call(context, 'app.ui.showDialog', {
      title,
      buttons,
      buttonOrientation,
      statusIcon: dialogType === 'Status' ? statusIcon : undefined,
      content: {
        contentText: content,
        ...contentStyle,
      },
      mask,
      showCloseBtn,
      canceledOnTouchOutside,
    })
    const { code, reason, data } = bridgeResult || {}
    if (code !== TigaGeneral.SUCCESS) {
      return errorHandler(fail, complete)({ code, reason })
    }
    return successHandler(success, complete)(parseResult(data))
  } catch (e) {
    let res = { code: unknownErrorCode, reason: `show${dialogType}Dialog:fail`, data: {} }
    return errorHandler(fail, complete)(res)
  }
}

const showInfoDialog = (options: UI.DialogOption) => showDialog(options, 'Info')
const showStatusDialog = (options: UI.StatusDialogOption) => showDialog(options, 'Status')

function parseResult(data: any): any {
  let successResult = { dismissed: false, index: 0 }
  if (data.index == -1) {
    successResult.dismissed = true
    delete successResult['index']
  } else {
    successResult.dismissed = false
    successResult.index = data.index
  }
  return successResult
}

function parseParams(options: UI.DialogOption & UI.StatusDialogOption): any {
  let {
    title,
    statusIcon,
    content,
    contentStyle = {},
    buttons = [
      {
        text: '确定', // 默认确定按钮文字
      },
    ],
    buttonOrientation,
    mask,
    showCloseBtn = false,
    canceledOnTouchOutside = false,
    success,
    fail,
    complete,
    context,
  } = options || {}

  // 弹窗默认内容样式
  contentStyle = Object.assign(
    {
      contentColor: '#666666',
      contentAlignment: UI.DialogContentAlignment.Center,
      maxLinesOfContent: 3,
    },
    contentStyle
  )

  // 按钮默认排列方向
  if (typeof buttonOrientation == 'undefined') {
    if (buttons.length <= 2) {
      buttonOrientation = UI.DialogButtonOrientation.Horizontal // 横向
    } else {
      buttonOrientation = UI.DialogButtonOrientation.Vertical // 竖向
    }
  }

  // 按钮默认颜色
  if (buttons.length == 1) {
    buttons[0].color = buttons[0].color || defaultMainButtonColor
  }
  if (buttonOrientation == UI.DialogButtonOrientation.Horizontal) {
    for (let index = 0; index < buttons.length; index++) {
      const element = buttons[index]
      if (index == 0) {
        element.color = element.color || defaultButtonColor
        continue
      }
      element.color = element.color || defaultMainButtonColor
    }
  } else {
    for (let index = 0; index < buttons.length; index++) {
      const element = buttons[index]
      if (index != buttons.length - 1) {
        element.color = element.color || defaultMainButtonColor
        continue
      }
      element.color = element.color || defaultButtonColor
    }
  }

  return {
    title,
    statusIcon,
    content,
    contentStyle,
    buttons,
    buttonOrientation,
    showCloseBtn,
    canceledOnTouchOutside,
    success,
    complete,
    fail,
    context,
    mask
  }
}

export * from '../../types/tiga-ui'
export { showInfoDialog, showStatusDialog }

