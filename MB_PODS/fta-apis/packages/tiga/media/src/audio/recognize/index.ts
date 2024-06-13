import {
  PermissionStatus,
  Permissions,
  checkPermission,
  requestPermission,
} from '@fta/tiga-permission'
import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { RecognizeOption, VoiceRecognizeCallBack, VoiceRecognizeResult } from './audioTypes'

let eventId: string

export async function startVoiceRecognize(
  option: RecognizeOption
): Promise<TigaGeneral.CallbackResult> {
  const isHavePermission = await isHaveMicrophonePermission(option)
  // 无权限情况
  if (!isHavePermission) {
    if (option.permissionRequest) {
      const { status } = await requestPermission({
        context: option?.context,
        permission: Permissions.microphone,
        rationale: option?.rationale,
        topHint: option?.topHint,
      })
      if (status != PermissionStatus.granted) {
        // 请求之后依然无权限直接返回
        return errorHandler(option.fail, option.complete)({ code: 2, reason: '无权限' })
      }
    } else {
      // 无权限，也不要求请求权限
      return errorHandler(option.fail, option.complete)({ code: 2, reason: '无权限' })
    }
  }

  const params: RecognizeOption = {
    maxTime: option.maxTime ? option.maxTime : 60,
    fileName: option.fileName,
    afterOverTime: option.afterOverTime ? option.afterOverTime : 60,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.audio.startRecognize',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const events: TigaGeneral.Events = TigaGeneral.getEvents(option.context)

      eventId = events.on('MBVoiceRecognizeContent', async (res) => {
        console.log(`语音识别状态通知  res:  ${JSON.stringify(res)}`)

        if (!res) {
          return
        }
        const { code } = res

        // 收到这几种场景,需要手动停止监听 https://devstatic.amh-group.com/fta-tiga-demo/#/components/tiga/media#startvoicerecognize
        if (code == 1 || code == 12 || code == 20 || code == 21) {
          console.log(`取消语音识别监听  res:  ${eventId}`)
          events.off('MBVoiceRecognizeContent', eventId)
        }
        if (option.callBack) {
          option.callBack(res)
        }
      })
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      return errorHandler(option.fail, option.complete)({ code: code, reason: reason })
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `startVoiceRecognize fail, error msg: ${error.message}` })
  }
}

export async function stopVoiceRecognize(
  option: TigaGeneral.Option<TigaGeneral.CallbackResult>
): Promise<TigaGeneral.CallbackResult> {
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.audio.stopRecognize',
      null
    )
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
    )({ code: 1, reason: `stopVoiceRecognize fail, error msg: ${error.message}` })
  }
}

export async function cancelVoiceRecognize(
  option: TigaGeneral.Option<TigaGeneral.CallbackResult>
): Promise<TigaGeneral.CallbackResult> {
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.audio.cancelRecognize',
      null
    )
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
    )({ code: 1, reason: `stopVoiceRecognize fail, error msg: ${error.message}` })
  }
}

async function isHaveMicrophonePermission(option: TigaGeneral.Option<any>): Promise<Boolean> {
  try {
    const { status } = await checkPermission({
      context: option.context,
      permission: Permissions.microphone,
    })
    return status == 1
  } catch (error) {
    return true
  }
}

export { RecognizeOption, VoiceRecognizeCallBack, VoiceRecognizeResult }
