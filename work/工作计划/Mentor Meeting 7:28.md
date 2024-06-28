#### OUTLINE

fox使用

hubble大致流程实践

手机调试

sdwebimage 需求



#### Content:

##### 1. FOX + Jenkins:

###### 安装:

最新版本： 最新面板

某个历史版本：首页 > 版本管理 > 打包取包

###### 打包：

自动打包 ：每俩小时

手动打包：首页 > 打包上传 > 打包管理 > jenkins job名 （选择56qq开头的）> 打包 

`e.g.  56qq_MBNewOne_YMMConsignor_Enterprise`

手动打包一般使用于 ： 提测等



##### 2. Hubble

一般有自己负责的模块，只需要关注自己负责的模块出现的问题

根据设备id锁定 > 日志分析 > 

崩溃分析 > 详情 > 解析（堆栈） > crashed thread

hubble 监控 行为日志 搜索日志 指标 日志 警告 cpu （后续了解）



3. sdwebimage需求

public / private bucket

缓存是以url作为key，但是私有的bucket的url 的参数部分会有变动导致缓存读取不一致

方法：所有private bucket存储需要拓展一下url的缓存读取策略

首先需要了解sdwebimage



beta什么时候可以删除掉？

将远程私有代码库的spec文件上传到repo库当中是ci自动触发的吗



Mb-binary-specrepo 是什么 和 mb-specrepo有什么区别？

development pod 内修改库代码

Config.file from pod?

provision profile 会包含 certificate 所以cer为none对吗







debug 加载时机 了解一下整个app启动调用流程







