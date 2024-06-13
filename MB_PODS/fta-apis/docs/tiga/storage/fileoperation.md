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
title: 文件、目录操作
order: 2
---

## [access](https://docs.taro.zone/docs/apis/files/FileSystemManager#access)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

判断文件/目录是否存在

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.access
```

### 类型

```jsx | pure
(option: AccessOption) => void
```

### 参数

#### AccessOption

<API id="Storage_FileSystemManagerAccessOption"></API>

### 返回

#### AccessFailCallbackResult

| 属性名 | 描述                     | 类型     |
| ------ | ------------------------ | -------- |
| errMsg | 错误信息, 文件目录不存在 | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.access({
  context: context,
  path: Taro.env.USER_DATA_PATH + '/cargobundle/detail',
  success(res) {
    console.log('文件/目录存在: ', res)
  },
  fail(result) {
    console.log('文件/目录不存在: ', result)
  },
})
```

## [mkdir](https://docs.taro.zone/docs/apis/files/FileSystemManager#mkdir)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

创建目录，注意目录名防重复

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.mkdir
```

### 类型

```jsx | pure
(option: MkdirOption) => void
```

### 参数

<API id="Storage_FileSystemManagerMkdirOption"></API>

### 返回

#### MkdirFailCallbackResult

| 属性名 | 描述                                                                                                                                                                                       | 类型     |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| errMsg | 错误信息, no such file or directory 上层目录不存在(当非递归创建时)； Path permission denied 传入的路径没有权限； File name too long 文件名过长(64 字符)； file already exists 已有同名文件 | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.mkdir({
  context: context,
  dirPath: Taro.env.USER_DATA_PATH + '/cargobundle/detail',
  recursive: true,
  success(res) {
    console.log('创建目录成功: ', res)
  },
  fail(result) {
    console.log('创建目录目录失败: ', result)
  },
})
```

## [rmdir](https://docs.taro.zone/docs/apis/files/FileSystemManager#rmdir)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

删除目录

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.rmdir
```

### 类型

```jsx | pure
(option: RmdirOption) => void
```

#### 参数

<API id="Storage_FileSystemManagerRmdirOption"></API>

### 返回

#### RmdirFailCallbackResult

| 属性名 | 描述                                                                                                                                                                               | 类型     |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| errMsg | 错误信息, no such file or directory 文件/目录不存在; 'fail directory not empty': 目录不为空(不递归删除时如果文件夹不为空则会删除失败)；Path permission denied 传入的路径没有权限； | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.rmdir({
  context: context,
  dirPath: Taro.env.USER_DATA_PATH + '/cargobundle/detail',
  recursive: true,
  success(res) {
    console.log('删除目录成功: ', res)
  },
  fail(result) {
    console.log('删除目录目录失败: ', result)
  },
})
```

## [unlink](https://docs.taro.zone/docs/apis/files/FileSystemManager#unlink)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

删除文件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.unlink
```

### 类型

```jsx | pure
(option: UnlinkOption) => void
```

### 参数

<API id="Storage_FileSystemManagerUnlinkOption"></API>

### 返回

#### UnlinkFailCallbackResult

| 属性名 | 描述                                                                                                                                                                                           | 类型     | 默认值 |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------ |
| errMsg | 错误信息, operation not permitted 操作不被允许传入的是一个目录(当删除文件时，如果路径时一个目录 报错)； no such file or directory 文件/目录不存在; Path permission denied 传入的路径没有权限； | `string` | `--`   |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.unlink({
  context: context,
  filePath: Taro.env.USER_DATA_PATH + '/cargobundle/1.mp3',
  success(res) {
    console.log('删除文件成功: ', res)
  },
  fail(result) {
    console.log('删除文件失败: ', result)
  },
})
```

## [readdir](https://docs.taro.zone/docs/apis/files/FileSystemManager#readdir)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

读取目录内文件列表

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.readdir
```

### 类型

```jsx | pure
(option: ReaddirOption) => void
```

### 参数

<API id="Storage_FileSystemManagerReaddirOption"></API>

### 返回

#### ReaddirFailCallbackResult

| 属性名 | 描述                                                                                                                                                               | 类型     |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| errMsg | 错误信息, no such file or directory 文件/目录不存在，或者目标文件路径的上层目录不存在； fail not a directory 不是目录；Path permission denied 传入的路径没有权限； | `string` |

#### ReaddirSuccessCallbackResult

| 属性名 | 描述                                                                                                                                                               | 类型       |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------- |
| files  | 指定目录下的文件名数组                                                                                                                                             | `string[]` |
| errMsg | 错误信息, no such file or directory 文件/目录不存在，或者目标文件路径的上层目录不存在； fail not a directory 不是目录；Path permission denied 传入的路径没有权限； | `string`   |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.readdir({
  context: context,
  dirPath: Taro.env.USER_DATA_PATH + '/cargobundle/detail',
  success(res) {
    console.log('读取制定目录文件名成功: ', res)
  },
  fail(result) {
    console.log('读取制定目录文件名失败: ', result)
  },
})
```

## [copyFile](https://docs.taro.zone/docs/apis/files/FileSystemManager#copyfile)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

复制文件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.copyFile
```

### 类型

```jsx | pure
(option: CopyFileOption) => void
```

### 参数

<API id="Storage_FileSystemManagerCopyFileOption"></API>

### 返回

#### CopyFileFailCallbackResult

| 属性名 | 描述                                                                                                                                                                                                                                                                               | 类型     |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| errMsg | 错误信息, no such file or directory 源文件不存在，或目标文件上级目录不存在(上级目录是文件无法创建时); the maximum size of the file storage limit is exceeded 存储空间不足； illegal operation on a directory, 不可对目录进行此操作； Path permission denied 指定目标路径没有写权限 | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.copyFile({
  context: context,
  srcPath: Taro.env.USER_DATA_PATH + '/cargobundle/1.mp3',
  destPath: Taro.env.USER_DATA_PATH + '/cargobundle/2.mp3',
  success(res) {
    console.log('copy文件成功: ', res)
  },
  fail(result) {
    console.log('copy文件失败: ', result)
  },
})
```

## [rename](https://docs.taro.zone/docs/apis/files/FileSystemManager#rename)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

重命名文件。可以把文件从 oldPath 移动到 newPath

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.rename
```

### 类型

```jsx | pure
(option: RenameOption) => void
```

### 参数

<API id="Storage_FileSystemManagerRenameOption"></API>

### 返回

#### RenameFailCallbackResult

| 属性名 | 描述                                                                                                                                                         | 类型     |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| errMsg | 错误信息, no such file or directory 源文件/目录不存在, 或目标文件上级目录不存在(上级目录是文件无法创建时); Path permission denied 源文件或目标路径没有写权限 | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.rename({
  context: context,
  oldPath: Taro.env.USER_DATA_PATH + '/cargobundle/1.mp3',
  newPath: Taro.env.USER_DATA_PATH + '/cargobundle/2.mp3',
  success(res) {
    console.log('移动文件成功: ', res)
  },
  fail(result) {
    console.log('移动文件失败: ', result)
  },
})
```

## [getFileInfo](https://docs.taro.zone/docs/apis/files/FileSystemManager#getfileinfo)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

获取本地沙盒文件 信息

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.getFileInfo
```

### 类型

```jsx | pure
(option: getFileInfoOption) => void
```

### 参数

<API id="Storage_FileSystemManagerGetFileInfoOption"></API>

### 返回

#### GetFileInfoFailCallbackResult

| 属性名 | 描述                 | 类型     |
| ------ | -------------------- | -------- |
| errMsg | 错误信息, 文件不存在 | `string` |

#### GetFileInfoSuccessCallbackResult

| 属性名 | 描述                   | 类型     |
| ------ | ---------------------- | -------- |
| size   | 文件大小，以字节为单位 | `number` |
| errMsg | 成功                   | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.getFileInfo({
  context: context,
  filePath: Taro.env.USER_DATA_PATH + '/cargobundle/1.mp3',
  success(res) {
    console.log('getFileInfo成功: ', res)
  },
  fail(result) {
    console.log('getFileInfo失败: ', result)
  },
})
```

## [saveFile](https://docs.taro.zone/docs/apis/files/FileSystemManager#savefile)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

小程序实现：保存临时文件到本地。此接口会移动临时文件，因此调用成功后，tempFilePath 将不可用。
端内实现：移动文件，从 tempFilePath 移动到 filePath，且 filePath 字段为必填

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.saveFile
```

### 类型

```jsx | pure
(option: SaveFileOption) => void
```

### 参数

<API id="Storage_FileSystemManagerSaveFileOption"></API>

### 返回

#### SaveFileSuccessCallbackResult

| 属性名 | 描述                                                                                                                                                         | 类型     |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| errMsg | 错误信息, no such file or directory 源文件/目录不存在, 或目标文件上级目录不存在(上级目录是文件无法创建时); Path permission denied 源文件或目标路径没有写权限 | `string` |

#### SaveFileFailCallbackResult

| 属性名        | 描述             | 类型     |
| ------------- | ---------------- | -------- |
| savedFilePath | 存储后的文件路径 | `string` |
| errMsg        | 成功             | `string` |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.saveFile({
  context: context,
  tempFilePath: getPathOne(),
  filePath: getPathTwo(),
  success(res) {
    console.log('保存临时文件成功: ', res)
  },
  fail(result) {
    console.log('保存临时文件失败: ', result)
  },
})
```

## [stat](https://docs.taro.zone/docs/apis/files/FileSystemManager#stat)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

获取文件 Stats 对象

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

FileSystemManager.stat
```

### 类型

```jsx | pure
(option: StatOption) => void
```

### 参数

<API id="Storage_FileSystemManagerStatOption"></API>

### 返回

#### StatFailCallbackResult

| 属性名 | 描述                                                                                        | 类型     |
| ------ | ------------------------------------------------------------------------------------------- | -------- |
| errMsg | 错误信息, no such file or directory 文件不存在; Path permission denied 传入的路径没有权限； | `string` |

#### StatSuccessCallbackResult

| 属性名 | 描述                                                                                                                                                                                             | 类型              |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------- |
| stats  | 当 recursive 为 false 时，res.stats 是一个 Stats 对象。当 recursive 为 true 且 path 是一个目录的路径时，res.stats 是一个 Object，key 以 path 为根路径的相对路径，value 是该路径对应的 Stats 对象 | `Stats or Object` |
| errMsg | 成功                                                                                                                                                                                             | `string`          |

### 示例

```jsx | pure
const fileManager = Taro.getFileSystemManager()
fileManager.stat({
  context: context,
  path: Taro.env.USER_DATA_PATH + '/cargobundle',
  recursive: isRecursive,
  success(res) {
    console.log('获取stat对象成功: ', res)
  },
  fail(result) {
    console.log('获取stat对象失败: ', result)
  },
})
```
