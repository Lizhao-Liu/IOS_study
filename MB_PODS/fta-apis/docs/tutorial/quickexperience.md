---
nav:
  title: 指南
  order: 2
title: 快速体验
---

## Demo 体验

1、安装 app 测试包，切换至 QA 环境

2、在 X-Ray 配置面板中安装插件 fta-tiga-demo

3、插件安装成功，扫码体验

<img src="./demo.png" width="200" height="200" />

## Demo 本地调试

[项目地址](https://code.amh-group.com/MBFrontend/fta-apis)

### 前置条件

安装 [@fta/cli](https://fta.amh-group.com/cli/#/guide/0-0-quick-start) 并创建项目（node 版本需要大于 14.19.x）

```bash
# 安装 @fta/cli
$ npm install -g @fta/cli
```

### 启动项目

进入项目根目录下，执行命令：

```bash
# 1. 安装基础依赖
$ yarn

# 2. 安装组件依赖：
$ yarn bootstrap:lerna

# 3. 构建组件：
$ yarn build:packages

```

#### 调试 Thresh

启动 Thresh 示例项目，并使用 APP 访问。

```bash
$ yarn start:thresh

$ 路由进入demo: ymm://flutter.dynamic/dynamic-page?biz=fta-tiga-demo&page=components-overall-overall
```

#### 调试 微前端

启动 微前端 示例项目，并使用 APP 访问。

```bash
$ yarn start:mw

$ 路由进入demo: http://{本机IP}:10088/microweb/#/fta-tiga-demo/components/overall/overall
```
