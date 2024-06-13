import Thresh, { IRouterContext } from '@thresh/thresh-lib'
import { getNavigator } from './navigator'
import { SCHEME_THIS } from './urlConstants'
import { nonNullContext, setTopPageContext } from './util/contexts'

export function onPageShow(context: any, localUrl: string | URL) {
  console.log('onPageShow', context, localUrl.toString())
  const page = nonNullContext(context)
  setTopPageContext(page)
  getNavigator(page).onPageShow(page, localUrl)
}

function parseLocalUrl(pageName: string): string {
  const localPath = pageName.replace(/-/g, '/')
  return `${SCHEME_THIS}///${localPath}`
}

export function withNavigator(Component) {
  return Component
}

let inited = false

export function initNavigator() {
  if (inited) {
    return
  }
  inited = true

  const beforePageDidAppear = Thresh.beforePageDidAppear
  Thresh.beforePageDidAppear = (page, status) => {
    beforePageDidAppear?.(page, status)

    const url = new URL(parseLocalUrl(page.__pageName__))
    const bizParams = paramsMap.get(page.__context__)
    for (let prop in bizParams) {
      url.searchParams.append(prop, bizParams[prop])
    }
    onPageShow(page.__context__, url)
  }

  const beforeRouter = Thresh.beforeRouter
  Thresh.beforeRouter = (context: IRouterContext, pageName: string, params: any) => {
    beforeRouter?.(context, pageName, params)

    // console.log('beforeRouter', context, pageName, params)

    const bizParams = {}
    for (let prop in params) {
      if (!nonBizParams.includes(prop)) {
        bizParams[prop] = params[prop]
      }
    }
    paramsMap.set(context, bizParams)
  }
}

const nonBizParams = [
  'amh-refer-spm',
  'appName',
  'biz',
  'buildType',
  'contextId',
  'jsBundlePath',
  'jsContextId',
  'page',
  'pageName',
]

const paramsMap = new WeakMap<IRouterContext, any>()
