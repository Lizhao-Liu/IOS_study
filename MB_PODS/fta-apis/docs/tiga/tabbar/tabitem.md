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
title: Item处理
order: 1
---

## updateTabbarItem

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

持久修改 tabBar 某一项的内容，支持修改图片、标题，图片只支持网络路径；
修改成功后 App 下次启动依旧有效;
重置修改调用：resetTabBarItem

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.updateTabbarItem
```

### 类型

```jsx | pure
(opts: UpdateTabbarItemOption): Promise<TabOperationSuccessResult>
```

### 参数

#### UpdateTabbarItemOption

<API id="Tabbar_UpdateTabbarItemOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.updateTabbarItem({
  context: context,
  tabPageName: tabPageName,
  text: updateItemTitle,
  iconPath: updateItemIcon,
  selectIconPath: updateItemSelectIcon,
  iconAnimate: true,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('updateTabbarItem.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('updateTabbarItem.success:', res)
  },
})
```

## resetTabBarItem

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

重置对 tabBar 某一项的内容持久修改，重置为 tab 基础数据内容。
和 updateTabbarItem 配对使用。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.resetTabBarItem
```

### 类型

```jsx | pure
(opts: ResetTabBarItemOption): Promise<TabOperationSuccessResult>
```

### 参数

#### ResetTabBarItemOption

<API id="Tabbar_ResetTabBarItemOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.resetTabBarItem({
  context: context,
  tabPageName: tabPageName,
  immediately: true,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('resetTabBarItem.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('resetTabBarItem.success:', res)
  },
})
```

## updateTempTabBarItem

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

临时修改 tabBar 某一项的内容，支持修改图片、标题，图片只支持网络路径。
临时修改在下次 App 启动时无效。
重置临时修改调用：resetTempTabBarItem
适用场景：比如列表页上滑的时候修改 tab 内容为 “返回顶部” 等业务场景。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.updateTempTabBarItem
```

### 类型

```jsx | pure
(opts: UpdateTempTabBarItemOption): Promise<TabOperationSuccessResult>
```

### 参数

#### UpdateTempTabBarItemOption

<API id="Tabbar_UpdateTempTabBarItemOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     |
| ------ | -------------------------------------------------------------- | -------- |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` |
| reason | 成功或失败原因                                                 | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.updateTempTabBarItem({
  context: context,
  tabPageName: tabPageName,
  text: tempItemTitle,
  iconPath: tempItemIcon,
  selectIconPath: tempItemSelectIcon,
  iconAnimate: true,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('updateTempTabBarItem.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('updateTempTabBarItem.success:', res)
  },
})
```

## resetTempTabBarItem

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

重置对 tabBar 某一项的临时内容修改，重置为 tab 基础数据内容。
和 updateTempTabBarItem 配对使用。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.resetTempTabBarItem
```

### 类型

```jsx | pure
(opts: ResetTempTabBarItemOption): Promise<TabOperationSuccessResult>
```

### 参数

#### ResetTempTabBarItemOption

<API id="Tabbar_ResetTempTabBarItemOption"></API>

### 返回

#### TabOperationSuccessResult

| 属性名 | 描述                                                           | 类型     | 默认值 |
| ------ | -------------------------------------------------------------- | -------- | ------ |
| code   | 结果码 0 成功，1 参数错误，2 目标 tab 不存在，100 其它原因失败 | `number` | `--`   |
| reason | 成功或失败原因                                                 | `string` | `--`   |

### 示例

```jsx | pure
Tiga.Tabbar.resetTempTabBarItem({
  context: context,
  tabPageName: tabPageName,
  iconAnimate: true,
  fail(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('resetTempTabBarItem.fail:', res)
  },
  success(res) {
    Taro.showToast({ title: res.reason ?? '' })
    console.log('resetTempTabBarItem.success:', res)
  },
})
```
