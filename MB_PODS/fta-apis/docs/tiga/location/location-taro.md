---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 位置
  order: 120
type:
  title: 定位
  order: 2
title: 定位（支持小程序）
order: 1
---


## [getLocation](https://taro-docs.jd.com/docs/apis/location/getLocation)
<Platform support="thresh,mw,logic,h5,weapp" version='1.3.0' ></Platform>

### 介绍

实时定位，需要定位权限。

:::info{title=备注}

- 需要注意出入参，端内和端外有差异，端内不支持定位相关参数。
- 返回的经纬度为 gcj02 的坐标。
- app 端不支持定位相关参数设置.
- 默认为用户选定的定位精度请求。用户可以通过设置控制是否开启精确位置。

:::

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getLocation
```

### 类型

```jsx | pure
(option?: Taro.getLocation.Option) => Promise<Taro.getLocation.SuccessCallbackResult>
```

### 参数
#### Taro.getLocation.Option

<API id="Location_GetLocationProps"></API>

### 返回
#### [Taro.getLocation.SuccessCallbackResult](https://taro-docs.jd.com/docs/apis/location/getLocation)

以下为扩展字段【仅在 APP 端内生效】

| 属性名 | 描述 | 类型  |
| ----- | ----- | -------- |
| address                   | 【仅在 app 端内生效】详细地址                                            | `string` |
| province                  | 【仅在 app 端内生效】省份名                                              | `string` |
| city                      | 【仅在 app 端内生效】城市名称                                            | `string` |
| district                  | 【仅在 app 端内生效】区/县名称                                           | `string` |
| streetNumber              | 【仅在 app 端内生效】门牌号                                              | `string` |
| poi                       | 【仅在 app 端内生效】POI 名称                                            | `string` |
| street                    | 【仅在 app 端内生效】街道                                                | `string` |
| sensitiveHandleResultCode | 【仅在 app 端内生效】地址偏移状态码                                      | `number` |
| sensitiveHandleResultDesc | 【仅在 app 端内生效】地址偏移文字描述，与 sensitiveHandleResultCode 对应 | `string` |
| name                      | 【仅在 app 端内生效】【仅在 iOS 端内生效】地址名                         | `string` |

### 示例

```jsx | pure
Taro.getLocation({
  context: context,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```


## [getFuzzyLocation](https://taro-docs.jd.com/docs/apis/location/getFuzzyLocation)

<Platform support="thresh,mw,logic,h5,weapp" version='1.3.0' ></Platform>

### 介绍

触发一次实时定位。需要定位权限。

:::info{title=备注}

- 需要注意出入参，端内和端外有差异，端内不支持定位相关参数。
- 返回的经纬度为 gcj02 的坐标。
- app 端不支持定位相关参数设置.
- 默认为用户选定的定位精度请求。用户可以通过设置控制是否开启精确位置。
- 端内实现和 getLocationInfo 是同一个 api。端内建议使用 getLocationInfo

:::

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Taro.getFuzzyLocation
```

### 类型

```jsx | pure
(option?: Taro.getFuzzyLocation.Option) => Promise<Taro.getFuzzyLocation.SuccessCallbackResult>
```

### 参数
#### Taro.getFuzzyLocation.Option
<API id="Location_GetFuzzyLocationProps"></API>

### 返回
#### [Taro.getFuzzyLocation.SuccessCallbackResult](https://taro-docs.jd.com/docs/apis/location/getFuzzyLocation)
| 属性名                    | 描述                                                                     | 类型     |
| ------------------------- | ------------------------------------------------------------------------ | -------- |
| address                   | 【仅在 app 端内生效】详细地址                                            | `string` |
| province                  | 【仅在 app 端内生效】省份名                                              | `string` |
| city                      | 【仅在 app 端内生效】城市名称                                            | `string` |
| district                  | 【仅在 app 端内生效】区/县名称                                           | `string` |
| streetNumber              | 【仅在 app 端内生效】门牌号                                              | `string` |
| poi                       | 【仅在 app 端内生效】POI 名称                                            | `string` |
| street                    | 【仅在 app 端内生效】街道                                                | `string` |
| sensitiveHandleResultCode | 【仅在 app 端内生效】地址偏移状态码                                      | `number` |
| sensitiveHandleResultDesc | 【仅在 app 端内生效】地址偏移文字描述，与 sensitiveHandleResultCode 对应 | `string` |
| name                      | 【仅在 app 端内生效】【仅在 iOS 端内生效】地址名                         | `string` |
| accuracy                  | 【仅在 app 端内生效】位置的精确度(iOS 无此值， 返回 0)                   | `number` |
| altitude                  | 【仅在 app 端内生效】高度，单位 m                                        | `number` |
| horizontalAccuracy        | 【仅在 app 端内生效】水平精度，单位 m （Android 无法获取，返回 0）       | `number` |
| speed                     | 【仅在 app 端内生效】速度，单位 m/s                                      | `number` |
| verticalAccuracy          | 【仅在 app 端内生效】垂直精度，单位 m（Android 无法获取，返回 0）        | `number` |

### 示例

```jsx | pure
Taro.getFuzzyLocation({
  context: context,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
