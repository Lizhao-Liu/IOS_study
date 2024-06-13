---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 营销广告
  order: 160
type:
  title: 埋点（绑定页面）
  order: 0
title: 埋点（事件行为）
order: 3
---

##  tapWithPage 
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点-绑定页面)点击广告

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.tapWithPage
```

### 类型

```jsx | pure
(option: TapProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### TapProps

<API id="Advertisement_tapProps"></API>

### 返回
#### TigaGeneral.CallbackResult

| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.tapWithPage({
  context: context,
  pageSession: 'pageSession',
  advertId: 171,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```


## closeWithPage 
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点)广告所在页面显示

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.closeWithPage
```

### 类型

```jsx | pure
(option: CloseProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### CloseProps
<API id="Advertisement_closeProps"></API>

### 返回
#### TigaGeneral.CallbackResult

| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.closeWithPage({
  context: context,
  pageSession: 'pageSession',
  advertIds: [171, 172],
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```
