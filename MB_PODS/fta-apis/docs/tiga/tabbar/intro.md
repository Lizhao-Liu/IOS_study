---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 首页Tab
  order: 140
title: 总览
order: 0
---

# Tabbar tabbar

<Platform name="tabbar" version="1.0.0"></Platform>

## 介绍

主页 Tab 操作, 如在 tabbar 上显示小红点、数字 badge 等; 以及可以更改 tabbar icon 和标题显示。

| 功能                           | 功能描述                                        |
| ------------------------------ | ----------------------------------------------- |
| [tab 选中事件](./selectevent)  | tab 切换以及路由跳转到主页，触发 tab 选择事件   |
| [tab 角标、小红点](./tabbadge) | tab 角标                                        |
| [气泡](./tabbubble)            | tab 上方气泡                                    |
| [hint 提示](./tabhint)         | tab hint 提示                                   |
| [tabItem 处理](./tabitem)      | 修改 tabitem 图标、标题，支持临时修改、持久修改 |
| [获取 tab 数据](./tabbar)      | 获取当前 tab 数据                               |

## 作者

<Author name="xianming.chang"></Author>

## 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar
```
