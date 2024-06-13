/**
 * URL#pathname has different behavior between javaScript engines.
 *
 * Considering this URL 'this://host/path', it is not a standard URL.
 * it uses a non-standard scheme ('this' instead of something like 'http' or 'https').
 *
 * In most JavaScript engines, when you try to parse a non-standard URL,
 * they will simply treat the part after the scheme as the path. ('/path')
 *
 * However, Chrome's JavaScript engine (V8) behaves differently.
 * It treats the entire URL as the path if the scheme is not recognized. ('//host/path')
 */

export namespace URLCompat {
  export function path(url: string | URL): string {
    if (isHttpUrl(url)) {
      return getHttpUrlPath(url)
    } else {
      return getNonHttpUrlPath(url)
    }
  }

  function isHttpUrl(url: string | URL): boolean {
    if (typeof url === 'string') {
      return url.startsWith('https:') || url.startsWith('http:')
    } else {
      return url.protocol == 'https:' || url.protocol == 'http:'
    }
  }

  function getHttpUrlPath(url: string | URL): string {
    const urlObj = typeof url === 'string' ? new URL(url) : url
    return urlObj.pathname
  }

  function getNonHttpUrlPath(url: string | URL): string {
    let str = typeof url === 'string' ? url : url.toString()
    const hashIndex = str.indexOf('#')
    if (hashIndex >= 0) {
      str = str.substring(0, hashIndex)
    }
    const queryIndex = str.indexOf('?')
    if (queryIndex >= 0) {
      str = str.substring(0, queryIndex)
    }
    const schemeIndex = str.indexOf(':')
    if (schemeIndex < 0) {
      throw 'Missing protocol'
    }
    str = str.substring(schemeIndex + 1)
    if (!str.startsWith('//')) {
      throw 'Invalid host'
    }
    const pathIndex = str.indexOf('/', 2)
    if (pathIndex >= 0) {
      return str.substring(pathIndex)
    } else {
      // no path
      return ''
    }
  }
}
