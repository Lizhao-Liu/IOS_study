---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100
type:
  title: 音频
  order: 3
title: 音频播放
order: 1
---

# 音频播放

<!-- :::info{title=说明} 
1. 
2. 
::: -->

## createInnerAudioContext

<Platform name="media" version="1.4.1"></Platform>

### 介绍

创建一个音频播放器对象。

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.createInnerAudioContext
```

### 类型

```jsx | pure
() => Taro.InnerAudioContext
```

## InnerAudioContext

### 介绍

音频播放器

仅在应用活跃时播放，Android 对应前台或短暂退至后台时，iOS 对应前台时。

### 属性

:::info{title=部分属性在应用内不生效}
- startTime
- referrerPolicy
- duration
- currentTime
- buffered
- seek
- onTimeUpdate & offTimeUpdate
- onWaiting & offTimeWaiting
- onSeeking & offSeeking
- onSeeked & offSeeked
:::

<API id='Media_TaroInnerAudioContext' hideDefault='true'></API>

#### InnerAudioContext.onErrorDetail

<API id='Media_TaroInnerAudioContextOnErrorDetail' hideDefault='true'></API>

#### InnerAudioContext.onErrorDetailErrCode

<API id='Media_TaroInnerAudioContextOnErrorDetailErrCode' hideDefault='true'></API>

## 示例

```jsx | pure
const audioContext = Taro.createInnerAudioContext()
audioContext.autoplay = true
audioContext.src = 'https://qaimage.ymm56.com/ymmfile/scheduler-driver-voice/20210323/52489de3-746c-4d2b-bd6c-cbd7ddedd94d.mp3'
audioContext.onPlay(() => {
  console.log('开始播放')
})
audioContext.onError((res) => {
  console.log(res.errMsg)
  console.log(res.errCode)
})
```

## 示例 Demo

<code src='@examples/components/tiga/media/audioPlayerBlock.tsx'></code>

