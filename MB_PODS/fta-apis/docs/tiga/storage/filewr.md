---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 数据存储
  order: 40
type:
  title: 文件管理
  order: 1
title: 文件字符串读写
order: 2
---

## [writeFile](https://docs.taro.zone/docs/apis/files/FileSystemManager#writefile)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

写文件, 目前只支持字符串写入文件且只支持 utf8 字符编码，文件大小限制 5M

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.writeFile
```

### 类型

```jsx | pure
(option: WriteFileOption) => void
```

### 参数

<API id="Storage_FileSystemManagerWriteFileOption"></API>

### 返回

#### WriteFileFailCallbackResult

| 属性名 | 描述                                                                                                                                                                                                                                                             | 类型     | 默认值 |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------ |
| errMsg | 错误信息, no such file or directory 文件/目录不存在，或者目标文件路径的上层目录不存在 the maximum size of the file storage limit is exceeded 存储空间不足. 或者 文件超出大小限制(5M)； Path permission denied 没有权限； fail illegal operation on a directory； | `string` | `--`   |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.writeFile({
  context: context,
  filePath: Taro.env.USER_DATA_PATH + '/cargobundle/a.txt',
  data: '测试字符串写入',
  success(res) {
    console.log('写入文件成功: ', res)
  },
  fail(result) {
    console.log('写入文件失败: ', result)
  },
})
```

## [appendFile](https://docs.taro.zone/docs/apis/files/FileSystemManager#appendfile)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

在文件结尾追加内容,目前只支持字符串文本，以 utf8 编码写入文件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.appendFile
```

### 类型

```jsx | pure
(option: AppendFileOption) => void
```

### 参数

<API id="Storage_FileSystemManagerAppendFileOption"></API>

### 返回

#### AppendFileFailCallbackResult

| 属性名 | 描述                                                                                                                                                                                                                                                              | 类型     |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| errMsg | 错误信息, no such file or directory 文件/目录不存在，或者目标文件路径的上层目录不存在； the maximum size of the file storage limit is exceeded 存储空间不足. 或者 文件超出大小限制(5M) ； Path permission denied 没有权限； fail illegal operation on a directory | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.appendFile({
  context: context,
  filePath: Taro.env.USER_DATA_PATH + '/cargobundle/a.txt',
  data: '文件末尾追加字符串',
  success(res) {
    console.log('文件末尾追加内容成功: ', res)
  },
  fail(result) {
    console.log('写文件末尾追加内容失败: ', result)
  },
})
```

## [readFile](https://docs.taro.zone/docs/apis/files/FileSystemManager#readfile)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

读取本地文件内容，目前端内只支持以 utf8 编码读取文件中字符串数据。不支持设置读取位置、读取长度。

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.readFile
```

### 类型

```jsx | pure
(option: ReadFileOption) => void
```

### 参数

<API id="Storage_FileSystemManagerReadFileOption"></API>

### 返回

#### ReadFileFailCallbackResult

| 属性名 | 描述                                                                                                                    | 类型     |
| ------ | ----------------------------------------------------------------------------------------------------------------------- | -------- |
| errMsg | 错误信息, no such file or directory 文件/目录不存在，或者目标文件路径的上层目录不存在； Path permission denied 没有权限 | `string` |

#### ReadFileSuccessCallbackResult

| 属性名 | 描述           | 类型     |
| ------ | -------------- | -------- |
| data   | 文件字符串内容 | `string` |
| errMsg | 成功           | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.readFile({
  context: context,
  filePath: Taro.env.USER_DATA_PATH + '/cargobundle/a.txt',
  success(res) {
    console.log('读取文件成功: ', res)
    setReadFileResult('读取文件内容成功: ' + JSON.stringify(res))
  },
  fail(result) {
    console.log('读取文件失败: ', result)
    setReadFileResult('读取文件内容失败' + JSON.stringify(result))
  },
  complete(res) {
    console.log('读取文件complete: ', res)
  },
})
```
