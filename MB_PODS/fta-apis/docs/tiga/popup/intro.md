---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 弹窗管控
  order: 150
title: 介绍
order: 0
---

# Popup 弹窗管控

<Platform name="popup" version="1.1.0"></Platform>

## 介绍

弹窗管控


:::info{title=备注}
**注：弹窗的 track（埋点） 方法和 finish（结束） 都需要调用。否则可能会导致异常。**

1. 弹窗的数据来源有两种，第一种是通过注册协议，也就是 interfaceName， 弹窗中心会拿这个通过聚合接口来请求数据，然后再进行分发数据。业务不需要手动添加数据。通常用于冷启动和一级页面。第二种情况是先注册协议，这里的 interfaceName 是业务自行生成的，是用于匹配协议实例分发数据的，注册之后，需要业务手动添加数据，然后再展示。通常用于二级页面的长链数据以及业务自行请求的弹窗数据。
2. track 是用于埋点的，理论上不影响主流程。但鉴于下面的逻辑，业务最好按照规范去埋点。
   a. 现在弹窗中心做了防护措施：15s 业务未调用 show 和 60s 未调用 finish， 会强制结束当前弹窗，并进行展示下一个。所以，track 的正确调用也会影响后续流程，比如：弹窗展示了但是未调用 show，展示了 15s，那么下一个弹窗展示出来会重叠。  
   b. 弹窗埋点和频次控制有关。如果有疑问，可以咨询管控产品或后端同事。
3. finish 是代表当前流程结束，弹窗中心会展示下一个。业务无论那种情况，都应该确保此方法被调用。
4. [techface 文档](https://techface.amh-group.com/doc/3039) 这里是原生文档，不需要了解的可以忽略。
5. [Tiga 文档](https://wiki.amh-group.com/pages/viewpage.action?pageId=696080262) 进一步做了一些说明和协助调试文档。
:::

## 作者
<Author name='dongwang.feng' dingTalk='a8bzscv'></Author>

#### 对接人

后端：丁许  
产品：刘路（申请弹窗）  
前端：iOS 冯东旺 Android 孔祥磊  
js 端：徐韦

## 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.Popup
```

## 使用引导

```jsx | pure
// 注册监听，纯 tiga 方法，也存在老的 bridge 和 thresh 封装的方法，这里只是纯 tiga 的方法。
Tiga.Popup.registerDialogMonitor({
  context: context,
  interfaceName: '/test/data2',
  requestParams: {
    recommendrss: {
      d: 'e',
    },
    drivermain: {
      m: 'w',
    },
  },
  pageList: ['recommendrss', 'drivermain'],
  show(data) {
    console.log('展示弹窗')
    // 这里需要调用 track 方法，type 为 1. 在其他合适的地方调用其他 type。 使用其他的方法的话也需要调用。
  },
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })

// 当业务弹窗流程处理完毕之后，包含点击关闭和点击跳转。需要调用 finish 弹窗。这个是必须调用的。
Tiga.Popup.finish({
  context: context,
  popupCode: 1234,
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })

 // 另外，使用手动添加数据的弹窗，需要调用 insert。
 Tiga.Popup.insertData({
  context: context,
  popupCode: 8888,
  interfaceName: '/test/data2',
  data: 'jsonString',
  isRegisterDialog: false,
  // isRegisterDialog 为 false 的时候，这里的 show 不会执行，推荐使用上面的方法注册，isRegisterDialog 不推荐设置，这里不使用。
  show(data) {
    console.log('展示弹窗')
  },
  })
  .then((res) => {
    console.log(res)
  })
  .catch((err) => {
    console.log(err)
  })

、、
