---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 位置
  order: 120
title: 总览
order: 0
---

# 定位服务
<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

## 介绍

定位相关，也包括行政区，反解能力。


:::info{title=备注}

1. 定位部分相关能力需要定位权限。
2. 行政区信息依赖后端数据更新。

:::

| 功能                              | 功能描述                         |
| --------------------------------- | ------------------------------ |
| [定位](./location)    | 定位能力  |
| [行政区](./region)  | 行政区数据处理 |


## 作者
<Author name='dongwang.feng' dingTalk='a8bzscv'></Author>

## 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Location
```
