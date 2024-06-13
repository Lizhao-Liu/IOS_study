---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 视图交互
  order: 60
title: 底部菜单
order: 4
---

# 底部菜单

## [showActionSheet](https://taro-docs.jd.com/docs/apis/ui/interaction/showActionSheet)

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

显示底部操作菜单

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.showActionSheet
```

### 类型

```jsx | pure

(opts: Taro.showActionSheet.Option): Promise<Taro.showActionSheet.SuccessCallbackResult>
```

### 参数

#### Taro.showActionSheet.Option

<API id='UI_TaroShowActionSheetOption'></API>

### 返回

#### Taro.showActionSheet.SuccessCallbackResult

| 属性名   | 描述                                                             | 类型     |
| -------- | ---------------------------------------------------------------- | -------- |
| tapIndex | 用户点击的按钮序号，从上到下的顺序，从 0 开始, -1 表示点击了取消 | `number` |
| errMsg   | 调用结果                                                         | `string` |

### 示例

<code src='@examples/components/tiga/ui/actionsheet/index.tsx'></code>
