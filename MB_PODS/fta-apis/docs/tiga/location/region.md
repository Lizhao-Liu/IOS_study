---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 位置
  order: 120
title: 行政区
order: 2
---

## getRegionParent 
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍

根据 code 获取父级城市

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getRegionParent
```

### 类型

```jsx | pure
(option: CodeProps): Promise<RegionCallbackResult>
```

### 参数
#### CodeProps
<API id="Location_CodeProps"></API>

### 返回
#### RegionCallbackResult
<span id='RegionCallbackResult'></span>

| 属性名          | 描述                       | 类型                          |
| --------------- | -------------------------- | ----------------------------- |
| name            | 城市名                     | `string`                      |
| fullName        | 城市全称                   | `string`                      |
| regionCode      | 城市 code                  | `number`                      |
| superCode       | 父级城市 code              | `number`                      |
| level           | 城市等级 1：省 2：市 3：区 | `number`                      |
| regionLongitude | 城市数据库中的经度         | `number`                      |
| regionLatitude  | 城市数据库中的纬度         | `number`                      |
| pyName          | 城市拼音                   | `string`                      |
| status          | 1 可用 0 禁用              | `number`                      |
| children        | 子级别城市列表             | `Array<RegionCallbackResult>` |

### 示例

```jsx | pure
Tiga.Location.getRegionParent({ context: context, code: 429005 })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
})
```


## getRegionWithCode 
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍
根据城市 code 获取地区信息

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getRegionWithCode
```

### 类型

```jsx | pure
(option: CodeProps): Promise<RegionCallbackResult>

```

### 参数
#### CodeProps
<API id="Location_CodeProps"></API>

### 返回
#### RegionCallbackResult

[RegionCallbackResult](#RegionCallbackResult)


### 示例

```jsx | pure
Tiga.Location.getRegionWithCode({ context: context, code: 429005 })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```


## getRegionWithName 
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍
根据省市区名字获取地区信息

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getRegionWithName
```

### 类型

```jsx | pure
(option: NameProps): Promise<RegionCallbackResult>
```

### 参数
#### NameProps
<API id="Location_NameProps"></API>

### 返回
#### RegionsCallbackResult

[RegionCallbackResult](#RegionCallbackResult)

### 示例

```jsx | pure
Tiga.Location.getRegionWithName({ 
  context: context, 
  city: '山西', 
  district: '太原' 
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```


## getRegionChildren 
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍
根据 code 获取子级别城市

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location.getRegionChildren
```

### 类型

```jsx | pure
(option: ChildrenProps): Promise<RegionsCallbackResult>
```

### 参数
#### ChildrenProps
<API id="Location_ChildrenProps"></API>

### 返回
#### RegionsCallbackResult
<span id="RegionsCallbackResult"></span>
| 属性名 | 描述 | 类型                                                 |
| ------ | ---- | ---------------------------------------------------- |
| list   | 经度 | Array<[RegionCallbackResult](#RegionCallbackResult)> |

### 示例

```jsx | pure
Tiga.Location.getRegionChildren({ context: context, code: 410000, deep: 3 })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
