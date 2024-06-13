---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: Push&长连
  order: 130
title: 总览
order: 0
---

# Message push & 长连

<Platform support="thresh,mw" version="1.3.0"></Platform>

## 介绍

push 和长连消息维护模块
提供长连消息监听功能、解除监听功能；
提供 push 消息监听 及 push 通用横幅/通知内容自定义功能。

| 功能                           | 功能描述                 |
| ------------------------------ | ------------------------ |
| [长连](./longconn)             | 长连                     |
| [push 消息处理](./push)        | 接收 push 处理逻辑       |
| [push 暂停、恢复](./pushpause) | 主动暂停、恢复 push 播报 |

## 作者

<Author name="xianming.chang"></Author>

## 引用

```jsx | pure
// Tiga Message API 调用
import Tiga from '@fta/tiga'
// 使用 Tiga.Message.xx 调用 common apis
Tiga.Message
```
