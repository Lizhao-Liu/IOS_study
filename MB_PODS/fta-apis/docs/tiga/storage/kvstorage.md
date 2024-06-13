---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 数据存储
  order: 40
type:
  title: KV 存储
  order: 1
title: 项目私有的持久化存储
order: 0
---

# 项目私有的持久化存储

## [getStorageInfo](https://docs.taro.zone/docs/apis/storage/getStorageInfo)

<Platform name="storage" version="1.0.0"></Platform>

异步获取该项目名下持久化存储记录和存储空间

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getStorageInfo({
  success: function (res) {
    console.log(res.keys)
    console.log(res.currentSize)
    console.log(res.limitSize)
  }
})
```

#### 类型

``` js
(option?: Option) => Promise<TaroGeneral.CallbackResult>
```

### Option

<API id="Storage_GetStorageInfoOption"></API>

### SuccessCallbackOption

| 属性名      | 描述                 | 类型     |
| ----------- | -------------------- | -------- |
| currentSize | 已用空间 KB          | number   |
| limitSize   | 总空间 KB            | number   |
| keys        | 当前存储域的所有 key | string[] |

## [setStorage](https://docs.taro.zone/docs/apis/storage/setStorage)

<Platform name="storage" version="1.0.0"></Platform>

存储键值对到本地持久化存储空间。会覆盖该项目名下的相同 key 的内容。

```jsx | pure
import Taro from '@tarojs/taro'

Taro.setStorage({
  key:"key",
  data:"value"
})
```

#### 类型

```javascript
(option: Option) => Promise<TaroGeneral.CallbackResult>
```

### Option

<API id="Storage_SetStorageOption"></API>

## [getStorage](https://docs.taro.zone/docs/apis/storage/getStorage)

<Platform name="storage" version="1.0.0"></Platform>

从该项目名下的本地持久化存储记录中异步获取指定 key 的内容

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getStorage({ context, key: 'key' })
  .then(res => {
    console.log(res.data)
  })
```

#### 类型

```typescript
<T = any>(option: Option<T>) => Promise<SuccessCallbackResult<T>>
```

### Option

<API id="Storage_GetStorageOption"></API>

### SuccessCallbackOption

| 属性名 | 描述 | 类型 |
| ------ | ---- | ---- |
| data   | 值   | T    |

## [removeStorage](https://docs.taro.zone/docs/apis/storage/removeStorage)

<Platform name="storage" version="1.0.0"></Platform>

从项目名下的本地持久化存储记录中移除指定 KV 数据

```jsx | pure
import Taro from '@tarojs/taro'

Taro.removeStorage({ context, key: 'key' })
```

#### 类型

```javascript
(option: Option) => Promise<TaroGeneral.CallbackResult>
```

### Option

<API id="Storage_RemoveStorageOption"></API>

## [clearStorage](https://docs.taro.zone/docs/apis/storage/clearStorage)

<Platform name="storage" version="1.0.0"></Platform>

清空该项目名下的本地持久化 KV 存储数据

``` js
import Taro from '@tarojs/taro'

Taro.clearStorage({ context })
```

#### 类型

```javascript
(option?: Option) => Promise<TaroGeneral.CallbackResult>
```

### Option

<API id="Storage_ClearStorageOption"></API>

<!-- ## 示例 Demo

<code src='@examples/components/tiga/storage/index.tsx'></code> -->
