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
title: 保存视频到相册
order: 2
---

# 保存视频到相册

:::info{title=说明}
1. 支持本地视频文件，不支持网络视频
2. 依赖相册权限，权限由内部统一申请
:::


## [saveVideoToPhotosAlbum](https://taro-docs.jd.com/docs/apis/media/video/saveVideoToPhotosAlbum)

<Platform name="media" version='1.0.0' ></Platform>

### 介绍

保存视频到相册

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.saveVideoToPhotosAlbum
```

### 类型

```jsx | pure
(opts: Taro.saveVideoToPhotosAlbum.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数
#### Taro.saveVideoToPhotosAlbum.Option

<API id="Media_TaroSaveVideoToPhotosAlbumOption"></API>

### 返回
#### TaroGeneral.CallbackResult

<API id="TaroGeneralCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.saveVideoToPhotosAlbum({
  context,
  filePath: videPath,
  success: (res) => {
    console.log('saveVideoToPhotosAlbum-success', res)
  },
  fail: (res) => {
    console.log('saveVideoToPhotosAlbum-fail', res)
  },
})
```
