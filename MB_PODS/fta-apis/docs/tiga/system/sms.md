---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 短信
order: 7
---

# 短信

## sendSms

<Platform support="thresh,mw,logic,h5" version='1.1.0' ></Platform>

### 介绍

发送短信，调起系统发送短信页面进行发送

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.sendSms
```

### 类型

```jsx | pure
(option: SmsProps): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### SmsProps

<API id="System_SendSmsProps"></API>

### 返回

#### TigaGeneral.CallbackResult

| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 参数错误 | `number` |
| reason | 原因                                 | `string` |

### 示例

```javascript
Tiga.System.sendSms({
  context: context,
  phone: '17088843854',
  content: 'hello world, 约基奇',
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
