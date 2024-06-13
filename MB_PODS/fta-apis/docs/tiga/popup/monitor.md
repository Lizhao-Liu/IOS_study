---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 弹窗管控
  order: 150
title: 弹窗监听
order: 3
---


## registerDialogMonitor
<Platform name="popup" version="1.1.0"></Platform>

### 介绍
注册弹窗监听

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup.registerDialogMonitor
```

### 类型

```jsx | pure
(option: RegisterProps): Promise<RegisterDialogMonitorCallBack>
```

### 参数
#### RegisterProps
<API id="Popup_RegisterProps"></API>

#### ShowCallBack

<span id='ShowCallBack'></span>

| 类型      | 描述      | 类型     |
| --------- | --------- | -------- | 
| popupCode | 弹窗 code | `number` |
| data      | 弹窗数据  | `string` | 

### 返回
#### RegisterDialogMonitorCallBack

<span id='RegisterDialogMonitorCallBack'></span>

| 类型     | 描述                   | 类型     | 
| -------- | ---------------------- | -------- | 
| dialogId | 弹窗监听实例的唯一标识, 用于移除或者更新 | `string` |  


### 示例

```jsx | pure
Tiga.Popup.registerDialogMonitor({
  context: context,
  interfaceName: '/test/data2',
  requestParams: {
    recommendrss: {
      d: 'e',
    },
    drivermain: {
      m: 'w',
    },
  },
  pageList: ['recommendrss', 'drivermain'],
  show(data) {
    console.log('展示弹窗')
    console.log(data)
  },
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```



## removeDialogMonitor
<Platform name="popup" version="1.1.0"></Platform>

### 介绍
移除弹窗监听

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup.removeDialogMonitor
```

### 类型

```jsx | pure
(option: RemoveProps): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### RemoveProps
<API id="Popup_RemoveProps"></API>

### 返回
#### TigaGeneral.CallbackResult

| 类型   | 描述      | 类型     | 
| ------ | --------- | -------- | 
| code   | 错误 code, 0： 成功， 1：失败 2： 参数错误 | `number` |  
| reason | 错误信息  | `string` |

### 示例

```jsx | pure
Tiga.Popup.removeDialogMonitor({
  context: context,
  dialogId: popupId,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```



## updateDialogRequestParams
<Platform name="popup" version="1.1.0"></Platform>

### 介绍
更新弹窗请求参数

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup.updateDialogRequestParams
```

### 类型

```jsx | pure
(option: UpdateProps): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### UpdateProps
<API id="Popup_UpdateProps"></API>

### 返回
#### TigaGeneral.CallbackResult

| 类型   | 描述      | 类型     | 
| ------ | --------- | -------- |
| code   | 错误 code,  0： 成功， 1：失败 2： 参数错误 | `number` | 
| reason | 错误信息  | `string` | 


### 示例

```jsx | pure
Tiga.Popup.updateDialogRequestParams({
  context: context,
  dialogId: popupId,
  requestParams: {
    a: 'mmm',
  },
  page: 'mine',
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
