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
title: Hint提示
order: 1
---

## showTabBarHint

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

为 tabBar 某一项添加 Hint
隐藏调用：removeTabBarHint

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.showTabBarHint
```

### 类型

```jsx | pure
(opts: ShowTabBarHintOption): Promise<TabOperationSuccessResult>
```

### 参数

#### ShowTabBarHintOption

<API id="Tabbar_ShowTabBarHintOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.showTabBarHint({
  context: context,
  tabPageName: tabPageName,
  text: hintText,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('showTabBarHint.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('showTabBarHint.success:', res)
  },
})
```

## removeTabBarHint

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

移除 tabBar 某一项的 hint 显示

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.removeTabBarHint
```

### 类型

```jsx | pure
(opts: RemoveTabBarHintOption): Promise<TabOperationSuccessResult>
```

### 参数

#### RemoveTabBarHintOption

<API id="Tabbar_RemoveTabBarHintOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.removeTabBarHint({
  context: context,
  tabPageName: tabPageName,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('removeTabBarHint.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('removeTabBarHint.success:', res)
  },
})
```
