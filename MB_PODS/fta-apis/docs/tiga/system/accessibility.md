---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 无障碍
order: 1
---

# 无障碍

:::info{title=说明}

- iOS 上检测是否开启辅助功能旁白
- 安卓上检测是否开启 talkback
  :::

## [checkIsOpenAccessibility](https://taro-docs.jd.com/docs/apis/device/accessibility/checkIsOpenAccessibility)

<Platform support="thresh,mw,logic,h5" version='1.3.0' ></Platform>

### 介绍

检测是否开启无障碍功能

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.checkIsOpenAccessibility
```

### 类型

```jsx | pure
(opts: Taro.checkIsOpenAccessibility.Option): Promise<Taro.checkIsOpenAccessibility.SuccessCallbackResult>
```

### 参数

#### Taro.checkIsOpenAccessibility.Option

<API id="System_AccessibilityProps"></API>

### 返回

#### [Taro.checkIsOpenAccessibility.SuccessCallbackResult](https://taro-docs.jd.com/docs/apis/device/accessibility/checkIsOpenAccessibility#successcallbackresult)

<API id='System_CheckIsOpenAccessibilitySuccessCallbackResult'></API>

### 示例

```javascript
Taro.checkIsOpenAccessibility({
  context,
}).then((res) => {
  console.log(res.open)
})
```
