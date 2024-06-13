declare namespace Taro {
  namespace showLoading {
    /**
     * @see https://taro-docs.jd.com/docs/apis/ui/interaction/showLoading
     */
    interface Option {
      /**
       * 提示的标题
       * @default 必选
       */
      title?: string

      /**
       * 是否显示透明蒙层，防止触摸穿透
       * @default false
       */
      mask?: boolean

      /**
       * loading延迟显示的等待时长，单位ms
       * 【仅在app端内生效】
       * @default 0
       */
      delay?: number

      /**
       * 页面 context
       * 【仅在app端内生效】
       */
      context?: any
    }
  }

  namespace showToast {
    /**
     * @see https://taro-docs.jd.com/docs/apis/ui/interaction/showToast
     */
    interface Option {
      /**
       * 是否显示透明蒙层，防止触摸穿透
       *【Android端暂不支持】
       * @default false
       */
      mask?: boolean

      /**
       * 提示的显示时长 单位 ms
       * 【Android端仅支持 1500/3000 ms，其他数值默认取临近值】
       * @default 1500
       */
      duration?: number

      /** toast基本样式
       *【仅在app端内生效】
       *
       * 可选值:
       * - 0: 纯文本;
       * - 1: 左边图标，右边文本;
       * - 2: 上面图标，下面文本;
       * @default 0
       * */
      toastType?: 0 | 1 | 2

      /** 图标
       *
       * 可选值:
       * - 'success': 显示成功图标，此时 title 文本最多显示 7 个汉字长度;
       * - 'error': 显示错误图标，此时 title 文本最多显示 7 个汉字长度;
       * - 'warning': 显示警告图标，此时 title 文本最多显示 7 个汉字长度，【仅在app端内生效】;
       * - 'none': 不显示图标，此时 title 文本最多可显示两行
       * - 【注意】'loading': app 端内不支持icon设置为loading，如需loading提示需要使用showLoading方法
       * */
      icon?: 'success' | 'none' | 'error' | 'warning' | 'loading'

      /** toast上下对齐方式
       * 【仅在app端内生效】
       *
       * 可选值:
       * - 0: 居中对齐;
       * - 1: 居上对齐;
       * - 2: 居下对齐
       * @default 0
       * */
      gravity?: 0 | 1 | 2

      /**
       * toast多行文本文字对齐方式
       *【仅在app端内生效】
       * 可选值：
       * - 0 : 居左对齐
       * - 1 : 居中对齐
       * - 2 : 居右对齐
       * @default 0 (toastType为2时默认居中对齐)
       */
      multilineTextAlignment?: 0 | 1 | 2

      /**
       * 页面 context
       *【仅在app端内生效】
       */
      context?: any
    }
  }

  namespace showModal {
    /**
     * @see https://taro-docs.jd.com/docs/apis/ui/interaction/showModal
     */
    interface Option {
      /**
       * 页面 context
       * 【仅在app端内生效】
       */
      context?: any

      /**
       * 取消按钮颜色
       * @default #000000
       */
      cancelColor?: string

      /**
       * 确认按钮颜色
       * @default #576B95
       */
      confirmColor?: string

      /**
       * 取消按钮文字
       * @default 取消
       */
      cancelText?: string

      /**
       * 确认按钮文字
       * @default 确定
       */
      confirmText?: string

      /**
       * 是否展示取消按钮
       * @default true
       */
      showCancel?: boolean

      /**
       * 背景蒙层透明度
       * 不传默认读取当前app端配置
       * 【仅在app端内生效】
       * @since 1.7.0
       */
      mask?: 'light' | 'dark'
    }
  }

  namespace hideLoading {
    /**
     * @see https://taro-docs.jd.com/docs/apis/ui/interaction/hideLoading
     */
    interface Option {
      /**
       * 页面 context
       * 【仅在app端内生效】
       */
      context?: any
    }
  }

  namespace hideToast {
    /**
     * @see https://taro-docs.jd.com/docs/apis/ui/interaction/hideToast
     */
    interface Option {
      /**
       * 页面 context
       * 【仅在app端内生效】
       */
      context?: any
    }
  }

  namespace showActionSheet {
    /**
     * @see https://taro-docs.jd.com/docs/apis/ui/interaction/showActionSheet
     */
    interface Option {
      /**
       * 页面 context
       * 【仅在app端内生效】
       */
      context?: any
    }
  }
}
