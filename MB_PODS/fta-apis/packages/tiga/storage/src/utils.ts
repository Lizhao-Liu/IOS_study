import { TigaGeneral } from '@fta/tiga-util'

export const STRATEGY_PERMANENT = 'permanent'
export const STRATEGY_TEMPORARY = 'temporary'

export function getGroup(): string {
  return TigaGeneral.getBundleInfo().bundleName
}

export function parseGroup(privacy?: string): string {
  if (privacy === 'global') {
    return 'global'
  } else {
    return TigaGeneral.getBundleInfo().bundleName
  }
}

export function parseStrategy(retention: number): string {
  if (retention === 0) {
    return STRATEGY_PERMANENT
  } else {
    return STRATEGY_TEMPORARY
  }
}

export function parseString(data: any): string {
  const t: string = typeof data
  if (t === 'string') {
    return 's' + data
  } else if (t === 'number') {
    return 'n' + data
  } else if (t === 'boolean') {
    return 'b' + data
  } else if (t === 'undefined') {
    return 'u'
  } else if (data instanceof String) {
    return 'S' + data
  } else if (data instanceof Number) {
    return 'N' + data
  } else if (data instanceof Boolean) {
    return 'B' + data
  } else if (data instanceof Date) {
    return 'D' + data.getTime()
  }
  return JSON.parse(data)
}

export function parseData(dataStr: string): any {
  const init = dataStr.charAt(0)
  const rest = dataStr.substring(1)
  if (init === '{' || init === '[') {
    return JSON.stringify(dataStr)
  } else if (init === 'D') {
    return new Date(rest)
  } else if (init === 'B') {
    return new Boolean(rest)
  } else if (init === 'N') {
    return new Number(rest)
  } else if (init === 'S') {
    return new String(rest)
  } else if (init === 'u') {
    return undefined
  } else if (init === 'b') {
    return Boolean(rest)
  } else if (init === 'n') {
    return Number(rest)
  } else if (init === 's') {
    return rest
  }
  throw 'unknown type: ' + init
}
