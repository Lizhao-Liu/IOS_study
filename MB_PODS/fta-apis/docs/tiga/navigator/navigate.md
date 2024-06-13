---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 路由导航
  order: 50
type:
  title: 页面跳转
title: 组合执行页面跳转
order: 2
---

# 组合执行页面跳转

## navigate

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

复合 API ，用于组合执行 `pop` + `push` 。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Navigator.navigate
```

### 类型

```js
(option: navigate.Option) => Promise<TigaGeneral.CallbackResult>
```

### 参数

#### navigate.Option

<API id='Navigator_NavigateOption'></API>

其中 `Push` / `Pop` / `PopUntil` 参数可参考 [push.Option](./push#pushoption) / [pop.Option](./pop#popoption) / [popUntil.Option](./pop#popuntiloption) 除去公共参数 `context` / `success` / `fail` / `complete` 部分。

### 示例

```javascript
// pop 1 + push 1
Tiga.Navigator.navigate({
  push: { url: 'ymm://app/testpush' },
  pop: { delta: 1 },
  context: context,
})

// pop 2 + push 1
Tiga.Navigator.navigate({
  push: { url: 'this:///components/tiga/navigator/index' },
  pop: { delta: 2 },
  context: context,
})
```
