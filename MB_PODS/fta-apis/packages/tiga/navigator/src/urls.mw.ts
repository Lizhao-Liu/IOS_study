import { SCHEME_THIS } from './urlConstants'
import { getPackageName } from './util/packages'
import { URLCompat } from './util/urlCompat'

export function isLocalUrl(url: string | URL) {
  if (typeof url === 'string') {
    return url.startsWith(SCHEME_THIS)
  } else {
    return url.protocol == SCHEME_THIS
  }
}

export function parseLocalUrl(url: URL) {
  if (url.protocol == SCHEME_THIS) {
    return url
  }

  const hashPrefix = `#/${getPackageName()}/`
  const localPath = url.hash.substring(hashPrefix.length)
  const localUrl = new URL(`${SCHEME_THIS}///${localPath}`)
  url.searchParams.forEach((value, key, _) => {
    localUrl.searchParams.append(key, value)
  })
  return localUrl
}

export function parseGlobalUrl(url: URL) {
  if (url.protocol != SCHEME_THIS) {
    return url
  }
  const pathAndQuery = url.toString().substring(SCHEME_THIS.length + 2)
  return new URL(`${location.origin}${location.pathname}#/${getPackageName()}${pathAndQuery}`)
}

export function isSameEnv(url: string | URL) {
  var urlObj: URL = typeof url === 'string' ? new URL(url) : url

  return (
    (urlObj.protocol == 'http:' || urlObj.protocol == 'https:') &&
    urlObj.hash.startsWith(`#/${getPackageName()}/`)
  )
}
