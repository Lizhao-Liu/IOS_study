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
  order: 1
title: 反解
order: 1
---


## geocoder
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍

经纬度反解，需要定位权限。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.geocoder
```

### 类型

```jsx | pure
(option: GeocoderProps): Promise<LocationInfoCallbackResult>
```

### 参数
#### GeocoderProps

<API id="Location_GeocoderProps"></API>

### 返回
#### LocationInfoCallbackResult
 
[LocationInfoCallbackResult](http://localhost:8000/tiga/location/location#%E8%BF%94%E5%9B%9E)

### 示例

```jsx | pure
Tiga.Location.geocoder({
  context: context,
  longitude: 121.408652,
  latitude: 31.209837,
  sensitiveOffset: 1000,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```



## webGeocoder
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍

反解（网络能力），需要使用网络。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.webGeocoder
```

### 类型

```jsx | pure
(option: WebGeocoderProps): Promise<WebLocationInfoCallbackResult>
```

### 参数
#### WebGeocoderProps
<API id="Location_WebGeocoderProps"></API>

### 返回
#### WebLocationInfoCallbackResult

| 属性名                    | 描述             | 类型     |
| ------------------------- | ---------------- | -------- |
| code   | 错误 code, 0 成功，1 失败           | `number` |
| reason | 原因                                 | `string` |
| lon                       | 经度             | `number` |
| lat                       | 纬度             | `number` |
| formattedAddress          | 结构化地址       | `string` |
| provinceName              | 省名             | `string` |
| provinceId                | 省 id            | `number` |
| cityName                  | 市名             | `string` |
| cityId                    | 市 id            | `number` |
| districtName              | 区名             | `string` |
| districtId                | 区 id            | `number` |
| town                      | 镇名             | `string` |
| townId                    | 镇 id            | `number` |
| street                    | 街道             | `string` |
| streetNumber              | 街道门牌号       | `string` |
| poiName                   | poi name         | `string` |
| sensitiveHandleResultCode | 地址偏移状态码   | `number` |
| sensitiveHandleResultDesc | 地址偏移文字描述 | `string` |

### 示例

```jsx | pure
Tiga.Location.webGeocoder({
  context: context,
  lon: 121.408652,
  lat: 31.209837,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
