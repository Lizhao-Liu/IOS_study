import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

async function showShareImageMenu(
  options: Partial<Taro.showShareImageMenu.Option> = {}
): Promise<TaroGeneral.CallbackResult> {
  const { success, fail, complete, context, path } = options || {}
  const shareImage = {
    imageUrl: path,
    type: 1,
  }
  const channels = {
    saveImage: shareImage,
    wechatSession: shareImage,
    wechatTimeline: shareImage,
    qq: shareImage,
    qzone: shareImage,
  }

  try {
    const showMenuResult = await TigaBridge.call(context, 'app.social.showShareMenu', {
      channels: Object.keys(channels),
      previewImage: path,
    })
    if (showMenuResult.code !== TigaGeneral.SUCCESS) {
      return errorHandler(
        fail,
        complete
      )({ errMsg: 'showShareImageMenu:fail ' + showMenuResult.reason })
    } else {
      const selectedChannel = showMenuResult.data?.channel
      const { code, reason }: any = await TigaBridge.call(context, 'app.social.share', {
        shareChannel: selectedChannel,
        shareMessage: channels[selectedChannel],
      })
      if (code == TigaGeneral.SUCCESS) {
        return successHandler(success, complete)({ errMsg: 'showShareImageMenu:ok' })
      } else {
        return errorHandler(fail, complete)({ errMsg: 'showShareImageMenu:fail ' + reason })
      }
    }
  } catch (e) {
    return errorHandler(fail, complete)({ errMsg: 'showShareImageMenu:fail' })
  }
}

export { showShareImageMenu }
