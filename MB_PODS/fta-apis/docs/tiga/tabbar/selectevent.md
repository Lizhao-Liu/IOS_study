---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 首页Tab
  order: 140
title: Tabbar选中事件
order: 2
---

## 监听 Tab select 变化事件

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

事件名：MBMainDidSelectTabPage

Tab 选中事件，点击 Tab 以及路由跳转主页触发的 tab 页面切换事件。点击已选中 tab 也会触发该事件。

### 返回

| 属性名            | 描述                                                                                               | 类型     | 版本    |
| ----------------- | -------------------------------------------------------------------------------------------------- | -------- | ------- |
| lastIndex         | 上一个选中的索引                                                                                   | `number` | `--`    |
| lastTabPageName   | 上一个选中的 tabPageName                                                                           | `string` | `--`    |
| selectIndex       | 选中的索引                                                                                         | `number` | `--`    |
| selectTabPageName | 选中的 tabPageName                                                                                 | `string` | `--`    |
| isManualClicked   | 1 是手动点击 Tab 切换；0 路由等其它操作                                                            | `string` | `--`    |
| extParams         | 路由跳转(isManualClicked=0) 且业务传了 ext 参数则携带。Tiga API 1.3.0, 宿主 7.55/8.55 版本开始支持 | `string` | `1.3.0` |

### 示例

```jsx | pure
// 添加监听
eventCenter.addEventListener('MBMainDidSelectTabPage', this.requestEvent)
// 移除监听
eventCenter.removeEventListener('MBMainDidSelectTabPage', this.requestEvent)
```
