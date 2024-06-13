import { IRouterContext } from '@thresh/thresh-lib'

let topPageContext: any

export function setTopPageContext(context: any) {
  topPageContext = context
}

export function nonNullContext(context?: any) {
  if (context === null || context === undefined) {
    throw 'missing context'
  }
  return context
}

export function nullableContext(context?: any) {
  if (context === null || context === undefined) {
    return null
  }
  return context
}

interface ContainerContext {
  __contextId__: string
}

interface PageContext extends ContainerContext {
  __pageId__: string
  // __pageName__
  // __pageSessionId__
}

export function getPageId(context: PageContext): string {
  return context.__pageId__
}

export function getContainerId(context: ContainerContext): string {
  return context.__contextId__
}

export function isRedirected(context: any): boolean {
  return (context as IRouterContext).__isRedirect__
}
