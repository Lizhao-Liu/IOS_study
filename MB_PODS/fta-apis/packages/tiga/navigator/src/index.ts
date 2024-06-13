import { TigaBridge, TigaGeneral } from '@fta/tiga-util'
import { simplify } from './amhRouters'
import { Bridges } from './bridges'
import { getNavigator } from './navigator'
import { isLocalUrl, isSameEnv, parseGlobalUrl } from './urls'
import { withCallback } from './util/callbacks'
import { nonNullContext } from './util/contexts'

export * from './pageChangeListener'
export { SCHEME_MICRO, SCHEME_THIS, SCHEME_THRESH } from './urlConstants'

export const FLAG_NEW_CONTAINER = 0x01
export const FLAG_KEEP_CONTAINER = 0x02
export const FLAG_CLEAR_TOP = 0x10

export const ANIM_DEFAULT = 0x00
export const ANIM_NONE = -1

export const STYLE_DEFAULT = 0x00
export const STYLE_PUSH_FIRST = 0x01
export const STYLE_NO_ANIM = 0x10

export declare namespace push {
  interface Option extends navigate.PushOption, TigaGeneral.Option<TigaGeneral.CallbackResult> {
    onResult?: (resultData: any) => void
  }
}

export declare namespace pop {
  interface Option extends navigate.PopOption, TigaGeneral.Option<TigaGeneral.CallbackResult> { }
}

export declare namespace popUntil {
  interface Option
    extends navigate.PopUntilOption,
    TigaGeneral.Option<TigaGeneral.CallbackResult> { }
}

export declare namespace navigate {
  interface Option extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
    push?: PushOption
    pop?: PopOption
    popUntil?: PopUntilOption
    /** 可选样式，详见前缀为 STYLE_ 常量 */
    style?: number
  }

  interface PushOption {
    /** 目标页，要求标准 URL 格式。详见 URL 协议 */
    url: string | URL
    /** 可选标记，多标记组合可使用位运算符 “|” */
    flag?: number
    /** 可选动效，详见前缀为 ANIM_ 常量 */
    anim?: number
  }

  interface PopOption {
    /** 回退的页面数。若大于实际页面数，则回到当前栈的首页。 */
    delta?: number
  }

  interface PopUntilOption {
    /** 回调函数。判断新的栈顶页 URL 是否符合条件可停止回退。 */
    predicate: (url: string) => boolean
  }
}

export declare namespace setResult {
  interface Option extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
    resultData: any
  }
}

export declare namespace getAppPages {
  // interface Option extends TigaGeneral.Option<CallbackResult> { }

  interface CallbackResult extends TigaGeneral.CallbackResult {
    pages: string[]
  }
}

export function push(option: push.Option): Promise<TigaGeneral.CallbackResult> {
  return withCallback(doPush(option), option)
}

function doPush(option: push.Option): Promise<TigaGeneral.CallbackResult> {
  console.log('push called', option)
  if (option.flag && (option.flag & FLAG_CLEAR_TOP) == FLAG_CLEAR_TOP) {
    return backOrPush(option)
  } else if (shouldKeepContainerWhenPush(option)) {
    return pushKeepingContainer(option)
  } else {
    return pushRemote(option)
  }
}

function shouldKeepContainerWhenPush(option: navigate.PushOption) {
  if (!isLocalUrl(option.url) && !isSameEnv(option.url)) {
    return false
  } else if (option.flag && (option.flag & FLAG_KEEP_CONTAINER) == FLAG_KEEP_CONTAINER) {
    return true
  } else if (option.flag && (option.flag & FLAG_NEW_CONTAINER) == FLAG_NEW_CONTAINER) {
    return false
  } else {
    return process.env.TARO_ENV_RUNTIME !== 'thresh'
  }
}

function pushKeepingContainer(option: push.Option) {
  const pushingUrl = typeof option.url === 'string' ? new URL(option.url) : option.url
  const context = nonNullContext(option.context)
  getNavigator(context).page(context).push(pushingUrl, option.onResult)
  return Promise.resolve({ code: 0, reason: 'push:ok' })
}

function pushRemote(option: push.Option): Promise<TigaGeneral.CallbackResult> {
  const context = nonNullContext(option.context)
  return Bridges.push(option.url, context)
    .then((requestId) => {
      if (option.onResult) {
        getNavigator(context).page(context).setListenerForResult(requestId, option.onResult)
      }
      return { code: 0, reason: 'push:ok' }
    })
    .catch((err) => {
      throw { code: 10, reason: 'push:fail:' + err.reason }
    })
}

function backOrPush(option: push.Option): Promise<TigaGeneral.CallbackResult> {
  const { context, url } = option
  return doGetAppPages({ context })
    .then(({ pages }) => {
      let delta = 0
      const pageSize = pages.length
      let found = false
      for (; pageSize - 1 - delta >= 0; delta++) {
        const page = pages[pageSize - 1 - delta]
        if (matches(page, url)) {
          found = true
          break
        }
      }
      if (found) {
        return doPop({ delta, context })
      } else {
        return doPush({ url, flag: option.flag & ~FLAG_CLEAR_TOP, context })
      }
    })
    .then((_res) => ({ code: 0, reason: 'push:ok' }))
    .catch((error) => {
      console.error('backOrPush', error)
      throw { code: error.code, reason: 'push:fail:' + error.reason }
    })
}

function matches(historyUrl: string, givenUrl: string | URL): boolean {
  const g = simplify(typeof givenUrl === 'string' ? new URL(givenUrl) : givenUrl)
  const h = new URL(historyUrl)
  console.log('matches1', g.toString(), h.toString())
  let res = g.protocol == h.protocol && g.host == h.host && g.pathname == h.pathname
  if (!res) {
    return false
  }
  g.searchParams.forEach((value, key, _parent) => {
    if (h.searchParams.get(key) != value) {
      res = false
    }
  })
  return res
}

export function pop(option: pop.Option): Promise<TigaGeneral.CallbackResult> {
  return withCallback(doPop(option), option)
}

function doPop(option: pop.Option): Promise<TigaGeneral.CallbackResult> {
  const delta = option.delta ? option.delta : 1
  if (getNavigator(nonNullContext(option.context)).getHistorySize() > delta) {
    return popKeepingContainer(option)
  } else {
    return popRemote(option)
  }
}

function popKeepingContainer(option: pop.Option) {
  return new Promise((resolve, _) => {
    const context = nonNullContext(option.context)
    getNavigator(context).page(context).pop(option.delta)
    resolve({ code: 0, reason: 'pop:ok' })
  })
}

function popRemote(option: pop.Option) {
  return new Promise((resolve, reject) => {
    getNavigator(nonNullContext(option.context)).release()
    const params = {
      pop: {
        delta: option.delta ? option.delta : 1,
      },
    }
    TigaBridge.call(nonNullContext(option.context), 'app.navigator.navigate', params)
      .then((response) => {
        if (response.code == 0) {
          resolve({ code: 0, reason: 'pop:ok' })
        } else {
          reject({ code: 10, reason: 'pop:fail:' + response.reason })
        }
      })
      .catch((err) => {
        reject({ code: 1, reason: 'pop:fail:' + err.message })
      })
  })
}

export function popUntil(option: popUntil.Option): Promise<TigaGeneral.CallbackResult> {
  return withCallback(doPopUntil(option), option)
}

function doPopUntil(option: popUntil.Option): Promise<TigaGeneral.CallbackResult> {
  const { context, predicate } = option
  return doGetAppPages({ context })
    .then(({ pages }) => {
      let delta = 0
      const pageSize = pages.length
      for (; pageSize - 1 - delta >= 0; delta++) {
        const page = pages[pageSize - 1 - delta]
        if (predicate(page)) {
          break
        }
      }
      return doPop({ delta, context })
    })
    .then((_res) => ({ code: 0, reason: `popUntil:ok` }))
    .catch((err) => {
      throw { code: err.code, reason: `popUntil:fail:${err.reason}` }
    })
}

export function navigate(option: navigate.Option): Promise<TigaGeneral.CallbackResult> {
  const { context, pop, popUntil, push } = option
  let promise: Promise<TigaGeneral.CallbackResult>
  if (pop && push) {
    promise = popAndPush(option)
  } else if (popUntil && push) {
    promise = popUntilAndPush(option)
  } else if (push) {
    promise = doPush({ ...push, context })
  } else if (pop) {
    promise = doPop({ ...pop, context })
  } else if (popUntil) {
    promise = doPopUntil({ ...popUntil, context })
  } else {
    promise = Promise.reject({ code: 2, reason: 'navigate:fail:invalid option' })
  }
  return withCallback(promise, option)
}

function popUntilAndPush(option: navigate.Option): Promise<TigaGeneral.CallbackResult> {
  const { context } = option
  const { predicate } = option.popUntil
  return doGetAppPages({ context }).then(({ pages }) => {
    let delta = 0
    const pageSize = pages.length
    for (; pageSize - 1 - delta >= 0; delta++) {
      const page = pages[pageSize - 1 - delta]
      if (predicate(page)) {
        break
      }
    }
    return popAndPush({ pop: { delta }, context })
  })
}

function popAndPush(option: navigate.Option): Promise<TigaGeneral.CallbackResult> {
  const keepContainerWhenPush = shouldKeepContainerWhenPush(option.push)
  const delta = option.pop.delta ? option.pop.delta : 1
  const pageSizeInCurrentContainer = getNavigator(nonNullContext(option.context)).getHistorySize()
  if (keepContainerWhenPush && delta <= pageSizeInCurrentContainer) {
    return popAndPushKeepingContainer(option)
  } else if (!keepContainerWhenPush && delta < pageSizeInCurrentContainer) {
    return popLocalAndPushRemote(option)
  } else {
    return popAndPushRemote(option)
  }
}

function popAndPushKeepingContainer(option: navigate.Option) {
  const pushingUrl =
    typeof option.push.url === 'string' ? new URL(option.push.url) : option.push.url
  const delta = option.pop.delta ? option.pop.delta : 1
  const context = nonNullContext(option.context)
  getNavigator(context).page(context).popAndPush(pushingUrl, delta)
  return Promise.resolve({ code: 0, reason: 'navigate:ok' })
}

function popLocalAndPushRemote(option: navigate.Option) {
  return new Promise((resolve, reject) => {
    const delta = option.pop.delta ? option.pop.delta : 1
    const context = nonNullContext(option.context)
    getNavigator(context).page(context).pop(delta)

    const pushingUrl =
      typeof option.push.url === 'string' ? new URL(option.push.url) : option.push.url
    const params = {
      push: {
        url: parseGlobalUrl(pushingUrl).toString(),
      },
    }
    TigaBridge.call(nonNullContext(option.context), 'app.navigator.navigate', params)
      .then((response) => {
        if (response.code == 0) {
          resolve({ code: 0, reason: 'navigate:ok' })
        } else {
          reject({ code: 10, reason: 'navigate:fail:' + response.reason })
        }
      })
      .catch((err) => {
        reject({ code: 1, reason: 'navigate:fail:' + err.message })
      })
  })
}

function popAndPushRemote(option: navigate.Option) {
  return new Promise((resolve, reject) => {
    getNavigator(nonNullContext(option.context)).release()
    const pushingUrl =
      typeof option.push.url === 'string' ? new URL(option.push.url) : option.push.url
    const pushAnim = (option.style && typeof option.style === 'number' && (option.style & STYLE_NO_ANIM) > 0) ? -1 : option.push.anim
    const style = (option.style && typeof option.style === 'number' && (option.style & STYLE_NO_ANIM) > 0) ? 1 : option.style
    const delta = option.pop.delta ? option.pop.delta : 1
    const params = {
      push: {
        url: parseGlobalUrl(pushingUrl).toString(),
        anim: pushAnim
      },
      pop: {
        delta: delta,
      },
      style
    }
    TigaBridge.call(nonNullContext(option.context), 'app.navigator.navigate', params)
      .then((response) => {
        if (response.code == 0) {
          resolve({ code: 0, reason: 'navigate:ok' })
        } else {
          reject({ code: 10, reason: 'navigate:fail:' + response.reason })
        }
      })
      .catch((err) => {
        reject({ code: 1, reason: 'navigate:fail:' + err.message })
      })
  })
}

export function setResult(option: setResult.Option): Promise<TigaGeneral.CallbackResult> {
  return withCallback(doSetResult(option))
}

export function doSetResult(option: setResult.Option): Promise<TigaGeneral.CallbackResult> {
  if (getNavigator(nonNullContext(option.context)).getHistorySize() > 1) {
    return setResultKeepingContainer(option)
  } else {
    return setResultRemote(option)
  }
}

function setResultKeepingContainer(option: setResult.Option): Promise<TigaGeneral.CallbackResult> {
  const context = nonNullContext(option.context)
  return Promise.resolve().then(() => {
    getNavigator(context).setResultToPreviousPage(context, option.resultData)
    return { code: 0, reason: 'setResult:ok' }
  })
}

function setResultRemote(option: setResult.Option): Promise<TigaGeneral.CallbackResult> {
  return Bridges.setResult(option.resultData, nonNullContext(option.context))
    .then(() => ({ code: 0, reason: 'setResult:ok' }))
    .catch((err) => {
      throw { code: 10, reason: 'setResult:fail:' + err.reason }
    })
}

export function getAppPages(
  option?: TigaGeneral.Option<getAppPages.CallbackResult>
): Promise<getAppPages.CallbackResult> {
  return withCallback(doGetAppPages(option), option)
}

function doGetAppPages(
  option?: TigaGeneral.Option<getAppPages.CallbackResult>
): Promise<getAppPages.CallbackResult> {
  return Bridges.history(nonNullContext(option?.context))
    .then((pages) => {
      for (let i = 0; i < pages.length; i++) {
        const urlObj = new URL(pages[i])
        pages[i] = simplify(urlObj).toString()
      }
      return { code: 0, pages, reason: 'getAppPages:ok' }
    })
    .catch((err) => {
      throw { code: err.code, reason: 'getAppPages:fail:' + err.reason }
    })
}
