---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: canIUse
  order: 0
title: 业务模块可用性检查
order: 2
---

# 业务模块可用性检查

:::info{title=说明}
用于 xray 业务模块之间的兼容性检查，检查 app 中使用的模块版本和目标版本的兼容性

xray 业务模块类型：
1. flutter: thresh项目
2. rn: rn项目
3. davinci: davinci项目
4. plugin: android插件
:::

## canIUseBizModule

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.canIUseBizModule
```

### 类型

```jsx | pure
(opts: CanIUseBizModuleOption): Promise<CanIUseBizModuleResult>
```

### 参数
#### CanIUseBizModuleOption

<API id='CanIUseBizModuleOption'></API>

### 返回
#### CanIUseBizModuleResult

<API id='CanIUseBizModuleResult' hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.canIUseBizModule({
    context,
    moduleType: 'flutter',
    moduleName: 'fta-tiga-demo',
    moduleVersion: '1.0.0',
  }).then((res) => {
    console.log('可用')
  }).catch((res) => {
    console.log(`不可用, 原因: ${res.reason}`)
  })
```
