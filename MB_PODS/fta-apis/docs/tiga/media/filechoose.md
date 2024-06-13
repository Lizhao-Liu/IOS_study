---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100 
type:
  title: 文件
  order: 4
title: 文件选择
order: 0
---

# 文件选择

:::info{title=说明} 
1. 支持文件选择
2. 功能依赖存储权限，权限由内部统一申请
:::

## chooseFile

<Platform name="media" version="1.0.0"></Platform>

### 介绍

文件选择

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.chooseFile
```

### 类型

```jsx | pure
(opts: ChooseFileOption): Promise<ChooseFileSuccessCallbackResult>
```

### 参数
#### ChooseFileOption

<API id='Media_ChooseFileOption'></API>

### 返回
#### ChooseFileSuccessCallbackResult

<API id='Media_ChooseFileSuccessCallbackResult' hideDefault='true'></API>

#### FileInfo

<API id='Media_FileInfo' hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.chooseFile({
  context,
  mimeTypes: [],
  uniformTypes: [],
  count: 2,
  maxSize: 5000000000,
  success: async (res) => {
    console.log('chooseFile-success', res)
  },
  fail: (res) => {
    console.log('chooseFile-fail', res)
  }
})
```
