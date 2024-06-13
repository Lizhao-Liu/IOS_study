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
title: 图片选择
order: 0
---

# 图片选择

:::info{title=说明} 
1. 支持相册选择图片和相机拍照，拍照支持选择系统相机和自定义相机
2. 压缩策略使用的是鲁班压缩，[压缩算法](https://github.com/Curzibn/Luban/blob/master/DESCRIPTION.md)
3. 功能依赖相册权限和相机权限，权限由内部统一申请
:::

## [chooseImage](https://taro-docs.jd.com/docs/apis/media/image/chooseImage)

<Platform name="media" version='1.0.0'></Platform>

### 介绍

拍摄或从手机相册中选择图片

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.chooseImage
```

### 类型

```jsx | pure
(opts: Taro.chooseImage.Option): Promise<Taro.chooseImage.SuccessCallbackResult>
```

### 参数
#### Taro.chooseImage.Option

<API id="Media_TaroChooseImageOption"></API>

### 返回
#### Taro.chooseImage.SuccessCallbackResult
<API id="Media_TaroChooseImageSuccessCallbackResult" hideDefault='true'></API>

#### Taro.chooseImage.ImageFile
<API id="Media_TaroChooseImageImageFile" hideDefault='true'></API>


### 示例

```jsx | pure
Taro.chooseImage({
  context,
  count: 9,
  sourceType: ['album', 'camera'],
  sizeType: ['compressed'],
  success: (res) => {
    console.log('chooseImage-success', res.tempFiles)
  },
  fail: (res) => {
    console.log('chooseImage-fail', res)
  }
})
```

## chooseAndUploadImage

<Platform name="media" version="1.0.0"></Platform>

### 介绍

拍摄或从手机相册中选择图片并上传阿里云

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.chooseAndUploadImage
```

### 类型

```jsx | pure
(opts: ChooseAndUploadImageOption): Promise<ChooseAndUploadImageSuccessCallbackResult>
```

### 参数
#### ChooseAndUploadImageOption

<API id="Media_ChooseAndUploadImageOption"></API>

### 返回
#### ChooseAndUploadImageSuccessCallbackResult

<API id="Media_ChooseAndUploadImageSuccessCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.chooseAndUploadImage({
  context,
  bizType: 'xxx',
  count: 4,
  sourceType: ['album', 'camera'],
  success: async (res) => {
    console.log('chooseAndUploadImage-success', res.ossUrls)
  },
  fail: (res) => {
    console.log('chooseAndUploadImage-fail', res)
  }
})
```
