import { GlobalThis } from './util/globals'

const TAG: string = 'Nav.Global'

class TigaNavigator {
  pop(delta: number) {
    console.log(TAG, 'pop(' + delta + ') called')
  }

  onResult(resultData: any) {
    console.log(TAG, 'onResult() called, resultData: ' + resultData)
  }
}

export function setGlobal() {
  if (GlobalThis.get('tigaNavigator')) {
    return
  }
  GlobalThis.set('tigaNavigator', new TigaNavigator())
}
