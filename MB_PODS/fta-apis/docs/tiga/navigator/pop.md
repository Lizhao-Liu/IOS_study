---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 路由导航
  order: 50
type:
  title: 页面跳转
title: 回退页面
order: 0
---

# 回退页面

## pop

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

回退到上一级页面。通常页面历史栈会将栈顶页面推出并关闭。<br>

支持一次回退多级页面，可通过 `getAppPages` 查看当前页面历史栈来决定回退层级，最多可回退到当前栈的栈底首页。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Navigator.pop
```

### 类型

```js
(option: pop.Option) => Promise<TigaGeneral.CallbackResult>
```

### 参数

#### pop.Option

<API id='Navigator_PopOption'></API>

### 示例

```javascript
// 回退一级页面
Tiga.Navigator.pop({ delta: 1, context })

// 回退两级页面
Tiga.Navigator.pop({ delta: 2, context })
```

## popUntil

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

回退页面，直到新的栈顶页面符合条件。<br>
执行时，会依次将当前栈顶页面的 URL 作为参数，回调 `predicate` 判断函数，若判断结果为 `true` 则停止回退，否则重复上述过程，直到回退到当前栈的栈底首页。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Navigator.popUntil
```

### 类型

```js
(option: popUntil.Option) => Promise<TigaGeneral.CallbackResult>
```

### 参数

#### popUntil.Option

<API id='Navigator_PopUntilOption'></API>

### 示例

```javascript
Tiga.Navigator.popUntil({
  predicate: (url: string) => {
    const res = url.startsWith('this:///components/tiga/navigator/alice')
    console.log('predicate', url, res)
    return res
  },
  context: context,
})
```

## [navigateBack](https://docs.taro.zone/docs/apis/route/navigateBack)

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

关闭当前页面，返回上一页面或多级页面。

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.navigateBack
```

### 类型

```js
(option: navigateBack.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### navigateBack.Option

<API id='Navigator_NavigateBackOption'></API>

### 示例

```javascript
Taro.navigateBack({ context })
```
