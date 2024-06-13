import { getNavigator } from './navigator'
import { setTopPageContext } from './util/contexts'

export function onPageShow(context: any, localUrl?: string | URL) {
  console.log('onPageShow', context, localUrl.toString())
  setTopPageContext(context)
  getNavigator(context).onPageShow(context, localUrl)
}

function parsePageId(options) {
  const pageId = options.query['tiga-page']
  return pageId ? pageId : options.path
}

function parseLocalUrl(options): URL {
  const url = new URL(`this:///${options.path}`)
  for (let prop in options.query) {
    if (nonBizParams.includes(prop)) {
      continue
    }
    url.searchParams.append(prop, options.query[prop])
  }
  console.log('parseLocalUrl', url.toString())
  return url
}

export function withNavigator(Wrapped) {
  return withNavigatorCLZ(Wrapped)
}

function withNavigatorCLZ(Wrapped) {
  return class Wrapper extends Wrapped {
    componentDidShow(options) {
      super.componentDidShow && super.componentDidShow(options)

      onPageShow(parsePageId(options), parseLocalUrl(options))
    }
  }
}

export function initNavigator() {}

const nonBizParams = ['amh-refer-spm', 'amh-rpn', 'tiga-page']
