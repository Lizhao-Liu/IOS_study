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
title: 加水印
order: 6
---

# 图片加水印

:::info{title=说明}
1. 只支持本地图片加水印，不支持网络图片
2. 支持加文字水印和图片水印，支持 图片四个角上以及斜45度平铺 的水印样式
3. 【android】加水印前，需要确保具有图片访问权限，如果图片源已经申请过权限则不需另外申请，比如: 图片源来自图片选择组件时就不需要申请权限
:::

## watermark

<Platform name="media" version="1.2.0"></Platform>

### 介绍

图片加水印

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.watermark
```

### 类型

```jsx | pure
(opts: WatermarkOption): Promise<WatermarkSuccessCallbackResult>
```

### 参数

#### WatermarkOption

<API id="Media_WatermarkOption"></API>

#### WatermarkSource

<API id="Media_WatermarkSource"></API>

#### WatermarkConfig

<API id="Media_WatermarkConfig"></API>

### 返回

#### WatermarkSuccessCallbackResult

<API id="Media_WatermarkSuccessCallbackResult" hideDefault='true'></API>

#### WatermarkResultImageFile

<API id="Media_WatermarkResultImageFile" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.watermark({
  context,
  sources: [
    {
      imagePath: imagePath,
      markConfigs: [
        {
          textMark: '水印文案',
          pos: 'right-bottom',
        },
        {
          textMark: '仅供满帮会员认证',
          pos: 'tiled',
        },
      ],
    }
  ],
  success: (res) => {
    console.log('watermark-success', res.files)
  },
  fail: (res) => {
    console.log('watermark-fail', res)
  }
})
```

## locationWatermark

<Platform name="media" version="1.2.0"></Platform>

### 介绍

图片加位置水印，包含时间和位置信息，位置信息优先取图片拍摄位置，取不到则取用户当前定位信息

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.locationWatermark
```

### 类型

```jsx | pure
(opts: LocationWatermarkOption): Promise<WatermarkSuccessCallbackResult>
```

### 参数
#### LocationWatermarkOption

<API id="Media_LocationWatermarkOption"></API>

#### LocationWatermarkSource

<API id="Media_LocationWatermarkSource"></API>

### 返回
#### WatermarkSuccessCallbackResult

<API id="Media_WatermarkSuccessCallbackResult" hideDefault='true'></API>

#### WatermarkResultImageFile

<API id="Media_WatermarkResultImageFile" hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.locationWatermark({
  context,
  sources: [
    {
      imagePath: imagePath,
    }
  ],
  success: (res) => {
    console.log('locationWatermark-success', res.files)
  },
  fail: (res) => {
    console.log('locationWatermark-fail', res)
  },
})
```
