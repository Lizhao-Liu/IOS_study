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
title: 获取图片信息
order: 3
---

# 获取图片信息

:::info{title=说明}
1. 支持本地图片、网络图片
2. 【android】获取本地图片信息时，需要确保具有图片访问权限，如果图片源已经申请过权限则不需另外申请，比如: 图片源来自图片选择组件时就不需要申请权限
:::

## [getImageInfo](https://taro-docs.jd.com/docs/apis/media/image/getImageInfo)

<Platform name="media" version='1.0.0' ></Platform>

### 介绍

获取图片信息

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getImageInfo
```

### 类型

```jsx | pure
(opts: Taro.getImageInfo.Option): Promise<Taro.getImageInfo.SuccessCallbackResult>
```

### 参数
#### Taro.getImageInfo.Option

<API id="Media_TaroGetImageInfoOption"></API>

### 返回
#### Taro.getImageInfo.SuccessCallbackResult

<API id="Media_TaroGetImageInfoSuccessCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.getImageInfo({
  context,
  src: imagePath,
  success: (res) => {
    console.log('getImageInfo-success', res)
  },
  fail: (res) => {
    console.log('getImageInfo-fail', res)
  },
})
```
