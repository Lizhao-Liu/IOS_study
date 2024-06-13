---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 营销广告
  order: 160
title: 弹出广告
order: 2
---



## popup
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

弹出广告

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.popup

```

### 类型

```jsx | pure
(option: PopupProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>

```

### 参数
#### PopupProps
<API id="Advertisement_popupProps"></API>



### 返回
#### TigaGeneral.CallbackResult

| 属性名 | 描述                              | 类型     |
| ------ | ------------------------------- | -------- |
| code   | 0 成功 1 参数异常 2 弹框弹出已达到次数限制 3 无广告数据 4 未知异常 | `number` |
| reason | 原因                             | `string` |

### 示例

```jsx | pure

Tiga.Advertisement.popup({
  context: context,
  positionCode: 171,
  success(res) {
    console.log(res)
  },
  fail(err) {
  console.log(err)
  },
})
```
