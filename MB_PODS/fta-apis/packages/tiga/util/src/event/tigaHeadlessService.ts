import {
  Bridge,
  HeadlessSeviceBase,
  IRouterServiceContext,
  ServiceRegistry,
} from '@thresh/thresh-lib'
import { getBundleInfo } from '../bundle/index.thresh'

let bundleName = null

initBundleName()

let isInitialized = false
let context: any

let resolveCallbacks: ((context: any) => void)[] = []

class TigaHeadlessService extends HeadlessSeviceBase<any, IRouterServiceContext> {
  constructor(props, ctx) {
    super(props, ctx)
    context = ctx
  }

  async headlessHandle() {
    for (const resolveCallback of resolveCallbacks) {
      resolveCallback(context)
    }
    resolveCallbacks = []
  }
}

function initBundleName() {
  bundleName = getBundleInfo()?.bundleName
}

export async function getHeadlessServiceContext(): Promise<any> {
  if (!bundleName || bundleName === 'unknown') {
    initBundleName()
    if (!bundleName || bundleName === 'unknown') {
      return Promise.resolve(null)
    }
  }
  if (context) {
    return Promise.resolve(context)
  }

  const serviceStartedPromise = new Promise<void>((resolve) => {
    resolveCallbacks.push(resolve)
  })
  if (!isInitialized) {
    isInitialized = true

    ServiceRegistry.registerService('TigaHeadlessService', TigaHeadlessService)
    try {
      Bridge.invoke(
        {},
        {
          module: 'thresh',
          business: 'base',
          method: 'executeThreshService',
          params: {
            schemeUrl: `ymm://flutter.dynamic/dynamic-page?biz=${bundleName}&headlessService=TigaHeadlessService`,
          },
        }
      )

      await serviceStartedPromise

      return Promise.resolve(context)
    } catch (error) {}
  } else {
    await serviceStartedPromise

    return Promise.resolve(context)
  }
  return Promise.resolve(null)
}
