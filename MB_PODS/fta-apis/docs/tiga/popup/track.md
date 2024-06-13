---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 弹窗管控
  order: 150
title: 埋点
order: 4
---


## track
<Platform name="popup" version="1.1.0"></Platform>

### 介绍
埋点

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup.track
```

### 类型

```jsx | pure
(option: TrackProps): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### TrackProps
<API id="Popup_TrackProps"></API>

### 返回
#### TigaGeneral.CallbackResult
<span id="CallbackResult"></span>

| 类型   | 描述      | 类型     |
| ------ | --------- | -------- | 
| code   | 错误 code, 0： 成功， 1：失败 2： 参数错误 | `number` | 
| reason | 错误信息  | `string` |

### 示例

```jsx | pure
Tiga.Popup.track({
  context: context,
  type: 2,
  popupCode: 1234,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
