import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as ShareType from './type'

async function share(
  option: ShareType.DirectShareOption | ShareType.DirectMotorcadeShareOption
): Promise<ShareType.ShareSuccessCallbackResult> {
  let { channel, shareTrack, context, success, fail, complete, ...shareMessage } = option
  try {
    if (channel === ShareType.ShareChannelType.Motorcade) {
      if (!isMotorcadeShare(option)) {
        return errorHandler(
          fail,
          complete
        )({
          code: ShareType.ShareErrorCodeEnum.ShareParamsInvalid,
          reason: `车队分享未传入pageUrl页面路由参数`,
        })
      } else {
        return shareToMotorcade(option)
      }
    }
    const { code, reason }: any = await TigaBridge.call(context, 'app.social.share', {
      shareChannel: channel,
      shareTrack,
      shareMessage,
    })
    if (code == TigaGeneral.SUCCESS) {
      let res: ShareType.ShareSuccessCallbackResult = { channel }
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)({ code, reason })
    }
  } catch (error) {
    return errorHandler(
      fail,
      complete
    )({ code: 1, reason: `share fail, error msg:  ${error.message}` })
  }
}

/** 端内车队分享： 当前通过native分享库跳转，待后续替换为直接调用路由bridge */
async function shareToMotorcade(
  option: ShareType.DirectMotorcadeShareOption
): Promise<ShareType.ShareSuccessCallbackResult> {
  let { channel, shareTrack, context, success, fail, complete, pageUrl } = option
  let shareMessage = {
    href: pageUrl,
    type: ShareType.ShareObjectType.WEB,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(context, 'app.social.share', {
      shareChannel: channel,
      shareTrack,
      shareMessage,
    })
    if (code == TigaGeneral.SUCCESS) {
      let res: ShareType.ShareSuccessCallbackResult = { channel }
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)({ code, reason })
    }
  } catch (error) {
    return errorHandler(
      fail,
      complete
    )({ code: 1, reason: `share fail, error msg:  ${error.message}` })
  }
}

/** 展示底部分享弹窗 */
async function showShareMenu(
  option: ShareType.ShowShareMenuOption
): Promise<ShareType.ShowShareMenuSuccessCallbackResult> {
  const { channels, shareTrack, title, previewImage, context, success, fail, complete } = option
  try {
    const showMenuResult = await TigaBridge.call(context, 'app.social.showShareMenu', {
      channels,
      previewImage,
      title,
      shareTrack,
    })

    enum ShowShareMenuResponseCode {
      Success = 0,
      ParamsInvalid = 1,
      NoShareChannel = 2,
      ShareMenuClosed = 3,
    }

    if (showMenuResult.code == TigaGeneral.SUCCESS) {
      let res: ShareType.ShowShareMenuSuccessCallbackResult = {
        selectedChannel: showMenuResult.data.channel,
      }
      return successHandler(success, complete)(res)
    } else if (showMenuResult.code == ShowShareMenuResponseCode.ParamsInvalid) {
      return errorHandler(
        fail,
        complete
      )({ code: ShareType.ShareErrorCodeEnum.ShareParamsInvalid, reason: showMenuResult.reason })
    } else if (showMenuResult.code == ShowShareMenuResponseCode.NoShareChannel) {
      return errorHandler(
        fail,
        complete
      )({
        code: ShareType.ShareErrorCodeEnum.ShareChannelsNotAvailable,
        reason: '未找到可用分享渠道',
      })
    } else if (showMenuResult.code == ShowShareMenuResponseCode.ShareMenuClosed) {
      return errorHandler(
        fail,
        complete
      )({ code: ShareType.ShareErrorCodeEnum.ShareCancel, reason: '分享菜单被取消' })
    } else {
      return errorHandler(
        fail,
        complete
      )({ code: ShareType.ShareErrorCodeEnum.ShareFail, reason: showMenuResult.reason })
    }
  } catch (error) {
    return errorHandler(
      fail,
      complete
    )({ code: 1, reason: `showShareMenu fail, error msg:  ${error.message}` })
  }
}

async function menuShare(
  option: ShareType.MenuShareOption
): Promise<ShareType.ShareSuccessCallbackResult> {
  const { channels, shareTrack, title, previewImage, context, success, fail, complete } = option
  let channelNames = Object.keys(channels) as ShareType.ShareChannelType[]
  try {
    const { selectedChannel } = await showShareMenu({
      channels: channelNames,
      shareTrack,
      title,
      previewImage,
      context,
    })
    return share({
      // 根据返回渠道调用分享
      context,
      channel: selectedChannel,
      shareTrack,
      ...channels[selectedChannel],
      success,
      fail,
      complete,
    })
  } catch (res) {
    return errorHandler(fail, complete)(res)
  }
}

async function getShareChannels(
  option: ShareType.GetShareChannelsOption
): Promise<ShareType.GetShareChannelsCallbackResult> {
  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.social.getShareChannels'
    )
    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(data)
    } else {
      return errorHandler(option.fail, option.complete)({ code, reason })
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `get share channels fail, error msg:  ${error.message}` })
  }
}

function isMotorcadeShare(
  option: ShareType.DirectShareOption | ShareType.DirectMotorcadeShareOption
): option is ShareType.DirectMotorcadeShareOption {
  return (option as ShareType.DirectMotorcadeShareOption).pageUrl !== undefined
}

export * from './type'
export { getShareChannels, menuShare, share, showShareMenu }
