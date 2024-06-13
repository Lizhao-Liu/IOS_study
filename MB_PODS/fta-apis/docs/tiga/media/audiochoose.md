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
title: 音频选择
order: 0
---

# 音频选择

:::info{title=说明} 
1. 支持音频文件选择
2. 功能依赖存储权限，权限由内部统一申请
:::

## chooseAudio

<Platform name="media" version="1.0.0"></Platform>

### 介绍

音频文件选择

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.chooseAudio
```

### 类型

```jsx | pure
(opts: ChooseAudioOption): Promise<ChooseFileSuccessCallbackResult>
```

### 参数
#### ChooseAudioOption

<API id='Media_ChooseAudioOption'></API>

### 返回
#### ChooseFileSuccessCallbackResult

<API id='Media_ChooseFileSuccessCallbackResult' hideDefault='true'></API>

#### FileInfo

<API id='Media_FileInfo' hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.chooseAudio({
  context,
  types: ['mp3', 'ogg', 'm4a'],
  count: 2,
  maxSize: 1000000000,
  success: (res) => {
    console.log('chooseAudio-success', res)
  },
  fail: (res) => {
    console.log('chooseAudio-fail', res)
  }
})
```
