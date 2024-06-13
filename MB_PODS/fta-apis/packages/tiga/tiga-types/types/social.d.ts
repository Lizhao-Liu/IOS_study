declare namespace Taro {
  namespace showShareImageMenu {
    /**
     * @see https://taro-docs.jd.com/docs/apis/share/showShareImageMenu
     */
    interface Option {
      /**
       * 页面 context
       * 【仅在app端内生效】
       */
      context?: any

      /**
       * 要分享的图片地址
       * 【app端内支持网络路径】
       */
      path: string
    }
  }
}
