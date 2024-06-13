---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: canIUse
  order: 0
title: Tiga可用性检查
order: 0
---

# Tiga可用性检查

:::info{title=说明}
目前只支持 Tiga api 的可用性检查，Taro api 暂不支持
  1. 指定 module/api 检查此 api 在基座中是否存在，若项目未接入基座，此判断始终通过
  2. 指定 Tiga 目标版本检查当前 app 是否兼容
:::

## canIUseTiga

<Platform support="thresh,mw,logic,h5" version="1.3.0"></Platform>

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.canIUseTiga
```

### 类型

```jsx | pure
(opts: CanIUseTigaOption): Promise<CanIUseTigaResult>
```

### 参数
#### CanIUseTigaOption

<API id='CanIUseTigaOption'></API>

### 返回
#### CanIUseTigaResult

<API id='CanIUseTigaResult' hideDefault='true'></API>

### 示例

```jsx | pure
Tiga.canIUseTiga({
    context,
    moduleName: 'Common',
    api: 'isAppForeground',
    tigaSDKVersion: '1.3.0',
  }).then((res) => {
    console.log('可用')
  }).catch((res) => {
    console.log(`不可用, 原因: ${res.reason}`)
  })
```
