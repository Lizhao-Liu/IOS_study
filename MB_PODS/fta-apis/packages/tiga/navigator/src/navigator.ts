import { TigaGeneral } from '@fta/tiga-util'
import { Bridges } from './bridges'
import { parseGlobalUrl, parseLocalUrl } from './urls'
import { getContainerId, isRedirected } from './util/contexts'
import { HistoryCompat } from './util/navigates'

export class LocalNavigator {
  private containerContext: any // first page's context

  history: Page[] = []

  constructor(context: any) {
    this.containerContext = context
    // let url = new URL(LocationCompat.getLocationString(context))
    // let localUrl = parseLocalUrl(url)
    // let globalUrl = parseGlobalUrl(url)
    // this.history.push(new Page(localUrl, globalUrl, this, context))

    TigaGeneral.getEvents(context).on('navigator.pop', this.onPopEvent)
    TigaGeneral.getEvents(context).on('navigator.onResult', this.onResultEvent)
  }

  page = (context: any) => {
    console.log('finding page', context)
    // for h5, each page has the same context instance
    for (let i = this.history.length - 1; i >= 0; i--) {
      if (this.history[i].context == context) {
        console.log('context found, index: ' + i)
        return this.history[i]
      }
    }
    const topPage = this.top()
    console.log('top page', topPage)
    if (!topPage.context) {
      topPage.context = context
    }
    return topPage
  }
  top = () => {
    if (this.history.length == 0) {
      console.error('No history')
      return null
    }
    return this.history[this.history.length - 1]
  }

  addHistory = (localUrl: URL, globalUrl: URL) => {
    this.history.push(new Page(localUrl, globalUrl, this))
    this.onHistoryChange()
  }

  removeHistory = (delta: number) => {
    for (let i = 0; i < delta; i++) {
      this.history.pop()
    }
    this.onHistoryChange()
  }

  replaceHistory = (localUrl: URL, globalUrl: URL) => {
    this.history[this.history.length - 1] = new Page(localUrl, globalUrl, this)
    this.onHistoryChange()
  }

  // removeThenAddHistory = (delta: number, localUrl: URL, globalUrl: URL) => {
  //   for (let i = 0; i < delta; i++) {
  //     this.history.pop()
  //   }
  //   this.history.push(new Page(localUrl, globalUrl, this))
  //   this.onHistoryChange()
  // }

  getHistorySize = () => {
    return this.history.length
  }

  private onHistoryChange = () => {
    this.toSyncPages = new Array(this.history.length)
    for (var i = 0; i < this.history.length; i++) {
      this.toSyncPages[i] = this.history[i].globalUrl
    }
    console.log('to sync pages', this.toSyncPages)

    Promise.resolve().then(() => {
      if (this.toSyncPages) {
        console.log('syncing pages', this.toSyncPages)
        Bridges.syncPages(this.toSyncPages, this.containerContext)
        this.toSyncPages = null
      } else {
        console.log('pages are latest')
      }
    })
  }

  private toSyncPages: Array<URL> = null

  onPageShow = (context: any, localUrl: string | URL) => {
    let pageIndex: number = -1
    for (let i = this.history.length - 1; i >= 0; i--) {
      if (this.history[i].context == context) {
        console.log('context found, index: ' + i)
        pageIndex = i
        break
      }
    }
    if (pageIndex >= 0) {
      const delta = this.history.length - 1 - pageIndex
      if (delta > 0) {
        this.removeHistory(delta)
      }
    } else if (isRedirected(context)) {
      const local = new URL(localUrl)
      this.replaceHistory(local, parseGlobalUrl(local))
      this.top().context = context
    } else {
      const topPage = this.history.length > 0 ? this.top() : null
      if (topPage && !topPage.context) {
        console.log('bind context to top, index: ' + (this.history.length - 1))
        topPage.context = context
      } else if (localUrl) {
        const local = new URL(localUrl)
        this.addHistory(local, parseGlobalUrl(local))
        this.top().context = context
      }
    }

    Promise.resolve().then(() => {
      this.tryCallbackOnResult()
    })
  }

  setResultToPreviousPage = (context: any, resultData: any) => {
    let previous: Page
    for (let i = this.history.length - 1; i >= 1; i--) {
      if (this.history[i].context == context) {
        console.log('previous found, index: ' + (i - 1))
        previous = this.history[i - 1]
        break
      }
    }
    if (previous) {
      // FIXME: check requestId
      if (previous.resultCallback) {
        previous.resultData = resultData === undefined ? null : resultData
      }
    } else {
      console.error('Unfound previous page')
    }
  }

  private onPopEvent = (eventData: any) => {
    console.log('got event: navigator.pop', eventData, this.containerContext)
    this.top().pop(eventData.delta)
  }

  private onResultEvent = (eventData: any) => {
    console.log('got event: navigator.onResult', eventData, this.containerContext)
    const requestId = eventData.requestId
    const topPage = this.top()
    if (requestId) {
      if (requestId == topPage.requestId) {
        topPage.resultData = eventData.resultData === undefined ? null : eventData.resultData
      } else {
        console.warn(`ignored resultData with unknown requestId ${requestId}`)
      }
    } else {
      console.warn('skipped checking requestId')
      topPage.resultData = eventData.resultData === undefined ? null : eventData.resultData
    }

    Promise.resolve().then(() => {
      this.tryCallbackOnResult()
    })
  }

  private tryCallbackOnResult = () => {
    const topPage = this.top()
    if (topPage.resultCallback && topPage.resultData !== undefined) {
      topPage.resultCallback(topPage.resultData)
      topPage.setListenerForResult(null, null)
    } else if (topPage.resultData !== undefined) {
      topPage.setListenerForResult(null, null)
    }
  }

  release = () => {
    localNavigators.delete(getContainerId(this.containerContext))
    TigaGeneral.getEvents(this.containerContext).off('navigator.pop', this.onPopEvent)
  }
}

let id = 1

namespace Ids {
  export function newId() {
    return id++
  }
}

export class Page {
  localUrl: URL
  globalUrl: URL
  navigator: LocalNavigator
  // index: number
  context: any
  id: number

  requestId?: string
  resultCallback?: (resultData: any) => void
  resultData?: any

  constructor(local: URL, global: URL, navigator: LocalNavigator, context?: any) {
    this.localUrl = local
    this.globalUrl = global
    this.navigator = navigator
    // this.index = navigator.getHistorySize()
    this.context = context
    this.id = Ids.newId()
  }

  push = (url: URL, resultCallback?: (resultData: any) => void) => {
    this.ensureTopPage()

    let localUrl = parseLocalUrl(url)
    let globalUrl = parseGlobalUrl(url)
    console.log(localUrl.toString(), globalUrl.toString())

    HistoryCompat.push(localUrl.toString(), this.context)
    this.navigator.addHistory(localUrl, globalUrl)

    // TODO: set requestId
    this.resultCallback = resultCallback
    this.resultData = null
  }

  pop = (delta: number) => {
    this.ensureTopPage()
    if (delta < 1) {
      return
    }
    HistoryCompat.pop(delta, this.context)
    this.navigator.removeHistory(delta)
  }

  popAndPush = (url: URL, delta: number) => {
    this.ensureTopPage()
    if (delta < 1) {
      throw 'delta should be at least 1'
    }
    if (delta >= 2) {
      HistoryCompat.pop(delta - 1, this.context)
      this.navigator.removeHistory(delta - 1)
    }
    let localUrl = parseLocalUrl(url)
    let globalUrl = parseGlobalUrl(url)
    HistoryCompat.replace(localUrl.toString(), this.context)
    this.navigator.replaceHistory(localUrl, globalUrl)
  }

  setListenerForResult = (requestId: string, resultCallback: (resultData: any) => void) => {
    this.requestId = requestId
    this.resultCallback = resultCallback
    this.resultData = undefined
  }

  // triggerOnResult = () => {

  // }

  private ensureTopPage = () => {
    if (this != this.navigator.top()) {
      throw 'Only top page can navigate'
    }
  }
}

const localNavigators = new Map<string, LocalNavigator>()

export function getNavigator(context: any) {
  const containerId = getContainerId(context)
  let target = localNavigators.get(containerId)
  if (!target) {
    target = new LocalNavigator(context)
    localNavigators.set(containerId, target)
  }
  return target
}
