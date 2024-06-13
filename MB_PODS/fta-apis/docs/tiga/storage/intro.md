---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 数据存储
  order: 40
title: 总览
order: 0
---

# 数据存储

<Platform name="storage" version="1.0.0"></Platform>

## 介绍

数据存储，包括 KV 存储，文件管理功能

| 功能                                         | 功能描述                                       |
| -------------------------------------------- | ---------------------------------------------- |
| [KV 存储：项目私有的持久化存储](./kvstorage) | 应用外 H5 和小程序也可使用的项目私有持久化存储 |
| [KV 存储：更多可选择存储域](./kvstoragetiga) | 应用内更多可选择的存储域，如全局共享、临时数据 |
| [获取文件管理实例](./filemanager)            | 获取文件管理器实例                             |
| [文件、目录操作](./fileoperation)            | 创建删除目录，获取文件、目录信息等操作         |
| [文件读写](./filewr)                         | 文件读写，只支持字符串                         |

## 作者

KV 存储：
<Author name="zhanxiang.shi"></Author>
文件管理：
<Author name="xianming.chang"></Author>

## 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Storage
```
