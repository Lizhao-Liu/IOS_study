declare namespace Taro {
  namespace getLocation {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface SuccessCallbackResult {
      /** 【APP 端内生效】详细地址 */
      address?: string
      /** 【APP 端内生效】省份名 */
      province?: string
      /** 【APP 端内生效】城市名称 */
      city?: string
      /** 【APP 端内生效】区/县名称 */
      district?: string
      /** 【APP 端内生效】门牌号 */
      streetNumber?: string
      /** 【APP 端内生效】POI名称 */
      poi?: string
      /** 【APP 端内生效】街道 */
      street?: string
      /** 【APP 端内生效】地址偏移状态码 */
      sensitiveHandleResultCode?: number
      /** 【APP 端内生效】地址偏移文字描述，与sensitiveHandleResultCode对应 */
      sensitiveHandleResultDesc?: string
      /** 【APP 端内生效】【仅 iOS 支持】 地址名 */
      name?: string
    }
  }

  namespace getFuzzyLocation {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface SuccessCallbackResult {
      /** 【APP 端内生效】详细地址 */
      address?: string
      /** 【APP 端内生效】省份名 */
      province?: string
      /** 【APP 端内生效】城市名称 */
      city?: string
      /** 【APP 端内生效】区/县名称 */
      district?: string
      /** 【APP 端内生效】门牌号 */
      streetNumber?: string
      /** 【APP 端内生效】POI名称 */
      poi?: string
      /** 【APP 端内生效】街道 */
      street?: string
      /** 【APP 端内生效】地址偏移状态码 */
      sensitiveHandleResultCode?: number
      /** 【APP 端内生效】地址偏移文字描述，与sensitiveHandleResultCode对应 */
      sensitiveHandleResultDesc?: string
      /** 【APP 端内生效】【仅 iOS 支持】 地址名 */
      name?: string
      /** 【APP 端内生效】位置的精确度(iOS 无此值， 返回 0) */
      accuracy?: number
      /** 【APP 端内生效】高度，单位 m */
      altitude?: number
      /** 【APP 端内生效】水平精度，单位 m	（Android 无法获取，返回 0） */
      horizontalAccuracy?: number
      /** 【APP 端内生效】速度，单位 m/s */
      speed?: number
      /** 【APP 端内生效】垂直精度，单位 m（Android 无法获取，返回 0） */
      verticalAccuracy?: number
    }
  }
}
