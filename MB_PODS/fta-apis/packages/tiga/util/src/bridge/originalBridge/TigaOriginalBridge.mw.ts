interface Result {
  code: number
  reason?: string
  data?: any
}

async function getTigaBridge() {
  if (window.TigaBridge) {
    return window.TigaBridge
  } else {
    return await new Promise((resolve) => {
      const eventHandler = (event) => {
        if (event.detail && event.detail.ready === 'Fulfilled') {
          window.removeEventListener(event.type, eventHandler)
          resolve(window.TigaBridge)
        }
      }
      window.addEventListener('mbBridge-ready', eventHandler)
    })
  }
}

const TigaOriginalBridge = {
  call: async function (context: any, bridgeName: string, params: any = {}): Promise<Result> {
    const tigaBridge = await getTigaBridge()
    return tigaBridge.call(bridgeName, params)
  },
}

export { TigaOriginalBridge }
