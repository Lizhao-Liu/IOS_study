---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
title: 总览
order: 0
---

# 通用工具

<Platform name="common" version="1.0.0"></Platform>

## 介绍

通用工具模块, 包含配置下发、前后台事件监听、截屏事件监听功能, Tiga 原生 SDK version 获取等

| 功能                   | 具体功能描述                                                                                                                         |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| [配置下发](./config)             | 配置下发 |
| [截屏监听](./screencapture)      | 截屏监听 |
| [App生命周期](./lifecycle)       | 前后台监听，获取当前前后台状态，退出app |
| [Bundle & 插件](./bundleinfo)   | 获取 Xray Bundle 信息和 android 插件信息 |
| [动态 Action](./dynamicaction)  | 动态 Action 事件监听 |
| [启动信息](./runtimelaunch)      | app 启动信息：进程信息、启动时间以及是否外链启动等 |
| [应用Session](./runtimesession)  | 标识 app 使用的 Session 信息 |
| [设备校准时间](./runtimecurrenttime) | 设备校准时间 | 
| [网络状态](./runtimenetwork) | 当前网络状态 |
| [Tiga版本](./tigasdkversion)  | 获取 app 当前 Tiga 版本 |

## 作者

<Author name="xianming.chang,longbing.you"></Author>

## 引用

```jsx | pure
// Tiga Common API 调用
import Tiga from '@fta/tiga'
// 使用 Tiga.Common.xx 调用 common apis
Tiga.Common

// Taro Common API 调用
import Taro from '@tarojs/taro'
```
