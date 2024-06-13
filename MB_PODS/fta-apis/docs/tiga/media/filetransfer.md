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
title: 文件转码
order: 0
---

# 文件转码

:::info{title=说明}

目前仅 iOS 端支持该 API，仅支持 amr\wav 语音文件互相转换。
如果业务传入目标文件路径，则应确保目标目录存在，即业务自行维护本地目录。

:::

## filetransfer

<Platform name="media" version="1.6.0"></Platform>

### 介绍

文件格式转码
目前仅 iOS 端支持该 API，仅支持 amr\wav 语音文件互相转换。
如果业务传入目标文件路径，则应确保目标目录存在，即业务自行维护本地目录。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.filetransfer
```

### 类型

```jsx | pure
(opts: FileTransferOption): Promise<FileTransferResult>
```

### 参数

#### ChooseFileOption

<API id='Media_FileTransferOption'></API>

### 返回

#### FileTransferResult

<API id='Media_FileTransferResult' hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.Media.filetransfer({
  context: context,
  srcPath: srcPath,
  srcFormat: srcFormat == 'amr' ? 'amr' : 'wav',
  dstPath: dstPath,
  dstFormat: dstFormat == 'wav' ? 'wav' : 'amr',
  success(res) {
    const message = '转码成功' + res.dstPath
    console.log(message)
    Taro.showToast({
      context: context,
      title: message,
    })
  },
  fail(res) {
    const message = '转码失败' + res.reason
    console.log(message)
    Taro.showToast({
      context: context,
      title: message,
    })
  },
})
```
