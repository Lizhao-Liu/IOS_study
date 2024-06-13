---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 网络
  order: 80
title: 下载
order: 3
---

:::info{title=备注}
下载网络文件到本地。如果不指定 filePath，默认返回临时文件绝对路径 iOS 系统冷启动路径会失效，业务不能缓存该临时路径。如果需要缓存应自己维护本地文件管理，有需要可以查看[文件管理](../storage/filemanager.md)模块文档。
:::

## downloadFile

<Platform support="thresh,mw,logic,h5" version='1.3.0' ></Platform>

### 介绍

下载网络文件文件到本地。

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.downloadFile
```

### 类型

```jsx | pure
(opts: Taro.downloadFile.Option): Promise<Taro.DownloadTask>
```

### 参数

#### Taro.downloadFile.Option

| 属性名   | 描述                                                          | 类型                                                            | 默认值   | 版本 |
| -------- | ------------------------------------------------------------- | --------------------------------------------------------------- | -------- | ---- |
| context  | 【APP 端内生效】页面 context                                  | `any`                                                           | `--`     | `--` |
| url      | 下载资源的 url                                                | `string`                                                        | `(必选)` | `--` |
| filePath | 指定文件下载后存储的路径,如果不指定，默认返回临时文件绝对路径 | `string`                                                        | `--`     | `--` |
| success  | 接口调用成功的回调函数                                        | `(result: Taro.downloadFile.FileSuccessCallbackResult) => void` | `--`     | `--` |
| fail     | 接口调用失败的回调函数                                        | `(res: TaroGeneral.CallbackResult) => void`                     | `--`     | `--` |
| complete | 接口调用结束的回调函数（调用成功、失败都会执行                | `(res: TaroGeneral.CallbackResult) => void`                     | `--`     | `--` |

#### DownloadTask

| 属性名           | 描述         | 类型                                                                   | 默认值 | 版本 |
| ---------------- | ------------ | ---------------------------------------------------------------------- | ------ | ---- |
| abort            | 取消下载方法 | `()=>void`                                                             | `--`   | `--` |
| onProgressUpdate | 进度回调     | `(callback: (progress: OnProgressUpdateCallbackResult) => void)=>void` | `--`   | `--` |

### 返回

#### FileSuccessCallbackResult

| 属性名       | 描述                                                                                     | 类型     | 版本 |
| ------------ | ---------------------------------------------------------------------------------------- | -------- | ---- |
| filePath     | 用户文件路径。传入 filePath 时会返回，跟传入的 filePath 一致                             | `string` | `--` |
| tempFilePath | 临时文件路径。没传入 filePath 指定文件存储路径时会返回，下载后的文件会存储到一个临时文件 | `string` | `--` |
| dataLength   | 数据长度，单位 Byte                                                                      | `number` | `--` |
| errMsg       | 上传结果信息                                                                             | `string` | `--` |

#### OnProgressUpdateCallbackResult

<API id="Network_DownloadTask_OnProgressUpdateCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
const downloadTask = Taro.downloadFile({
  context: context,
  url: fileUrl,
  success(result) {
    console.log('下载文件-success: ', result)
  },
  fail(res) {
    console.log('下载文件-failed: ', res)
  },
})

// 监听下载进度
downloadTask.onProgressUpdate((progress) => {
  setDownprogress(
    '下载进度：' +
      progress.progress +
      ' 总大小: ' +
      progress.totalBytesExpectedToWrite +
      ' 当前下载大小: ' +
      progress.totalBytesWritten
  )
})

// 取消下载
downloadTask.abort()
```
