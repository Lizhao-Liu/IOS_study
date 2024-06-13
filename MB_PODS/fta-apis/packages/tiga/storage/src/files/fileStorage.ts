import { TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { sandboxDir } from './fileUserpath'

export interface SandBoxPathOption extends TigaGeneral.Option<SandBoxPathResult> {}

export interface SandBoxPathResult extends TigaGeneral.CallbackResult {
  /**
   * 本地用户目录绝对路径
   */
  userPath: string
  /**
   * 本地临时目录绝对路径
   */
  tempPath: string
}

async function getSandboxPath(option: SandBoxPathOption): Promise<SandBoxPathResult> {
  const { complete, fail, success } = option

  const failRes = {
    code: 2,
    reason: 'some unknow exception!',
  }

  try {
    const result = await sandboxDir.sandboxUserPath(option.context)

    const res: SandBoxPathResult = {
      userPath: result.userPath,
      tempPath: result.tempPath,
    }

    return successHandler(success, complete)(res)
  } catch (error) {
    return errorHandler(fail, complete)(failRes)
  }
}

export { getSandboxPath }
