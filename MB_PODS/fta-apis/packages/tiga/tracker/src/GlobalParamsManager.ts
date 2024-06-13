import { TigaGeneral } from '@fta/tiga-util'
import { Bundle, TrackerGlobalConfigParams } from './trackParams'

class GlobalParamsManager {
  private static instance: GlobalParamsManager
  private bundle: Bundle

  private globalParamsFunction: () => { [key: string]: any }

  private constructor() {
    let currBundleInfo: TigaGeneral.BundleInfo = TigaGeneral.getBundleInfo()
    this.bundle = {
      name: currBundleInfo.bundleName,
      type: currBundleInfo.bundleType,
      version: currBundleInfo.bundleVersion,
    }
  }

  public static getInstance(): GlobalParamsManager {
    if (!GlobalParamsManager.instance) {
      GlobalParamsManager.instance = new GlobalParamsManager()
    }
    return GlobalParamsManager.instance
  }

  public setGlobalExtraParams(paramsFunction: () => { [key: string]: any }): void {
    this.globalParamsFunction = paramsFunction
  }

  public getGlobalExtraParams(): { [key: string]: any } {
    if (this.globalParamsFunction) {
      return this.globalParamsFunction()
    }
    return undefined
  }

  public clearGlobalExtraParams(): void {
    this.globalParamsFunction = undefined
  }

  public getGlobalConfig(): TrackerGlobalConfigParams {
    if (this.globalParamsFunction) {
      let bundle = this.bundle
      let params = this.globalParamsFunction()
      return {
        extraDict: params,
        bundle,
      }
    }
    return {
      bundle: this.bundle,
    }
  }
}

export default GlobalParamsManager
