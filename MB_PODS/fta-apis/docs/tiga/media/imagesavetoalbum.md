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
title: 保存到相册
order: 2
---

# 保存到相册

:::info{title=说明}
1. 支持本地图片、网络图片
2. 依赖相册权限，权限由内部统一申请
:::

## [saveImageToPhotosAlbum](https://taro-docs.jd.com/docs/apis/media/image/saveImageToPhotosAlbum)

<Platform name="media" version='1.0.0'></Platform>

### 介绍

保存图片到系统相册

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Taro.saveImageToPhotosAlbum
```

### 类型

```jsx | pure
(opts: Taro.saveImageToPhotosAlbum.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数
#### Taro.saveImageToPhotosAlbum.Option

<API id="Media_TaroSaveImageToPhotosAlbumOption"></API>

### 返回
#### TaroGeneral.CallbackResult

<API id="TaroGeneralCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.saveImageToPhotosAlbum({
  context,
  filePath: filePath,
  success: (res) => {
    console.log('saveImageToPhotosAlbum-success', res)
  },
  fail: (res) => {
    console.log('saveImageToPhotosAlbum-fail', res)
  },
})
```
