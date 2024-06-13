---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 埋点日志
  order: 70
title: 页面耗时
order: 3
---

# 页面耗时

:::info{title=说明}

PageViewPerformanceTracker

- 通过调用不同页面加载节点方法，根据不同节点的调用时机自动计算页面分段的加载耗时，并将该耗时数据添加到埋点数据中。
- 最终，调用 end 方法将触发埋点数据的上报。

PageViewPerformanceCustomTracker

- 自定义不同页面加载分段的起始时间和结束时间，通过传入的起始时间和结束时间计算页面分段的加载耗时，并将该耗时数据添加到埋点数据中。
- 最终，调用 end 方法将触发埋点数据的上报。

页面耗时埋点最终上报数据结构参考[页面体验监控-数据格式设计](https://wiki.amh-group.com/pages/viewpage.action?pageId=575957498#id-%E9%A1%B5%E9%9D%A2%E4%BD%93%E9%AA%8C%E7%9B%91%E6%8E%A7%E6%95%B0%E6%8D%AE%E6%A0%BC%E5%BC%8F%E8%AE%BE%E8%AE%A1-4%E3%80%81%E9%A1%B5%E9%9D%A2%E5%93%8D%E5%BA%94)

:::

## PageViewPerformanceTracker

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

`PageViewPerformanceTracker` 是一个设计用于跟踪页面组件生命周期中页面加载耗时指标的类。<br>
自动计算页面分段耗时并将监控数据上报到 Hubble 平台。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.PageViewPerformanceTracker
```

### 类型

```javascript
class PageViewPerformanceTracker {
    constructor(options: PageViewPerformanceTrackerConfigOption);
    begin(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>;
    pageLoad(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>;
    pageFirstLayout(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>;
    pageSecondLayout(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>;
    pageCustomIsolatedSection(option: PageViewPerformanceTrackOptionWithTimestamp, sectionName: string): Promise<TigaGeneral.CallbackResult>;
    end(option: PageViewPerformanceTrackOption, lastPageSectionName?: string): Promise<TigaGeneral.CallbackResult>;
}
```

#### **`constructor(options: PageViewPerformanceTrackerConfigOption)`**

构造函数，生成 PageViewPerformanceTracker 类型的实例。通过该实例，可以调用内部方法来跟踪页面加载过程中不同节点的耗时

#### **`begin(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>`**

开始跟踪页面性能

#### **`pageLoad(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>`**

页面加载（画布 load）完成

#### **`pageFirstLayout(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>`**

页面第一次（定义为页面骨架）绘制完成，即 FCP

#### **`pageSecondLayout(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>`**

页面大部分绘制完成 即（FMP-FCP）

#### **`end(option: PageViewPerformanceTrackOption, lastPageSectionName = 'page_interactive_prepare'): Promise<TigaGeneral.CallbackResult>`**

结束页面耗时跟踪统计,可设置 lastPageSectionName 参数自定义最后一段分段名称

#### **`pageCustomIsolatedSection(option: PageViewPerformanceTrackOptionWithTimestamp, sectionName: string): Promise<TigaGeneral.CallbackResult>`**

添加自定义起始、结束时间的独立分段

### 参数

#### PageViewPerformanceTrackerConfigOption

<API id='Tracker_PageViewPerformanceTrackerConfigOption'></API>

#### PageViewPerformanceTrackOption

| 属性名    | 描述                                     | 类型                                              | 默认值 |
| --------- | ---------------------------------------- | ------------------------------------------------- | ------ |
| extraDict | 每个页面节点上报数据时自定义的的业务参数 | ` { [key: string]: any }`                         | `--`   |
| tags      | 埋点上报标签                             | `{ [key: string]: number  \| string \| boolean }` | `--`   |

#### PageViewPerformanceTrackOptionWithTimestamp

| 属性名    | 描述                                     | 类型                                              | 默认值 |
| --------- | ---------------------------------------- | ------------------------------------------------- | ------ |
| extraDict | 每个页面节点上报数据时自定义的的业务参数 | ` { [key: string]: any }`                         | `--`   |
| tags      | 埋点上报标签                             | `{ [key: string]: number  \| string \| boolean }` | `--`   |
| beginAt   | 自定义开始点                             | `number`                                          | `--`   |
| endAt     | 自定义结束点                             | `number`                                          | `--`   |

### 示例

```javascript
let pageTracker = new Tiga.Tracker.PageViewPerformanceTracker({
  path: 'pagePath',
  pageName: 'pageName',
  extraDict: { common_page_key: 'common_page_value' },
  context,
})

pageTracker.begin({
  extraDict: { begin_key: 'begin_value' },
  tags: {
    begin_tag: 0,
  },
})

pageTracker.pageLoad({
  extraDict: { page_load_key: 'page_load_value' },
  tags: {
    page_load_tag: 'page_load_tag_value',
  },
})

pageTracker.pageFirstLayout({
  extraDict: { first_layout_key: 'first_layout_value' },
  tags: {
    first_layout_tag: true,
  },
})

pageTracker.pageSecondLayout({
  extraDict: { second_layout_key: 'second_layout_value' },
  tags: {
    second_layout_tag: false,
  },
})

pageTracker.pageCustomIsolatedSection(
  {
    extraDict: { custom_section_key: 'custom_section_value' },
    tags: {
      custom_section_tag: 2000,
    },
    beginAt: 1702004804,
    endAt: 1702004828,
  },
  'page_custom_section'
)

pageTracker.end(
  {
    extraDict: { tti_key: 'tti_value' },
    tags: {
      tti_tag: 'tti_tag_value',
    },
  },
  'your_last_section_name'
)
```

## PageViewPerformanceCustomTracker

<Platform name="tracker" version="1.3.0"></Platform>

### 介绍

自定义页面加载阶段不同分段的 (beginAt, endAt) 起始时间和结束时间并将监控数据上报到 Hubble 平台。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tracker.PageViewPerformanceCustomTracker
```

### 类型

```javascript
class PageViewPerformanceCustomTracker extends PageViewPerformanceTracker {
  constructor(options: PageViewPerformanceTrackerConfigOption);
  begin(option: PageViewPerformanceTrackOption): Promise<TigaGeneral.CallbackResult>;
  pageLoad(option: PageViewPerformancePageLoadTrackOptionWithTimestamp): Promise<TigaGeneral.CallbackResult>;
  pageFirstLayout(option: PageViewPerformancePageLoadTrackOptionWithTimestamp): Promise<TigaGeneral.CallbackResult>;
  pageSecondLayout(option: PageViewPerformancePageLoadTrackOptionWithTimestamp): Promise<TigaGeneral.CallbackResult>;
  pageCustomIsolatedSection(option: PageViewPerformanceTrackOptionWithTimestamp, sectionName: string): Promise<TigaGeneral.CallbackResult>;
  end(option: PageViewPerformancePageLoadTrackOptionWithTimestamp, lastPageSectionName?: string): Promise<TigaGeneral.CallbackResult>;
}
```

不同方法说明介绍同上 [PageViewPerformanceTracker](#pageviewperformancetracker)

### 参数

#### PageViewPerformanceTrackerConfigOption

<API id='Tracker_PageViewPerformanceTrackerConfigOption'></API>

#### PageViewPerformanceTrackOption

| 属性名    | 描述                                     | 类型                                              | 默认值 |
| --------- | ---------------------------------------- | ------------------------------------------------- | ------ |
| extraDict | 每个页面节点上报数据时自定义的的业务参数 | ` { [key: string]: any }`                         | `--`   |
| tags      | 埋点上报标签                             | `{ [key: string]: number  \| string \| boolean }` | `--`   |

#### PageViewPerformanceTrackOptionWithTimestamp

| 属性名    | 描述                                     | 类型                                              | 默认值 |
| --------- | ---------------------------------------- | ------------------------------------------------- | ------ |
| extraDict | 每个页面节点上报数据时自定义的的业务参数 | ` { [key: string]: any }`                         | `--`   |
| tags      | 埋点上报标签                             | `{ [key: string]: number  \| string \| boolean }` | `--`   |
| beginAt   | 自定义开始点                             | `number`                                          | `--`   |
| endAt     | 自定义结束点                             | `number`                                          | `--`   |

### 示例

```javascript
let pageTrackerWithTimestamps = new Tiga.Tracker.PageViewPerformanceCustomTracker({
  path: 'pagePath',
  pageName: 'pageName',
  extraDict: { common_page_key: 'common_page_value' },
  context,
})

pageTrackerWithTimestamps.begin({
  extraDict: { begin_key: 'begin_value' },
  tags: {
    begin_tag: 0,
  },
})

pageTrackerWithTimestamps.pageLoad({
  extraDict: { page_load_key: 'page_load_value' },
  tags: {
    page_load_tag: 'page_load_tag_value',
  },
  beginAt: 1702004704,
  endAt: 1702004728,
})

pageTrackerWithTimestamps.pageFirstLayout({
  extraDict: { first_layout_key: 'first_layout_value' },
  tags: {
    first_layout_tag: true,
  },
  beginAt: 1702004728,
  endAt: 1702004748,
})

pageTrackerWithTimestamps.pageSecondLayout({
  extraDict: { second_layout_key: 'second_layout_value' },
  tags: {
    second_layout_tag: false,
  },
  beginAt: 1702004748,
  endAt: 1702004768,
})

pageTrackerWithTimestamps.pageCustomIsolatedSection(
  {
    extraDict: { custom_section_key: 'custom_section_value' },
    tags: {
      custom_section_tag: 2000,
    },
    beginAt: 1702004734,
    endAt: 1702004760,
  },
  'page_custom_section'
)

pageTrackerWithTimestamps.end(
  {
    extraDict: { tti_key: 'tti_value' },
    tags: {
      tti_tag: 'tti_tag_value',
    },
    beginAt: 1702004768,
    endAt: 1702004788,
  },
  'your_last_section_name'
)
```
