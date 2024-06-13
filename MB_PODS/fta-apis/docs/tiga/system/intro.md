---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 总览
order: 0
---

# System 系统

<Platform name="system" version='1.0.0' ></Platform>

## 介绍

系统功能

| 功能                         | 具体功能描述                            |
| ---------------------------- | --------------------------------------- |
| [无障碍](./accessibility.md) | 检测是否开启无障碍功能                  |
| [日历](./calendar.md)        | 添加/删除/查找 系统日历事件             |
| [剪贴板](./cilpboard.md)     | 设置/获取粘贴板内容                     |
| [联系人](./contact.md)       | 选择联系人/获取所有联系人信息           |
| [电话](./phone.md)           | 拨打电话、注册/移除电话监听             |
| [屏幕](./screen.md)          | 获取/设置当前屏幕亮度、设置屏幕常亮状态 |
| [短信](./sms.md)             | 发送短信                                |
| [系统](./setting.md)         | 打开系统设置、异步获取系统信息          |
| [震动](./vibrate.md)         | 触发手机长震动/短震动                   |

## 作者

<Author name='dongwang.feng' dingTalk='a8bzscv'></Author>

## 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System
```
