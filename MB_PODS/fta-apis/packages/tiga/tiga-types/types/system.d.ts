declare namespace Taro {
  namespace getClipboardData {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
    }
  }

  namespace setClipboardData {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
    }
  }

  namespace chooseContact {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
      /** 【APP 端内生效】是否请求通讯录权限, 注: 仅安卓有效, iOS 选择联系人不需要权限.
       * @default false
       */
      permissionRequest?: boolean
      /** 【APP 端内生效】自定义弹窗文案, permissionRequest 为 true 时必传 */
      rationale?: string
      /** 【APP 端内生效】顶部提示, permissionRequest 为 true 时必传, 只支持 Android */
      topHint?: string
    }
  }

  namespace makePhoneCall {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
      /**【APP 端内生效】【android使用字段】是否直接拨出，true: 是，false: 否，默认值为false，注: 当用户未授予拨打电话权限的情况下仍然进拨号界面，涉及权限：Tiga.Permission.Permissions.phone */
      directCall?: boolean
    }

    interface PhoneCallbackResult extends TaroGeneral.CallbackResult {
      /**【APP 端内生效】【android使用字段】是否直接拨出，true: 是，false: 否，默认值为false，注: 当用户未授予拨打电话权限的情况下仍然进拨号界面，涉及权限：Tiga.Permission.Permissions.phone */
      directCall?: boolean
    }
  }

  namespace getSystemInfoAsync {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }
    interface Result extends TaroGeneral.CallbackResult {
      /** 【APP 端内生效】0：正常 1：Rooted (Android) or Jailbroken (iOS) */
      deviceState: number
      /** 【APP 端内生效】[Android] MIUI, Flyme, EMUI, ColorOS, FuntouchOS, SmartisanOS, EUI, Sense, AmigoOS, _360OS, NubiaUI, H2OS, YunOS, YuLong, SamSung, Sony, Lenovo, LG, Google, Other */
      romName: string | undefined
      /** 【APP 端内生效】[Android]  */
      romVersionName: string | undefined
      /** 【APP 端内生效】数字类型App版本号 如：6100001 */
      versionCode: number
      /** 【APP 端内生效】包构建类型  0: debug 1: release 2: adhoc */
      buildType: number
      /** 【APP 端内生效】 app类型  driver： 司机类App shipper：货主类App employee：满帮家 common：暂无分类 */
      appType: string
      /** 【APP 端内生效】 应用标识, bundleId */
      appId: string
      /** 【APP 端内生效】 设备id */
      deviceId: string
      /** 【APP 端内生效】 openUUID，金融风控使用 */
      dfp: string
      /** 【APP 端内生效】 服务器环境 0: dev 1: QA 3: release */
      serverType: number
      /** 【APP 端内生效】 文件host */
      fileUrl: string
      /** 【APP 端内生效】 接口baseUrl */
      apiUrl: string
      /** 【APP 端内生效】 广告id，iOS取idfa，Android取adid */
      adId: string
      /** 【APP 端内生效】 泳道[测试包字段] */
      swimlane: string
      /** 【APP 端内生效】 底部安全bar高度 */
      bottomBarHeight: number
    }
  }

  namespace vibrateLong {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
    }
  }

  namespace vibrateShort {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
    }
  }

  namespace checkIsOpenAccessibility {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
    }
  }

  namespace getNetworkType {
    interface Option {
      /**
       * 【APP 端内生效】页面 context
       */
      context?: any
    }
  }
}
