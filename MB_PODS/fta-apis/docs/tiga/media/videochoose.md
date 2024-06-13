---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100
type:
  title: 视频
  order: 2
title: 视频/图片选择
order: 0
---

# 视频/图片选择

:::info{title=说明} 
1. 支持视频和图片的选择，支持相册选择和相机拍摄
2. 图片压缩策略使用的是鲁班压缩，[压缩算法](https://github.com/Curzibn/Luban/blob/master/DESCRIPTION.md)
3. 功能依赖相册权限和相机权限，权限由内部统一申请
:::

## [chooseMedia](https://taro-docs.jd.com/docs/apis/media/video/chooseMedia)

<Platform name="media" version='1.0.0' ></Platform>

### 介绍

拍摄或从手机相册中选择图片或视频

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.chooseMedia
```

### 类型

```jsx | pure
(opts: Taro.chooseMedia.Option): Promise<Taro.chooseMedia.SuccessCallbackResult>
```

### 参数
#### Taro.chooseMedia.Option

<API id="Media_TaroChooseMediaOption"></API>

### 返回
#### Taro.chooseMedia.SuccessCallbackResult

<API id="Media_TaroChooseMediaSuccessCallbackResult" hideDefault='true'></API>

#### Taro.chooseMedia.ChooseMedia

<API id="Media_TaroChooseMediaChooseMedia" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.chooseMedia({
  context,
  count: 4,
  mediaType: ['video']
  sourceType: ['album', 'camera'],
  maxDuration: 20,
  success: async (res) => {
    console.log('chooseMedia-success', res.tempFiles)
  },
  fail: (res) => {
    console.log('chooseMedia-fail', res)
  }
})
```
