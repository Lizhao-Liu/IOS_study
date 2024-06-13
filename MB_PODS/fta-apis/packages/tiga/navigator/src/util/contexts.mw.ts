const CONTAINER_ID = 'MW'

let topPageContext: any

export function setTopPageContext(context: any) {
  topPageContext = context
}

export function nonNullContext(context?: any) {
  if (context) {
    return context
  }
  return topPageContext
}

export function nullableContext(context?: any) {
  if (context) {
    return context
  }
  return topPageContext
}

export function getPageId(context: any): string {
  return context as string
}

export function getContainerId(_context?: any): string {
  return CONTAINER_ID
}

export function isRedirected(context: any): boolean {
  return false
}
