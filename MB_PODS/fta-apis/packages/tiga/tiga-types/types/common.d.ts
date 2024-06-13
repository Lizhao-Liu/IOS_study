declare namespace Taro {
  namespace onUserCaptureScreen {
    /** 用户主动截屏事件的回调函数 */
    type Callback = (result: UserCaptureScreenResult) => void

    declare interface UserCaptureScreenResult extends TaroGeneral.CallbackResult {
      /**
       * 【APP 端内生效】
       * 截屏图片本地路径, 绝对路径 勿缓存, Android需要开启相册权限
       * 只有在App内该字段有效
       */
      localPath?: string
    }
  }
}
