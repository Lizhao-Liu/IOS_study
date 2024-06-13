---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100
type:
  title: 视频
  order: 2
title: 视频/图片预览
order: 1
---

# 视频/图片预览

:::info{title=说明}
1. 支持本地视频/图片，支持网络视频/图片
2. 【android】本地视频/图片预览时，需要确保具有视频/图片访问权限，如果视频/图片源已经申请过权限则不需另外申请，比如: 视频/图片源来自视频/图片选择组件时就不需要申请权限
:::


## [previewMedia](https://taro-docs.jd.com/docs/apis/media/image/previewMedia)

<Platform name="media" version='1.0.0' ></Platform>

### 介绍

图片和视频预览

### 引用

```jsx | pure
import Taro from '@tarojs/taro'

Taro.previewMedia
```

### 类型

```jsx | pure
(opts: Taro.previewMedia.Option): Promise<TaroGeneral.CallbackResult>
```

### 参数
#### Taro.previewMedia.Option

<API id="Media_TaroPreviewMediaOption"></API>

#### Taro.previewMedia.Sources

<API id="Media_TaroPreviewMediaSources"></API>

#### Taro.previewMedia.Menu

<API id="Media_TaroPreviewMediaMenu"></API>

### 返回
#### TaroGeneral.CallbackResult

<API id="TaroGeneralCallbackResult" hideDefault='true'></API>

### 示例

```jsx | pure
Taro.previewMedia({
  context,
  sources: [
    {
      url: imagePath,
      type: 'image',
    },
    {
      url: videoPath,
      type: 'video',
    }
  ],
  current: 0,
  menus: [
    {
      id: 'demo_menu1',
      title: '菜单1',
      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/d2833870-1d2e-4ae3-97bf-c31f7e1b6dbe.png',
    },
    {
      id: 'demo_menu2',
      title: '菜单2',
      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/230b6029-26c5-4f9d-a657-ffebd1e1727e.png',
    },
    {
      id: 'demo_menu3',
      title: '菜单3',
      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/d2833870-1d2e-4ae3-97bf-c31f7e1b6dbe.png',
    },
    {
      id: 'demo_menu4',
      title: '菜单4',
      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/230b6029-26c5-4f9d-a657-ffebd1e1727e.png',
    },
  ],
  onMenuClick: (menuId, source) => {
    console.log(
      'onMenuClick',
      `menuId: ${menuId}, source: ${JSON.stringify(source)}`
    )
  }
})
```
