---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 网络
  order: 80
title: 请求
order: 1
---



## request
<Platform support="thresh,mw,logic,h5" version='1.3.0' ></Platform>

### 介绍
网络请求,只支持端内请求。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Network.request
```

### 类型

```jsx | pure
(opts: RequestProps.Option): RequestProps.RequestTask
```

### 参数
#### RequestProps.Option

| 属性名 | 描述 | 类型  | 默认值 | 版本 |
| ----- | ---- | ---- | ---- | ---- |
| url  | 请求的 url	 | `string` | `(必选)` | `--` |
| data  | 请求的参数	 | `object` | `--` | `--` |
| header  | 请求的 header	 | `object` | `--` | `--` |
| timeout  | 超时时间	 | `number` | `--` | `--` |
| method  | 请求方法 GET, POST, 默认为 POST	 | [Method](#Method) | `POST` | `--` |
| encrypted  | 是否加密，测试环境，默认不加密。线上环境会默认加密。	 | `boolean` | `false` | `--` |
| type  | 网络库类型， YMM：运满满， HCB：货车帮， 默认为 YMM	 | [RequestType](#RequestType) | `YMM` | `--` |
| useDispatch  | 是否使用 dispatch 形式请求,货车帮网络库支持, 默认为 false	 | `boolean` | `false` | `--` |
| responseType  | 返回数据的解析格式, 默认为 normal，按照规范返回，其他类型会解析业务错误	 | [ResponseType](#ResponseType) | `normal` | `--` |
| context  | 页面context	 | `any` | `--` | `--` |
| success  | 接口调用成功的回调函数	 | `(res: SuccessCallbackResult) => void` | `--` | `--` |
| fail  | 接口调用失败的回调函数, code: 1 - 失败，2 - 参数错误	 | `(res: CallbackResult) => void` | `--` | `--` |
| complete  | 接口调用结束的回调函数（调用成功、失败都会执行）	 | `(res: CallbackResult \| SuccessCallbackResult \| any) => void	` | `--` | `--` |


#### Method
<span id="Method"></span>
| 取值 | 描述      | 类型     |
| ---- | --------- | -------- |
| GET  | get 请求  | `string` |
| POST | post 请求 | `string` |

#### RequestType
<span id="RequestType"></span>

| 取值 | 描述         | 类型      |
| ---- | ------------ | --------- |
| YMM  | 运满满侧请求 | ` string` |
| HCB  | 货车帮侧请求 | ` string` |

#### ResponseType
<span id="ResponseType"></span>

| 取值    | 描述                                                                                                                                                                                                              | 类型      |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| normal  | 通用的网络数据返回，包含 header，data，statusCode                                                                                                                                                                 | ` string` |
| data    | /\*\* 数据格式为：（原运满满业务）1. result == 1。 2. data 字段有值且类型是字典。 存在逻辑判断，result 为 1 返回正确的数据，否则返回失败，code 取值为 result，reason 取值为 errorMsg                              | ` string` |
| content | /\*\* 数据格式为：（原货车帮业务） 1. status == 'OK' 或者 success == 1。 1. content 字段有值且类型是字典。 存在逻辑判断，status 为 ok 返回正确的数据，否则返回失败，code 取值为 errorCode，reason 取值为 errorMsg | ` string` |

### 返回
#### SuccessCallbackResult

| 取值 | 描述      | 类型     |
| ---- | --------- | -------- |
| data  | 开发者服务器返回的数据  | `any` |
| header | 开发者服务器返回的 HTTP Response Header | `any` |
| statusCode | 开发者服务器返回的 HTTP 状态码 | `number` |


#### RequestProps.RequestTask

请求任务对象

#### RequestTask.abort()

中断网络请求。


### 示例

```jsx | pure
Tiga.Network.request({
  context: context,
  method: 'POST',
  responseType: 'data',
  url: '/ymm-userCenter-app/authenticate/checkCertifyStatus',
  data: {
    sceneId: 2,
  },
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })
```
