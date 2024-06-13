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
title: 进入新页面
order: 1
---

# 进入新页面

## push

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

路由获得 url 对应的页面，切换到该页面。通常会新建页面实例，页面历史栈将其入栈。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Navigator.push
```

### 类型

```js
(option: push.Option) => Promise<TigaGeneral.CallbackResult>
```

### 参数

#### push.Option

<API id='Navigator_PushOption'></API>

#### flag 可选常量

##### FLAG_NEW_CONTAINER

```typescript
const FLAG_NEW_CONTAINER: number
```

新页面可选项，要求新页面使用新容器。

##### FLAG_KEEP_CONTAINER

```typescript
const FLAG_KEEP_CONTAINER: number
```

新页面可选项，要求新页面保持当前容器。

##### FLAG_CLEAR_TOP

```typescript
const FLAG_CLEAR_TOP: number
```

新页面可选项。若目标页面已存在于当前页面历史栈，则不新建实例，而是推出栈顶页面直到已存在的目标页面回到栈顶。

### 示例

```jsx {4,15,26} | pure
// 新页面使用新容器
Tiga.Navigator.push({
  url: 'this:///components/tiga/navigator/index',
  flag: Tiga.Navigator.FLAG_KEEP_CONTAINER,
  context: context,
  onResult: (resultData) => {
    console.log('onResult', resultData)
    Taro.showToast({ title: `onResult: ${JSON.stringify(resultData)}` })
  },
})

// 新页面保持当前容器
Tiga.Navigator.push({
  url: 'this:///components/tiga/navigator/index',
  flag: Tiga.Navigator.FLAG_NEW_CONTAINER,
  context: context,
  onResult: (resultData) => {
    console.log('onResult', resultData)
    Taro.showToast({ title: `onResult: ${JSON.stringify(resultData)}` })
  },
})

// 推出栈顶页面直到已存在的目标页面回到栈顶
Tiga.Navigator.push({
  url: 'this:///components/overall/overall',
  flag: Tiga.Navigator.FLAG_CLEAR_TOP,
  context: context,
})
```

## [navigateTo](https://docs.taro.zone/docs/apis/route/navigateTo)

<Platform name='navigator' version='1.3.0' ></Platform>

### 介绍

保留当前页面，跳转到应用内的某个页面

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.navigateTo
```

### 类型

```js
(option: navigateTo.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### navigateTo.Option

<API id='Navigator_NavigateToOption'></API>

### 示例

```javascript
Taro.navigateTo({ url: '/components/tiga/navigator/index', context })
```
