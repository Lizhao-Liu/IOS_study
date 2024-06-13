---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
title: Bundle & 插件
order: 3
---

# Xray Bundle 信息和 android 插件信息

## getBundleInfo

<Platform name="common" version="1.1.0"></Platform>

### 介绍

查询 xray 中业务 bundle/插件(android) 信息

:::info{title=说明}
xray 业务模块类型：
1. flutter: thresh项目
2. rn: rn项目
3. davinci: davinci项目
4. plugin: android插件
:::

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getBundleInfo
```

### 类型

```jsx | pure
(opts: GetBundleInfoOption): Promise<GetBundleInfoCallbackResult>
```

### 参数
#### GetBundleInfoOption

<API id="Common_GetBundleInfoOption"></API>

#### BundleParam

| 属性名      | 描述                   | 类型       | 默认值   |
| ----------- | ---------------------- | ---------- | -------- |
| bundleType  | 需要查询的 bundle 类型 | `string`   | `--`     |
| bundleNames | 需要查询的 bundle 名   | `string[]` | `(必选)` |

### 返回
#### GetBundleInfoCallbackResult

| 属性名  | 描述        | 类型             |
| ------- | ----------- | ---------------- |
| bundles | bundle 信息 | `BundleResult[]` |

#### BundleResult

| 属性名     | 描述        | 类型           |
| ---------- | ----------- | -------------- |
| bundleType | bundle 类型 | `string`       |
| bundleList | bundle 信息 | `BundleInfo[]` |

#### BundleInfo

| 属性名        | 描述        | 类型     |
| ------------- | ----------- | -------- |
| bundleName    | bundle 名   | `string` |
| bundleVersion | bundle 版本 | `string` |

### 示例

```jsx | pure
Tiga.Common.getBundleInfo({
  context,
  bundles: [
    {
      bundleType: 'plugin',
    },
    {
      bundleType: 'flutter',
    },
    {
      bundleType: 'rn',
      bundleNames: ['fta-user', 'global-engine', 'common'],
    },
  ],
  success: (res) => {
    console.log('getBundleInfo-success', res)
  },
  fail: (res) => {
    console.log('getBundleInfo-fail', res)
  },
})
```

## getPluginInfo

<Platform name="common" version="1.2.0"></Platform>

### 介绍

获取 android 插件信息

:::info{title=说明}
1. 如果调用时插件还未安装，是获取不到插件信息的，比如：后置插件默认不会安装/启动
2. 如果不关心插件是否启动，只需获取插件版本信息，则使用 getBundleInfo 来获取版本信息即可
:::

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Common.getPluginInfo
```

### 类型

```jsx | pure
(opts: PluginInfoOption): Promise<PluginInfoResult>
```

### 参数
#### PluginInfoOption

<API id="Common_PluginInfoOption"></API>

### 返回
#### PluginInfoResult

| 属性名            | 描述           | 类型    |
| ----------------- | -------------- | ------- |
| pluginName        | 插件名         | string  |
| pluginVersion     | 插件版本       | string  |
| pluginVersionCode | 插件版本数字型 | number  |
| started           | 是否已启动     | boolean |

### 示例

```jsx | pure
Tiga.Common.getPluginInfo({
  context,
  pluginName: 'com.wlqq.phantom.plugin.ymm.cargo',
  success: (res) => {
    console.log('getPluginInfo-success', res)
  },
  fail: (res) => {
    console.log('getPluginInfo-fail', res)
  },
})
```
