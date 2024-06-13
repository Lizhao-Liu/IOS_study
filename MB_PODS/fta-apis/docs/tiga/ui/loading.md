---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 视图交互
  order: 60
title: 加载中提示
order: 2
---

# loading 提示

:::info{title=说明}

- 全局维护单个加载中提示框，新的记载中提示框会替换之前的加载中提示框
- Taro.showLoading 应与 Taro.hideLoading 配对使用
- 在 app 端内, Taro.showLoading 和 Taro.showToast 可同时显示，toast 和 loading 相关接口不可相互混用
- 在 app 端外, Taro.showLoading 和 Taro.showToast 同时只能显示一个，toast 和 loading 相关接口可相互混用
  :::

## [showLoading](https://taro-docs.jd.com/docs/apis/ui/interaction/showLoading)

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

显示 loading 提示框。需主动调用 Taro.hideLoading 才能关闭提示框

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.showLoading
```

### 类型

```jsx | pure

(opts: Taro.showLoading.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.showLoading.Option

<API id="UI_TaroShowLoadingOption"></API>

### 示例

```javascript
Taro.showLoading({
  title: '加载中',
  mask: true,
  context,
})
```

## [hideLoading](https://taro-docs.jd.com/docs/apis/ui/interaction/hideLoading)

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

隐藏 loading 提示框

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.hideLoading
```

### 类型

```jsx | pure

(opts: Taro.hideLoading.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.hideLoading.Option

<API id="UI_TaroHideLoadingOption"></API>

### 示例

```javascript
Taro.hideLoading({ context })
```

## Demo 示例

<code src='@examples/components/tiga/ui/loading/index.tsx'></code>
