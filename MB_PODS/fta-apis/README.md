# Tiga

> FTA 原子 API 集

# 快速开始

您可以在本仓库中进行 Tiga API 的开发、发布。

### 前置条件

安装 [@fta/cli](https://fta.amh-group.com/cli/#/guide/0-0-quick-start) 并创建项目（node 版本需要大于 14.19.x）

```bash
# 安装 @fta/cli
$ npm install -g @fta/cli
```

### 开发环境启动

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

### 新增模块

运行 create 或者 new 命令，根据提示输入基本信息，生成模块。

模块将默认以 `@fta/tiga-` 为前缀，如果 `@fta/tiga-network`。

```bash
# 创建 API 模块，比如：network, track
$ yarn new
# 或
$ npm run create
```

创建完成后，可能需要重新执行 `yarn bootstrap:lerna`，以便 lerna 能够识别到新的组件。

### 发布

构建并发布所有包到 npm, 我们使用 lerna 来管理多包仓库，详细的命令请参考 [lerna](https://lerna.js.org/docs/features/version-and-publish)

你仍然可以在单个组件目录下执行 `yarn publish`来手动发布组件（不推荐）。

```bash
# 打包所有组件
$ npm build:packages
# 发布到 npm
$ npm pub
```

### 文档项目部署

在 [服务准入](https://project-beidou.amh-group.com/fe/project/new) 中完成项目准入，然后在 [北斗部署系统](https://deploy-beidou.amh-group.com/fe/#/) 中进行部署。

## 目录结构

```bash
├── docs # 文档目录
  └── components # Tiga模块文档
├── examples # 和文档目录保持一致，存放Tiga模块的样例
└── packages # monorepo的目录结构管理组件包
  └── tiga # Tiga模块
```

## Docs 编写规范 `<Badge>`必须 `</Badge>`

- 在 `docs/components/tiga` 文件夹下面按照现有的目录结构（如下）建立自己模块的 `markdown` 文件，在 `markdown` 中编写组件使用文档（[参见 dumi](https://d.umijs.org/zh-CN)）

  ```bash
  docs
  ├── overview.md
  └── components
    └── tiga # Tiga模块

  ```

- 在书写使用文档时，示例代码一律按照文档的目录规则编写在 `examples` 文件下（强制要求），在 `markdown` 中使用外部 `demo` 的形式引入。在示例的头部配置当前组件支持的平台以及标题：

```typescript
/**
 * hideActions: ["CSB"]
 * platform: ['thresh' , 'mw' , 'weapp'`]
 */
import React from 'react'
```

```typescript
platform: Array<'thresh', 'mw', 'weapp'>
```
