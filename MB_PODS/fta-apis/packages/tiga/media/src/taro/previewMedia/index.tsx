import { TigaGeneral, TigaBridge, successHandler, errorHandler, uuid } from '@fta/tiga-util'
import Taro from '@tarojs/taro'

export async function previewMedia(
  opts: Taro.previewMedia.Option
): Promise<TaroGeneral.CallbackResult> {
  const { sources, menus, current, showmenu, context, success, fail, complete } = opts
  try {
    const files = sources?.map((src: Taro.previewMedia.Sources) => {
      return {
        filePath: src.url,
        fileType: src.type ?? 'image',
        videoPoster: src.poster,
        description: src.description,
      }
    })
    const previewId = uuid()
    const params = {
      previewId: previewId,
      sources: files,
      menus: menus,
      current: current,
      showSaveToAlbum: showmenu ? 1 : 0,
    }
    const response = await TigaBridge.call(context, 'app.media.preview', params)
    if (response?.code == TigaGeneral.SUCCESS) {
      setOnMenuClickListener(previewId, menus, opts.onMenuClick)
      const res = { errMsg: null }
      return successHandler(success, complete)(res)
    } else {
      const res = { errMsg: `previewMedia: fail, errorMsg: ${response?.reason}` }
      return errorHandler(fail, complete)(res)
    }
  } catch (e) {
    const res = { errMsg: `previewMedia: fail, errorMsg: ${e.message}` }
    return errorHandler(fail, complete)(res)
  }
}

interface Source {
  filePath: string
  fileType: string
  videoPoster: string
  description: string
}
interface PreviewFinishedEventData {
  previewId: string
}
interface OnMenuItemClickEventData extends PreviewFinishedEventData {
  menuId: string
  source: Source
}

function setOnMenuClickListener(
  previewId: string,
  menus: Taro.previewMedia.Menu[],
  onMenuClick: (menuId: string, source: Taro.previewMedia.Sources) => void
) {
  if (!menus || menus.length == 0 || !onMenuClick) {
    return
  }

  const onMenuItemClickEventListener = (eventData: OnMenuItemClickEventData) => {
    if (previewId !== eventData?.previewId) {
      return
    }
    const source: Taro.previewMedia.Sources = {
      url: eventData?.source?.filePath,
      type: eventData?.source?.fileType as 'image' | 'video',
      poster: eventData?.source?.videoPoster,
      description: eventData?.source?.description,
    }
    onMenuClick && onMenuClick(eventData?.menuId, source)
  }
  TigaGeneral.eventCenter.on(
    TigaGeneral.MBEVENT_MEDIA_PREVIEW_MENU_ITEM_CLICK,
    onMenuItemClickEventListener
  )

  const onPreviewFinishedListener = (eventData: PreviewFinishedEventData) => {
    if (previewId !== eventData?.previewId) {
      return
    }
    TigaGeneral.eventCenter.off(
      TigaGeneral.MBEVENT_MEDIA_PREVIEW_MENU_ITEM_CLICK,
      onMenuItemClickEventListener
    )
    TigaGeneral.eventCenter.off(
      TigaGeneral.MBEVENT_MEDIA_PREVIEW_FINISHED,
      onPreviewFinishedListener
    )
  }
  TigaGeneral.eventCenter.on(TigaGeneral.MBEVENT_MEDIA_PREVIEW_FINISHED, onPreviewFinishedListener)
}
