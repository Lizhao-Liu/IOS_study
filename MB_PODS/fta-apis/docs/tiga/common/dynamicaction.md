---
nav:
  title: API
  order: 1
  second: 'ignore'
group:
  title: 通用工具
  order: 10
title: 动态Action
order: 10
---

# 动态 Action

## registerDynamicAction

<Platform name="common" version="1.4.0"></Platform>

### 介绍

注册动态 Action 监听。
具体动态 Action 逻辑可以查看文档：
https://techface.amh-group.com/doc/30

### 类型

```jsx | pure
(opts: RegisterActionOption): DynamicActionHandle
```

### 参数
#### RegisterActionOption

<API id="Common_RegisterActionOption"></API>

### 返回
#### DynamicActionHandle

| 属性名   | 描述                                             | 类型   | 默认值 |
| -------- | ------------------------------------------------ | ------ | ------ |
| listener | 监听 action 回调函数，返回的参数是业务 json 数据 | `Func` | `--`   |

### 示例
```jsx | pure
Tiga.Common.registerDynamicAction({
  context,
  name: actionName,
  success(res) {
    console.log('注册成功')
  },
  fail(res) {
    console.log('注册失败')
  },
}).listener = (res: any) => {
  console.log(JSON.stringify(res))
}
```
