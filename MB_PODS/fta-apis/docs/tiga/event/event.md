---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 事件总线
  order: 20
title: 订阅 / 取消 / 触发事件
order: 1
---

# 订阅 / 取消 / 触发事件

## getEvents

<Platform name="util" version="1.0.0"></Platform>

基于当前 `Context`，获取事件订阅管理器。

当事件监听行为用于前台界面更新时，应使用该方法获得 `Events` 对象。并在组件相应的生命周期函数中，成对地调用 `on(...)` 和 `off(...)` ，避免组件在未挂载状态下监听事件。

```javascript
import Tiga from '@fta/tiga'

const events = TigaGeneral.getEvents(context)
```

#### 类型

```javascript
(context?: any) => Events
```

## eventCenter

<Platform name="util" version="1.0.0"></Platform>

访问项目全局的事件订阅管理器的常量。

当事件监听行为和前台界面无关时，可使用该常量来订阅事件。

```javascript
import Tiga from '@fta/tiga'

const events = TigaGeneral.eventCenter
```

#### 类型

```javascript
const eventCenter: Events
```

## Events

<Platform name="util" version="1.0.0"></Platform>

事件订阅管理器接口

```javascript
import Tiga from '@fta/tiga'

const events = TigaGeneral.getEvents(context)
// const events = TigaGeneral.eventCenter
```

#### 接口定义

<API id='Util_GeneralEvents' hideDefault='true'></API>

### on

订阅事件

``` js
events.on('EVENT_NAME', data => {
  console.log(data)
})
```

#### 类型

``` js
(eventName: string, listener: EventListener) => string
```

### off

取消订阅

变更： 1.1.0 修复 Thresh 无法取消订阅

``` js
const EVENT_NAME_A = 'EVENT_NAME_A'
const token = events.on(EVENT_NAME_A, data => { console.log(data) })
events.off(EVENT_NAME_A, token)

const EVENT_NAME_B = 'EVENT_NAME_B'
const listener = data => { console.log(data) }
events.on(EVENT_NAME_B, listener)
events.off(EVENT_NAME_B, listener)
```

#### 类型

``` js
(eventName: string, token: string): void
(eventName: string, listener: EventListener): void
```

### trigger

触发事件

``` js
events.trigger('EVENT_NAME', data)
```

#### 类型

``` js
(eventName: string, data): void
```

<!-- ## EventListener

<Platform name="util" version="1.0.0"></Platform>

事件触发回调函数的类型定义

#### 类型

```javascript
(eventData: any) => void
``` -->

<!-- ## 示例 Demo

<code src='@examples/components/tiga/event/index.tsx'></code> -->
