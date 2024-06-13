import { TigaBridge } from '@fta/tiga-util'

export namespace Bridges {
  export function create(context?: any): Promise<string> {
    return compat(TigaBridge.call(context, 'app.audioPlayer.create', null)).then(
      (res) => res.data.token as string
    )
  }

  export function destroy(token: string, context?: any): void {
    TigaBridge.call(context, 'app.audioPlayer.destroy', { token })
  }

  export function setPlaybackParams(
    token: string,
    volume: number,
    rate: number,
    context?: any
  ): void {
    TigaBridge.call(context, 'app.audioPlayer.playbackParams', { token, volume, rate })
  }

  export function prepareSource(token: string, src: string, context?: any): Promise<void> {
    return compat(TigaBridge.call(context, 'app.audioPlayer.prepareSource', { token, src })).then(
      () => {}
    )
  }

  export function play(token: string, context?: any): Promise<void> {
    return compat(TigaBridge.call(context, 'app.audioPlayer.play', { token })).then(() => {})
  }

  export function pause(token: string, context?: any): Promise<void> {
    return compat(TigaBridge.call(context, 'app.audioPlayer.pause', { token })).then(() => {})
  }

  export function stop(token: string, context?: any): Promise<void> {
    return compat(TigaBridge.call(context, 'app.audioPlayer.stop', { token })).then(() => {})
  }

  // export function seek(token: string, context?: any): void {
  //   TigaBridge.call(context, 'app.audioPlayer.seek', { token })
  // }
}

interface Result {
  code: number
  reason?: string
  data?: any
}

function compat(bridgePromise: Promise<Result>): Promise<Result> {
  return bridgePromise.then((response) => {
    if (response.code == 0) {
      return response
    } else {
      throw response
    }
  })
}
