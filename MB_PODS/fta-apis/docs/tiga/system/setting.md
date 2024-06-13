---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 系统
order: 7
---

# 系统

## openSystemSetting

<Platform support="thresh,mw,logic,h5" version='1.0.0' ></Platform>

### 介绍

打开系统设置

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.openSystemSetting
```

### 类型

```jsx | pure
(opts: SettingProps): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### SettingProps

<API id="System_SettingPropsProps"></API>

### 返回

#### TigaGeneral.CallbackResult

| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 参数错误 | `number` |
| reason | 原因                                 | `string` |

### 示例

```javascript
Tiga.System.openSystemSetting({
  context: context,
  type: 'push',
})
```

## [getSystemInfoAsync](https://docs.taro.zone/docs/apis/base/system/getSystemInfoAsync)

<Platform support="thresh,mw" version="1.3.0"></Platform>

### 介绍

异步获取系统信息
注意：

1. 当前版本获取信息中 windowWidth、widowHeight 分别取自 screenWidth 和 screenHeight，safeArea 字段为空
2. albumAuthorized、wifiEnabled 等系统权限字段为空，如果需要请查询对应权限 API

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getSystemInfoAsync
```

### 类型

```jsx | pure
(option?: Option) => Promise<Taro.getSystemInfoAsync.Result>
```

### 参数

#### Taro.getSystemInfoAsync.Option

<API id="System_SystemInfoAsyncProps"></API>

### 返回

#### [Taro.getSystemInfoAsync.Result](https://docs.taro.zone/docs/apis/base/system/getSystemInfoAsync#result)

`详见 Taro 文档` 以下为扩展字段【仅在 APP 端内生效】

| 属性名          | 描述                                                                               | 类型     |
| --------------- | ---------------------------------------------------------------------------------- | -------- |
| deviceState     | 0：正常 1：Rooted (Android) or Jailbroken (iOS)                                    | `number` |
| romName         | [Android]                                                                          | `string` |
| romVersionName  | [Android]                                                                          | `string` |
| versionCode     | 数字类型 App 版本号 如：6100001                                                    | `number` |
| buildType       | 包构建类型 0: debug 1: release 2: adhoc                                            | `number` |
| appType         | app 类型 driver： 司机类 App shipper：货主类 App employee：满帮家 common：暂无分类 | `string` |
| appId           | 应用标识, bundleId                                                                 | `string` |
| deviceId        | 设备 id                                                                            | `string` |
| dfp             | openUUID，金融风控使用                                                             | `string` |
| serverType      | 服务器环境 0: dev 1: QA 3: release                                                 | `number` |
| fileUrl         | 文件 host                                                                          | `string` |
| apiUrl          | 接口 baseUrl                                                                       | `string` |
| adId            | 广告 id，iOS 取 idfa，Android 取 adid                                              | `string` |
| swimlane        | 泳道[测试包字段]                                                                   | `string` |
| bottomBarHeight | 底部安全 bar 高度                                                                  | `number` |

### 示例

```javascript
Taro.getSystemInfoAsync({
  context: context,
  success(res) {
    console.log('getSystemInfoAsync success: ', JSON.stringify(res))
  },
  complete(res) {
    console.log('getSystemInfoAsync complete')
  },
  fail(res) {
    console.log('getSystemInfoAsync fail: ', JSON.stringify(res))
  },
})
```
