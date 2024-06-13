---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 视图交互
  order: 60
title: 弹窗
order: 3
---

# 弹窗

## showInfoDialog

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

显示基础文字信息弹窗

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.UI.showInfoDialog
```

### 类型

```jsx | pure
(opts: DialogOption): Promise<DialogSuccessCallbackResult>
```

### 参数

#### DialogOption

<API hideTitle='true' id='UI_DialogOption' src="@packages/tiga/ui/src/index.tsx"></API>

#### DialogContentStyle

<API id='UI_DialogContentStyle'></API>

#### DialogButton

<API id='UI_DialogButton'></API>

### 返回

#### DialogSuccessCallbackResult

| 属性名    | 描述             | 类型      |
| --------- | ---------------- | --------- |
| dismissed | 弹窗是否被关闭   | `boolean` |
| index     | 点击的按钮 index | `number`  |

### 示例

```javascript
Tiga.UI.showInfoDialog({
  title: '对话框标题',
  content: `Ei mundi pertinax vis, ea vel tritani ceteros. Et vis stet facete perpetua. Brute ridens torquatos ei vis, sed ei nibh wisi debet, te elitr equidem vocibus cum. Duo accusata ullamcorper et, ex noster aperiri eloquentiam mel.
  Aeque vidisse volutpat usu id, usu impetus neglegentur at. Cu mei vocibus suscipit, eu sea discere veritus, mollis nostrum detracto eum ea. Ea nusquam scaevola forensibus duo, eu altera ancillae aliquando usu. Ut epicuri lobortis assentior duo. Vel id zril tantas perpetua. Eum no vidisse atomorum dissentiet, quo partem ancillae et.`,
  contentStyle: {
    maxLinesOfContent: 5, // 弹窗内容设置展示最大行数为5
    contentAlignment: 1, // 弹窗内容局左对齐
  },
  context,
  buttons: [
    {
      text: '选项一',
      color: '#32CD32', //自定义按钮颜色
    },
    {
      text: '选项二',
      color: '#FFB6C1', //自定义按钮颜色
    },
  ],
  showCloseBtn: true, //显示右上角关闭选项
  buttonOrientation: 0, //按钮横向排列
  canceledOnTouchOutside: true, //开启点击外部自动关闭弹窗
})
```

## showStatusDialog

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

显示支持自定义状态 icon 弹窗, icon 位于 title 上方

### 引用

```jsx | pure
import Tiga from '@fta/tiga'

Tiga.UI.showStatusDialog
```

### 类型

```jsx | pure
(opts: StatusDialogOption): Promise<DialogSuccessCallbackResult>
```

### 参数

#### StatusDialogOption

<API hideTitle='true' id='UI_StatusDialogOption' src="@packages/tiga/ui/src/index.tsx"></API>

### 返回

#### DialogSuccessCallbackResult

| 属性名    | 描述             | 类型      |
| --------- | ---------------- | --------- |
| dismissed | 弹窗是否被关闭   | `boolean` |
| index     | 点击的按钮 index | `number`  |

### 示例

```javascript
Tiga.UI.showStatusDialog({
  title: '对话框标题',
  content: '描述文案',
  contentStyle: {
    contentColor: '#DC143C',
  },
  context,
  buttons: [
    {
      text: '知道了',
      color: '#32CD32',
    },
  ],
  statusIcon: 'https://imagecdn.ymm56.com/ymmfile/static/image/trade/success.png', // 设置上方icon
  buttonOrientation: 0,
  canceledOnTouchOutside: true,
})
```

## [showModal](https://taro-docs.jd.com/docs/apis/ui/interaction/showModal)

<Platform support="thresh,mw,h5,logic" version="1.0.0"></Platform>

### 介绍

显示模态对话框

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.showModal
```

### 类型

```jsx | pure

(opts: Taro.showModal.Option): Promise<Taro.showModal.SuccessCallbackResult>

```

### 参数

#### Taro.showModal.Option

<API id='UI_TaroShowModalOption'></API>

### 返回

#### Taro.showModal.SuccessCallbackResult

| 属性名  | 描述                               | 类型      |
| ------- | ---------------------------------- | --------- |
| cancel  | 为 true 时，表示用户点击了取消     | `boolean` |
| confirm | 为 true 时，表示用户点击了确定按钮 | `boolean` |
| errMsg  | 调用结果                           | `string`  |

### 示例

```javascript
Taro.showModal({
  content: '双按钮弹窗',
  title: '对话框标题',
  showCancel: true,
  cancelText: '取消',
  cancelColor: '#32CD32',
  confirmText: '确定',
  confirmColor: '#DC143C',
  context,
})
```

## 示例 Demo

<code src='@examples/components/tiga/ui/dialog/index.tsx'></code>
