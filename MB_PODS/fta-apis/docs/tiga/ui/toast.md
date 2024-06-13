---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 视图交互
  order: 60
title: 轻提示
order: 1
---

# toast 提示

:::info{title=说明}

- 全局维护单个消息提示框，新的消息提示框会替换之前的消息提示框
- Taro.showToast 应与 Taro.hideToast 配对使用
- 在 app 端内, Taro.showLoading 和 Taro.showToast 可同时显示，toast 和 loading 相关接口不可相互混用
- 在 app 端外, Taro.showLoading 和 Taro.showToast 同时只能显示一个，toast 和 loading 相关接口可相互混用
  :::

## [showToast](https://taro-docs.jd.com/docs/apis/ui/interaction/showToast)

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

显示消息提示框

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.showToast
```

### 类型

```jsx | pure

(opts: Taro.showToast.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.showToast.Option

<API id='UI_TaroShowToastOption'></API>

### 示例

```javascript
// 纯文本 toast
Taro.showToast({
  title: '提示标题',
  icon: 'none',
  context,
})

// 成功 toast
Taro.showToast({
  title: '成功',
  icon: 'success',
  context,
})

// 自定义图标
Taro.showToast({
  title: '标题',
  image: 'https://imagecdn.ymm56.com/ymmfile/static/image/trade/success.png', // 自定义图标url
  toastType: 1, //左边图标,右边文本
  context,
})

// 1.5秒后自动隐藏
Taro.showToast({
  title: '标题',
  duration: 1500,
  context,
}).catch((e) => {
  console.log(e)
})
```

## [hideToast](https://taro-docs.jd.com/docs/apis/ui/interaction/hideToast)

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

隐藏消息提示框

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.hideToast
```

### 类型

```jsx | pure

(opts: Taro.hideToast.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.hideToast.Option

| 属性名   | 描述                                             | 类型                          | 默认值 | 版本 |
| -------- | ------------------------------------------------ | ----------------------------- | ------ | ---- |
| context  | 页面 context【仅在 app 端内生效】                | any                           | --     | --   |
| complete | 接口调用结束的回调函数（调用成功、失败都会执行） | (res: CallbackResult) => void | --     | --   |
| fail     | 接口调用失败的回调函数                           | (res: CallbackResult) => void | --     | --   |
| success  | 接口调用成功的回调函数                           | (res: CallbackResult) => void | --     | --   |

### 示例

```javascript
Taro.hideToast({
  context,
})
```

## 示例 Demo

<code src='@examples/components/tiga/ui/toast/index.tsx'></code>
