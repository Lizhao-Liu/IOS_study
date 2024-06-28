1. 8月带教计划

2. 私有桶图片缓存问题

   修改代码在哪里 查找sdwebimage 寻找协议 callers calling hierachy 使用filter find

   落实修改的位置 在mainModule（main module与appbasis区别） 不同目录对应不同时机，不同时机的含义， 修改位置在home加载首页下，新建一个launchtask； 

   区分于传统方式 都放在didfinisihlaunchapp中，其实修改不同时机的逻辑一个是为了让不同的事情有一个不同的处理时机，也有利于读取不同的task的处理时间，从而进行启动时间的优化

   main module是一个相对上层的module，它里面存放着一些关于通用性的功能，防止下层的耦合，提取成protocol进行让上层依赖下层，mainmodule是偏向于业务的，appbasis是更加无关业务的通用集合

   

3. dmpt 的使用 创办修改提测 bug页面 产线需求

---





---

工作任务：

1. 掌握基础库的使用方法，了解其实现原理，包括

   - [ ] MBNetworkLib, 

   - [x] MBUIKit, 

   - [x] MBFoundation, 

   - [ ] MBLogLib, 

   - [x] YMMRouterLib, 

   - [ ] MBDoctor,

   - [ ] MBStorageLib；

> 输出基础库相关功能、代码、demo或接入文档的优化建议。

2. 完成部分基础库的需求，包括SDWebImage缓存key优化；

> - [x] 完成1项基础库需求；
> - [ ] 完成2项基础库需求；

3.  调试面板改造，并完善相关基础库的App内调试功能。

> - [ ] 调研调试面板改造方案 
> - [ ] 完成调试面板整体改造
> - [ ] 完成1个基础库调试功能优化
> - [ ] 完成2个基础库调试功能优化
>
> 调试面板主要窗口在前面半屏展示（network，日志，配置下发，等），添加更多选项可以跳回原窗口，同时可以展示的界面也只展示主要的内容，更多的内容进一步操作触发
>
> [思路](./调试面板改造)

学习任务：

1. 常用第三方框架使用和原理学习，包括SDWebImage，AFNetworking，Masonry，YYModel等框架学习。

> - [x] sdwebimage 完成学习demo，且输出一篇框架学习文档。
>   - [ ] 相关技巧知识点补充
> - [x] Masonry 完成学习demo，且输出一篇框架学习文档。
> - [ ] YYModel 完成学习demo，且输出一篇框架学习文档。
> - [ ] AFNetworking 完成学习demo，且输出一篇框架学习文档。





#### 自定8月计划：

第一周（8.2 - 8.9）

- [x] MBFoundation

- [x] MBUIKit

- [x] SDWebImage缓存key优化

- [x] SDWebImage框架学习

- [x] 熟悉调试面板架构



第二周（8.10-8.16）

- [x] YMMRouterLib
- [x] Afnetworking

- [x] Masonry

- [ ] 调试面板整体改造调研



第三周（8.17 - 8.23）

- [x] MBNetworkLib
- [ ] YYModel
- [ ] MBLogLib

- [ ] 调试面板优化



第四周（8.24 - 8.30）

- [ ] mbstoragelib
- [ ] MBDoctor

- [ ] 调试面板优化



---

#### 基础库介绍：

[综合架构文档](https://techface.amh-group.com/doc/1074)

[techface接入文档](https://techface.amh-group.com/channel/3)

###### [MBFoundation](https://code.amh-group.com/iOSYmm/MBFoundation/tree/develop/MBFoundation/Classes)

框架完整定义并提供了一套iOS开发常用基础API集合，包括但不限于基本数据类型、结构体、类、对象、时间日期处理、文件系统、内存安全管理、归档存储、异步协程机制等相关功能。

swift调用oc

组件内调用 bridge 桥接文件

组件外 podfile modular header

oc调用swift

工程配置

###### [MBUIKit](https://code.amh-group.com/iOSYmm/MBUIKit)

公共视图

[文档](https://techface.amh-group.com/doc/662)



###### [MBStorageLib](https://code.amh-group.com/iOSYmm/MBStorageLib/tree/develop)

MBStorage提供KV存储和数据库存储，其中KV类型的数据针对不同的需求和使用场景，提供了三种存储方式：MBKV，MBKeychainStorage和MBMemoryStorage。

[文档](https://techface.amh-group.com/doc/874)



###### [MBNetwork](https://code.amh-group.com/MBFrontend/iOS/MBNetworkLib)

**MBNetwork** 是满帮集团移动端iOS原生Objective-C编写的基础网络模块，旨在为满帮所有业务线/基础域提供 **服务端接口网络请求功能**，并提供了包括但不限于*请求参数序列化* *响应数据反序列化* *自定义拦截器* *缓存* *加解密* *DNS优化* 等功能。

###### [MBLogLib](https://code.amh-group.com/MBFrontend/iOS/MBLogLib/tree/develop)

处理日志（create upload）

[文档](https://techface.amh-group.com/doc/916)

###### [YMMRouterLib](https://code.amh-group.com/iOSYmm/YMMRouterLib/tree/develop)

页面路由机制

[文档 接入指南](https://techface.amh-group.com/doc/1404)



###### [MBDoctor](https://code.amh-group.com/iOSYmm/MBDoctor/tree/develop)

*MBDoctor* 是满帮集团iOS移动端通用的行为采集模块，旨在通过 [Hubble平台](http://hubble.amh-group.com/#/feDashboard) 为满帮所有基础业务线提供 **线上用户行为诊断功能**，提供包括但不限于用户页面路径跟踪、点击行为、网络请求、历史Crash堆栈、日志流、性能耗时、自定义等用户行为相关数据在线查询能力。

[文档](https://techface.amh-group.com/doc/1064)





其他库：

[YMMMainModule](https://code.amh-group.com/iOSYmm/YMMMainModule/tree/dev/20220818)

![MainModule-Launch](./images/MainModule-Launch.png)

basic: main() -> willFinishLaunchingWithOptions

Biz : 

Home: applicationDidFinishLaunching 方法里的事情

idle：首页渲染完成 线程空闲

privacy：同意隐私授权的页面







---



