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
  order: 0
title: 定位（端内）
order: 1
---


## getCacheLocationInfo 1
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>


### 介绍

获取缓存定位，不会触发实时定位，适合对定位要求不是特别及时的场景使用。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getCacheLocationInfo
```

### 类型

```jsx | pure
(option: TigaGeneral.Option<TigaGeneral.CallbackResult>): Promise<LocationInfoCallbackResult>
```

### 参数
#### TigaGeneral.Option<TigaGeneral.CallbackResult>
<API id="Location_GeneralProps"></API>

### 返回
#### LocationInfoCallbackResult

<span id='LocationInfoCallbackResult'></span>
| 属性名 | 描述 | 类型 | 
| ----- | ----- | ------ |
| code   | 错误 code, 0 成功，1 失败 | `number` |
| reason | 原因                                 | `string` |
| name | 【城市信息】城市名 | `string` | `--` |
| fullName | 【城市信息】城市全称 | `string` | `--` |
| regionCode | 【城市信息】城市 code | `number` | `--` |
| superCode | 【城市信息】父级城市 code | `number` | `--` |
| level | 【城市信息】城市等级 1：省 2：市 3：区 | `number` | `--` |
| regionLongitude | 【城市信息】城市数据库中的经度 | `number` | `--` |
| regionLatitude | 【城市信息】城市数据库中的纬度 | `number` | `--` |
| pyName | 【城市信息】城市拼音 | `string` | `--` |
| status | 【城市信息】1 可用 0 禁用 | `number` | `--` |
| locationTime | 【城市信息】定位时间,单位 s, 用与判断时间差, getCacheLocationInfo 时值存在 | `string` | `--` |
| longitude | 【定位信息】定位经度 | `number` | `--` |
| latitude | 【定位信息】定位纬度 | `number` | `--` |
| address | 【定位信息】地址 | `string` | `--` |
| province | 【定位信息】省名 | `string` | `--` |
| city | 【定位信息】市名 | `string` | `--` |
| district | 【定位信息】区名 | `string` | `--` |
| streetNumber | 【定位信息】门牌号 | `string` | `--` |
| poi | 【定位信息】poi 名称 | `string` | `--` |
| street | 【定位信息】街道 | `string` | `--` |
| sensitiveHandleResultCode | 【定位信息】地址偏移状态码 1 未处理 2 地址剔除省市区替换名称 3 地址中敏感词替换为空 | `number` | `--` |
| sensitiveHandleResultDesc | 【定位信息】地址偏移文字描述，与 sensitiveHandleResultCode 对应 | `string` | `--` |
| formatName | 【构造信息】拼接的城市名字,例: 上海市 长宁区, 江苏省 南京市 雨花台区 | `string` | `--` |
| districtId | 【构造信息】区 id | `number` | `--` |
| cityId | 【构造信息】市 id | `number` | `--` |
| provinceId | 【构造信息】省 id | `number` | `--` |
| accuracy | 【定位附加信息】位置的精确度(iOS 无此值， 返回 0) | `number` | `1.3.0` |
| altitude | 【定位附加信息】高度，单位 m | `number` | `1.3.0` |
| horizontalAccuracy | 【定位附加信息】水平精度，单位 m （Android 无法获取，返回 0） | `number` | `1.3.0` |
| speed | 【定位附加信息】速度，单位 m/s | `number` | `1.3.0` |
| verticalAccuracy | 【定位附加信息】垂直精度，单位 m（Android 无法获取，返回 0） | `number` | `1.3.0` |


### 示例

```jsx | pure
Tiga.Location.getCacheLocationInfo({ context: context })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```


## getLocationInfo
<Platform support="thresh,mw,logic,h5" version='1.1.0'></Platform>

### 介绍

触发一次实时定位。需要定位权限。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getLocationInfo
```

### 类型

```jsx | pure
(option: TigaGeneral.Option<TigaGeneral.CallbackResult>): Promise<LocationInfoCallbackResult>
```

### 参数
#### TigaGeneral.Option
<API id="Location_GeneralProps"></API>

### 返回
#### LocationInfoCallbackResult
[LocationInfoCallbackResult](#LocationInfoCallbackResult)

### 示例

```jsx | pure
Tiga.Location.getLocationInfo({ context: context })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```


## getLocationInfoAttach
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍

支持多种参数选择，指定是否请求权限，取多久之内的缓存，取不到之后会去重新触发定位，如果是非即时定位的信息的场景，推荐使用该方法。需要定位权限。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getLocationInfoAttach
```

### 类型

```jsx | pure
(option: LocationProps): Promise<LocationInfoCallbackResult>
```

### 参数
#### LocationProps

<API id="Location_LocationProps"></API>

### 返回
#### LocationInfoCallbackResult

[LocationInfoCallbackResult](#LocationInfoCallbackResult)

### 示例

```jsx | pure
Tiga.Location.getLocationInfoAttach({
  context: context,
  timeInterval: 10,
  permissionRequest: true,
  topHint: '请开启定位权限-顶部提示',
  rationale: '请开启定位权限',
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
