---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
title: 配置下发
order: 2
---

# 配置下发

## getConfig

<Platform name="common" version="1.0.0"></Platform>

### 介绍

获取配置下发数据
注意：App 生命周期内 配置下发数据可能会发生变化，配置下发数据会在 App 启动时、App 前后台切换时会主动请求更新，以及后台配置长链更新时触发请求更新。

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getConfig
```

### 类型

```jsx | pure
(opts: GetConfigOption): Promise<GetConfigResult>
```
### 参数
#### GetConfigOption

<API id="Common_GetConfigOption"></API>

### 返回
#### GetConfigResult

| 属性名 | 描述       | 类型     |
| ------ | ---------- | -------- |
| value  | 配置项的值 | `string` |

### 示例

```jsx | pure
Tiga.Common.getConfig({
  context,
  group: group,
  key: key,
  defaultValue: defaultValue,
  success(res) {
    setResult(res.value)
    console.log('配置下发 success, value: ', res.value)
  },
  fail(res) {
    console.log('配置下发 fail: ', res)
  },
})
```
