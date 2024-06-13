import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

export enum PermissionStatus {
  error = -1, //检查发生异常
  denied = 0,
  granted = 1,
  restricted = 2,
  limited = 3,
  permanentlyDenied = 4,
}

export enum ServiceStatus {
  usable = 0, // 可用
  unusable = 1, // 不可用
  none = 2, // 无此服务
}

export enum Permissions {
  /// Android: support
  /// iOS: support
  /// weapp: 'scope.addPhoneCalendar'
  calendar = 0,
  /// Android: support
  /// iOS: support
  /// weapp: 'scope.camera'
  camera = 1,
  /// Android: support
  /// iOS: support
  /// weapp: 'scope.addPhoneContact'
  contacts = 2,
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  /// weapp: 'scope.userLocation'
  location = 3,
  /// Android:
  ///   When running on Android < Q: Fine and Coarse Location
  ///   When running on Android Q and above: Background Location Permission
  /// iOS: CoreLocation - Always
  ///   When requesting this permission the user needs to grant permission
  ///   for the `locationWhenInUse` permission first, clicking on
  ///   the `Àllow While Using App` option on the popup.
  ///   After allowing the permission the user can request the `locationAlways`
  ///   permission and can click on the `Change To Always Allow` option.
  locationAlways = 4,
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  locationWhenInUse = 5,
  /// Android: None
  /// iOS: MPMediaLibrary
  mediaLibrary = 6,
  /// Android: Microphone
  /// iOS: Microphone
  /// weapp: 'scope.record'
  microphone = 7,
  /// Android: Phone
  /// iOS: Nothing
  phone = 8,
  /// When running on Android T and above: Read image files from external storage
  /// When running on Android < T: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  photos = 9,
  /// Android: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  photosAddOnly = 10,
  /// Android: Nothing
  /// iOS: Reminders
  reminders = 11,
  /// Android: Body Sensors
  /// iOS: CoreMotion
  sensors = 12,
  /// Android: Sms
  /// iOS: Nothing
  sms = 13,
  /// Android: Microphone
  /// iOS: Speech
  speech = 14,
  /// Android: External Storage
  /// iOS: Access to folders like `Documents` or `Downloads`. Implicitly
  /// granted.
  storage = 15,
  /// Android: Ignore Battery Optimizations
  /// iOS: nothing
  ignoreBatteryOptimizations = 16,
  ///
  notification = 17,
  /// Android: Allows an application to access any geographic locations
  /// persisted in the user's shared collection.
  accessMediaLocation = 18,
  /// When running on Android Q and above: Activity Recognition
  /// When running on Android < Q: Nothing
  /// iOS: Nothing
  activityRecognition = 19,
  /// iOS 13 and above: The authorization state of Core Bluetooth manager.
  /// When running < iOS 13 or Android this is always allowed.
  /// weapp: 'scope.bluetooth'
  bluetooth = 21,
  /// Android: Allows an application a broad access to external storage in
  /// scoped storage.
  /// iOS: Nothing
  ///
  /// You should request the Manage External Storage permission only when
  /// your app cannot effectively make use of the more privacy-friendly APIs.
  /// For more information: https://developer.android.com/training/data-storage/manage-all-files
  ///
  /// When the privacy-friendly APIs (i.e. [Storage Access Framework](https://developer.android.com/guide/topics/providers/document-provider)
  /// or the [MediaStore](https://developer.android.com/training/data-storage/shared/media) APIs) is all your app needs the
  /// [PermissionGroup.storage] are the only permissions you need to request.
  ///
  /// If the usage of the Manage External Storage permission is needed,
  /// you have to fill out the Permission Declaration Form upon submitting
  /// your app to the Google Play Store. More details can be found here:
  /// https://support.google.com/googleplay/android-developer/answer/9214102#zippy=
  manageExternalStorage = 22,
  ///Android: Allows an app to create windows shown on top of all other apps
  ///iOS: Nothing
  systemAlertWindow = 23,
  ///Android: Allows an app to request installing packages.
  ///iOS: Nothing
  requestInstallPackages = 24,
  ///Android: Nothing
  ///iOS: Allows user to accept that your app collects data about end users and
  ///shares it with other companies for purposes of tracking across apps and websites.
  appTrackingTransparency = 25,
  ///Android: Nothing
  ///iOS: Notifications that override your ringer
  criticalAlerts = 26,
  ///Android: Allows the user to access the notification policy of the phone.
  /// EX: Allows app to turn on and off do-not-disturb.
  ///iOS: Nothing
  accessNotificationPolicy = 27,
  ///Android: Allows the user to look for Bluetooth devices
  ///(e.g. BLE peripherals).
  ///iOS: Nothing
  bluetoothScan = 28,
  ///Android: Allows the user to make this device discoverable to other
  ///Bluetooth devices.
  ///iOS: Nothing
  bluetoothAdvertise = 29,
  ///Android: Allows the user to connect with already paired Bluetooth devices.
  ///iOS: Nothing
  bluetoothConnect = 30,
  ///Android: Allows the user to connect to nearby devices via Wi-Fi
  ///iOS: Nothing
  nearbyWifiDevices = 31,
  /// When running on Android T and above: Read video files from external storage
  /// When running on Android < T: Nothing
  /// iOS: Nothing
  videos = 32,
  /// When running on Android T and above: Read audio files from external storage
  /// When running on Android < T: Nothing
  /// iOS: Nothing
  audio = 33,
  /// When running on Android S and above: Allows exact alarm functionality
  /// When running on Android < S: Nothing
  ///iOS: Nothing
  scheduleExactAlarm = 34,
}
export enum Services {
  /// 系统定位服务开关状态
  location = Permissions.location,
}

export interface PermissionCheckOption extends TigaGeneral.Option<PermissionResult> {
  context?: any
  /** 接口调用失败的回调函数  1：失败 2： 参数错误
   * @link PermissionResult
   */
  fail?: (res: PermissionResult) => void
  /** 权限类型
   * @link Permissions
   */
  permission: Permissions
}

export interface ServiceCheckOption extends TigaGeneral.Option<ServiceResult> {
  context?: any
  /** 接口调用失败的回调函数  1：失败 2： 参数错误
   * @link ServiceResult
   */
  fail?: (res: ServiceResult) => void
  /** 权限类型, 目前只支持定位 Permissions.location， 数值类型为 3
   * @link Permissions
   */
  service: Permissions
}

export interface PermissionRequestOption extends TigaGeneral.Option<PermissionResult> {
  context?: any
  /** 接口调用失败的回调函数  1：失败 2： 参数错误
   * @link PermissionResult
   */
  fail?: (res: PermissionResult) => void
  /** 权限类型
   * @link Permissions
   */
  permission: Permissions
  /** 自定义弹窗文案， 如果需要提示文案，两个值都需要传入 */
  rationale: string
  /** 顶部提示, 只支持 Android */
  topHint: string //Android only
}

export interface PermissionResult extends TigaGeneral.CallbackResult {
  status: PermissionStatus
}

export interface ServiceResult extends TigaGeneral.CallbackResult {
  /** 服务状态  */
  status: ServiceStatus
}

/**
 * 检查权限，只能单个
 * 只支持promise风格的返回，不以回调形式返回
 * @param option 待检查的权限参数，只支持一次检查单个
 * @returns Promise<PermissionResult>
 */
export async function checkPermission(option: PermissionCheckOption): Promise<PermissionResult> {
  //兼容了微信小程序支持的权限，微信小程序走taro实现
  // if (Taro.getEnv() == TaroGeneral.ENV_TYPE.WEAPP) {
  //   let res = await Taro.getSetting()
  //   return {
  //     code: 0,
  //     status: encodeBoolPermissionStatus(res.authSetting[toWeappScope(option.permission)]),
  //   }
  // }
  try {
    //端内场景走Tiga bridge
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.permission.check',
      {
        permission: option.permission,
      }
    )

    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(data)
    } else {
      return errorHandler(option.fail, option.complete)({ code: code, reason: reason })
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `permission check fail, error msg: ${error.message}` })
  }
}

/**
 * 申请单个授权
 * @param option 申请权限的参数，rationale 用户拒绝后自定义弹框的文案，topHint Android特有弹出系统权限框时顶部的提示文案
 * @returns Promise<PermissionResult>
 */
export async function requestPermission(
  option: PermissionRequestOption
): Promise<PermissionResult> {
  // if (Taro.getEnv() == TaroGeneral.ENV_TYPE.WEAPP) {
  //   let successResolve = null
  //   let result = new Promise<PermissionResult>(function (resolve) {
  //     successResolve = resolve
  //   })
  //   Taro.authorize({
  //     scope: toWeappScope(option.permission),
  //     success: function () {
  //       successResolve({
  //         status: PermissionStatus.granted,
  //       })
  //     },
  //     fail: function () {
  //       successResolve({
  //         status: PermissionStatus.denied,
  //       })
  //     },
  //   })
  //   return result
  // }
  try {
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.permission.request',
      {
        permission: option.permission,
        rationale: option.rationale,
        topHint: option.topHint,
      }
    )

    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(data)
    } else {
      return errorHandler(option.fail, option.complete)({ code: code, reason: reason })
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `permission request fail, error msg: ${error.message}` })
  }
}

// todo 后续增加批量申请授权能力，目前无必要
// export async function requestPermissions() {

// }

export async function checkService(option: ServiceCheckOption): Promise<ServiceResult> {
  //兼容了微信小程序支持的权限，微信小程序走taro实现
  // if (Taro.getEnv() == TaroGeneral.ENV_TYPE.WEAPP) {
  //   return Promise.reject('not supported on miniprograme')
  // }

  try {
    //端内场景走Tiga bridge
    const { code, reason, data }: any = await TigaBridge.call(
      option.context,
      'app.permission.checkServiceStatus',
      {
        permission: option.service,
      }
    )
    if (code == TigaGeneral.SUCCESS) {
      return successHandler(option.success, option.complete)(data)
    } else {
      return errorHandler(option.fail, option.complete)({ code: code, reason: reason })
    }
  } catch (error) {
    return errorHandler(
      option.fail,
      option.complete
    )({ code: 1, reason: `permission checkServiceStatus fail, error msg: ${error.message}` })
  }
}

function toWeappScope(permission: Permissions) {
  switch (permission) {
    case Permissions.camera:
      return 'scope.camera'
    case Permissions.location:
      return 'scope.location'
    //todo 补全小程序的权限映射
  }
}

//留作批量授权时使用
function toWeappScopes(permissions: Permissions[]) {
  return permissions.map((value) => {
    return toWeappScope(value)
  })
}

function encodeBoolPermissionStatus(value: Boolean) {
  if (value) {
    return PermissionStatus.granted
  } else {
    return PermissionStatus.denied
  }
}
