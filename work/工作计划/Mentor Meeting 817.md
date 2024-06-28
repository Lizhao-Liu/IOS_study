## Mentor Meeting 8/17



1. mbnetworklib  plugin部分

2. mbdebug  services

3. hook方法 [method swizzle](http://gonghonglou.com/2020/11/08/hook/)

4. 版本号

5. 调试面板优化

   悬浮窗：那可不可以hook presentviewcontroller，降级为view

   半屏的实现方式：模态，push，addchildvc

   

   scroll view 的常用实现方式

   

6. @EXModule()





nsnotification

kvc/kvo

区别和作用



内存映射



[插件化设计](https://juejin.cn/post/6979627037245849607)













##### 悬浮窗：

继续优化方向





##### 版本号：

第三位：

第二位：公共api变动

第一位

beta





##### 私有库学习问题

MBNetworkLib 

对AFNetworking的封装， manager单例问题？

调用方只需要实现 *MBNetworkInterceptDelegate* 协议即可实现自定义拦截功能？

plugin部分的代码



##### 知识点

运行时关联属性

kvo kvc

多线程



##### 调试面板

新建分支并命名？

react native？

addChildViewController方法 和didmovetoparentviewcontroller