---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: APM
  order: 110
title: 总览
order: 0
---

# APM

<Platform name="apm" version="1.4.0"></Platform>

## 介绍

apm 相关功能，包含获取 app 性能数据等

| 功能                     | 具体功能描述                               |
| ------------------------ | ------------------------------------------ |
| [内存](./memory.md)      | 获取内存使用情况、监听系统内存不足告警事件 |
| [存储空间](./storage.md) | 获取存储空间使用情况                       |

## 作者

<Author name="lizhao.liu"></Author>

## 引用

```jsx | pure
// Tiga APM API 调用
import { Tiga } from '@fta/tiga'
// 使用 Tiga.APM.xx 调用 APM apis
Tiga.APM

// Taro APM API 调用
import Taro from '@tarojs/taro'
```
