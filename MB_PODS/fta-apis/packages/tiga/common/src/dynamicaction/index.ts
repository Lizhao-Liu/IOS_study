import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export interface DynamicActionHandle extends Promise<TigaGeneral.CallbackResult> {
  /** 监听action事件回调 */
  listener: (res: any) => void
}

export interface RegisterActionOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /** 动态action名字 */
  name: string
}

export function registerDynamicAction(option: RegisterActionOption): DynamicActionHandle {
  let actionToken: string
  async function getActionToken(): Promise<string> {
    if (actionToken) {
      return Promise.resolve(actionToken)
    }
    const params = {
      name: option.name,
    }

    try {
      const res = await TigaBridge.call(option.context, 'app.action.register', params)
      if (res?.code == TigaGeneral.SUCCESS) {
        actionToken = res?.data?.token
        return Promise.resolve(actionToken)
      }
      return Promise.resolve(null)
    } catch (error) {
      return Promise.resolve(null)
    }
  }

  const { success, fail, complete } = option
  const p: any = new Promise(async (resolve, reject) => {
    const token = await getActionToken()

    const res: TigaGeneral.CallbackResult = {
      code: TigaGeneral.SUCCESS,
    }

    if (token) {
      success && success(res)
      complete && complete(res)
      resolve(res)
    } else {
      res.code = 1001
      res.reason = '请检查action name'
      fail && fail(res)
      complete && complete(res)
      reject(res)
    }
  })

  const eventCallback = (event) => {
    const { token, name, params } = event
    if (token == actionToken && name == option.name && p.listener) {
      p.listener(params)
    }
  }
  TigaGeneral.eventCenter.on('MBDynamicActionEvent', eventCallback)

  return p
}
