#### OUTLINE

- 企业开发到部署的大致过程

  gitlab pull 需要修改的库 -> 上传更新库到repo -> 集成库framework化并发布 -> 打包app -> 测试包安装 -> 监控

- 熟悉工程目录



#### GOALS

1. 能够按照规范操作git仓库，提交代码；
2. 能够独立完成库发布、宿主打包和测试包安装流程; 
3. 能够使用hubble查询用户行为日志和离线日志，完成用户故障的定位; 
4. 熟悉宿主工程的各项配置，完成App版本等配置的修改；
5. 能够编译和运行各种不同类型的App包。



#### TO DO LIST

- [x] clone 公司代码，熟悉git 使用方式 （1）
- [x] 阅读代码工程，熟悉相应工程配置 i.e. 依赖管理 静态库embedding，code signing配置 （4）
- [x] 熟悉jenkins fox 平台操作 （2）
- [x] 企业邮箱注册开发者账号 （2 5）
- [x] 学习苹果证书和签名体系 （2 5）
- [x] 熟悉hubble平台的使用 （3）
- [x] 学习podspec文档语法 熟悉cocoapod私有库创建 参考官网 （2）
- [x] 了解跨app通信 keychain sharing (4)
- [x] 进一步熟悉整个ci/cd过程，参考[公司文档](http://techface.amh-group.com/doc/1022) (12345)









#### Summary

1. Gitlab拉取代码 

   修改某个库代码 需要pod指定路径 否则git识别不到修改

   修改完成 打tag 注意同步pod spec文件和podfile版本号 version 

   ci/cd页面 check import check dependency check 二进制framework打包 发布成功（钉钉提醒） 不可以引用依赖使用service组件

   podspec  定义路径clone代码库`=> path:`  才能修改git 在pod中不能直接修改 

   - [ ] 学习podspec文件书写格式语法

   分支格式 develop dev/日期  merge request

   数组? 

   repo 

   壳工程 读取repo

   代码库 读取 引入repo

   pod repo update

   学习使用pod 写podspec文件 参考官网

2. Jenkins打包  fox是jenkins的封装 fox下载二维码（满帮家） 自动打包 分支格式

3. 发布 ： 证书 （用企业邮箱注册苹果账号）开发者账号和描述 手动添加 / 自动添加 tf 

   - [x] keychain sharing （待研究）

4. hubble 监控 行为日志 搜索日志 指标 日志 警告 cpu

5. 工程目录 添加静态库repo workspace pod静态库的引入 依赖插件



#### 梳理组件

MBFoundation: 

```
MBFoundation框架完整定义并提供了一套iOS开发常用基础API集合，包括但不限于基本数据类型、结构体、类、对象、时间日期处理、文件系统、内存安全管理、归档存储、异步协程机制等相关功能
```

swift







[资料](http://techface.amh-group.com/doc/1022)



