import { TigaGeneral } from '@fta/tiga-util'

export function withCallback<T>(promise: Promise<T>, option?: TigaGeneral.Option<T>): Promise<T> {
  return new Promise((resolve, reject) => {
    promise
      .then((data) => {
        option?.success && option.success(data)
        option?.complete && option.complete(data)
        resolve(data)
      })
      .catch((error) => {
        option?.fail && option.fail(error)
        option?.complete && option.complete(error)
        reject(error)
      })
  })
}

export function callbackSuccess<T extends TigaGeneral.CallbackResult>(
  success?: (res: T) => void,
  complete?: (res: T) => void
): (res: T) => Promise<T> {
  return function (res: T): Promise<T> {
    success && success(res)
    complete && complete(res)
    return Promise.resolve(res)
  }
}

export function callbackFailure<T extends TigaGeneral.CallbackResult>(
  success?: (res: T) => void,
  complete?: (res: T) => void
): (res: T) => Promise<T> {
  return function (res: T): Promise<T> {
    success && success(res)
    complete && complete(res)
    return Promise.resolve(res)
  }
}
