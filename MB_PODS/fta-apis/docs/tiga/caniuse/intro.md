---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: canIUse
  order: 0
title: 总览
order: 0
---

# canIUse

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

## 介绍

可用性检查

| 功能                              | 功能描述                         |
| --------------------------------- | ------------------------------ |
| [Tiga可用性检查](./caniusetiga)    | 检查当前 app 是否支持此 Tiga api 的使用           |
| [业务模块可用性检查](./caniusebizmodule)  | 检查当前 app 所使用的业务模块版本是否满足要求，常用于业务模块之间存在依赖时的检查判断 |


## 作者

<Author name='longbing.you'></Author>

## 引用

```jsx | pure
import Tiga from '@fta/tiga'
// Tiga api 可用性检查
Tiga.canIUseTiga

// 业务模块 可用性检查
Tiga.canIUseBizModule
```
