import { parseGlobalUrl } from '../urls'

export namespace LocationCompat {
  export function getLocationString(_context?: any): string {
    return window.location.toString()
  }
}

export namespace HistoryCompat {
  export function push(localUrl?: string, _context?: any) {
    const url = parseGlobalUrl(new URL(localUrl))
    console.log('window.location.href', url)
    window.location.href = url.toString()
  }

  export function pop(delta: number, _context?: any) {
    console.log('window.history.go', delta)
    window.history.go(-delta)
  }

  export function replace(localUrl: string, _context?: any) {
    const url = parseGlobalUrl(new URL(localUrl))
    window.location.replace(url)
  }
}
