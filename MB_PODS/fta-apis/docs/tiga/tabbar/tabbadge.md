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
title: 角标&小红点
order: 1
---

## showTabBarBadge

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

为 tabBar 某一项的右上角添加 badge 形式文本。
隐藏 badge 调用：hideTabBarBadge

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.showTabBarBadge
```

### 类型

```jsx | pure
(opts: ShowTabBarBadgeOption): Promise<TabOperationSuccessResult>
```

### 参数

#### ShowTabBarBadgeOption

<API id="Tabbar_ShowTabBarBadgeOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.showTabBarBadge({
  context: context,
  tabPageName: tabPageName,
  text: badgeText,
  fail(res) {
    console.log('showTabBarBadge.fail:', res)
  },
  success(res) {
    console.log('showTabBarBadge.success:', res)
  },
})
```

## hideTabBarBadge

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

隐藏 tabBar 某一项右上角的 badge 文本

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.hideTabBarBadge
```

### 类型

```jsx | pure
(opts: HideTabBarBadgeOption): Promise<TabOperationSuccessResult>
```

### 参数

#### HideTabBarBadgeOption

<API id="Tabbar_HideTabBarBadgeOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.hideTabBarBadge({
  context: context,
  tabPageName: tabPageName,
  fail(res) {
    console.log('hideTabBarBadge.fail:', res)
  },
  success(res) {
    console.log('hideTabBarBadge.success:', res)
  },
})
```

## showTabBarRedDot

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

显示 tabBar 某一项的右上角的红点
隐藏小红点调用：removeTabBarRedDot

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.showTabBarRedDot
```

### 类型

```jsx | pure
(opts: ShowTabBarRedDotOption): Promise<TabOperationSuccessResult>
```

### 参数

#### ShowTabBarRedDotOption

<API id="Tabbar_ShowTabBarRedDotOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.showTabBarRedDot({
  context: context,
  tabPageName: tabPageName,
  fail(res) {
    console.log('showTabBarRedDot.fail:', res)
  },
  success(res) {
    console.log('showTabBarRedDot.success:', res)
  },
})
```

## removeTabBarRedDot

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

隐藏 tabBar 某一项的右上角的红点

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.removeTabBarRedDot
```

### 类型

```jsx | pure
(opts: RemoveTabBarRedDotOption): Promise<TabOperationSuccessResult>
```

### 参数

#### RemoveTabBarRedDotOption

<API id="Tabbar_RemoveTabBarRedDotOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.removeTabBarRedDot({
  context: context,
  tabPageName: tabPageName,
  fail(res) {
    console.log('removeTabBarRedDot.fail:', res)
  },
  success(res) {
    console.log('removeTabBarRedDot.success:', res)
  },
})
```
