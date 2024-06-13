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
title: 图片预览
order: 1
---

# 图片预览

:::info{title=说明}
1. 支持本地图片、网络图片
2. 【android】本地图片预览时，需要确保具有图片访问权限，如果图片源已经申请过权限则不需另外申请，比如: 图片源来自图片选择组件时就不需要申请权限
:::

## [previewImage](https://taro-docs.jd.com/docs/apis/media/image/previewImage)

<Platform name="media" version='1.0.0' ></Platform>

### 介绍

图片预览

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.previewImage
```

### 类型

```jsx | pure
(opts: Taro.previewImage.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数
#### Taro.previewImage.Option

<API id="Media_TaroPreviewImageOption"></API>

### 返回
#### TaroGeneral.CallbackResult

<API id="TaroGeneralCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.previewImage({
  context,
  urls: imagePaths,
  current: currentImagePath,
  showmenu: true,
})
```
