---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 网络
  order: 80
title: 上传
order: 2
---

:::info{title=备注}
上传本地文件到服务器。

如果上传多个文件 有一个失败整个上传任务为失败。
业务侧如果需要持久缓存不要使用 url 绝对路径，绝对路径可能会失效。
文件服务文档：https://techface.amh-group.com/doc/773 若需要申请 bizType，文件服务后台地址： dev：https://dev-boss.amh-group.com/public-service-admin/#/fileCenter/bizTypeManageList qa：https://qa-boss.amh-group.com/public-service-admin/#/fileCenter/bizTypeManageList prd：https://boss.amh-group.com/public-service-admin/#/fileCenter/bizTypeManageList
:::

## uploadFiles

<Platform support="thresh,mw,logic,h5" version='1.0.0' ></Platform>

### 介绍

上传本地文件到服务器。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Network.uploadFiles
```

### 类型

```jsx | pure
(opts: Upload.UploadTaskOption): Upload.UploadTask
```

### 参数

#### UploadTaskOption

| 属性名    | 描述                                                                | 类型                                                  | 默认值   | 版本 |
| --------- | ------------------------------------------------------------------- | ----------------------------------------------------- | -------- | ---- |
| ossServer | 上传 OSS 服务方，默认 1，可选 1(阿里 oss)、2(华为 obs)              | `number`                                              | `--`     | `--` |
| timeout   | 超时时间，单位毫秒                                                  | `number`                                              | `--`     | `--` |
| files     | 文件对应的 key，开发者在服务端可以通过这个 key 获取文件的二进制内容 | `UploadFileInfo[]	`                                    | `(必选)` | `--` |
| context   | 页面 context                                                        | `any`                                                 | `--`     | `--` |
| success   | 上传成功的回调函数                                                  | `(res: UploadSuccessResult) => void`                  | `--`     | `--` |
| fail      | 上传失败的回调函数 超时: code 1001                                  | `(res: CallbackResult) => void`                       | `--`     | `--` |
| complete  | 上传结束的回调函数（上传成功、失败都会执行）                        | `(res: CallbackResult \| UploadSuccessResult)=> void` | `--`     | `--` |

#### UploadFileInfo

| 属性名     | 描述                                                                                                 | 类型     | 默认值   |
| ---------- | ---------------------------------------------------------------------------------------------------- | -------- | -------- |
| bizType    | oss bizType, oss 桶                                                                                  | `string` | `(必须)` |
| localPath  | 文件本地路径                                                                                         | `string` | `(必选)` |
| specifyKey | 上传指定路径（宿主 8.55/7.55，tiga 1.3.0 版本新增）,路径必须是完整 path，ymmfile/业务 oss 桶/文件名, |

例 1：ymmfile/ios-package/68910796-2d36-452f-b6bd-82fe1b7a98e9
例 2：ymmfile/ios-package/68910796-2d36-452f-b6bd-82fe1b7a98e9.jpg | `string`| `--` |
| fileExtensionName | 文件扩展名, 如果不传将会从 localPath 中解析扩展名 | `string` | `(必选)` |

#### UploadTask

| 属性名           | 描述         | 类型                                                       | 默认值   |
| ---------------- | ------------ | ---------------------------------------------------------- | -------- |
| abort            | 取消下载方法 | `()=>void`                                                 | `--`     |
| onProgressUpdate | 进度回调     | `(callback: (progress: TaskProgressResult) => void)=>void` | `(必选)` |

### 返回

#### TaskProgressResult

| 属性名  | 描述                           | 类型     |
| ------- | ------------------------------ | -------- |
| percent | 上传进度变化 progress: 0 ~ 100 | `number` |

#### UploadSuccessResult

| 属性名      | 描述                                                                  | 类型            |
| ----------- | --------------------------------------------------------------------- | --------------- |
| code        | 成功失败 code                                                         | `number`        |
| reason      | 成功失败描述                                                          | `string`        |
| ossUrls     | [废弃字段！！！]网络 url 绝对路径数组，绝对路径。请使用 `ossFileList` | `string[]`      |
| ossFileList | 上传结果信息                                                          | `OSSFileInfo[]` |

#### OSSFileInfo

| 属性名      | 描述                                      | 类型     |
| ----------- | ----------------------------------------- | -------- |
| absoluteUrl | 网络 url 绝对路径，即完成路径 https://xxx | `string` |
| ossKey      | 相对路径                                  | `string` |

### 示例

```jsx | pure
const uploadtask = Tiga.Network.uploadFiles({
  context: context,
  timeout: 120,
  files: [
    {
      bizType: bizType,
      localPath: localPath,
    },
  ],
  success(res) {
    Taro.showToast({ context: context, title: res.reason ?? '上传成功' })
    console.log('uploadFiles success: ', res.ossFileList[0].absoluteUrl)
  },
  fail(res) {
    Taro.showToast({ context: context, title: res.reason ?? '上传失败' })
    console.log('uploadFiles fail: ', res)
  },
})

// 监听进度
uploadtask.onProgressUpdate((progress) => {
  // 设置进度
  setUploadProgress(progress.percent)
  console.log('uploadFiles 进度监听, 上传进度 progress: ', progress.percent)
})
```
