import { TigaBridge, TigaGeneral } from '@fta/tiga-util'

export declare namespace getAudioVolume {
  interface Option extends TigaGeneral.Option<CallbackResult> {
    usage: string
  }

  interface CallbackResult extends TigaGeneral.CallbackResult {
    mute: number
    volume: number
  }
}

export function getAudioVolume(
  option: getAudioVolume.Option
): Promise<getAudioVolume.CallbackResult> {
  return TigaBridge.call(option.context, 'app.system.getAudioVolume', { usage: option.usage })
    .then((response) => {
      if (response.code == 0) {
        return response
      } else {
        throw response
      }
    })
    .then((res) => ({
      code: 0,
      reason: 'getAudioVolume:ok',
      mute: res.data.mute as number,
      volume: (res.data.volume as number) / 100,
    }))
    .catch((err) => {
      throw { code: 10, reason: 'getAudioVolume:fail:' + err.reason }
    })
}
