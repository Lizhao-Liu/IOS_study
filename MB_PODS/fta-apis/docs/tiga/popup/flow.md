---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 弹窗管控
  order: 150
title: 流程结束
order: 2
---


## finish
<Platform name="popup" version="1.1.0"></Platform>

### 介绍
弹窗结束, 业务必须调用！！！

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup.finish
```

### 类型

```jsx | pure
(option: FinishProps): Promise<TigaGeneral.CallbackResult>
```

### 参数
<API id="Popup_FinishProps"></API>

### 返回
#### TigaGeneral.CallbackResult
<span id="CallbackResult"></span>

| 类型   | 描述      | 类型     | 
| ------ | --------- | -------- | 
| code   | 错误 code, 0： 成功， 1：失败 2： 参数错误 | `number` | 
| reason | 错误信息  | `string` |


### 示例

```jsx | pure
Tiga.Popup.finish({
  context: context,
  popupCode: 1234,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```


