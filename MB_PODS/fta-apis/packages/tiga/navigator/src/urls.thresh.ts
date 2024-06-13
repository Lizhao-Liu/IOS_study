import { SCHEME_THIS } from './urlConstants'
import { getPackageName } from './util/packages'

export function isLocalUrl(url: string | URL) {
  if (typeof url === 'string') {
    return url.startsWith(SCHEME_THIS)
  } else {
    return url.protocol == SCHEME_THIS
  }
}

export function parseLocalUrl(url: URL): URL {
  if (url.protocol == SCHEME_THIS) {
    return url
  }

  const pageName = url.searchParams.get('page')
  const localPath = pageName.replace(/-/g, '/')
  const localUrl = new URL(`${SCHEME_THIS}///${localPath}`)
  url.searchParams.forEach((value, key, _) => {
    if (key != 'biz' && key != 'page') {
      localUrl.searchParams.append(key, value)
    }
  })
  return localUrl
}

export function parseGlobalUrl(url: URL): URL {
  if (url.protocol != SCHEME_THIS) {
    return url
  }
  // console.log(url.pathname)
  const pageName = url.pathname.substring(1).replace(/\//g, '-')
  const globalUrl = new URL(
    `ymm://flutter.dynamic/dynamic-page?biz=${getPackageName()}&page=${pageName}`
  )
  url.searchParams.forEach((value, key, _) => {
    globalUrl.searchParams.append(key, value)
  })
  return globalUrl
}

export function isSameEnv(url: string | URL) {
  var urlObj: URL = typeof url === 'string' ? new URL(url) : url

  return isThreshUrl(urlObj) && urlObj.searchParams.get('biz') == getPackageName()
}

function isThreshUrl(url: URL) {
  return (
    (url.host == 'flutter.dynamic' && url.pathname == '/dynamic-page') ||
    (url.host == 'flutter.app' && url.pathname == '/dynamic/dynamic-page')
  )
}
