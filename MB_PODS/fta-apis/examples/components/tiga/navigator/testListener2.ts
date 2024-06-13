let inited = false

declare global {
  interface Window {
    App: AppInfo
  }

  interface AppInfo {
    _currentProject: string

    reactApp?: ReactApp
  }

  interface ReactApp {
    _history: ReactHistory
  }

  interface ReactHistory {
    push: (path: string) => void
    replace: (path: string) => void
    go: (delta: number) => void
    listen: (f: (location: ILocation, action: EAction) => void) => void
  }
}

interface ILocation {
  hash: string
  pathname: string
  query?: Record<string, string>
  seatch: string
  state?: Record<string, string>
  path: string
}

enum EAction {
  POP = 'POP',
  REPLACE = 'REPLACE',
  PUSH = 'PUSH',
}

const reactHistory = window.App?.reactApp?._history

export function init() {
  if (inited) {
    return
  }
  inited = true

  console.log('init called')

  if (!reactHistory) {
    console.warn('window.App.reactApp._history is undefined')
    return
  }
  reactHistory.listen((location: ILocation, action: EAction) => {
    console.log('ftaHistory action', location, action)
    // const [location, action] = argus as [ILocation, EAction]

    // switch ()
  })
}
