import { TigaGeneral } from '@fta/tiga-util'
import { parseSysteminfo } from './systeminfo'
import { GlobalSystemInfo, AppBaseInfo } from './systemtype'
class DataCache {
  readonly systemInfo: GlobalSystemInfo
  appInfo?: AppBaseInfo

  private constructor() {
    this.systemInfo = parseSysteminfo()
  }

  private static instance: DataCache | null = null
  static getInstance(): DataCache {
    this.instance = this.instance || new DataCache()
    return this.instance
  }

  // 注册监听，监听动态变化字段
  // registerListener() {
  //   /** 泳道swimlane */
  //   TigaGeneral.eventCenter.on('MBNetworkSwimlaneChangeEvent', (result) => {
  //     if (result.swimlane) {
  //       this.systemInfo.swimlane = result.swimlane
  //     }
  //   })
  // }
}

export default DataCache.getInstance()
