import { TigaBridge, TigaGeneral } from '@fta/tiga-util'
import * as RequestProps from '../types'

function request(option: RequestProps.Option): RequestProps.RequestTask {
  const idString = generateMixed(32)
  const params: RequestProps.Option | any = {
    url: option.url,
    data: option.data,
    header: option.header,
    timeout: option.timeout,
    method: option.method,
    encrypted: option.encrypted ? 1 : 0,
    type: option.type,
    useDispatch: option.useDispatch ? 1 : 0,

    // 附加参数,内部使用
    id: idString,
  }

  const p: any = new Promise(async (resolve, reject) => {
    TigaBridge.call(option.context, 'app.network.request', params)
      .then((resData) => {
        const res: {
          code?: number
          reason?: string
          data?: { httpCode: any; header: any; data: any; errorCode: any; errorMsg: any }
        } = resData || {}
        if (res.code == TigaGeneral.SUCCESS) {
          // httpCode 为 200 并且 没有 errorCode 为请求成功
          if (res.data?.httpCode == 200 && !res.data?.errorCode) {
            if (option.responseType == 'data') {
              // data + result
              if (res?.data?.data?.result == 1) {
                if (option.success) {
                  option.success(res?.data?.data?.data)
                }
                if (option.complete) {
                  option.complete(res?.data?.data?.data)
                }
                resolve(res?.data?.data?.data)
              } else {
                const result = {
                  code: res?.data?.data?.result,
                  reason: res?.data?.data?.errorMsg,
                }
                if (option.fail) {
                  option.fail(result)
                }
                if (option.complete) {
                  option.complete(result)
                }
                reject(result)
              }
            } else if (option.responseType == 'content') {
              // content + status || content + success
              if (res?.data?.data?.status == 'ok' || res?.data?.data?.success == 1) {
                if (option.success) {
                  option.success(res?.data?.data?.content)
                }
                if (option.complete) {
                  option.complete(res?.data?.data?.content)
                }
                resolve(res?.data?.data?.content)
              } else {
                const result = {
                  code: res?.data?.data?.errorCode,
                  reason: res?.data?.data?.errorMsg,
                }
                if (option.fail) {
                  option.fail(result)
                }
                if (option.complete) {
                  option.complete(result)
                }
                reject(result)
              }
            } else {
              const result: RequestProps.SuccessCallbackResult = {
                statusCode: res.data?.httpCode,
                header: res.data?.header,
                data: res.data?.data,
              }
              if (option.success) {
                option.success(result)
              }
              if (option.complete) {
                option.complete(result)
              }
              resolve(result)
            }
          } else {
            console.log(idString)
            // 优先取 httpCode
            const errCode =
              res.data?.httpCode > 0 && res.data?.httpCode != 200
                ? res.data?.httpCode
                : res.data?.errorCode
            const result = {
              code: errCode,
              reason: res.data?.errorMsg,
            }
            console.log(result)
            if (option.fail) {
              option.fail(result)
            }
            if (option.complete) {
              option.complete(result)
            }
            reject(result)
          }
        } else if (res.code == 9999) {
          // 取消之后的回调,不需要返回给业务
          console.log('取消之后的请求回调')
        } else {
          if (option.fail) {
            option.fail({ code: res.code, reason: res.reason })
          }
          if (option.complete) {
            option.complete({ code: res.code, reason: res.reason })
          }
          reject({ code: res.code, reason: res.reason })
        }
      })
      .catch((error) => {
        console.log('error:', error)
        if (option.fail) {
          option.fail({ code: 1, reason: error.message })
        }
        if (option.complete) {
          option.complete({ code: 1, reason: error.message })
        }
        reject({ code: 1, reason: error.message })
      })
  })

  p.abort = function () {
    /* 取消请求 */
    const params: any = { id: idString }
    TigaBridge.call(option.context, 'app.network.abort', params)
  }

  return p
}

//生成n位数字字母混合得字符串
function generateMixed(n) {
  let chars = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ]
  let res = ''
  for (let i = 0; i < n; i++) {
    let id = Math.floor(Math.random() * 36)
    res += chars[id]
  }
  return res
}

export * from '../types'
export { request }
