---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: APM
  order: 110
title: 存储空间
order: 3
---

# 存储空间使用情况

## getStorageUsage

<Platform name="apm" version="1.4.0"></Platform>

### 介绍

获取 存储空间 使用情况

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.APM.getStorageUsage
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<GetStorageUsageCallbackResult>):  Promise<GetStorageUsageCallbackResult>
```

### 参数

#### TigaGeneral.Option

<API id='APM_GetStorageUsageOption'></API>

### 返回

#### GetStorageUsageCallbackResult

| 属性名                | 描述                                  | 类型     |
| --------------------- | ------------------------------------- | -------- |
| totalStorageForDevice | 获取设备总存储空间，单位 MB           | `number` |
| availableStorage      | 获取设备的可用存储空间，单位 MB       | `number` |
| totalStorageUsage     | 获取整个设备的使用的存储空间，单位 MB | `number` |

### 示例

```javascript
Tiga.APM.getStorageUsage({ context }).then((res: Tiga.APM.GetStorageUsageCallbackResult) => {
  console.log(res)
})
```
