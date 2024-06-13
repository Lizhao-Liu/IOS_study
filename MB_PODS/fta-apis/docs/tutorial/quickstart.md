---
nav:
  title: 指南
  order: 2
title: 快速接入
---

# Tiga

## 介绍

FTA 原子 API 集

`最新版本: 1.6.0`

## 引用

使用 yarn 安装

```bash
# 依赖 @fta/tiga 库
yarn add @fta/tiga

# 依赖 @types/fta-tiga，需要添加到 global.d.ts，用于保证 Taro 扩展字段不会报错
yarn add -D @types/fta-tiga
```

在 global.d.ts 中引入 @types/fta-tiga

```jsx | pure
/// <reference types="@types/fta-tiga" />
```

导入 Tiga

```jsx | pure
import Tiga from '@fta/tiga'
```
