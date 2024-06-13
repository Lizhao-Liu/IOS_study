import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as MiniProgram from './type'

async function launchMiniProgram(
  option: MiniProgram.WXMiniProgramOption | MiniProgram.AlipayMiniProgramOption,
  platform: 'WX' | 'Alipay'
): Promise<TigaGeneral.CallbackResult> {
  try {
    const method =
      platform === 'WX' ? 'app.social.launchWXMiniProgram' : 'app.social.launchAlipayMiniProgram'
    const params =
      platform === 'WX'
        ? {
            userName: (option as MiniProgram.WXMiniProgramOption).userName,
            path: (option as MiniProgram.WXMiniProgramOption).path,
            type: (option as MiniProgram.WXMiniProgramOption).type,
          }
        : {
            appId: (option as MiniProgram.AlipayMiniProgramOption).appId,
            page: (option as MiniProgram.AlipayMiniProgramOption).page,
            query: (option as MiniProgram.AlipayMiniProgramOption).query,
          }
    const { code, reason }: any = await TigaBridge.call(option.context, method, params)
    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)({})
    } else {
      return errorHandler(option.fail, option.complete)({ code, reason })
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `launch ${platform}MiniProgram fail, error msg:  ${error.message}` })
  }
}

const launchWXMiniProgram = (option: MiniProgram.WXMiniProgramOption) =>
  launchMiniProgram(option, 'WX')
const launchAlipayMiniProgram = (option: MiniProgram.AlipayMiniProgramOption) =>
  launchMiniProgram(option, 'Alipay')

export * from './type'
export { launchAlipayMiniProgram, launchWXMiniProgram }

