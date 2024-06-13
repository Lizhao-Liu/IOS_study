import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as Push from './type'
import * as Cache from './pushCache'

async function registerPush(option: Push.MBPushHandleOption): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.notificationType) {
    failRes.code = 1
    failRes.reason = '缺少参数'
    return errorHandler(fail, complete)(failRes)
  }
  const params = {
    notificationType: option.notificationType,
    consumeMode: option.consumeMode,
  }

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.registerPush', params)
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    // 监听push消息成功，加入缓存
    const listener = new Cache.PushListener(
      option.notificationType,
      option.consumeMode,
      option.didReceivePushMessage,
      option.didDequeuePushMessage
    )
    // const listener: Cache.PushListener = {
    //   notificationType: option.notificationType,
    //   useMode: option.consumeMode,
    //   receiveCallback: option.didReceivePushMessage,
    //   dequeueCallback: option.didDequeuePushMessage
    // }
    console.log(
      '缓存notificationType: ',
      option.notificationType,
      ', receiveCallback:',
      option.didReceivePushMessage,
      ', dequeueCallback:',
      option.didDequeuePushMessage
    )
    Cache.pushCache.setCache(listener, option.notificationType)

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function removePushListen(
  option: Push.MBPushRemoveListenOption
): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.notificationType) {
    failRes.code = 1
    failRes.reason = '缺少参数'
    return errorHandler(fail, complete)(failRes)
  }

  const params = {
    notificationType: option.notificationType,
  }

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.removePushListen', params)
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    Cache.pushCache.removeListener(option.notificationType)

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function pushConsume(option: Push.MBPushConsumeOption): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.notifiable) {
    failRes.code = 1
    failRes.reason = '缺少参数notifiable'
    return errorHandler(fail, complete)(failRes)
  }

  if (!option.notifiable.pushId) {
    failRes.code = 1
    failRes.reason = '缺少参数 notifiable.pushId'
    return errorHandler(fail, complete)(failRes)
  }

  if (!option.notifiable.notificationType) {
    failRes.code = 1
    failRes.reason = '缺少参数 notifiable.notificationType'
    return errorHandler(fail, complete)(failRes)
  }

  if (
    option.enableNotifiable === null ||
    option.enableNotifiable === undefined ||
    option.enableNotifiable
  ) {
    if (!option.notifiable.title || !option.notifiable.message) {
      failRes.code = 1
      failRes.reason = '缺少参数通知title或message'
      return errorHandler(fail, complete)(failRes)
    }
  }

  const notifiable = option.notifiable
  let banner = null
  if (
    option.enableNotifiable === null ||
    option.enableNotifiable === undefined ||
    option.enableNotifiable
  ) {
    banner = {
      title: notifiable.title,
      message: notifiable.message,
      view: notifiable.view,
      roule: notifiable.roule,
    }
  }

  let audio = null
  if (
    (option.enableAudio === null || option.enableAudio === undefined || option.enableAudio) &&
    option.notifiable
  ) {
    if (Array.isArray(notifiable.sound)) {
      audio = {
        soundSeg: notifiable.sound,
      }
    } else if (notifiable.sound && notifiable.sound.startsWith('tts://')) {
      const realSound = notifiable.sound.slice(6)
      audio = {
        speech: realSound,
      }
    } else if (notifiable.sound) {
      audio = {
        soundUrl: notifiable.sound,
      }
    }
  }

  let params: { [key: string]: any } = {
    pushId: option.notifiable.pushId,
    notificationType: option.notifiable.notificationType,
  }
  if (option.notifiable.utmCampaign) {
    params['utmCampaign'] = option.notifiable.utmCampaign
  }
  if (option.notifiable.report) {
    params['report'] = option.notifiable.report
  }
  if (banner != null && audio != null) {
    params['notifiable'] = banner
    params['audio'] = audio
  } else if (banner != null && audio === null) {
    params['notifiable'] = banner
  } else if (banner === null && audio != null) {
    params['audio'] = audio
  }

  console.log('push consume content: ', params)
  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.consumePush', params)
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function pushQuit(option: Push.MBPushFinishOption): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.pushId) {
    failRes.code = 1
    failRes.reason = '缺少参数'
    return errorHandler(fail, complete)(failRes)
  }

  const params = {
    pushId: option.pushId,
  }

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.pushQuit', params)
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function showSystemNotification(
  option: Push.MBNotificationOption
): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.notification) {
    failRes.code = 1
    failRes.reason = '缺少参数通知相关参数'
    return errorHandler(fail, complete)(failRes)
  }

  if (!option.notification.pushId || !option.notification.notificationType) {
    failRes.code = 1
    failRes.reason = '缺少参数pushId或notificationType'
    return errorHandler(fail, complete)(failRes)
  }

  if (!option.notification.title || !option.notification.message) {
    failRes.code = 1
    failRes.reason = '缺少参数通知title或message'
    return errorHandler(fail, complete)(failRes)
  }

  const notifiable = option.notification
  const banner = {
    title: notifiable.title,
    message: notifiable.message,
    view: notifiable.view,
  }

  let params: { [key: string]: any } = {
    pushId: notifiable.pushId,
    notificationType: notifiable.notificationType,
  }

  params['notifiable'] = banner

  if (notifiable.utmCampaign) {
    params['utmCampaign'] = notifiable.utmCampaign
  }
  if (notifiable.report) {
    params['report'] = notifiable.report
  }

  let audio = null
  if (Array.isArray(notifiable.sound)) {
    audio = {
      soundSeg: notifiable.sound,
    }
  } else if (notifiable.sound && notifiable.sound.startsWith('tts://')) {
    const realSound = notifiable.sound.slice(6)
    audio = {
      speech: realSound,
    }
  } else if (notifiable.sound) {
    audio = {
      soundUrl: notifiable.sound,
    }
  }

  if (audio && audio != null) {
    params['audio'] = audio
  }

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.notification', params)
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function pausePush(option: Push.MBPausePushOption): Promise<Push.MBPausePushResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  const params = {}

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.pausePush', params)
    const { code, reason, data } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: Push.MBPausePushResult = {
      token: data.token,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

async function resumePush(option: Push.MBResumePushOption): Promise<TigaGeneral.CallbackResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  if (!option.token) {
    failRes.code = 1
    failRes.reason = '缺少参数'
    return errorHandler(fail, complete)(failRes)
  }

  const params = {
    token: option.token,
  }

  try {
    const bridgeResult = await TigaBridge.call(option.context, 'app.push.resumePush', params)
    const { code, reason } = bridgeResult || {}
    failRes.code = code
    failRes.reason = reason
    if (code !== 0) throw new Error()

    const res: TigaGeneral.CallbackResult = {
      ...bridgeResult,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

export {
  registerPush,
  removePushListen,
  pushConsume,
  pushQuit,
  pausePush,
  resumePush,
  showSystemNotification,
}
