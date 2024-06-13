import { TigaBridge } from '@fta/tiga-util'
import { parseGlobalUrl } from './urls'

export namespace Bridges {
  export function syncPages(pages: URL[], context: any): void {
    TigaBridge.call(context, 'app.navigator.syncPages', { pages })
  }

  export function history(context: any): Promise<string[]> {
    return compat(TigaBridge.call(context, 'app.navigator.history'))
      .then((res) => res.data.pages as string[])
      .then((pages) => {
        for (let i = 0; i < pages.length; i++) {
          if (pages[i] == 'UNKNOWN') {
            pages[i] = 'ymm://unknown'
          }
        }
        return pages
      })
  }

  export function push(url: string | URL, context: any): Promise<string> {
    const pushingUrl = typeof url === 'string' ? new URL(url) : url
    const params = {
      push: {
        url: parseGlobalUrl(pushingUrl).toString(),
      },
    }
    return compat(TigaBridge.call(context, 'app.navigator.navigate', params)).then(
      (res) => res.data?.requestId
    )
  }

  export function setResult(resultData: any, context: any): Promise<void> {
    const params = {
      data: resultData,
    }
    return compat(TigaBridge.call(context, 'app.navigator.setResult', params)).then(() => {})
  }
}

interface Result {
  code: number
  reason?: string
  data?: any
}

function compat(bridgePromise: Promise<Result>): Promise<Result> {
  return bridgePromise.then((response) => {
    if (response.code == 0) {
      return response
    } else {
      throw response
    }
  })
}
