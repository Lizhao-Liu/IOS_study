---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 耗时统计
order: 6
---

# 耗时统计

## beginTransactionTrack

<Platform name="tracker" version="1.0.0"></Platform>

### 介绍

`beginTransactionTrack` 是一个开始跟踪并计算分段耗时的方法，此方法返回一个 Promise 对象，并包含添加分段，结束耗时统计等方法，用于计算分段耗时并将收集到的数据上报到 Hubble & Cosmos 平台。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.beginTransactionTrack
```

### 类型

```jsx | pure
// beginTransactionTrack 方法调用会返回一个 TransactionTracker 类型的 promise:
(action: TransactionTrackBeginAction, trackParam: BaseTrackParam): TransactionTracker
```

```javascript
interface TransactionTracker extends Promise<TransactionTrackBeginCallbackResult> {
  section(action: TransactionTrackSectionAction,trackParam?: Partial<BaseTrackParam>): Promise<any>
  beginIsolatedSection(action: TransactionTrackCommonAction,trackParam?: Partial<BaseTrackParam>): Promise<any>
  endIsolatedSection(action: TransactionTrackCommonAction,trackParam?: Partial<BaseTrackParam>): Promise<any>
  end(action: TransactionTrackCommonAction, trackParam?: Partial<BaseTrackParam>): Promise<any>
}
```

#### **`beginTransactionTrack(action: TransactionTrackBeginAction, trackParam: BaseTrackParam)`**

开始跟踪计算分段耗时

#### **`section(action: TransactionTrackSectionAction, trackParam: BaseTrackParam)`**

添加主分段

#### **`beginIsolatedSection(action: TransactionTrackCommonAction, trackParam: BaseTrackParam)`**

开始独立的分段

#### **`endIsolatedSection(action: TransactionTrackCommonAction, trackParam: BaseTrackParam)`**

结束独立的分段

#### **`end(action: TransactionTrackCommonAction, trackParam: BaseTrackParam)`**

结束耗时统计

### 参数

#### TransactionTrackBeginAction

<API id='Tracker_TransactionTrackBeginAction'></API>

#### BaseTrackParam

<API id='Tracker_BaseTrackParam'></API>

#### TransactionTrackSectionAction

<API id='Tracker_TransactionTrackSectionAction'></API>

#### TransactionTrackCommonAction

<API id='Tracker_TransactionTrackCommonAction'></API>

### 示例

```javascript
let tracker: Tiga.Tracker.TransactionTracker = Tiga.Tracker.beginTransactionTrack(
  {
    metricName: 'performance.pageview',
    path: 'ymm://test/test',
  },
  {
    context: context,
    extraDict: {
      ext1: 'value1',
      ext2: 'value2',
    },
  }
)

tracker.section(
  {
    sectionName: `section${count++}`,
    path: 'ymm://test/test',
  },
  {
    context: context,
    extraDict: {
      ext1: 'value1',
      ext2: 'value2',
    },
  }
)

tracker.beginIsolatedSection(
  {
    sectionName: 'isolated_section',
    path: 'ymm://test/test',
  },
  {
    context: context,
    extraDict: {
      ext1: 'value1',
      ext2: 'value2',
    },
  }
)

tracker.endIsolatedSection(
  {
    sectionName: 'isolated_section',
    path: 'ymm://test/test',
  },
  {
    context: context,
    extraDict: {
      ext1: 'value1',
      ext2: 'value2',
    },
  }
)

tracker.end(
  {
    sectionName: 'end section',
    path: 'ymm://test/test',
  },
  {
    context: context,
    extraDict: {
      ext1: 'value1',
      ext2: 'value2',
    },
  }
)
```
