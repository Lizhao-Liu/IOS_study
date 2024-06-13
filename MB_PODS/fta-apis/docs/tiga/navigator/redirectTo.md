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
title: 页面重定向
order: 3
---

# 页面重定向

## [redirectTo](https://docs.taro.zone/docs/apis/route/redirectTo)

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

关闭当前页面，跳转到应用内的某个页面

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.redirectTo
```

### 类型

```js
(option: redirectTo.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### redirectTo.Option

<API id='Navigator_RedirectToOption'></API>

### 示例

```javascript
Taro.redirectTo({ url: '/components/overall/overall', context })
```
