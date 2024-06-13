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
title: 更多可选择的存储域
order: 1
---

# 更多可选择的存储域

本页面的 API 提供包含[项目私有的持久化存储](kvstorage)在内的更多的存储域供选择：

||长期|临时（进程存活周期）|
|-|-|-|
|项目私有|支持|支持|
|全局共享|支持|支持|

## getKvStorage

<Platform name="storage" version="1.0.0"></Platform>

访问存储管理器 `KvStorageManager`

```jsx | pure
import Tiga from '@fta/tiga'

const storage = Tiga.Storage.getKvStorage({ context, privacy: 'package' })
```

#### 类型

``` js
(option: getKvStorage.Option): KvStorageManager
```



<API id="Storage_GetKvStorageOption"></API>

## KvStorageManager

存储管理器接口

#### 接口定义

| 属性名 | 类型                                                                                                          | 说明               |
| ------ | ------------------------------------------------------------------------------------------------------------- | ------------------ |
| info   | `() => Promise<KvStorageManager.info.SuccessCallbackResult>`                                                  | 查询当前存储域信息 |
| set    | `(option: KvStorageManager.set.Option) => Promise<TigaGeneral.CallbackResult>`                                | 存储键值对         |
| get    | `<T = any>(option: KvStorageManager.get.Option<T>) => Promise<KvStorageManager.get.SuccessCallbackResult<T>>` | 获取存储的值       |
| remove | `(option: KvStorageManager.remove.Option) => Promise<TigaGeneral.CallbackResult>`                             | 移除键值对         |
| clear  | `() => Promise<TigaGeneral.CallbackResult>`                                                                   | 清空当前存储域     |

### info

查询当前存储域信息

```jsx | pure
import Tiga from '@fta/tiga'

const storage = Tiga.Storage.getKvStorage({ context })
storage.info()
  .then(res => console.log(res.keys, res.currentSize, res.limitSize))
```

#### SuccessCallbackResult

| 属性名      | 描述                 | 类型     |
| ----------- | -------------------- | -------- |
| currentSize | 已用空间 KB          | number   |
| limitSize   | 总空间 KB            | number   |
| keys        | 当前存储域的所有 key | string[] |

### set

存储键值对到当前存储域

```jsx | pure
import Tiga from '@fta/tiga'

const storage = Tiga.Storage.getKvStorage({ context })
storage.set({ key: "key", data: "data" })
```

#### Option

| 属性名 | 描述 | 类型   | 默认值 |
| ------ | ---- | ------ | ------ |
| key    | 键   | string | (必填) |
| data   | 值   | any    | (必填) |

### get

从当前存储域获取存储的值

```jsx | pure
import Tiga from '@fta/tiga'

const storage = Tiga.Storage.getKvStorage({ context })
storage.get({ key: "key" })
  .then(res => {
    console.log(res.data)
  })
```

#### Option

| 属性名 | 描述 | 类型   | 默认值 |
| ------ | ---- | ------ | ------ |
| key    | 键   | string | (必填) |

#### SuccessCallbackResult

| 属性名 | 描述 | 类型 |
| ------ | ---- | ---- |
| data   | 值   | any  |

### remove

从当前存储域中移除键值对

```jsx | pure
import Tiga from '@fta/tiga'

const storage = Tiga.Storage.getKvStorage({ context })
storage.remove({ key: "key" })
```

#### Option

| 属性名 | 描述 | 类型   | 默认值 |
| ------ | ---- | ------ | ------ |
| key    | 键   | string | (必填) |

### clear

清空当前存储域

```jsx | pure
import Tiga from '@fta/tiga'

const storage = Tiga.Storage.getKvStorage({ context })
storage.clear()
```

<!-- ## 示例 Demo

<code src='@examples/components/tiga/storage/index.tsx'></code> -->
