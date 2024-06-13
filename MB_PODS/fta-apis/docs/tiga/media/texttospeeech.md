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
title: 语音合成
order: 3
---

# 语音合成

<!-- :::info{title=说明} 
1. 
2. 
::: -->

## getSpeaker

<Platform name="media" version="1.4.1"></Platform>

### 介绍

获取语音合成播放器对象。

该对象为代理对象，Native 侧实现为单例，即实际播放效果可能受其他业务调用影响。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.getSpeaker
```

### 类型

```jsx | pure
() => Tiga.Media.Speaker
```

## Speaker

### 介绍

语音合成播放器接口

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.Speaker
```

### 属性

<API id='Media_Speaker' hideDefault='true'></API>

#### Speaker.Speak.Option

<API id='Media_SpeakerSpeakOption'></API>

#### Speaker.Speak.CallbackResult

<API id='Media_SpeakerSpeakCallbackResult' hideDefault='true'></API>

## 示例

```jsx | pure
const speaker = Tiga.Media.getSpeaker()
speaker.speak({ text: '这是合成语音' })
```

## 示例 Demo

<code src='@examples/components/tiga/media/textSpeakerBlock.tsx'></code>

