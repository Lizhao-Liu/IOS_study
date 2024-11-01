Object Modelling Technique



head first

1. 策略模式 通用词汇 鸭子与它的行为
2. 





---

#### 文章学习

[iOS 架构师之路：慎用继承](https://juejin.cn/post/6844903464997240839) 

替代继承的方式：

协议（共同接口声明）/ 代理 （调用方法delegate 而不是由子类重写） / 类别 / 组合（cache 不是继承nsdictionary而是组合dictionary）

如果只是共享接口，我们可以使用协议；如果是希望共用一个方法的部分实现，但希望根据需要执行不同的其他行为，我们可以使用代理；如果是添加方法，我们可以优先使用类别（category）；如果是为了使用一个类的很多方法，我们可以使用组合来实现



[继承和面向接口（iOS架构思想篇）](https://juejin.cn/post/6844903630651260941#heading-6)

面向接口编程

protocol / 继承











## iOS设计模式

[🐻iOS设计模式](https://juejin.cn/post/6844904200564916237)

[ios设计模式详解（含代码示例）](https://juejin.cn/post/6844903665166204942)

[design patterns for ios github code demo](https://github.com/apress/pro-objective-c-design-patterns-for-ios)

[design patterns for ios notes](https://www.jianshu.com/p/595a10d77601)

> 涉猎比较 内容易理解



### overview

对象创建：原型prototype  工厂factory method  抽象工厂abstract factory  生成器builder  单例singleton

接口适配：适配器adapter  桥接bridge  外观facade 

抽象集合：组合composite  迭代器iterator 

对象去耦：中介者mediator  观察者observer

行为扩展：访问者visitor  装饰decorator  责任链chain of responsibility

算法封装：模版方法template method  策略strategy  命令command

性能与对象访问：享元flyweight  代理proxy

对象状态：备忘录memento



### 设计原则

开放-封闭原则 (OCP): 开闭原则是总纲，它告诉我们要对扩展开放，对修改关闭；

里氏替换原则 (LSP): 告诉我们不要破坏继承体系；子类型必须能够替换掉它们的父类型

依赖倒转原则(DIP): 依赖倒置原则告诉我们要面向接口编程；

`A. 高层模块不应该依赖低层模块，两个都应该依赖抽象。B. 抽象不应该依赖细节，细节应该依赖抽象。`

单一职责原则 (SRP): 单一职责原则告诉我们实现类要职责单一；

接口隔离原则告诉我们在设计接口的时候要精简单一；

迪米特法则（LoD）: 告诉我们要降低耦合度；如果两个类不必彼此直接通信，那么这两个类就不应当发生直接的相互作用。如果其中一个类需要调用另一个类的某一个方法的话，可以通过第三者转发这个调用

合成复用原则（CARP）: 告诉我们要优先使用组合或者聚合关系复用，少用继承关系复用。



### 创建者模式

##### 简单工厂模式

##### 工厂方法模式

```undefined
定义：定义创建对对象的接口，让子类决定实例化哪一个类，工厂方法使得一个类的实例化延迟到子类。
```

适用情形：

- 编译时无法准确预期要创建的对象的类。
- 类想让其子类决定在运行时创建什么
- 类由若干辅助类为其子类，而你想将返回哪个子类这一信息局部化

##### 抽象工厂模式 （类簇） --masonry masabstractconstraint

```undefined
定义：提供一个创建一系列相关或相互依赖对象的接口，而无需指定他们具体的类。 
```

软件设计黄金法则：变动需要抽象。 比如，如果APP要支持更换皮肤，可以设计成抽象工厂。

提供一个接口，用于创建与某些对象相关或依赖于某些对象的类家族，而又不需要指定它们的具体类。通过这种模式可以去除客户代码和来自工厂的具体对象细节之间的耦合关系

[三个工厂模式的比较](https://juejin.cn/post/6844904190599233549)

抽象工厂与工厂方法比较

![img](https://upload-images.jianshu.io/upload_images/1547283-517de8b08acd7647.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

##### 建造者模式  / 生成器模式

[建造者模式](https://www.liam365craft.com/index.php/2022/02/18/builder-pattern/)

```undefined
定义：  将一个复杂对象的构建与它的表现分离，使得同样的构建过程可以创建不同的表现。
```

适用情景：

- 需要创建涉及各种部件的复杂对象。创建对象的算法应该独立于部件的装配方式。常见例子是构建组合对象。
- 构建过程需要以不同的方式构建对象。 将做什么 和 怎么做 两个问题分开解决。

生成器与抽象工厂的比较

![img](https://upload-images.jianshu.io/upload_images/1547283-92c4861a6c2f917d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

建造者模式就是【创建】并【配置】了一个对象，而抽象工厂只是创建一组产品，这也是他们最大的区别。

##### 原型模式

```undefined
定义：使用原型实例指定创建对象的种类，并通过复制这个原型创建新的对象。
```

适用情景：

- 需要创建的对象应独立于其类型与创建方式。
- 要实例化的类是运行时决定的。
- 不想要与产品层次相对应的工厂层次。
- 不同类的实例间的差异仅是状态的若干组合。因此复制相应数量的原型比手工实例化更加方便。
- 类不容易创建，比如每个组件可把其他组件作为子节点的组合对象。复制已有的组合对象并对副本进行修改会更加容易。

原型模式是非常简单的一种设计模式, 在多数情况下可被理解为一种深复制的行为。在Objective-C中使用原型模式, 首先要遵循NSCoping协议(OC中一些内置类遵循该协议, 例如NSArray, NSMutableArray等)。

##### 单例模式

```undefined
定义:保证一个类仅有一个实例，并且提供一个访问它的全局访问点。
```

保证一个类仅有一个实例，并提供一个访问它的全局访问点。该类需要跟踪单一的实例，并确保没有其它实例被创建。单例类适合于需要通过单个对象访问全局资源的场合。

有几个Cocoa框架类采用单例模式，包括`NSFileManager`、`NSWorkspace`、和`NSApplication`类



### 结构型模式

#### 1. 接口适应相关设计模式

##### 适配器模式 wrapper

将一个类的接口转换成另外一个客户希望的接口。Adapter 模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。

基本上有两种实现适配器的方式:

1.通过集成来适配来适配两个接口，这种称为类适配器，多通过多重继承来实现，但是OBJ-C没有多重继承，可以通过协议来实现。

2.对象适配器。与类适配器不同，对象适配器不继承被适配者，而是组合一个对它的引用。

```undefined
定义： 将一个类的接口转换成客户希望的另一个接口，适配器模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。
```

适用情形：

- 已有的类的接口和需求不匹配。
- 想要一个可复用的类，该类能够同可能带有不兼容接口的其它类协作。
- 需要适配一个类的几个不同子类，可是让每一个子类去子类化一个类适配器又不现实。那么可以通过使用对象适配器（也叫委托）来适配其父类的接口。

类适配器与对象适配器的对比

![img](https:////upload-images.jianshu.io/upload_images/1547283-96f4a7279b5fb1f7.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

##### 桥接模式

```undefined
定义：将抽象部分与它的实现部分分离，使它们都可以独立的变化。 
```

适用情形：

- 不想在抽象与其实现之间实现固定的绑定关系。
- 抽象及其实现都应该可以通过子类化独立进行扩展。
- 对抽象的实现进行修改不应该影响客户端的代码。
- 如果每个实现需要额外的子类以细化抽象，则说明有必要把他们分成两个部分。
- 想在带有不同抽象接口的多个对象之间共享一个实现。

##### 外观模式

```undefined
定义：为系统中的一组接口提供一个统一的接口，外观定义一个高层接口，让子系统更易于使用。 
```

适用情形：

- 子系统正逐渐变得复杂。应用模式的过程中演化出很多类。可以适用外观为这些子系统提供一个比较简单的接口。
- 可以使用外观对子系统进行分层。每个子系统级别由一个外观作为入口点。让他们通过其外观进行通信，可以简化它们的依赖关系。

#### 2. 对象去耦合相关设计模式

##### 中介者模式

”迪米特法则“，如果两个类不必彼此直接通信，那么这两个类就不应当发生直接的相互作用。如果其中的一个类需要调用另一个类的某一个方法的话，可以通过第三者转发。

```undefined
定义：用一个对象来封装一系列对象的交互方式。中介者使各对象不需要显示地相互引用，从而使其耦合松散，而且可以独立地改变他们之间的交互。 
```

适用情形：

- 对象间的交互虽然定义明确然而非常复杂，导致一组对象彼此相互依赖而且难以理解。
- 因为对象引用了许多其他对象并与其通讯，导致对象难以复用。
- 想要定制一个分布在多个类中的逻辑或行为，又不想由太多子类。

```undefined
说明：中介者模式以中介者内部的复杂性代替交互的复杂性，因为中介者封装与合并了colleague的各种协作逻辑，
自身可能变得比他们任何一个都要复杂得多，这会让中介者本身变成无所不知的庞然大物，并且难以维护。
```

##### 观察者模式

[观察者模式](https://so.csdn.net/so/search?q=观察者模式&spm=1001.2101.3001.7020)(通知机制,KVO机制)

```undefined
定义：定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并自动更新。  也称作发布——订阅模式。 
```

适用情形：

- 有两种抽象类型相互依赖。将他们封装在各自的对象中，就可以对他们单独进行改变和复用。
- 对一个对象的改变需要同时改变其他对象，但是又不知道有多少对象待改变。
- 一个对象必须通知其它对象，但是又不知道其他对象是什么。

通知与键值观察直接的主要差别

![img](https:////upload-images.jianshu.io/upload_images/1547283-56d00048b3d574b6.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



#### 3. 抽象集合相关设计模式

##### 组合模式

```undefined
定义：将对象组合成树形结构以表示“部分——整体”的层次结构，组合使得用户对单个对象和组合对象的使用具有一致性。 
```

将对象组合成树形结构以表示‘部分-整体’的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。

- 想获得对象抽象的树形表示（部分——整体层次结构）
- 想让客户端统一处理组合结构中的所有对象。

##### 迭代器模式

```undefined
定义：提供一种方法访问一个聚合对象中的各个元素，而又不暴露对该对象的内部表示。 
```

适用情形：

- 需要访问组合对象的内容，而又不暴露其内部表示。
- 需要通过多种方式遍历组合对象。
- 需要提供一个统一的接口，用来遍历各种类型的组合对象。

基本上由两种类型的迭代器：外部迭代器和内部迭代器。外部迭代器让客户端直接操作迭代过程，所以客户端需要知道外部迭代器才能使用。另一种情况是，集合对象在其内部维护并操作一个外部迭代器。提供内部迭代器的典型的集合对象为客户端定义一个接口，或者从底层的集合一次访问一个元素，或者向每个元素发送消息。

内部迭代器与外部迭代器的区别

![img](https:////upload-images.jianshu.io/upload_images/1547283-e229e2f491927caa.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



#### 4. 行为扩展相关设计模式

##### 访问者模式

访问者模式设计两个关键角色（或者说组件）：访问者和它访问的元素。元素可以是任何对象，但通常是“部分-整体”结构中的节点。

```undefined
定义：表示一个作用于某对象结构中的各元素的操作。它让我们可以在不改变各元素的类的前提下定义作用于这些元素的新操作。 
```

适用情形：

- 一个复杂的对象结构包含很多其他对象，他们有不同的接口，但是想对这些对象实施一些依赖于其具体类型的操作。
- 需要对一个组合结构的对象进行很多不相关的操作，但是不想让这些操作”污染“这些对象的类。可以将相关的操作集中起来，定义在一个访问者类中，并在需要在访问者中定义的操作时使用它。
- 定义复杂结构的类很少做修改，但是需要经常向其添加新的操作。

##### 装饰模式

标准的装饰模式包括一个抽象的 Component 父类它为其他具体组件（component）声明一些操作。

```undefined
定义：动态地给一个对象添加一些额外地职责。就扩展功能来说，装饰模式相比生成子类更为灵活。
```

适用情形：

- 想要在不影响其他对象的情况下，以动态、透明的方式给单个对象加职责。
- 想要扩展一个类的行为，却做不到。类定义可能被隐藏，无法进行子类化；或者，对类的每个行为的扩展，为支持每种功能组合，将产生大量的子类。
- 对类的职责的扩展是可选的。

装饰模式与策略模式的差异

![img](https:////upload-images.jianshu.io/upload_images/1547283-49ce868b04e97bdf.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

这种模式创建了一个装饰类，用来包装原有的类，并在保持类方法签名完整性的前提下，提供了额外的功能。

范畴 Category 与装饰模式

![img](https://upload-images.jianshu.io/upload_images/1547283-19d084871e3ad3fa.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

> 虽然通过类别可以实现装饰模式，但是这并不是一种严格的实现，由类别添加的方法是编译时绑定的，而装饰模式是动态绑定的，另外类别也没有封装被扩展类的实例。类别适合装饰器不多的时候，上面的例子只有一个NetData装饰器，用类别实现会更轻量，更容易。
>
> 在类别中调用原类方法
>
> ```objc
> - (void)callClassMethod {
>     u_int count;
>     Method *methods = class_copyMethodList([Student class], &count);
>     NSInteger index = 0;
>     
>     for (int i = 0; i < count; i++) {
>         SEL name = method_getName(methods[i]);
>         NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
> 
>         if ([strName isEqualToString:@"run"]) {
>             index = i;  // 先获取原类方法在方法列表中的索引
>         }
>     }
>     
>     // 调用方法
>     Student *stu = [[Student alloc] init];
>     SEL sel = method_getName(methods[index]);
>     IMP imp = method_getImplementation(methods[index]);
>     ((void (*)(id, SEL))imp)(stu,sel);
> }
> ```

##### 职责链模式（Chain of Responsibility）

责任链模式的主要思想是，对象引用了同一类型的另一个对象，形成一条链。链中的每个对象实现了同样的方法，处理链中第一个对象发起的同一个请求。如果一个对象不知道如何处理请求，它就把请求传给下一个响应器。

```undefined
定义：使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间发生耦合，此模式将这些对象连成一条链，并沿着这条链传递请求，直到有一个对象处理它为止。 
```

适用情形：

- 有多个对象可以处理请求，而处理程序只有在运行时才能确定。
- 向一组对象发出请求，而不想显示地指定处理请求的特定处理程序。



#### 5. 算法封装相关设计模式

##### 模版方法模式

该模式的基本思想是在抽象类的一个方法中定义“标准”算法。在这个方法中调用的基本操作应由子类重载予以实现。这个方法被称为“模板”，因为方法定义的算法缺少一些特有的操作。

```undefined
定义：定义一个操作中算法的骨架，而将一些步骤延迟到子类中。模板方法使子类可以重定义算法的某些特定步骤而不改变算法的结构。
```

适用情形：

- 需要一次性实现算法的不变部分，并将可变的行为留给子类来实现。
- 子类的共同行为应该被提取出来放到公共类中，以避免代码重复。现有的代码的差别应该被分离为新的操作，然后用一个调用这些新操作的模板方法来替换这些不同的代码。
- 需要控制子类的扩展。可以定义一个在特定点调用“钩子”（hook）操作的模板方法，子类可以通过对钩子操作的实现在这些点扩展功能。

模板方法会调用5种类型的操作：

- 对具体类或客户端类的具体操作
- 对抽象类的具体操作
- 抽象操作
- 工厂方法
- 钩子操作

模板方法与委托模式的比较

![img](https:////upload-images.jianshu.io/upload_images/1547283-e965891ebb5dde9b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

##### 策略模式 strategy ？

```undefined
定义：定义一系列算法，把他们一个个封装起来，并且使他们可相互替换。本模式使得算法可独立于使用它的客户而变化。 
```

适用情形：

- 一个类在其操作中适用多个条件语句来定义很多行为。我们可以把相关的条件分支移动到他们自己的策略类中。
- 需要算法的各种变体。
- 需要避免把复杂的、与算法相关的数据结构暴露给客户端。

```undefined
提示：如果代码中有很多条件语句，就可能意味着需要把它们重构成各种策略对象。
```

##### 命令模式 command

```undefined
定义：将请求封装为一个对象，从而可用不同的请求对客户进行参数化，对请求排队或者记录请求日志，以及支持可撤销的操作。 
```

适用情形：

- 想让应用程序支持撤销与恢复。
- 想用对象参数化一个动作以执行操作，并用不同命令对象来代替回调函数。
- 想要在不同时刻对请求进行指定、排列和执行。
- 想记录修改日志，这样在系统故障时，这些修改可在后来重做一遍。
- 想让系统支持事务，事务封装了对数据的一系列修改。事务可以建模为命令对象。



#### 6. 性能和对象访问相关设计模式

##### Flyweight pattern 享元模式

实现享元模式需要两个关机组件，通常是可共享的享元对象和保存它们的池。

```undefined
定义：运用共享技术支持大量细粒度的对象。
```

适用场景：

- 应用程序使用很多对象
- 在内存中保存对象会影响性能
- 对象的多数特有状态（外在状态）可以放到外部而轻量化
- 移除了外在状态后，可以用较少的共享对象替代原来那组对象
- 应用程序不依赖对象标识  节省内存



##### 代理模式

```undefined
定义：为其他对象提供一种代理以控制对这个对象的访问。 
```

适用情形：

- 需要一个远程代理，为位于不同地址空间或者网络中的对象提供本地代表。
- 需要一个虚拟代理，来根据要求创建重型的对象。
- 需要一个保护代理，来根据不同访问权限控制对原对象的访问。
- 需要一个智能引用代理，通过对实体对象的引用进行引用技术来管理内存。也能用于锁定实体对象，让其他对象不能改变



#### 7. 对象状态相关设计模式

##### 备忘录模式

```undefined
定义：在不破坏封装的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态，这样以后就可将该对象恢复到原先保存的状态。 
```

适用情形：

- 需要保存一个对象（或某部分）在某一时刻的状态，这样以后就可以恢复到先前的状态。
- 用于捕获状态的接口会暴露实现的细节，需要将其隐藏起来。





**解释器模式（Interpreter）**，给定一个语言，定义它的文法的一种表示，并定义一个解释器，这个解释器使用该表示来解释语言中的句子。

[iOS中常用的设计模式](https://blog.csdn.net/qq_19678579/article/details/86162604)

[OS最实用的13种设计模式（全部有github代码）](https://www.jianshu.com/p/9c4a219e9cf9)











