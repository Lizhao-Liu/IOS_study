declare namespace Taro {
  namespace setScreenBrightness {
    interface Option {
      /**
       * 屏幕亮度值，范围 0 ~ 1。0 最暗，1 最亮
       * @default (必选)
       */
      value: number

      /** 【APP 端内生效】页面 context */
      context?: any
    }
  }

  namespace getScreenBrightness {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }
    interface SuccessCallbackOption extends TaroGeneral.CallbackResult {
      /** 屏幕亮度值，范围 0 ~ 1，0 最暗，1 最亮 */
      value: number
    }
  }

  namespace setKeepScreenOn {
    interface Option {
      /**
       * @default (必选)
       */
      keepScreenOn: boolean
      /** 【APP 端内生效】页面 context */
      context?: any
    }
  }
}
