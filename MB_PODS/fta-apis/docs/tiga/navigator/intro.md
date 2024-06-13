---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 路由导航
  order: 50
title: 总览
order: 0
---

# 路由导航

<Platform name='navigator' version='1.3.0' ></Platform>

## 介绍

路由跳转
:::info{title=说明}
URL 协议<br>

Tiga API 的参数和返回结果，有涉及页面 URL 的，均遵循以下规则：

- 本项目页面，支持识别并默认使用 `this:///${PATH_AND_QUERY}` 。
- 其他 H5 项目页面，支持识别并默认使用 `http(s)` 协议而非 `ymm` 协议的嵌套 URL
- 其他 Thresh 或 Native 项目页面，支持识别并默认使用 `ymm` 协议

:::

| 功能                                   | 具体功能描述                |
| -------------------------------------- | --------------------------- |
| [查询当前页面历史栈](./getAppPages.md) | 查询当前页面历史栈          |
| [回退页面](./pop.md)                   | 回退页面                    |
| [进入新页面](./push.md)                | 进入新页面                  |
| [组合执行页面跳转](./navigate.md)      | 复合 API ，组合执行页面跳转 |
| [页面重定向](./redirectTo.md)          | 页面重定向                  |

## 作者

<Author name="zhanxiang.shi"></Author>

## 引用

```jsx | pure
// Tiga Navigator API 调用
import Tiga from '@fta/tiga'
// 使用 Tiga.Navigator.xx 调用 Navigator apis
Tiga.Navigator

// Taro API 调用
import Taro from '@tarojs/taro'
```

## 初始化

开发者需在 `app.ts` 执行路由导航功能初始化代码。初始化逻辑会开启监听页面变化，以便页面历史栈能及时更新。

```jsx | pure
// app.ts
class App extends Component {
  ...
}

export function onLaunch(context, params) {
  ...
  Tiga.Navigator.initNavigator()
}

export default Tiga.Navigator.withNavigator(App)
```
