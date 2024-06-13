---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 营销广告
  order: 160
title: 营销数据
order: 1
---

## getAdData
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

根据广告位 id 获取广告数据

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.getAdData

```

### 类型

```jsx | pure
(option: GetAdProps<TigaGeneral.CallbackResult>): Promise<AdDataCallback>
```

### 参数
#### GetAdProps

<API id="Advertisement_AdProps"></API>

### 返回
#### AdDataCallback
<span id="AdDataCallback"></span>
| 属性名      | 描述     | 类型     |
| -------------------- | ------------------------------------------ | --------------------------------------------- |
| code  |  错误 code, 0 成功，1 失败 2 参数错误 | `number` | 
| reason  |  原因	 | `string` |
| advertId             | 广告 id                                    | `number`                                      |
| positionCode         | 广告位 id                                  | `number`                                      |
| startTime            | 开始时间                                   | `number`                                      |
| endTime              | 结束时间                                   | `number`                                      |
| advertTestFlag       | 测试标记                                   | `boolean`                                     |
| updateTime           | 更新时间                                   | `number`                                      |
| pictureUrl           | 图片地址                                   | `string`                                      |
| url                  | 链接                                       | `string`                                      |
| text                 | 文案                                       | `string`                                      |
| appType              | 类型                                       | `number`                                      |
| sort                 | 排序                                       | `number`                                      |
| frequency            | 广告显示次数 -1 为无限制                   | `number`                                      |
| utmCampaign          | UTM 标记                                   | `number`                                      |
| advertMetricInfo     | 智能投放埋点字段                           | `string`                                      |
| videoUrl             | 视频 url                                   | `string`                                      |
| videoTitle           | 视频 title                                 | `string`                                      |
| advertElementType    | 广告素材类型：1-图片，2-文字，3-气泡，4-H5 | `number`                                      |
| width                | 图片宽                                     | `number`                                      |
| height               | 图片高                                     | `number`                                      |
| advertFrequencyRules |       频率                                     | [AdvertFrequencyRules](#AdvertFrequencyRules) |
| advertActivateRules  |       激活类型                                     | [AdvertActivateRules](#AdvertActivateRules)   |

#### AdvertFrequencyRules

<span id='AdvertFrequencyRules'></span>

| 属性名   | 描述                                                                              | 类型     |
| -------- | --------------------------------------------------------------------------------- | -------- |
| ruleType | 显示策略类型 1 表示 app 开启期间，不再重复显示 2 表示 app 间隔 value 的时间再显示 | `number` |
| status   | 是否生效                                                                          | `number` |
| value    | 时间间隔数目                                                                      | `number` |

#### AdvertActivateRules

<span id='AdvertActivateRules'></span>

| 属性名        | 描述                                                                  | 类型     |
| ------------- | --------------------------------------------------------------------- | -------- |
| activateType  | 激活类型【1-进入页面展示，2-离开页面展示，3-未操作浏览页面 X 秒展示】 | `number` |
| advertId      | 广告 id                                                               | `number` |
| activateValue | 激活值【3-300（300 秒）】                                             | `number` |



### 示例

```jsx | pure
Tiga.Advertisement.getAdData({
  context: context,
  positionCode: 2333,
  success(res) {
    console.log(res)
  },
  fail(err) {
  console.log(err)
  },
})
```



## getRefreshInfo
<Platform support="thresh,mw,logic,h5" version='1.3.1' ></Platform>

### 介绍

获取刷新文案

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Advertisement.getRefreshInfo
```

### 类型

```jsx | pure
(option: RefreshProps<TigaGeneral.CallbackResult>): Promise<RefreshTextCallback>
```

### 参数
#### RefreshProps

<API id="Advertisement_RefreshProps"></API>

### 返回
####  RefreshTextCallback

| 属性名      | 描述                            | 类型     |
| ----------- | ------------------------------- | -------- |
| code  |  错误 code, 0 成功，1 失败 2 参数错误 | `number` | 
| reason  |  原因	 | `string` |
| refreshText | 营销文案                        | `string` |
| lottieUrl   | 用于加载 lottie 的远程 url 链接 | `string` |
| id          | 营销文案 id                     | `string` |
| textColor   | 营销文案 textColor              | `string` |


### 示例

```jsx | pure
Tiga.Advertisement.getRefreshInfo({
  context: context,
  pageName: 'recommend_cargolist',
  success(res) {
      console.log(res)
  },
  fail(err) {
    console.log(err)
  },
})
```
