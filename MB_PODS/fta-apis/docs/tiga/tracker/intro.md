---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 总览
order: 0
---

# 埋点 & 日志

<Platform name="tracker" version="1.0.0"></Platform>

## 介绍

埋点&日志

| 功能                                        | 具体功能描述                                         |
| ------------------------------------------- | ---------------------------------------------------- |
| [全局埋点参数](./globalParams.md)           | 设置埋点公用业务自定义参数                           |
| [页面曝光](./pageView.md)                   | 页面曝光/停留时长埋点                                |
| [区块曝光](./regionExposure.md)             | 区块曝光/停留时长埋点                                |
| [元素曝光](./exposure.md)                   | 元素曝光埋点                                         |
| [点击埋点](./tap.md)                        | 点击控件埋点                                         |
| [清除埋点缓存](./clearCache.md)             | 清除元素曝光埋点缓存                                 |
| [页面耗时](./pageViewPerformance.md)        | 跟踪计算页面加载耗时并上报到 Hubble 平台             |
| [错误数据监控上报](./errorMonitor.md)       | 监控上报异常错误数据到 Hubble 平台                   |
| [性能数据监控上报](./performanceMonitor.md) | 监控上报性能数据到 Hubble 平台                       |
| [网络数据监控上报](./networkMonitor.md)     | 监控上报网络数据到 Hubble 和 Cosmos 大数据平台       |
| [自定义数据监控上报](./monitor.md)          | 监控上报自定义监控数据到 Hubble 或 Cosmos 大数据平台 |
| [离线日志](./log.md)                        | 上报不同等级离线日志                                 |
| [耗时统计](./transaction.md)                | 自定义跟踪并计算分段耗时并上报到 Hubble 平台         |

> 相关链接：
>
> - [前端埋点&监控文档](https://techface.amh-group.com/doc/53): 了解满帮集团移动端的通用埋点技术方案、数据格式、监控&告警配置等
> - [Hubble 平台](https://hubble.amh-group.com/#/feDashboard/grafana): 是一款集成了链路、指标、日志 3 要素的监控平台，为满帮所有基础业务线提供线上用户行为诊断功能

## 作者

<Author name="longbing.you,lizhao.liu"></Author>

## 引用

```jsx | pure
// Tiga Tracker API 调用
import Tiga from '@fta/tiga'
// 使用 Tiga.Tracker.xx 调用 tracker apis
Tiga.Tracker
```
