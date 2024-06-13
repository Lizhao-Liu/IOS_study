---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 首页Tab
  order: 140
type:
  title: Tab数据&操作
  order: 1
title: Tabbar数据
order: 1
---

## getTabDataList

<Platform support="thresh,mw,logic,h5" version="1.1.0"></Platform>

### 介绍

查询获取所有 tab 信息

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Tabbar.getTabDataList
```

### 类型

```jsx | pure
(opts: TabDataListOption): Promise<TabDataListResult>
```

### 参数

#### TabDataListOption

<API id="Tabbar_TabDataListOption"></API>

### 返回

#### TabDataListResult

| 属性名             | 描述                    | 类型          |
| ------------------ | ----------------------- | ------------- |
| currentSelectedPos | 当前选中索引, 从 0 开始 | number        |
| tabList            | tab 数据列表            | TabDataInfo[] |

#### TabDataInfo

| 属性名      | 描述                                 | 类型     |
| ----------- | ------------------------------------ | -------- |
| tabPageName | tab 页面唯一标识, 可以用来做逻辑交互 | `string` |
| tabPageUrl  | [iOS]tab 页面路由                    | `string` |
| packageName | [Android]获取 tab 服务名             | `string` |
| methodName  | [Android]获取 tab 方法名             | `string` |
| tabName     | tabitem 标题                         | `string` |
| extParam    | 扩展参数，json 字符串                | `string` |

### 示例

```jsx | pure
Tiga.Tabbar.getTabDataList({
  context: context,
  fail(res) {
    console.log('fail:', res)
  },
  success(res) {
    console.log('success:', res)
  },
})
```
