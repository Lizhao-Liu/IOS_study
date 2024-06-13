---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 电话
order: 5
---

# 电话

## onCallStatusChange

<Platform support="thresh,mw,logic,h5" version='1.2.0' ></Platform>

### 介绍

注册电话监听

:::warning{title=备注}
1、(Android)在注册监听的时候，会直接先收到一条 当前状态的回调  
2、(Android)拨出电话和接通 是 一个状态  
3、(Android)在部分机型（如高版本小米），如果拨打电话不是在 App 内直接跳转过去的，系统是不会及时返回状态的，会在用户切回 App 的时候再将经历的状态一起返回。  
4、需要和 `makePhoneCall` 一起使用
:::

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.onCallStatusChange
```

### 类型

```jsx | pure
(option: PhoneObserverOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### PhoneObserverOption

<API id="System_OnCallStatusChangeProps"></API>

### 返回

#### PhoneObserverResult

| 属性名 | 描述                                                | 类型     |
| ------ | --------------------------------------------------- | -------- |
| status | 0: 挂断 1： 接通 2： 来电话了 3： 播出电话 (仅 iOS) | `number` |

#### TigaGeneral.CallbackResult

| 属性名 | 描述                                                          | 类型     |
| ------ | ------------------------------------------------------------- | -------- |
| code   | 错误 code, 0：成功， 1：失败 2：参数错误 3 已经添加过该监听了 | `number` |
| reason | 原因                                                          | `string` |

### 示例

```javascript
const listener: Tiga.System.PhoneObserverCallBack = function (res: any) {
  console.log(`第一个：${JSON.stringify(res)}`)
}
Tiga.System.onCallStatusChange({
  context: context,
  callback: listener,
})
  .then((res) => {
    console.log(res.status)
  })
  .catch((err) => {
    console.log(err)
  })
```

## offCallStatusChange

<Platform support="thresh,mw,logic,h5" version='1.2.0' ></Platform>

### 介绍

移除电话监听

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.offCallStatusChange
```

### 类型

```jsx | pure
(option: PhoneObserverOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### PhoneObserverOption

<API id="System_OnCallStatusChangeProps"></API>

### 返回

#### TigaGeneral.CallbackResult

| 属性名 | 描述                                                          | 类型     |
| ------ | ------------------------------------------------------------- | -------- |
| code   | 错误 code, 0：成功， 1：失败 2：参数错误 3 已经移除过该监听了 | `number` |
| reason | 原因                                                          | `string` |

### 示例

```javascript
Tiga.System.offCallStatusChange({
  context: context,
  callback: listener,
})
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```

## [makePhoneCall](https://taro-docs.jd.com/docs/apis/device/phone/makePhoneCall)

<Platform support="thresh,mw,logic,h5" version='1.1.1' ></Platform>

### 介绍

拨打电话

:::warning{title=备注}
【android 使用字段】是否直接拨出，true: 是，false: 否，默认值为 false，注: 当用户未授予拨打电话权限的情况下仍然进拨号界面，涉及权限：Tiga.Permission.Permissions.phone
:::

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.makePhoneCall
```

### 类型

```jsx | pure
(opts: Taro.makePhoneCall.Option): Promise<Taro.makePhoneCall.PhoneCallbackResult>
```

### 参数

#### Taro.makePhoneCall.Option

<API id="System_MakePhoneCallProps"></API>

### 返回

#### PhoneCallbackResult

在 TaroGeneral.CallbackResult 的基础上扩展了 directCall 字段，此扩展字段【仅在 APP 端内生效】

| 属性名     | 描述                                                  | 类型      |
| ---------- | ----------------------------------------------------- | --------- |
| directCall | 【android 使用字段】是否直接拨出，true: 是，false: 否 | `boolean` |

### 示例

```javascript
Taro.makePhoneCall({
  context: context,
  phoneNumber: '911',
  directCall: true,
  success(res) {
    console.log('success' + JSON.stringify(res))
  },
  fail(res) {
    console.log('fail' + JSON.stringify(res))
  },
  complete(res) {
    console.log('complete' + JSON.stringify(res))
  },
})
```
