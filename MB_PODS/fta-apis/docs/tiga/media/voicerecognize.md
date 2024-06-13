---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100
type:
  title: 音频
  order: 3
title: 语音识别
order: 1
---

## startVoiceRecognize

<Platform support="thresh,mw,logic,h5" version='1.2.0' ></Platform>

### 介绍

注册语音识别监听

:::info{title=备注}
开启之后，识别过程，原生发送事件总线:  
duration 单位为 s

```json
{"eventName": "MBVoiceRecognizeContent", "data": {"text": "识别内容"， "code": 0, "reason": "失败原因", "filePath": "缓存路径"， "duration": 10}}
```

监听收到的内容是:

```json
{"text": "识别内容"， "code": 0, "reason": "失败原因", "filePath": "缓存路径"， "duration": 10}

```

code：  
0 识别中  
1 识别结束（超时或主动结束之后，会带有 filePath 和 duration 字段）

10 开始检测到声音 > 0，业务可以处理动画  
11 检测到的声音为 0， 业务可以停止动画  
12 取消识别。

20 识别发生错误  
21 未检测到用户语音（仅 iOS）

注：filePath 和 duration 字段，在主动关闭或者被动关闭的情况下才有, 取消的情况下没有.
:::

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.startVoiceRecognize
```

### 类型

```jsx | pure
(opts: RecognizeOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### RecognizeOption

<API id="Media_RecognizeOption"></API>

#### VoiceRecognizeCallBack

<span id="VoiceRecognizeCallBack"></span>

| 属性名   | 描述                                                                                                                                                                                                                                                                                            | 类型     |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| text     | 识别内容                                                                                                                                                                                                                                                                                        | `string` |
| status   |  0 正常 <br> 1 识别结束（超时或主动结束之后，会带有 filePath 和 duration 字段） <br> 10 开始检测到声音 > 0，业务可以处理动画 <br> 11 检测到的声音为 0 <br> 12 取消识别，这个行为一般发生在启动之前，会调用取消。科大讯飞引擎不会自动结束。 <br> 20 识别发生错误 <br> 21 未检测到用户语音（ios） | `number` |
| reason   | 原因                                                                                                                                                                                                                                                                                            | `string` |
| filePath | 存储音频的本地文件                                                                                                                                                                                                                                                                              | `string` |
| duration | 时长                                                                                                                                                                                                                                                                                            | `number` |

### 返回

#### TigaGeneral.CallbackResult

| 属性名 | 描述                                                    | 类型     |
| ------ | ------------------------------------------------------- | -------- |
| code   | 0：成功， 1：失败 2：参数错误 3  开启失败，已经在监听了 | `number` |
| reason | 原因                                                    | `string` |

### 示例

```jsx | pure
Tiga.Media.startVoiceRecognize({
  context: context,
  callBack: listener2,
  permissionRequest: true,
  topHint: 'hello',
  rationale: 'hello world',
})
  .then((res: any) => {
    console.log(res)
  })
  .catch((err: any) => {
    console.log(err)
  })
```

## stopVoiceRecognize

<Platform support="thresh,mw,logic,h5" version='1.2.0' ></Platform>

### 介绍

停止语音识别监听

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.stopVoiceRecognize
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### TigaGeneral.Option

<API id="TigaGeneralOption_CallbackResult"></API>

#### TigaGeneral.CallbackResult

| 属性名 | 描述                         | 类型     |
| ------ | ---------------------------- | -------- |
| code   | 错误 code, 0：成功， 1：失败 | `number` |
| reason | 原因                         | `string` |

### 示例

```jsx | pure
Tiga.Media.stopVoiceRecognize({
  context: context,
})
  .then((res: any) => {
    console.log(res)
  })
  .catch((err: any) => {
    console.log(err)
  })
```

## cancelVoiceRecognize

<Platform support="thresh,mw,logic,h5" version='1.2.0' ></Platform>

### 介绍

取消语音识别

:::info{title=备注}
移除之后,不会拿到完整的结果,会收到一条 code = 12 的通知.
:::

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Media.cancelVoiceRecognize
```

### 类型

```jsx | pure
(opts: TigaGeneral.Option<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### TigaGeneral.Option

<API id="TigaGeneralOption_CallbackResult"></API>

### 返回

#### TigaGeneral.CallbackResult

| 属性名 | 描述                         | 类型     |
| ------ | ---------------------------- | -------- |
| code   | 错误 code, 0：成功， 1：失败 | `number` |
| reason | 原因                         | `string` |

### 示例

```jsx | pure
Tiga.Media.cancelVoiceRecognize({
  context: context,
})
  .then((res: any) => {
    console.log(res)
  })
  .catch((err: any) => {
    console.log(err)
  })
```
