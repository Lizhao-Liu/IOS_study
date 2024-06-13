---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 弹窗管控
  order: 150
title: 添加数据
order: 1
---

:::info{title=备注}
  1. 单 code 多页面使用：popupCode 和 pageList， 多 code 多页面,需要使用 pageInfoList，pageInfoList 的优先级高。  
  2. isRegisterDialog 为 true 是,业务不需要单独调用 registerDialogMonitor,会内部直接执行此方法. 参数使用的
    是 interfaceName,由于主动注册的情况下,不需要后端参数请求,故不需要 requestParams.
:::


## insertData
<Platform name="popup" version="1.1.0"></Platform>

### 介绍
手动添加弹窗数据

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup.insertData
```

### 类型

```jsx | pure
(option: InsertProps): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### InsertProps
<API id="Popup_InsertProps"></API>

PageInfo

| 属性      | 描述            | 类型     | 是否必选 | 默认值 |
| --------- | --------------- | -------- | -------- | ------ |
| page      | code 对应的页面 | `string` | 是       |        |
| popupCode | 弹窗的 code     | `number` | 是       |        |


#### ShowCallBack
<span id="ShowCallBack"></span>
| 类型   | 描述      | 类型 | 备注 |
| --------- | --------------- | -------- | -------- |
| popupCode	  | 弹窗 code	 | `number`  | `--` |
| data	  | 弹窗数据	| `string` | `--` |

### 返回
#### TigaGeneral.CallbackResult
<span id="CallbackResult"></span>
| 类型   | 描述      | 类型   |
| ------ | --------- | ---------- |
| code   | 错误 code, 0： 成功， 1：失败 2： 参数错误 | `number`  |
| reason | 错误信息  | `string`  |
| data   | isRegisterDialog 为 true 的情况下的返回数据 | [RegisterDialogMonitorCallBack](#RegisterDialogMonitorCallBack) |

#### RegisterDialogMonitorCallBack

<span id='RegisterDialogMonitorCallBack'></span>

| 类型     | 描述                   | 类型     |
| -------- | ---------------------- | -------- | 
| dialogId | 弹窗监听实例的唯一标识, 用于移除或者更新 | `string` |  


### 示例

```jsx | pure
Tiga.Popup.insertData({
  context: context,
  popupCode: 8888,
  interfaceName: '/test/data2',
  data: 'jsonString',
  isRegisterDialog: false,
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


