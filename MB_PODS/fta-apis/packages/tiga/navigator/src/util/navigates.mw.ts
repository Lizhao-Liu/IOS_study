import { SCHEME_THIS } from '../urlConstants'
import { getPackageName } from './packages'

declare global {
  interface Window {
    App: AppInfo
  }

  interface AppInfo {
    _currentProject: string

    reactApp?: ReactApp
  }

  interface ReactApp {
    _history: ReactHistory
  }

  interface ReactHistory {
    push: (path: string) => void
    replace: (path: string) => void
    go: (delta: number) => void
  }
}

const reactHistory = window.App?.reactApp?._history

export namespace LocationCompat {
  export function getLocationString(_context?: any): string {
    return window.location.toString()
  }
}

export namespace HistoryCompat {
  export function push(localUrl?: string, _context?: any) {
    const path = localUrl.substring(SCHEME_THIS.length + 2)
    const reactUrl = appendPageId(`/${getPackageName()}${path}`)
    console.log('reactHistory.push', reactUrl)
    reactHistory.push(reactUrl)
  }

  export function pop(delta: number, _context?: any) {
    console.log('reactHistory.pop', delta)
    reactHistory.go(-delta)
  }

  export function replace(localUrl: string, _context?: any) {
    const path = localUrl.substring(SCHEME_THIS.length + 2)
    const reactUrl = appendPageId(`/${getPackageName()}${path}`)
    console.log('reactHistory.replace', reactUrl)
    reactHistory.replace(reactUrl)
  }
}

function appendPageId(url: string): string {
  if (url.indexOf('?') >= 0) {
    return `${url}&tiga-page=${newId()}`
  } else {
    return `${url}?tiga-page=${newId()}`
  }
}

let pageId = 1

function newId() {
  return pageId++
}
