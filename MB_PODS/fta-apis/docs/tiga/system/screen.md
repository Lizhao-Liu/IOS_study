---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 屏幕
order: 6
---

# 屏幕

## [setScreenBrightness](https://taro-docs.jd.com/docs/apis/device/screen/setScreenBrightness)

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

设置屏幕亮度

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.setScreenBrightness
```

### 类型

```jsx | pure
(opts: Taro.setScreenBrightness.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.setScreenBrightness.Option

<API id="System_SetScreenBrightnessProps"></API>

### 示例

```javascript
Taro.setScreenBrightness({ value: 0.5, context }).then((res: any) => {
  console.log('亮度设置成功')
})
```

## [getScreenBrightness](https://taro-docs.jd.com/docs/apis/device/screen/getScreenBrightness)

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

获取屏幕亮度

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.getScreenBrightness
```

### 类型

```jsx | pure
(opts: Taro.getScreenBrightness.Option): Promise<Taro.getScreenBrightness.SuccessCallbackOption>
```

### 参数

#### Taro.getScreenBrightness.Option

<API id="System_GetScreenBrightnessProps"></API>

### 返回

#### [Taro.getScreenBrightness.SuccessCallbackOption](https://taro-docs.jd.com/docs/apis/device/screen/getScreenBrightness#successcallbackoption)

`详见 Taro 文档`

### 示例

```javascript
Taro.getScreenBrightness({ context }).then((res: any) => {
  console.log('屏幕亮度' + res.value.toFixed(1))
})
```

## [setKeepScreenOn](https://taro-docs.jd.com/docs/apis/device/screen/setKeepScreenOn)

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

设置当前页面是否保持常亮状态

:::info{title=说明}

- 【APP 端】设置屏幕常亮状态仅在当前容器有效，当关闭当前容器后，之前设置的常亮状态会恢复
- 【APP 端】为确保屏幕常亮状态能够在页面切换情况下正常展示，需要在当前页面每次重新显示会触发的生命周期方法内调用设置当前页面屏幕常亮状态

:::

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.setKeepScreenOn
```

### 类型

```jsx | pure
(opts: Taro.setKeepScreenOn.Option): Promise<Taro.setKeepScreenOn.Promised>
```

### 参数

#### Taro.setKeepScreenOn.Option

<API id="System_SetKeepScreenOnProps"></API>

### 返回

#### [Taro.setKeepScreenOn.Promised](https://taro-docs.jd.com/docs/apis/device/screen/setKeepScreenOn#promised)

`详见 Taro 文档`

### 示例

```javascript
Taro.setKeepScreenOn({ keepScreenOn: true, context }).then((res: any) => {
  console.log('已设置为常亮')
})
```
