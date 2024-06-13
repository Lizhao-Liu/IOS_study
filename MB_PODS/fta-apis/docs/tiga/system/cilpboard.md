---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 剪贴板
order: 3
---

# 剪贴板

## [setClipboardData](https://taro-docs.jd.com/docs/apis/device/clipboard/setClipboardData)

<Platform support="thresh,mw,logic,h5" version='1.1.1' ></Platform>

### 介绍

设置粘贴板内容

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.setClipboardData
```

### 类型

```jsx | pure
(opts: Taro.setClipboardData.Option): Promise<Taro.setClipboardData.Promised>
```

### 参数

#### Taro.setClipboardData.Option

<API id="System_SetClipboardDataProps"></API>

### 返回

#### [Taro.setClipboardData.Promised](https://taro-docs.jd.com/docs/apis/device/clipboard/setClipboardData#promised)

`详见 Taro 文档`

### 示例

```javascript
Taro.setClipboardData({
  context: context,
  data: 'hello world',
})
```

## [getClipboardData](https://taro-docs.jd.com/docs/apis/device/clipboard/getClipboardData)

<Platform support="thresh,mw,logic,h5" version='1.1.1' ></Platform>

### 介绍

获取粘贴板内容

:::info{title=备注}
  1. ”设置-隐私-隐私设置-允许平台向您展示赋值信息“ 开关关闭，端内会返回”无权限“的错误。
:::

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getClipboardData
```

### 类型

```jsx | pure
(opts: Taro.getClipboardData.Option): Promise<Taro.getClipboardData.Promised>
```

### 参数

#### Taro.getClipboardData.Option

<API id="System_GetClipboardDataProps"></API>

### 返回

#### [Taro.getClipboardData.Promised](https://taro-docs.jd.com/docs/apis/device/clipboard/getClipboardData#promised)

`详见 Taro 文档`

### 示例

```javascript
Taro.getClipboardData({
  context,
}).then((res) => {
  console.log(res.data) //剪贴板的内容
})
```
