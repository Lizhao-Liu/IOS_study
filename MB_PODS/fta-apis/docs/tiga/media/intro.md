---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 多媒体
  order: 100
title: 总览
order: 0
---

# 多媒体

<Platform name="media" version="1.0.0"></Platform>

## 介绍

多媒体相关功能，其中包括 语音识别，多媒体文件选择、预览、压缩等

| 功能                                 | 功能描述                         |
| ------------------------------------ | -------------------------------- |
| [图片选择](./imagechoose)            | 拍摄或者从相册选择图片           |
| [图片预览](./imagepreview)           | 在新页面中全屏预览图片           |
| [保存图片到相册](./imagesavetoalbum) | 保存图片到系统相册               |
| [获取图片信息](./imageinfo)          | 获取图片宽高等信息               |
| [图片 base64](./imagebase64)         | 本地图片和 base64 之间的互转     |
| [图片压缩裁剪](./imagecompresscrop)  | 图片压缩&裁剪                    |
| [图片加水印](./imagewatermark)       | 图片加水印                       |
| [视频/图片选择](./videochoose)       | 拍摄或者从相册选择视频/图片      |
| [视频/图片预览](./videopreview)      | 在新页面中全屏播放视频或预览图片 |
| [保存视频到相册](./videosavetoalbum) | 保存视频到系统相册               |
| [音频选择](./audiochoose)            | 选择音频文件                     |
| [音频播放](./audioplay)              | 播放在线或本地音频文件           |
| [语音识别](./voicerecognize)         | 语音识别                         |
| [语音合成](./texttospeeech)          | 文本转语音                       |
| [文件选择](./filechoose)             | 文件选择、文件转码               |

## 作者

图片相关 & 视频相关 & 音频选择 & 文件选择：
<Author name="longbing.you"></Author>
音频播放 & 语音合成：
<Author name="zhanxiang.shi"></Author>
语音识别：
<Author name="dongwang.feng"></Author>

## 引用

```jsx | pure
// Tiga Media API 调用
import Tiga from '@fta/tiga'
// 使用 Tiga.Media.xx 调用 media apis
Tiga.Media

// Taro Media API 调用
import Taro from '@tarojs/taro'
```
