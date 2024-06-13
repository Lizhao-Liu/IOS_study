---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 全局埋点参数
order: 1
---

# 全局埋点参数

:::info{title=说明}

当前项目全局共用自定义埋点业务参数，调用埋点方法时将自动添加到埋点的 extra 字段中。
:::

## setGlobalExtraParams

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

设置埋点公用业务自定义参数

接受回调形式，在真正埋点的时候读取这个参数。 如果调用埋点方法处业务参数也传入了同样的 key，将覆盖全局的业务参数

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.setGlobalExtraParams
```

### 类型

```jsx | pure
(paramsBlock: () => { [key: string]: any }) : void
```

### 示例

```javascript
Tiga.Tracker.setGlobalExtraParams(() => {
  return {
    global_bundle_key: 'global_bundle_value',
  }
})
```

## getGlobalExtraParams

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

获取埋点公用业务自定义参数

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.getGlobalExtraParams
```

### 类型

```jsx | pure
(void) : { [key: string]: any }
```

### 示例

```javascript
Tiga.Tracker.getGlobalExtraParams()
```

## clearGlobalExtraParams

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

清空埋点公用业务自定义参数

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.clearGlobalExtraParams
```

### 类型

```jsx | pure
(void) : void
```

### 示例

```javascript
Tiga.Tracker.clearGlobalExtraParams()
```
