---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: Push&长连
  order: 130
title: 长连
order: 1
---

# 长连

:::info{title=说明}

监听长连消息，多个业务可以监听同一个消息类型。
注意：

1. 解除监听时如果不传函数实例则会移除 opType 对应的所有监听者。
2. 添加监听时，注意页面刷新不能造成监听函数实例变更

:::

## registerLongConnListen

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

使用 opType 注册长链消息监听，注意回调监听函数必填。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.registerLongConnListen
```

### 类型

```jsx | pure
(option: MBLongConnHandleOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBLongConnHandleOption

<API id="Message_MBLongConnHandleOption"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
const receiveLongConnCallback = useCallback(
    (res:any) => {
      console.log('收到长链消息: ', res.opType, ', longConnMsg:', res)
    },
    []
  )
useEffect(() => {
  return () => {
  }
}, [receiveLongConnCallback])

Tiga.Message.registerLongConnListen({
  context: context,
  opType: opType,
  receiveMessageCallback: receiveLongConnCallback
  complete(res) {
    console.log('注册opType监听 complete结果: ', res)
  },
})
```

## removeLongConnListen

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 介绍

解除长链消息监听。
注意：解除监听时需要传入监听时同一函数实例;
解除监听时如果不传函数实例则会移除 opType 对应的所有监听者。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Message.removeLongConnListen
```

### 类型

```jsx | pure
(option: MBRemoveLongConnListenOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### MBRemoveLongConnListenOption

<API id="Message_MBRemoveLongConnListenOption"></API>

### 返回

#### TigaGeneral.CallbackResult

<API id="TigaGeneralOption_CallbackResult"></API>

### 示例

```jsx | pure
// 添加长连监听
const receiveLongConnCallback = useCallback((res: any) => {
  console.log('收到长链消息: ', res.opType, ', longConnMsg:', res)
  const result = '收到长链消息:' + JSON.stringify(res)
  Taro.showToast({
    context: context,
    title: result,
  })
}, [])

useEffect(() => {
  return () => {
    // 解除监听
  }
}, [receiveLongConnCallback])

Tiga.Message.registerLongConnListen({
  context: context,
  opType: opType,
  receiveMessageCallback: receiveLongConnCallback,
  complete(res) {
    console.log('注册opType监听 complete结果: ', res)
    const result = '注册长链结果:' + JSON.stringify(res)
    Taro.showToast({
      context: context,
      title: result,
    })
  },
})

// 根据监听函数实例移除单个监听
Tiga.Message.removeLongConnListen({
  context: context,
  opType: opType,
  receiveMessageCallback: receiveLongConnCallback,
  success(res) {
    console.log('解除注册opType success结果: ', res)
  },
  fail(res) {
    console.log('解除注册opType fail结果: ', res)
  },
})
```
