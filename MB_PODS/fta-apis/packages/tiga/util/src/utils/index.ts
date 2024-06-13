import Taro from '@tarojs/taro'
import { CallbackResult } from '../generalTypes'

export function successHandler(
  success?: (res: TaroGeneral.CallbackResult | CallbackResult) => void,
  complete?: (res: TaroGeneral.CallbackResult | CallbackResult) => void
) {
  return function (res: TaroGeneral.CallbackResult | CallbackResult): Promise<any> {
    success && success(res)
    complete && complete(res)
    return Promise.resolve(res)
  }
}

export function errorHandler(
  fail?: (res: TaroGeneral.CallbackResult | CallbackResult) => void,
  complete?: (res: TaroGeneral.CallbackResult | CallbackResult) => void
) {
  return function (res: TaroGeneral.CallbackResult | CallbackResult): Promise<any> {
    fail && fail(res)
    complete && complete(res)
    return Promise.reject(res)
  }
}

export function uuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const random = (Math.random() * 16) | 0
    return (c === 'x' ? random : (random & 0x3) | 0x8).toString(16)
  })
}
