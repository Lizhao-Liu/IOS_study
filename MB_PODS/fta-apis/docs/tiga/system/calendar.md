---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 系统设备
  order: 30
title: 日历
order: 2
---

# 日历

:::info{title=权限说明}

调用日历相关 API 前，调用方需要调用 [权限 API](../permission/intro.md) 检查并请求日历权限
:::

## [addPhoneCalendar](https://taro-docs.jd.com/docs/apis/device/calendar/addPhoneCalendar)

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

向系统日历添加事件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.addPhoneCalendar
```

### 类型

```jsx | pure
(opts: Taro.addPhoneCalendar.Option): Promise<Taro.addPhoneCalendar.SuccessCallbackResult>
```

### 参数

#### Taro.addPhoneCalendar.Option

<API id="System_AddPhoneCalendarProps"></API>

### 返回

#### Taro.addPhoneCalendar.SuccessCallbackResult

以下为扩展字段【仅在 APP 端内生效】

| 属性名   | 描述                             | 类型     |
| -------- | -------------------------------- | -------- |
| eventKey | 【APP 端内生效】日历事件唯一标识 | `string` |

### 示例

```javascript
Taro.addPhoneCalendar({
  title: 'event title',
  description: 'description',
  location: 'location',
  startTime: 1702004804,
  endTime: '1702004904',
  allDay: true,
  alarm: true,
  alarmOffset: 0,
  context,
}).then((res: any) => {
  console.log('添加成功, 事件id:' + res.eventKey)
})
```

## [addPhoneRepeatCalendar](https://taro-docs.jd.com/docs/apis/device/calendar/addPhoneRepeatCalendar)

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

向系统日历添加重复事件

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.addPhoneRepeatCalendar
```

### 类型

```jsx | pure
(opts: Taro.addPhoneRepeatCalendar.Option): Promise<Taro.addPhoneRepeatCalendar.SuccessCallbackResult>
```

### 参数

#### Taro.addPhoneRepeatCalendar.Option

<API id="System_AddPhoneRepeatCalendarProps"></API>

### 返回

#### Taro.addPhoneRepeatCalendar.SuccessCallbackResult

以下为扩展字段【仅在 APP 端内生效】

| 属性名   | 描述                             | 类型     |
| -------- | -------------------------------- | -------- |
| eventKey | 【APP 端内生效】日历事件唯一标识 | `string` |

### 示例

```javascript
Taro.addPhoneRepeatCalendar({
  title: 'event title',
  description: 'description',
  location: 'location',
  startTime: 1702004804,
  endTime: '1702004904',
  allDay: true,
  alarm: true,
  alarmOffset: 0,
  context,
  repeatInterval: 'month',
}).then((res: any) => {
  console.log('添加成功, 事件id:' + res.eventKey)
})
```

## getPhoneCalendarEvent

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

获取系统日历已添加事件

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.getPhoneCalendarEvent
```

### 类型

```jsx | pure
(opts: GetCalendarEventOption): Promise<GetPhoneCalendarEventSuccessCallbackResult>
```

### 参数

#### GetCalendarEventOption

<API id="System_GetCalendarEventProps"></API>

### 返回

#### GetPhoneCalendarEventSuccessCallbackResult

| 属性名         | 描述                                                       | 类型      |
| -------------- | ---------------------------------------------------------- | --------- |
| title          | 日历事件标题                                               | `string`  |
| startTime      | 开始时间的 unix 时间戳 (1970 年 1 月 1 日开始所经过的秒数) | `number`  |
| endTime        | 结束时间的 unix 时间戳 (1970 年 1 月 1 日开始所经过的秒数) | `number`  |
| allDay         | 是否全天事件                                               | `boolean` |
| description    | 事件说明                                                   | `string`  |
| location       | 事件位置                                                   | `string`  |
| alarm          | 是否提醒                                                   | `boolean` |
| alarmOffset    | 提醒提前量，单位分钟                                       | `number`  |
| repeat         | 是否重复                                                   | `boolean` |
| repeatInterval | 重复周期                                                   | `string`  |
| repeatEndTime  | 重复周期结束时间的 unix 时间戳                             | `number`  |

### 示例

```javascript
Tiga.System.getPhoneCalendarEvent({ context, eventKey: 'xxxx' }).then((res: any) => {
  console.log(res)
})
```

## removePhoneCalendarEvent

<Platform support="thresh,mw,logic,h5" version="1.2.0"></Platform>

### 介绍

删除系统日历已添加事件

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.System.removePhoneCalendarEvent
```

### 类型

```jsx | pure
(opts: RemovePhoneCalendarEventOption): Promise<TigaGeneral.CallbackResult>
```

### 参数

#### RemovePhoneCalendarEventOption

<API id="System_RemovePhoneCalendarEventProps"></API>

### 示例

```javascript
Tiga.System.removePhoneCalendarEvent({ context, eventKey: 'xxxx' }).then((res: any) => {
  console.log('删除成功')
})
```
