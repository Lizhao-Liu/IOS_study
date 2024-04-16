









[如何做到四端统一桥接？微医跨平台桥接标准化方案了解一下](https://www.infoq.cn/article/gjc55agu5frjf2syiitp)







### iOS中的JSCore

[reference](https://blog.csdn.net/MeituanTech/article/details/82108667)





JSValue
JSValue实例是一个指向JS值的引用指针。我们可以使用JSValue类，在OC和JS的基础数据类型之间相互转换。同时我们也可以使用这个类，去创建包装了Native自定义类的JS对象，或者是那些由Native方法或者Block提供实现JS方法的JS对象。

在JSContext一节中，我们接触了大量的JSValue类型的变量。在JSContext一节中我们了解到，我们可以很简单的通过KVC操作JS全局对象，也可以直接获得JS代码执行结果的返回值（同时每一个JS中的值都存在于一个执行环境之中，也就是说每个JSValue都存在于一个JSContext之中，这也就是JSValue的作用域），都是因为JSCore帮我们用JSValue在底层自动做了OC和JS的类型转换。
