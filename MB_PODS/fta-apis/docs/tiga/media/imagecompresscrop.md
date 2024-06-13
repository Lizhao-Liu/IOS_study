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
title: 压缩裁剪
order: 5
---

# 压缩裁剪

:::info{title=说明}
1. 只支持本地图片，不支持网络图片
2. 【android】压缩裁剪前，需要确保具有图片访问权限，如果图片源已经申请过权限则不需另外申请，比如: 图片源来自图片选择组件时就不需要申请权限
:::

## [compressImage](https://taro-docs.jd.com/docs/apis/media/image/compressImage)

<Platform name="media" version='1.0.0' ></Platform>

### 介绍

压缩图片，可选压缩质量

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.compressImage
```

### 类型

```jsx | pure
(opts: Taro.compressImage.Option): Promise<Taro.compressImage.SuccessCallbackResult>
```

### 参数
#### Taro.compressImage.Option

<API id="Media_TaroCompressImageOption"></API>

### 返回
#### Taro.compressImage.SuccessCallbackResult

<API id="Media_TaroCompressImageSuccessCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.compressImage({
  context,
  src: imagePath,
  quality: 80,
  compressedWidth: 200,
  success: async (res) => {
    console.log('compressImage-success', res.tempFilePath)
  },
  fail: (res) => {
    console.log('compressImage-fail', res)
  }
})
```

## [cropImage](https://taro-docs.jd.com/docs/apis/media/image/cropImage)

裁剪图片

<Platform name="media" version='1.0.0' ></Platform>

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.cropImage
```

### 类型

```jsx | pure
(opts: Taro.cropImage.Option): Promise<Taro.cropImage.SuccessCallbackResult>
```

### 参数
#### Taro.cropImage.Option

<API id="Media_TaroCropImageOption"></API>

### 返回
#### Taro.cropImage.SuccessCallbackResult

<API id="Media_TaroCropImageSuccessCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.cropImage({
  context,
  src: imagePath,
  cropScale: '1:1',
  success: async (res) => {
    console.log('cropImage-success', res.tempFilePath)
  },
  fail: (res) => {
    console.log('cropImage-fail', res)
  }
})
```
