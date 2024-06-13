---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100
type:
  title: 图片
  order: 1
title: 图片base64
order: 4
---

# 图片base64

:::info{title=说明}

1. 支持本地图片和 base64 的互转
2. 【android】获取图片 base64 前，需要确保具有图片访问权限，如果图片源已经申请过权限则不需另外申请，比如: 图片源来自图片选择组件时就不需要申请权限
   :::

## getImageBase64

<Platform name="media" version="1.0.0"></Platform>

### 介绍

获取图片 base64

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.getImageBase64
```

### 类型

```jsx | pure
(opts: GetImageBase64Option): Promise<GetImageBase64SuccessCallbackResult>
```

### 参数

#### GetImageBase64Option

<API id="Media_GetImageBase64Option"></API>

### 返回

#### GetImageBase64SuccessCallbackResult

<API id="Media_GetImageBase64SuccessCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.getImageBase64({
  context,
  imagePath: imagePath,
  success: (res) => {
    console.log('getImageBase64-success', res.base64)
  },
  fail: (res) => {
    console.log('getImageBase64-fail', res)
  },
})
```

## saveBase64

<Platform name="media" version="1.0.0"></Platform>

### 介绍

图片 base64 保存到文件

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.saveBase64
```

### 类型

```jsx | pure
(opts: SaveImageBase64Option): Promise<SaveImageBase64SuccessCallbackResult>
```

### 参数

#### SaveImageBase64Option

<API id="Media_SaveImageBase64Option"></API>

### 返回

#### SaveImageBase64SuccessCallbackResult

<API id="Media_SaveImageBase64SuccessCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.saveBase64({
  context,
  base64: imageBase64,
  type: 'jpg',
  success: (res) => {
    console.log('saveBase64-success', res.imagePath)
  },
  fail: (res) => {
    console.log('saveBase64-fail', res)
  },
})
```
