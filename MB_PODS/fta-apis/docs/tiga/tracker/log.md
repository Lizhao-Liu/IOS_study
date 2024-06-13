---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 离线日志
order: 5
---

# 离线日志

## infoLog

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报信息类型日志

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.infoLog
```

### 类型

```javascript
((opts: LogOptions)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### LogOptions

<API id='Tracker_LogOptions'></API>

### 示例

```javascript
Tiga.Tracker.infoLog({ tag: 'log_tag', message: 'this is a message', context })
```

## debugLog

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报 debug 类型日志

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.debugLog
```

### 类型

```javascript
((opts: LogOptions)) : Promise<TigaGeneral.CallbackResult>
```

### 参数

#### LogOptions

<API id='Tracker_LogOptions'></API>

### 示例

```javascript
Tiga.Tracker.debugLog({
  tag: 'log_debug_tag',
  message: 'this is a debug message',
  context,
})
```

## warningLog

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报警告类型日志

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.warningLog
```

### 类型

```javascript
((opts: LogOptions)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### LogOptions

<API id='Tracker_LogOptions'></API>

### 示例

```javascript
Tiga.Tracker.warningLog({
  tag: 'log_warning_tag',
  message: 'this is a warning message',
  context,
})
```

## errorLog

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

上报错误类型日志

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.errorLog
```

### 类型

```javascript
((opts: LogOptions)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### LogOptions

<API id='Tracker_LogOptions'></API>

### 示例

```javascript
Tiga.Tracker.errorLog({
  tag: 'log_error_tag',
  message: 'this is an error message',
  context,
})
```

## fatalLog

<Platform name="tracker" version="1.4.0"></Platform>

### 介绍

上报 fatal 类型日志

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.fatalLog
```

### 类型

```javascript
((opts: LogOptions)): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### LogOptions

<API id='Tracker_LogOptions'></API>

### 示例

```javascript
Tiga.Tracker.fatalLog({
  tag: 'log_fatal_tag',
  message: 'this is a fatal message',
  context,
})
```
