# 更新日志

## 1.7.0

_2024-04-23_

### ✨ New Features

- **UI**

  - 新增弹窗背景透明蒙层梯度参数

## 1.6.0

_2024-03-27_

### ✨ New Features

- **Navigator**

  - 替换栈顶页面时，可选择关闭切换动画
  
- **Media**

  -  [iOS] 增加文件转码功能
  -  tts语音合成，增加播放开始、结束回调
  
### 🐛 Bug Fixes

- **Media**

  - 修复 音频播放器在暂停状态下无法切换音频源
  - 修复 语音识别权限问题

- **APM**

  - 修复 监听内存不足告警事件 无效问题

## 1.5.0

_2024-01-23_

### 🐛 Bug Fixes

- **Network**

  - 修复上传文件的问题

- **Popup**

  - 修复弹窗管控事件注册

- **Media**

  - 视频选择支持返回视频时长和宽高

## 1.4.2

_2023-12-26_

### 🐛 Bug Fixes

- **Network**

  - 兼容文件上传后缀处理

- **Event**

  - 事件总线 npe 保护处理

## 1.4.1

_2023-11-29_

### 🐛 Bug Fixes

- **Media**

  - 修复音频播放问题

## 1.4.0

_2023-10-26_

### ✨ New Features

- **System**

  - isDriver/isYMM 等 API 支持

- **Media**

  - 音频播放
  - 音频录制
  - 图片/视频预览页自定义菜单

- **Advertisement**

  - 新增广告相关功能

- **APM**

  - 新增 获取 内存/存储空间 使用情况相关功能

- **Push**

  - 完成 android 端实现

- **支持 Thresh 基座**

## 1.3.1-alpha.1

_2023-09-26_

### 🐛 Bug Fixes

- canIUse 返回值修复
- **Navigator**
  - getAppPages 问题修复

## 1.3.0

_2023-09-20_

### ✨ New Features

- **Message**

  - push
  - 长连

- **Navigator**

  - 路由

- **Storage**

  - 文件存储

- **Network**

  - 网络请求
  - 下载

- **canIUse**

  - canIUseTiga
  - canIUseBizModule

- **Media**

  - 图片/视频预览 UI 优化

- **Common**

  - 是否前台
  - 是否外链启动
  - app 启动时间
  - 退出应用

- **System**
  - getSystemInfoAsync
  - 振动

### 🐛 Bug Fixes

- 修复在容器关闭后收不到事件总线的问题

## 1.3.0-alpha.4

_2023-09-06_

### 🐛 Bug Fixes

- 修复 Global Logic 问题
- 修复非 FTA 的 H5 项目问题

## 1.3.0-alpha.0

_2023-09-01_

### ✨ New Features

- 支持 Global Logic

## 1.2.0

_2023-08-23_

### ✨ New Features

- **System**

  - 通话状态监听
  - 系统日历事件操作：查询、添加、删除
  - 屏幕亮度设置、常亮设置

- **Common**

  - 获取 Tiga 原生 SDK 版本号
  - 获取 APP 进程信息
  - 获取 APP 使用的 Session 信息
  - 获取校准过的当前时间
  - 获取网络状态
  - 获取 Android 插件信息
  - 截屏监听

- **Media**

  - 图片添加水印
  - 语音识别

- **Popup**
  - 弹窗管控

## 1.1.1

_2023-08-14_

### 🐛 Bug Fixes

- **System**
  - 剪切板操作 迁移成 Taro API
  - 拨打电话 迁移成 Taro API
  - 选择联系人 迁移成 Taro API

## 1.1.0

_2023-08-10_

### ✨ New Features

- **System**

  - 获取所有联系人信息

- **Common**

  - 查询业务 bundle/插件 信息
  - 进入前后台回调

- **Location**

  - 定位、位置信息
  - 经纬度反编码

- **Social**
  - 分享
  - 打开 微信/支付宝 小程序

## 1.0.0

_2023-07-20_

### ✨ New Features

- **System**

  - 打开系统设置
  - 发送短信

- **Common**

  - 获取配置下发数据

- **UI**

  - 展示数据信息弹窗
  - 反馈提示弹窗
  - loading 弹窗
  - Toast 提示
  - 模态弹窗
  - 操作菜单弹窗

- **Storage**

  - kv 存储

- **Permission**

  - 检查/请求权限

- **Media**

  - 图片/视频/音频/文件选择
  - 图片 base64 获取/保存
  - 选择并上传图片
  - 图片压缩/裁剪
  - 获取图片信息
  - 图片/视频预览
  - 保存图片/视频到系统相册

- **Network**

  - 网络请求
  - 文件上传

- **Tracker**

  - 埋点/日志

- **Tabbar**

  - 显示/隐藏 Badge/小红点/气泡/提示文字
  - 获取 Tab 信息
  - 修改 Tab 信息

- **Util**
  - 事件总线
  - TigaBridge
