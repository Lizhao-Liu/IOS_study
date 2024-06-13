import { isSameEnv, parseLocalUrl } from './urls'
import { URLCompat } from './util/urlCompat'

export function simplify(url: URL): URL {
  if (isYmmWrappedUrl(url)) {
    return simplify(unwrap(url))
  }
  if (isSameEnv(url)) {
    return parseLocalUrl(url)
  }
  return url
}

function isYmmWrappedUrl(url: URL): boolean {
  return (
    ['ymm:', 'wlqq:'].includes(url.protocol) &&
    ['/web', '/trans_mbweb'].includes(URLCompat.path(url))
  )
}

function unwrap(url: URL): URL {
  return new URL(url.searchParams.get('url'))
}
