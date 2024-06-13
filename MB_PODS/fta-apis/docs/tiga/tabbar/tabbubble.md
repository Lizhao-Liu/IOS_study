---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 首页Tab
  order: 140
type:
  title: Tab数据&操作
  order: 1
title: 气泡
order: 1
---

## showTabBubble

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

为 tabBar 某一项添加 bubble 气泡
隐藏调用：removeTabBubble

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.showTabBubble
```

### 类型

```jsx | pure
(opts: ShowTabBubbleOption): Promise<TabOperationSuccessResult>
```

### 参数

#### ShowTabBubbleOption

<API id="Tabbar_ShowTabBubbleOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.showTabBubble({
  context: context,
  tabPageName: tabPageName,
  showCloseBtn: showCloseBtn,
  text: bubbleText,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('showTabBubble.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('showTabBubble.success:', res)
  },
})
```

## removeTabBubble

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

移除 tabBar 某一项的 bubble 气泡显示

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.removeTabBubble
```

### 类型

```jsx | pure
(opts: RemoveTabBubbleOption): Promise<TabOperationSuccessResult>
```

### 参数

#### RemoveTabBubbleOption

<API id="Tabbar_RemoveTabBubbleOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.removeTabBubble({
  context: context,
  tabPageName: tabPageName,
  fail(res) {
    console.log('removeTabBubble.fail:', res)
  },
  success(res) {
    console.log('removeTabBubble.success:', res)
  },
})
```
