---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: Push&长连
  order: 130
type:
  title: Push推送
  order: 1
title: Push暂停
order: 2
---

# Push 消息处理

:::info{title=说明}

应用内，有些业务页面需要不展示 push 消息横幅，可以调用暂停，离开页面时调用恢复接口。
:::

## pausePush

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

暂停 push 消息处理。注意合适的时机调用恢复接口

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.pausePush
```

### 类型

```jsx | pure
(option: MBPausePushOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBPausePushOption

<API id="Message_MBPausePushOption"></API>

### 返回

#### MBPausePushResult

<API id="Message_MBPausePushResult"></API>

### 示例

```jsx | pure
Tiga.Message.pausePush({
  context: context,
  success(res) {
    console.log('暂停push消息播报队列 success结果: ', res)
  },
  fail(res) {
    console.log('暂停push消息播报队列 fail结果: ', res)
  },
})
```

## resumePush

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

恢复 push 消息处理。暂停和恢复有一一对应关系，恢复时需要传入暂停时获取到的 token 唯一标识。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.resumePush
```

### 类型

```jsx | pure
(option: MBResumePushOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBResumePushOption

<API id="Message_MBResumePushOption"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
Tiga.Message.resumePush({
  context: context,
  token: queuToken,
  success(res) {
    console.log('恢复push消息播报队列 success结果: ', res)
  },
  fail(res) {
    console.log('恢复push消息播报队列 fail结果: ', res)
  },
})
```
