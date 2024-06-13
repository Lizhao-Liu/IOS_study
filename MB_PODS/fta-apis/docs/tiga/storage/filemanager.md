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
title: 获取文件管理实例
order: 2
---

## 文件系统

文件系统提供的一套文件、目录管理接口。通过 Taro.getFileSystemManager() 可以获取到全局唯一的文件系统管理器，所有文件系统的管理操作通过 FileSystemManager 来调用。

业务如果需要主动创建目录、文件，应该使用 Taro.env.USER_DATA_PATH 全局变量来获取根目录，然后进行文件操作。
例如创建一个目录：

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

## [getFileSystemManager](https://docs.taro.zone/docs/apis/files/getFileSystemManager)

<Platform support="thresh,mw,h5,logic" version="1.3.0"></Platform>

### 介绍

获取文件管理器的实例，后续文件操作都需要通过文件管理器实例进行。

### 类型

```jsx | pure
(void) => FileSystemManager
```

无参数
const fileManager = Taro.getFileSystemManager()
