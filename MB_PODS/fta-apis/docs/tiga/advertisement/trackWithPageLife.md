---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 营销广告
  order: 160
type:
  title: 埋点（绑定页面）
  order: 1
title: 埋点（lifecycle)
order: 3
---


## pageAppear
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点)广告所在页面显示


### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.pageAppear
```

### 类型

```jsx | pure
(option: PageLifeProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### PageLifeProps
<API id="Advertisement_pageLifeProps"></API>

### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |

### 示例

```jsx | pure
Tiga.Advertisement.pageAppear({
  context: context,
  pageSession: 'pageSession',
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```


## visibleOnPage
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点-绑定页面)广告所在视图可见

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.visibleOnPage
```

### 类型

```jsx | pure
(option: VisibleProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### VisibleProps
<API id="Advertisement_visibleProps"></API>

#### AdModel
<span id="adModel"><span>
| 属性名           | 描述                                                                                  | 类型     | 默认值   |
| ---------------- | ------------------------------------------------------------------------------------- | -------- | -------- |
| advertId         | 广告 id                                                                               | `number` | `(必选)` |
| positionCode     | 位置 id                                                                               | `string` | `(必选)` |
| advertMetricInfo | 智能投放埋点字段                                                                      | `string` | `--`     |
| pictureUrl       | 广告图片 url, 图片广告必填                                                            | `string` | `--`     |
| url              | 如果是 h5 广告表示广告 h5 页面 url, h5 广告必填；如果是非 h5 广告表示广告点击跳转地址 | `string` | `--`     |
| text             | 文本广告文本内容, 文本广告必填                                                        | `string` | `--`     |


### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.visibleOnPage({
  context: context,
  pageSession: '2222',
  adviewType: 1,
  adModel: m,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```

## invisibleOnPage 
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点)广告所在页面显示


### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.invisibleOnPage
```

### 类型

```jsx | pure
(option: InVisibleProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### InVisibleProps
<API id="Advertisement_inVisibleProps"></API>

### 返回
#### TigaGeneral.CallbackResult

| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.invisibleOnPage({
  context: context,
  pageSession: 'pageSession',
  advertId: 171,
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```


##  pageDisappear
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点)广告所在页面离开

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.pageDisappear
```

### 类型

```jsx | pure
(option: PageLifeProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### PageLifeProps
<API id="Advertisement_pageLifeProps"></API>


### 返回
#### TigaGeneral.CallbackResult
| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.pageDisappear({
  context: context,
  pageSession: 'pageSession',
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```


## pageDestroy 
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍
(广告埋点)广告所在页面销毁

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.pageDestroy
```

### 类型

```jsx | pure
(option: PageLifeProps<TigaGeneral.CallbackResult>): Promise<TigaGeneral.CallbackResult>
```

### 参数
#### PageLifeProps

<API id="Advertisement_pageLifeProps"></API>

### 返回
#### TigaGeneral.CallbackResult

| 属性名 | 描述                                 | 类型     |
| ------ | ------------------------------------ | -------- |
| code   | 错误 code, 0 成功，1 失败 2 缺少参数 | `number` |
| reason | 原因                                 | `string` |

### 示例

```jsx | pure
Tiga.Advertisement.pageDestroy({
  context: context,
  pageSession: 'pageSession',
  success(res) {
    console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```

