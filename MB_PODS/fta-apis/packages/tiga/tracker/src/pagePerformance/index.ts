import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import GlobalParamsManager from '../GlobalParamsManager'
import { Bundle } from '../trackParams'

export interface PageViewPerformanceTrackOption
  extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 扩展业务字段
   */
  extraDict?: { [key: string]: any }
  /**
   * 指标tags，tags的值必须保证可穷举
   */
  tags?: {
    [key: string]: number | string | boolean
  }
}

export interface PageViewPerformanceTrackerConfigOption {
  /**
   * 页面名称, 用于上报到大数据平台的名称
   */
  pageName?: string
  /**
   * 页面的路径
   */
  path: string
  /**
   * 页面context
   */
  context: any
  /**
   * 自定义拓展参数，当前页面公用
   */
  extraDict?: {
    [key: string]: any
  }
}

const ERROR_MISSING_TIMESTAMP = {
  reason: 'Both beginAt and endAt timestamps are required for custom page isolated section.',
  code: 1,
}

export class PageViewPerformanceTracker {
  pageName?: string // 对应scenario 上报大数据平台
  path: string // 页面path
  context: any // 页面上下文
  bundle?: Bundle // bundle信息
  extraDict?: {
    // 自定义参数，页面公用
    [key: string]: any
  }
  protected trackId: string

  constructor(options: PageViewPerformanceTrackerConfigOption) {
    this.path = options.path
    this.context = options.context
    this.pageName = options.pageName
    this.bundle = GlobalParamsManager.getInstance().getGlobalConfig().bundle
    this.extraDict = options.extraDict
  }

  public async begin(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult> {
    const { success, fail, complete, extraDict, tags } = option
    const reqParams: any = {
      action: 'begin',
      begin: {
        metricName: 'performance.pageview',
        path: this.path,
        scenario: this.pageName,
        tags,
      },
      bundle: this.bundle,
      extraDict: this.getMergedExtraDict(extraDict),
    }

    const res = await TigaBridge.call(this.context, 'app.track.transaction', reqParams)

    if (res.code == TigaGeneral.SUCCESS) {
      this.trackId = res.data?.transactionTrackId
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  }

  /**
   * 结束页面耗时监控并上报埋点
   * @param option 页面分段耗时数据
   * @param lastPageSectionName 页面结尾 section 名称，默认 page_interactive_prepare
   */
  public async end(
    option: PageViewPerformanceTrackOption,
    lastPageSectionName = 'page_interactive_prepare'
  ): Promise<TigaGeneral.CallbackResult> {
    const { success, fail, complete } = option
    const reqParams: any = {
      action: 'end',
      end: {
        sectionName: lastPageSectionName,
        trackId: this.trackId,
        path: this.path,
        tags: option.tags,
      },
      bundle: this.bundle,
      extraDict: this.getMergedExtraDict(option.extraDict),
    }

    const res = await TigaBridge.call(this.context, 'app.track.transaction', reqParams)

    if (res.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  }

  public async pageLoad(
    option: PageViewPerformanceTrackOption
  ): Promise<TigaGeneral.CallbackResult> {
    return this._trackSection('page_load', option)
  }

  public async pageFirstLayout(
    option: PageViewPerformanceTrackOption
  ): Promise<TigaGeneral.CallbackResult> {
    return this._trackSection('page_first_layout', option)
  }

  public async pageSecondLayout(
    option: PageViewPerformanceTrackOption
  ): Promise<TigaGeneral.CallbackResult> {
    return this._trackSection('page_second_layout', option)
  }

  public async pageCustomIsolatedSection(
    option: PageViewPerformanceTrackOptionWithTimestamp,
    sectionName: string
  ): Promise<TigaGeneral.CallbackResult> {
    if (typeof option.beginAt === 'undefined' || typeof option.endAt === 'undefined') {
      return Promise.reject(ERROR_MISSING_TIMESTAMP)
    }
    return this._trackSection(sectionName, option)
  }

  protected getMergedExtraDict(extraDict: any): any {
    const mergedExtraDict = {
      ...GlobalParamsManager.getInstance().getGlobalConfig().extraDict,
      ...this.extraDict,
      ...extraDict,
    }

    return mergedExtraDict
  }

  protected async _trackSection<T extends PageViewPerformanceTrackOption>(
    sectionName: string,
    option: T
  ): Promise<TigaGeneral.CallbackResult> {
    const { success, fail, complete, tags, extraDict, ...rest } = option
    let mergedExtraDict = this.getMergedExtraDict(extraDict)
    const reqParams: any = {
      action: 'section',
      section: {
        trackId: this.trackId,
        sectionName,
        path: this.path,
        tags: tags,
        ...rest,
      },
      bundle: this.bundle,
      extraDict: mergedExtraDict,
    }

    const res = await TigaBridge.call(this.context, 'app.track.transaction', reqParams)

    if (res.code == TigaGeneral.SUCCESS) {
      return successHandler(success, complete)(res)
    } else {
      return errorHandler(fail, complete)(res)
    }
  }
}

export interface PageViewPerformanceTrackOptionWithTimestamp
  extends PageViewPerformanceTrackOption {
  /**
   * 自定义页面耗时打点 通过此参数设置开始点
   */
  beginAt: number
  /**
   * 自定义页面耗时打点 通过此参数设置结束点
   */
  endAt: number
}

export interface PageViewPerformancePageLoadTrackOptionWithTimestamp
  extends PageViewPerformanceTrackOption {
  beginAt?: number //pageload section中可以不传beginAt
  endAt: number
}

export class PageViewPerformanceCustomTracker extends PageViewPerformanceTracker {
  public async pageLoad(
    option: PageViewPerformancePageLoadTrackOptionWithTimestamp
  ): Promise<TigaGeneral.CallbackResult> {
    return this._trackSection('page_load', option)
  }

  public async pageFirstLayout(
    option: PageViewPerformancePageLoadTrackOptionWithTimestamp
  ): Promise<TigaGeneral.CallbackResult> {
    return this._trackSection('page_first_layout', option)
  }

  public async pageSecondLayout(
    option: PageViewPerformancePageLoadTrackOptionWithTimestamp
  ): Promise<TigaGeneral.CallbackResult> {
    return this._trackSection('page_second_layout', option)
  }

  public async end(
    option: PageViewPerformancePageLoadTrackOptionWithTimestamp,
    lastPageSectionName = 'page_interactive_prepare'
  ): Promise<TigaGeneral.CallbackResult> {
    const { success, fail, complete } = option

    const buildParams = (actionType: string, extraProps: any = {}) => ({
      action: actionType,
      [actionType]: {
        trackId: this.trackId,
        path: this.path,
        tags: option.tags,
        ...extraProps,
      },
      bundle: this.bundle,
      extraDict: this.getMergedExtraDict(option.extraDict),
    })

    const callTigaBridge = async (params: any) => {
      const res = await TigaBridge.call(this.context, 'app.track.transaction', params)
      if (res.code === TigaGeneral.SUCCESS) {
        return successHandler(success, complete)(res)
      }
      return errorHandler(fail, complete)(res)
    }

    const sectionParams = buildParams('section', {
      sectionName: lastPageSectionName,
      beginAt: option.beginAt,
      endAt: option.endAt,
    })
    const sectionResponse = await callTigaBridge(sectionParams)

    if (sectionResponse.code === TigaGeneral.SUCCESS) {
      const endParams = buildParams('end')
      return await callTigaBridge(endParams)
    }

    return sectionResponse
  }
}
