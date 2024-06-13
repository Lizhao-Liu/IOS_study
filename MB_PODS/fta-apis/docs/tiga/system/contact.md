---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 联系人
order: 4
---

# 联系人

## getAllContacts

<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍

获取所有联系人信息

注： 需要考虑联系人权限，具体查看[权限 API](../permission/intro.md)

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.getAllContacts
```

### 类型

```jsx | pure
(option: ContactsProps): Promise<ContactsResult>
```

### 参数

#### ContactsProps

<API id="System_GetAllContactsProps"></API>

### 返回

#### ContactsResult

| 属性名 | 描述       | 类型                   |
| ------ | ---------- | ---------------------- |
| list   | 联系人数组 | `Array<ContactResult>` |

#### ContactResult

| 属性名          | 描述       | 类型            |
| --------------- | ---------- | --------------- |
| nickName        | 名字       | `string`        |
| phoneNumberList | 所有电话号 | `Array<string>` |

### 示例

```javascript
Tiga.System.getAllContacts({
  context: context,
  permissionRequest: true,
  rationale: '请在设置页中打开该权限',
  topHint: '666',
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

## [chooseContact](https://taro-docs.jd.com/docs/apis/device/contact/chooseContact)

<Platform support="thresh,mw,logic,h5" version='1.1.1' ></Platform>

### 介绍

选择联系人

:::warning{title=备注}

1. !!! phoneNumberList 此参数在端内是数组类型，在端外是字符串。如果需要在端内和端外使用，需要特殊处理。
2. Android 需要考虑联系人权限，具体查看[权限 API](../permission/intro.md)
   :::

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.chooseContact
```

### 类型

```jsx | pure
(opts: Taro.chooseContact.Option): Promise<Taro.chooseContact.SuccessCallbackResult>
```

### 参数

#### Taro.chooseContact.Option

<API id="System_ChooseContactProps"></API>

### 返回

#### [Taro.chooseContact.SuccessCallbackResult](https://taro-docs.jd.com/docs/apis/device/contact/chooseContact#callbackResult)

| 属性名          | 描述             | 类型            |
| --------------- | ---------------- | --------------- |
| phoneNumber     | 手机号           | `string`        |
| displayName     | 联系人姓名       | `string`        |
| phoneNumberList | 联系人的所有电话 | `array<string>` |

### 示例

```javascript
Taro.chooseContact({
  context: context,
  permissionRequest: true,
  rationale: '请在设置页中打开该权限',
  topHint: '666',
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
