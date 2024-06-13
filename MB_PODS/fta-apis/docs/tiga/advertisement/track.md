---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 营销广告
  order: 160
title: 埋点
order: 3
---


## show
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

(埋点)展示广告

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.show
```

### 类型

```jsx | pure
(option: LogProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### LogProps

<API id="Advertisement_logProps"></API>

### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.show({
  context: context,
  adId: 2333,
  positionCode: 255655,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})

```


## tap
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

(埋点)点击广告

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.tap
```

### 类型

```jsx | pure
(option: LogProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### LogProps

<API id="Advertisement_logProps"></API>

### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.tap({
  context: context,
  adId: 2333,
  positionCode: 255655,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```



## close 
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

(埋点)关闭广告


### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.close
```

### 类型

```jsx | pure
(option: LogProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### LogProps

<API id="Advertisement_logProps"></API>

### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.close({
  context: context,
  adId: 2333,
  positionCode: 255655,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```




## stay 
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

(埋点)广告停留时长

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.stay
```

### 类型

```jsx | pure
(option: StayLogProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### StayLogProps
<API id="Advertisement_stayLogProps"></API>

### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.stay({
  context: context,
  adId: 2333,
  positionCode: 255655,
  duration: 23,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```
