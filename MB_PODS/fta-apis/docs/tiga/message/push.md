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
title: Push消息处理
order: 0
---

# Push 消息处理

:::info{title=说明}

业务类型推送消息会对应一个 notificationType，业务可以使用 notificationType 注册该类型 push 消息监听，然后做自定义逻辑处理。<br/>
例如以下场景(应用内)<br/>
场景一：业务收到消息后需要展示一个弹框，那么可以在 push 消息进入消息队列之前直接拦截处理，或者消息出队之后处理 显示弹框。<br/>
场景二：业务收到消息后需要展示一个横幅，目前仅支持通用横幅样式

举例：业务需要在收到消息后立即触发一个弹框，需要按以下步骤调用

1. 在 App 启动时调用 registerPush，consumeMode 参数传入 1，注册 push 消息监听，一般在 Global Logic 中进行
2. 在 ReceivePushMessageCallback 回调中处理弹框逻辑。

注意：<br/>
iOS 应用外会展示系统横幅 <br/>
Android App 在后台时需要业务调用 showSystemNotification 来触发通知横幅
:::

## registerPush

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

使用 notificationType 注册 push 消息监听。
一个 notificationType 只能被注册一次，后注册会覆盖前者。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.registerPush
```

### 类型

```jsx | pure
(option: MBPushHandleOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBPushHandleOption

<API id="Message_MBPushHandleOption"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
const receivePushMesssageCallback = useCallback((msg: Tiga.Message.MBPushMessage) => {
  console.log('收到push消息: ', JSON.stringify(msg))
}, [])

useEffect(() => {
  return () => {}
}, [receivePushMesssageCallback])

Tiga.Message.registerPush({
  context: context,
  notificationType: notificationType,
  consumeMode: 1, // 拦截消息，不进入消息处理队列，直接消费
  didReceivePushMessage: receivePushMesssageCallback,
  fail(res) {},
  success(res) {},
})
```

## removePushListen

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

使用 notificationType 解除该类型 push 消息监听。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.removePushListen
```

### 类型

```jsx | pure
(option: MBPushRemoveListenOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBPushRemoveListenOption

<API id="Message_MBPushRemoveListenOption"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
Tiga.Message.removePushListen({
  context: context,
  notificationType: notificationType,
  fail(res) {},
  success(res) {},
})
```

## pushConsume

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

消费 push 消息，可以展示横幅，播放语音。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.pushConsume
```

### 类型

```jsx | pure
(option: MBPushConsumeOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBPushConsumeOption

<API id="Message_MBPushConsumeOption"></API>

#### MBPushNotifiable

<API id="Message_MBPushNotifiable"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
const pushMesssageDequeueCallback = useCallback((msg: Tiga.Message.MBPushMessage) => {
  const pushMsg = new Tiga.Message.MBPushNotifiable(msg)
  Tiga.Message.pushConsume({
    context: context,
    pushId: msg.pushId,
    notifiable: pushMsg,
  })
}, [])

useEffect(() => {
  return () => {}
}, [pushMesssageDequeueCallback])

Tiga.Message.registerPush({
  context: context,
  notificationType: notificationType,
  consumeMode: 0,
  didReceivePushMessage: receivePushMesssageCallback,
  fail(res) {},
  success(res) {},
})
```

## pushQuit

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

结束本条 push 消息消费，push 模块将会继续处理下一条 push 消息。
比如 货源已下架，不需要再展示横幅，可以直接调用 pushQuit 结束 push 消息消费即可。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.pushQuit
```

### 类型

```jsx | pure
(option: MBPushFinishOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBPushFinishOption

<API id="Message_MBPushFinishOption"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
Tiga.Message.pushQuit({
  context: context,
  pushId: msg.pushId,
})
```

## showSystemNotification

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

[Android]端有效。
展示系统通知。该方法一般用于判断 App 在前台展示弹框，判断 App 在后台展示系统通知。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.showSystemNotification
```

### 类型

```jsx | pure
(option: MBNotificationOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBNotificationOption

<API id="Message_MBNotificationOption"></API>

#### MBSystemNotification

<API id="Message_MBSystemNotification"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
const notification = new Tiga.Message.MBSystemNotification(msg)
Tiga.Message.showSystemNotification({
  context: context,
  pushId: msg.pushId,
  notification: notification,
})
```
