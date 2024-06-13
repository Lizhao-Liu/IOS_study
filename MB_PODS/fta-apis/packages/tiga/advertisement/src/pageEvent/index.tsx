import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { CloseProps, InVisibleProps, PageLifeProps, TapProps, VisibleProps } from '..//propTypes'

// 广告所在页面显示
async function pageAppear(option: PageLifeProps): Promise<TigaGeneral.CallbackResult> {
  const params: PageLifeProps = {
    pageSession: option.pageSession,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(option.context, 'app.ad.pageAppear', params)
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `pageAppear fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 广告所在视图可见
async function visibleOnPage(option: VisibleProps): Promise<TigaGeneral.CallbackResult> {
  const params: VisibleProps = {
    pageSession: option.pageSession,
    adviewType: option.adviewType,
    adModel: option.adModel,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.ad.visibleWithPage',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `visibleOnPage fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 广告所在视图不可见
async function invisibleOnPage(option: InVisibleProps): Promise<TigaGeneral.CallbackResult> {
  const params: InVisibleProps = {
    pageSession: option.pageSession,
    advertId: option.advertId,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.ad.invisibleWithPage',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `invisibleOnPage fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 广告所在页面离开
async function pageDisappear(option: PageLifeProps): Promise<TigaGeneral.CallbackResult> {
  const params: PageLifeProps = {
    pageSession: option.pageSession,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.ad.pageDisappear',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `pageDisappear fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 广告所在页面销毁
async function pageDestroy(option: PageLifeProps): Promise<TigaGeneral.CallbackResult> {
  const params: PageLifeProps = {
    pageSession: option.pageSession,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.ad.pageDestroy',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `pageDestroy fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 点击广告 - 绑定页面
async function tapWithPage(option: TapProps): Promise<TigaGeneral.CallbackResult> {
  const params: TapProps = {
    pageSession: option.pageSession,
    advertId: option.advertId,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.ad.tapWithPage',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `tapWithPage fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

// 关闭广告 - 绑定页面
async function closeWithPage(option: CloseProps): Promise<TigaGeneral.CallbackResult> {
  const params: CloseProps = {
    pageSession: option.pageSession,
    advertIds: option.advertIds,
  }
  try {
    const { code, reason }: any = await TigaBridge.call(
      option.context,
      'app.ad.closeWithPage',
      params
    )
    if (code == TigaGeneral.SUCCESS) {
      const res = { code: TigaGeneral.SUCCESS, reason: reason }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res = { code: code, reason: reason }
      return errorHandler(option.fail, option.complete)(res)
    }
  } catch (error) {
    const res = { code: 1, reason: `closeWithPage fail, errorMsg: ${error.message}` }
    return errorHandler(option.fail, option.complete)(res)
  }
}

export {
  closeWithPage,
  invisibleOnPage,
  pageAppear,
  pageDestroy,
  pageDisappear,
  tapWithPage,
  visibleOnPage,
}
