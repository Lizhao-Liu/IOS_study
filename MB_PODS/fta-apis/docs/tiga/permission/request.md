---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 权限
  order: 90
title: 权限请求
order: 2
---



## requestPermission
<Platform name="permission" version="1.0.0"></Platform>

### 介绍

权限请求

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Permission.requestPermission
```

### 类型

```jsx | pure
(opts: PermissionRequestOption): Promise<PermissionResult>

```

### 参数
#### PermissionRequestOption
<API id="Permission_PermissionRequestProps"></API>

### 返回
#### PermissionResult
<span id="PermissionResult"></span>
| 属性名 | 描述     | 类型                                  |
| ------ | -------- | ------------------------------------- |
| status | 权限状态 | [PermissionStatus](#PermissionStatus) |

#### PermissionStatus

<span id='PermissionStatus'></span>

| 属性名 | 描述                                                                                                    | 类型     |
| ------ | ------------------------------------------------------------------------------------------------------- | -------- |
| 0      | 表示用户未授予该权限，此时申请可以弹出系统授权弹窗                                                      | `number` |
| 1      | 有权限                                                                                                  | `number` |
| 2      | 受限状态，也包括系统调用高版本的权限和不存在的权限                                                      | `number` |
| 3      | 有限的, iOS 14+ 支持(相册) 注: 业务在读取到此权限的时候应该认为是有权限的,只能选择用户已经选择了的照片. | `number` |
| 4      | 表示用户永久拒绝了该权限，此时申请只会弹出我们的自定义引导授权弹框                                      | `number` |

#### Permissions
<span id='Permissions'></span>

- 0 - 日历: calendar
- 1 - 相机: camera
- 2 - 通讯录: contacts
- 3 - 定位（使用期间）: location | locationWhenInUse
- 4 - 定位（总是）: locationAlways （仅 ios）
- 5 - 定位（使用期间）：locationWhenInUse （仅 ios）
- 6 - 媒体: media
- 7 - 麦克风: microphone
- 8 - 电话: phone
- 9 - 相册: photos （仅 ios）
- 10 - 相册（仅添加）: photosAddOnly （仅 ios 14+）
- 11 - 日历事件和提醒: reminders
- 12 - 传感器：sensors
- 13 - 短信: sms （仅 Android）
- 14 - 语音识别: speech
- 15 - 存储 storage（仅 Android）
- 16 - 忽略电池优化 （仅 Android）
- 17 - 通知: notification
- 18 - accessMediaLocation（仅 Android）
- 19 - activityRecognition（仅 Android Q+）
- 21 - 蓝牙: bluetooth
- 22 - manageExternalStorage（仅 Android）
- 23 - systemAlertWindow （仅 Android）
- 24 - requestInstallPackages（仅 Android）
- 25 - 行为跟踪:appTrackingTransparency （仅 ios）
- 26 - 重要通知（仅 ios 12+）
- 27 - accessNotificationPolicy （仅 Android）
- 28 - bluetoothScan（仅 Android）
- 29 - bluetoothAdvertise （仅 Android）
- 30 - bluetoothConnect（仅 Android）
- 31 - nearbyWifiDevices（仅 Android）
- 32 - videos（仅 Android T+）
- 33 - audio（仅 Android T+）
- 34 - scheduleExactAlarm （仅 Android S+）



### 示例

```jsx | pure
Tiga.Permission.requestPermission({
  context: context,
  permission: Tiga.Permission.Permissions.calendar,
  topHint: '测试',
  rationale: '请到设置页面中打开该权限',
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
