import Thresh from '@thresh/thresh-lib'
import { getPackageName } from './packages'
import { SCHEME_THIS } from '../urlConstants'

export namespace LocationCompat {
  export function getLocationString(context?: any): string {
    return `ymm://flutter.dynamic/dynamic-page?biz=${getPackageName()}&page=${context.__pageName__}`
  }
}

export namespace HistoryCompat {
  export function push(localUrl?: string, context?: any) {
    const pageName = parseThreshPageNameFromLocalUrl(localUrl)
    console.log('HistoryCompat.push', localUrl, pageName)
    Thresh.openPage(context, pageName)
  }

  export function pop(delta: number, context?: any) {
    Thresh.closePages(context, delta)
  }

  export function replace(localUrl: string, context?: any) {
    const pageName = parseThreshPageNameFromLocalUrl(localUrl)
    console.log('HistoryCompat.replace', localUrl, pageName)
    Thresh.redirect(context, pageName)
  }
}

function parseThreshPageNameFromLocalUrl(url: string) {
  const path = url.substring(SCHEME_THIS.length + 3)
  return path.replace(/\//g, '-')
}

function parseThreshPageNameFromGlobalUrl(url: string | URL) {
  const urlObj = typeof url === 'string' ? new URL(url) : url
  return urlObj.searchParams.get('page')
}
