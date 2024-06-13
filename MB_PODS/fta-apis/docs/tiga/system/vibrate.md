---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 震动
order: 8
---

# 震动

## [vibrateShort](https://taro-docs.jd.com/docs/apis/device/vibrate/vibrateShort)

<Platform support="thresh,mw,logic,h5" version='1.3.0' ></Platform>

### 介绍

使手机发生较短时间的振动（15 ms）。仅在 iPhone 7 / 7 Plus 以上机型生效，仅 Android 8.0 及以上系统版本支持

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.vibrateShort
```

### 类型

```jsx | pure
(option?: Option) => Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.vibrateShort.Option

<API id="System_VibrateShortProps"></API>

### 返回

#### [Taro.vibrateShort.Promised](https://taro-docs.jd.com/docs/apis/device/clipboard/setClipboardData#promised)

`详见 Taro 文档`

### 示例

```javascript
Taro.vibrateShort({
  context: context,
  type: 'light', //heavy medium light
})
```

## [vibrateLong](https://taro-docs.jd.com/docs/apis/device/vibrate/vibrateLong)

<Platform support="thresh,mw,logic,h5" version='1.3.0' ></Platform>

### 介绍

使手机发生较长时间的振动（400ms）

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.vibrateLong
```

### 类型

```jsx | pure
(option?: Option) => Promise<TaroGeneral.CallbackResult>
```

### 参数

#### Taro.vibrateLong.Option

<API id="System_VibrateLongProps"></API>

### 返回

#### [Taro.vibrateLong.Promised](https://taro-docs.jd.com/docs/apis/device/vibrate/vibrateLong)

`详见 Taro 文档`

### 示例

```javascript
Taro.vibrateLong({ context })
```
