---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 营销广告
  order: 160
title: 总览
order: 0
---


# 营销广告

<Platform name="advertisement" version='1.1.0' ></Platform>

## 介绍

营销广告

:::info{title=备注}

1. pageAppear，visibleOnPage，invisibleOnPage，pageDisappear，pageDestroy，tapWithPage，closeWithPage 这几个 api 是原来广告的埋点事件，与原生页面的声明周期绑定。 如果是迁移业务需要使用这些埋点。
2. show，tap，close，stay 这几个 api 是纯净的调用，不包含其他逻辑，仅仅是调用的埋点 api，如果需要一些计算属性，比如：停留时长，需要业务计算好，然后调用 stay。

:::

| 功能                              | 功能描述                         |
| --------------------------------- | ------------------------------ |
| [营销数据](./marketing-data)    | 获取广告等营销数据   |
| [弹出广告](./show-advertisement)  | 弹出广告 |
| [埋点](./track)    | 埋点，不绑定页面，单纯埋点逻辑实现 |
| [埋点（绑定页面）](./track-with-page)  | 埋点，绑定页面，与老 bridge 功能一致 |

## 作者
<Author name='dongwang.feng' dingTalk='a8bzscv'></Author>

## 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement
```
