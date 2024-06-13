import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import { parseData, parseGroup, parseStrategy, parseString } from './utils'

export declare namespace getKvStorage {
  interface Option {
    /**
     * @description package: 项目级隔离 / global: APP 全局共享
     * @default     package
     * */
    privacy?: string
    /**
     * @description 0: 长期 / 1: 临时（进程存活周期）
     * @default     0
     * */
    retention?: number
    /**
     * @description Thresh Context
     * */
    context?: any
  }
}
export interface KvStorageManager {
  info: (
    option?: KvStorageManager.info.Option | undefined
  ) => Promise<KvStorageManager.info.SuccessCallbackResult>

  set: (option: KvStorageManager.set.Option) => Promise<TigaGeneral.CallbackResult>

  get: <T = any>(
    option: KvStorageManager.get.Option<T>
  ) => Promise<KvStorageManager.get.SuccessCallbackResult<T>>

  remove: (option: KvStorageManager.remove.Option) => Promise<TigaGeneral.CallbackResult>

  clear: (option?: KvStorageManager.clear.Option | undefined) => Promise<TigaGeneral.CallbackResult>
}

export function getKvStorage(option: getKvStorage.Option): KvStorageManager {
  return new StorageManager(option.privacy, option.retention, option.context)
}

export declare namespace KvStorageManager {
  namespace info {
    interface Option {
      complete?: (res: TigaGeneral.CallbackResult) => void
      fail?: (res: TigaGeneral.CallbackResult) => void
      success?: (option: SuccessCallbackResult) => void
    }

    interface SuccessCallbackResult extends TigaGeneral.CallbackResult {
      currentSize: number
      keys: string[]
      limitSize: number
    }
  }

  namespace set {
    interface Option {
      data: any
      key: string
      complete?: (res: TigaGeneral.CallbackResult) => void
      fail?: (res: TigaGeneral.CallbackResult) => void
      success?: (res: TigaGeneral.CallbackResult) => void
    }
  }

  namespace get {
    interface Option<T> {
      key: string
      complete?: (res: TigaGeneral.CallbackResult) => void
      fail?: (res: TigaGeneral.CallbackResult) => void
      success?: (res: SuccessCallbackResult<T>) => void
    }

    interface SuccessCallbackResult<T> extends TigaGeneral.CallbackResult {
      data: T
    }
  }

  namespace remove {
    interface Option {
      key: string
      complete?: (res: TigaGeneral.CallbackResult) => void
      fail?: (res: TigaGeneral.CallbackResult) => void
      success?: (res: TigaGeneral.CallbackResult) => void
    }
  }

  namespace clear {
    interface Option {
      complete?: (res: TigaGeneral.CallbackResult) => void
      fail?: (res: TigaGeneral.CallbackResult) => void
      success?: (res: TigaGeneral.CallbackResult) => void
    }
  }
}

class StorageManager implements KvStorageManager {
  privacy: string
  retention: number
  group: string
  strategy: string
  context?: any

  constructor(privacy?: string, retention = 0, context = null) {
    this.privacy = privacy
    this.retention = retention
    this.group = parseGroup(privacy)
    this.strategy = parseStrategy(retention)
    this.context = context
  }

  async info(
    option?: KvStorageManager.info.Option | undefined
  ): Promise<KvStorageManager.info.SuccessCallbackResult> {
    const params = {
      group: this.group,
      strategy: this.strategy,
    }

    const { code, reason, data }: any = await TigaBridge.call(
      this.context,
      'app.storage.info',
      params
    )

    if (code == 0) {
      const res: KvStorageManager.info.SuccessCallbackResult = {
        currentSize: data.totalBytes - data.availableBytes,
        keys: data.keys,
        limitSize: data.totalBytes,
        code: 0,
        reason: 'getStoargeInfo:ok',
      }
      return successHandler(option?.success, option?.complete)(res)
    } else {
      const res: TigaGeneral.CallbackResult = {
        code: 1,
        reason: 'getStoargeInfo:fail:' + reason,
      }
      return errorHandler(option?.fail, option?.complete)(res)
    }
  }

  async set(option: KvStorageManager.set.Option): Promise<TigaGeneral.CallbackResult> {
    const { code, reason }: any = await TigaBridge.call(this.context, 'app.storage.set', {
      group: this.group,
      key: option.key,
      value: parseString(option.data),
      strategy: this.strategy,
    })

    if (code == 0) {
      const res: TigaGeneral.CallbackResult = {
        code: 0,
        reason: 'set:ok',
      }
      return successHandler(option.success, option.complete)(res)
    } else {
      const res: TigaGeneral.CallbackResult = {
        code: 1,
        reason: 'set:fail:' + reason,
      }
      return errorHandler(option.fail, option.complete)(res)
    }
  }

  async get<T = any>(
    option: KvStorageManager.get.Option<T>
  ): Promise<KvStorageManager.get.SuccessCallbackResult<T>> {
    const { code, reason, data }: any = await TigaBridge.call(this.context, 'app.storage.get', {
      group: this.group,
      key: option.key,
      strategy: this.strategy,
    })

    if (code == 0) {
      return successHandler(
        option.success,
        option.complete
      )({
        code: 0,
        reason: 'get:ok',
        data: data.value && parseData(data.value),
      })
    } else {
      return errorHandler(
        option.fail,
        option.complete
      )({
        code: 1,
        reason: 'get:fail:' + reason,
      })
    }
  }

  async remove(option: KvStorageManager.remove.Option): Promise<TigaGeneral.CallbackResult> {
    const { code, reason }: any = await TigaBridge.call(this.context, 'app.storage.remove', {
      group: this.group,
      key: option.key,
      strategy: this.strategy,
    })

    if (code == 0) {
      return successHandler(
        option.success,
        option.complete
      )({
        code: 0,
        reason: 'remove:ok',
      })
    } else {
      return errorHandler(
        option.fail,
        option.complete
      )({
        code: 1,
        reason: 'remove:fail:' + reason,
      })
    }
  }

  async clear(
    option?: KvStorageManager.clear.Option | undefined
  ): Promise<TigaGeneral.CallbackResult> {
    const { code, reason }: any = await TigaBridge.call(this.context, 'app.storage.clear', {
      group: this.group,
      strategy: this.strategy,
    })

    if (code == 0) {
      return successHandler(
        option?.success,
        option?.complete
      )({
        code: 0,
        reason: 'clear:ok',
      })
    } else {
      return errorHandler(
        option?.fail,
        option?.complete
      )({
        code: 1,
        reason: 'clear:fail:' + reason,
      })
    }
  }
}
