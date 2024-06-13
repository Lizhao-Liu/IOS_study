---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 路由导航
  order: 50
title: 查询当前页面历史栈
order: 1
---

# 查询当前页面历史栈

## getAppPages

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

查询当前页面历史栈

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Navigator.getAppPages
```

### 类型

```js
(option?: TigaGeneral.Option<getAppPages.CallbackResult>): Promise<getAppPages.CallbackResult>
```

### 参数

<API id='Navigator_GetAppPagesOption'></API>

### 返回

#### getAppPages.CallbackResult

| 属性名 | 描述                                         | 类型     |
| ------ | -------------------------------------------- | -------- |
| pages  | URL 数组，首位对应栈底首页，末位对应栈顶页面 | string[] |

### 示例

```javascript
Tiga.Navigator.getAppPages({ context })
  .then((res) => console.log('getAppPages', res.pages))
  .catch((err) => console.error('getAppPages', err))
```
