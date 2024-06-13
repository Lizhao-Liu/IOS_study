---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: APM
  order: 110
title: 内存
order: 2
---

# 内存使用情况

## getMemoryUsage

<Platform name="apm" version="1.4.0"></Platform>

### 介绍

获取 内存 使用情况

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.APM.getMemoryUsage
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<GetMemoryUsageCallbackResult>):  Promise<GetMemoryUsageCallbackResult>
```

### 参数

#### TigaGeneral.Option

<API id='APM_GetMemoryUsageOption'></API>

### 返回

#### GetMemoryUsageCallbackResult

| 属性名               | 描述                                           | 类型     |
| -------------------- | ---------------------------------------------- | -------- |
| appMemoryUsage       | 当前应用使用的内存, 单位(MB)                   | `number` |
| totalMemoryUsage     | 设备上所有应用和系统进程使用的总内存, 单位(MB) | `number` |
| availableMemory      | 剩余可用内存, 单位(MB)                         | `number` |
| totalMemoryForDevice | 获取设备的总物理内存, 单位(MB)                 | `number` |

### 示例

```javascript
Tiga.APM.getMemoryUsage({ context }).then((res: Tiga.APM.GetMemoryUsageCallbackResult) => {
  console.log(res)
})
```

## [onMemoryWarning](https://taro-docs.jd.com/docs/apis/device/memory/onMemoryWarning)

<Platform name="apm" version="1.4.0"></Platform>

### 介绍

监听系统内存不足告警事件。

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.onMemoryWarning
```

### 类型

```jsx | pure

(callback: Callback): void
```

### 参数

| 属性名   | 描述                       | 类型                                                 |
| -------- | -------------------------- | ---------------------------------------------------- |
| callback | 内存不足告警事件的回调函数 | `(res: Taro.onMemoryWarning.CallbackResult) => void` |

### 返回

#### Taro.onMemoryWarning.CallbackResult

| 属性名 | 描述                                                                                                                                                        | 类型     |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| level  | 内存告警等级，只有 Android 才有，对应系统宏定义<br>- 5: TRIM_MEMORY_RUNNING_MODERATE<br>- 10: TRIM_MEMORY_RUNNING_LOW<br>- 15: TRIM_MEMORY_RUNNING_CRITICAL | `number` |

### 示例

```javascript
const listener = function (res: any) {
  console.log('监听到内存告警')
}

Taro.onMemoryWarning(listener)
```

## [offMemoryWarning](https://taro-docs.jd.com/docs/apis/device/memory/offMemoryWarning)

<Platform name="apm" version="1.4.0"></Platform>

### 介绍

取消监听内存不足告警事件。

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.offMemoryWarning
```

### 类型

```jsx | pure

(callback: Callback) => void
```

### 参数

| 属性名   | 描述                             | 类型                                                 |
| -------- | -------------------------------- | ---------------------------------------------------- |
| callback | onMemoryWarning 时传入的监听回调 | `(res: Taro.onMemoryWarning.CallbackResult) => void` |

### 示例

```javascript
Taro.offMemoryWarning(listener)
```
