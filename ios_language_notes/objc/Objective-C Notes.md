

prerequisite：

[ c指针变量和地址](https://blog.csdn.net/qq_32166627/article/details/80012755)

---



> Reference: 
>
> [tutorial](https://www.runoob.com/w3cnote/objective-c-tutorial.html)
>
> [「建议收藏」《Effective Objective-C 2.0》52 个知识点总结（上）](https://juejin.cn/post/6904440708006936590/)
>
> [「建议收藏」《Effective Objective-C 2.0》52 个知识点总结（下）](https://juejin.cn/post/6904440732287762439/)
>
> [一篇文章拿下《Effective Objective-C 2.0编写高质量iOS与OS X代码的52个有效方法》](https://www.jianshu.com/p/862b064e82e0)



![img](https://upload-images.jianshu.io/upload_images/1457495-debf9e0c37687e51.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)





---

### 第一章：熟悉 Objective-C

#### 1. 了解Objective-C语言的起源

- Objective-C 为 C 语言添加了面向对象特性，是其超集。

- Objective-C 使用动态绑定的消息结构，也就是说，在运行时才会检查对象类型。接收一条消息之后，究竟应执行何种代码，由运行期环境而非编译器来决定。

  运行期本质上是一种与开发者所编写的代码相连接的动态库，其代码能把开发者所编写的所有程序粘合起来，所以只要更新运行期组件就可以提升应用程序性能。

- 理解 C 语言的核心概念有助于写好 Objective-C 程序。尤其要掌握内存管理模型和指针。

  对于 `NSString *string = @"the string"` ，NSString 实例分配在堆中，string 指针变量分配在栈上并指向该实例。
  分配在堆中的内存必须直接管理，而分配在栈上用于保存变量的内存则会在其栈帧弹出时自动清理。

- 与创建结构体相比，创建对象还需要额外开销，例如分配和释放对内存等。

#### 2.  在类的头文件中尽量少引用其他头文件

- 除非确有必要，否则不要引入头文件 （增加编译时间）。一般来说，应在某个类的头文件中使用 “向前声明(forward declaring)” 来提及别的类，并在实现文件中引入那些类的头文件。这样做可以尽量降低类之间的耦合（coupling）。

- 有时无法使用向前声明，比如要声明的某个类遵循一项协议。这种情况下，尽量把 “该类遵循某协议” 的这条声明移至 “class-continuation 分类” 中。如果不行的话，就把协议单独放在一个头文件中，然后将其引入。

必须要在 .h 中引入其他文件的情景：

1. 继承，子类的 .h 中必须 `#import` 父类

2. 遵从某个协议，使用 

   ```
   @protocol
   ```

    只能告诉编译器有某个协议，而此时编译器却要知道该协议中的具体方法和属性。

   - 这是难免的，但我们最好将该协议单独放在一个头文件里。如果将协议定义在某个比较大的类 A 的头文件里，那么我们如果要引入该协议，就要引入 A 的全部内容，这样就增加了编译时间，甚至可能产生相互引用问题。
   - 但是 “委托协议” 就不用单独写一个头文件了，因为 “委托协议” 只有与 “委托类” 放在一起定义才有意义。这种情况下，代理类应该将 “该类遵从某协议” 的这条声明转移至类扩展中，这样的话只要在 .m 中引入包含委托协议的头文件即可，而不需要放在 .h 中。【🚩 27】

3. 分类

4. 枚举，用到定义在其他类里的枚举

#### 3. 多用字面量语法，少用与之等价的方法

- 应该使用字面量语法来创建字符串、数值、数组、字典。与创建此类对象的常规方法相比，这么做更加简洁扼要。
- 应该通过取下标操作来访问数组下标或字典中的键所对应的元素。
- 用字面量语法创建数组或字典时，若值中有 nil，则会抛出异常。因此，务必确保值里不含 nil。

- 使用字面量语法（语法糖）来创建字符串、数值、数组、字典，可以缩减代码长度，使代码更简洁，同时提高易读性。

  ```objc
  NSString *someString = @"Effective Objective-C 2.0";
  	
  NSNumber *someNumber = @1; // 只包含数值，没有多余的语法成分
  NSNumber *floatNumber = @3.5f;
  NSNumber *boolNumber = @YES;
  NSNumber *charNumber = @'a';
  //字面量数组
  NSArray *animals = @[@"cat", @"dog", @"mouse", @"badger"];
  NSString *dog = animals[1]; // “取下标” 操作更为简洁，更易理解，与其他语言语法类似
  //字面量字典
  NSDictionary *personData = @{@"firstName" : @"Matt", 
  			                        @"lastName" : @"Galloway",
                   	                 @"age" : @28};   // <Key>:<Value>，比使用方法创建的写法 <Value>, <key> 更易读
  NSString *lastName = personData[@"lastName"];
  //可变数组和字典
  NSMutableArray *mutableArray = animals.mutableCopy;
  NSMutableDictionary *mutableDictionary = personData.mutableCopy;
  mutableArray[1] = @"dog"; // 对于可变数组或字典，可以通过下标修改其中的元素值
  mutableDictionary[@"lastName"] = @"Galloway";
  ```

- 对于数组和字典来说，使用字面量语法更安全。如果数组中存在值为 nil 的对象，则会抛出异常。而如果使用 

  `initWithObjects:`的话，数组元素个数会在你不知道的情况下减少，且难以排查该错误。

  ```objc
  id obj1 = [[NSObject alloc]init];
  id obj2 = nil;
  id obj3 = [[NSObject alloc]init];
  NSArray *array2 = [[NSArray alloc]initWithObjects:obj1, obj2, obj3, nil];
  // array2 = @[obj1]，而非 @[obj1, obj3]
  // initWithObjects: 方法会依次处理各个参数，直到发现 nil 为止，由于 obj2 为 nil，所以该方法会提前结束
  NSArray *array1 = @[obj1, obj2, obj3];
  // 该字面量方式创建数组，效果等同于是先创建了一个数组，然后把方括号内的所以对象都加到这个数组中。如果数值元素对象中有 nil 则会抛出异常。
  // Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]'
  // 同样的，你使用 addObject: 往数组中添加 nil 也会抛出异常
  NSMutableArray *mArr = [NSMutableArray arrayWithObjects:obj1, obj2, obj3, nil];
  [mArr addObject:nil]; // 编译器已经给出了警告 ⚠️  Null passed to a callee that requires a non-null argument
  // Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil'
  ```

- 局限性 
  如果是自定义的 NSNumber、NSArray、NSDictionary 这些类的子类，则无法使用字面量语法创建其实例。然而，由于 NSNumber、NSArray、NSDictionary 都是已定型的 “子族”【🚩 9】 ，所以很少有人会去从中定义子类。自定义的 NSString 的子类支持字面量语法，但要修改编译器的选项才行。

- 使用字面量语法创建出来的都是不可变对象，若想要可变对象则需要调用 mutableCopy 方法。这样做会多调用一个方法，而且还多创建了一个对象（如果使用方法的话就可以直接创建一个可变对象），不过使用字面量语法所带来的好处是多于这个缺点的。

  ```objc
  NSMutableArray *mutableArray = [@[@1, @2, @3] mutableCopy];
  ```

#### 4. 多用类型常量，少用 #define 预处理指令

- 不要用预处理指令定义常量。这样定义出来的常量不含类型信息，编译器只是会在编译前据此执行查找与替换操作。即使有人重新定义了常量值，编译器也不会产生警告信息，这将导致应用程序中的常量值不一致。

- 在实现文件中使用 `static const` 来定义 “只在编译单元内可见的常量”（translation-unit-specific constant）。由于此类常量不在全局符号表中，所以无须为其名称加前缀。[objectivec static关键字](https://juejin.cn/post/6844903590205587469)

- 在头文件中使用 `extern` 来声明全局常量，并在相关实现文件中定义其值。这种常量要出现在全局符号表中，所以其名称应加以区隔，通常用与之相关的类名做前缀。

##### 定义常量使用类型常量，不建议使用预处理指令。

###### 预处理指令和类型常量的区别：

|          | 预处理指令     | 类型常量                                                   |
| -------- | -------------- | ---------------------------------------------------------- |
|          | 简单的文本替换 |                                                            |
|          | 不包括类型信息 | 包括类型信息（可以清楚描述常量的含义，有助于编写开发文档） |
|          | 可被任意修改   | 不可被修改                                                 |
|          |                | 可以设置其使用范围                                         |
| 编译时刻 | 预编译         | 编译                                                       |
| 编译检查 | 没有           | 有                                                         |

###### 预处理指令

```objc
#define ANIMATION_DURATION 0.3
```

1. 预处理指令会把源代码中的 ANIMATION_DURATION 都替换为 0.3。
2. 该常量没有类型信息，它应该为 NSTimeInterval 类型才合理。
3. 假设此指令声明在某个头文件中，那么所有引入了这个头文件的代码，其 ANIMATION_DURATION 在编译时都会被替换为 0.3。

###### 类型常量

```objc
static const NSTimeInterval kAnimationDuration = 0.3;
```

1. 该常量 kAnimationDuration 包含类型信息，其为 NSTimeInterval 类型（包括类型信息）。
2. static 修饰符意味着该常量只在定义它的 .m 中可见（设置了其使用范围）。
3. const 修饰符意味着该常量不可修改（不可修改）。

###### 类型常量命名法

1. 如果常量局限于某 “编译单元”（也就是 .m 中），则命名前面加字母 `k`，比如 `kAnimationDuration`。
2. 如果常量在类之外可见，定义成了全局常量，则通常以 `类名` 作为前缀，比如 `EOCViewClassAnimationDuration`。

###### 局部类型常量

```objc
static const NSTimeInterval kAnimationDuration = 0.3;
```

1. 一定要同时使用 static 和 const 来声明。这样编译器就不会创建符号，而是像预处理指令一样，进行值替换。
2. 如果试图修改由 const 修饰的变量，编译器就会报错。
3. 如果不加 static，则编译器就会它创建一个 “外部符号 symbol”。此时如果另一个编译单元中也声明了同名变量，那么编译器就会抛出 “重复定义符号” 的错误：

```objc
duplicate symbol _kAnimationDuration in:
    EOCAnimatedView.o
    EOCOtherView.o
```

4. 局部类型常量不放在 “全局符号表” 中，所以无须用类名作为前缀。

###### 全局类型常量

比如，要在类代码中调用nsnotificationcenter以通知他人。用一个对象来派发通知，令其他欲接收通知的对象向该对象注册，这样就能实现此功能了。派发通知时，需要使用字符串来表示此项通知的名称，这个名字就可以声明为一个外界可见的常值变量。这样注册者无需知道实际字符串值，只需以常值变量来注册自己想要接受的通知即可。

```objc
// In the header file
extern NSString *const EOCStringConstant;
	
// In the implementation file
NSString *const EOCStringConstant = @"VALUE";
```

1. 此类常量会被放在 “全局符号表” 中，这样才可以在定义该常量的编译单元之外使用。
2. const 位置不同则常量类型不同，以上为，定义一个指针常量 EOCStringConstant，指向 NSString 对象。也就是说，EOCStringConstant 不会再指向另一个 NSString 对象。[const放在不同位置的不同含义](https://blog.csdn.net/qq_41906934/article/details/90646958)
3. extern 是告诉编译器，在 “全局符号表” 中将会有一个名叫 EOCStringConstant 的符号。这样编译器就允许代码使用该常量。因为它知道，当链接成二进制文件后，肯定能找到这个常量。
4. 此类常量必须要定义，而且只能定义一次，通常这个常量在头文件声明，在实现文件中定义
5. 在实现文件生成目标文件时（编译器每收到一个 “编译单元” .m，就会输出一份 “目标文件” ），编译器会在 “数据段” 为字符串分配存储空间。链接器会把此目标文件与其他目标文件相链接，以生成最终的二进制文件。凡是用到 EOCStringConstant 这个全局符号的地方，链接器都能将其解析。
6. 因为符号要放在全局符号表里，所以常量命名需谨慎，为避免名称冲突，一般以类名作为前缀。



#### 5. 用枚举表示状态、选项、状态码

- 应该用枚举来表示状态机的状态、传递给方法的选项以及状态码等值，给这些值起个易懂的名字。

- 如果把传递给某个方法的选项表示为枚举类型，而多个选项又可同时使用，那么就将各选项值定义为 2 的幂次，以便通过按位或操作将其组合起来。

- 用 `NS_ENUM` 与 `NS_OPTIONS` 宏来定义枚举类型，并指明其底层数据类型。这样做可以确保枚举是用开发者所选的底层数据类型实现出来的，而不会采用编译器所选的类型。

- 在处理枚举类型的 switch 语句中不要实现 default 分支。这样的话，加入新枚举之后，编译器就会提示开发者：switch 语句并未处理所有枚举。

###### 原始写法

```objc
enum EOCConnectionState {
    EOCConnectionStateDisconnected,
    EOCConnectionStateConnecting,
    EOCConnectionStateConnected,
};
// 声明变量
enum EOCConnectionState state = EOCConnectionStateDisconnected;
```

定义类型别名

```objc
// typedef 定义一个类型别名
typedef enum EOCConnectionState EOCConnectionState;
// 声明变量
EOCConnectionState state = EOCConnectionStateDisconnected;
```

可以不使用编译器所分配的序号，而是手动指定，接下去的枚举的值都会在你指定的值的基础上递增 1

```objc
enum EOCConnectionState  {
    EOCConnectionStateDisconnected = 1,
    EOCConnectionStateConnecting,
    EOCConnectionStateConnected,
};
```

###### 指定枚举的底层数据类型

- 在以前，实现枚举所用的数据类型取决于编译器，不过其二进制位的个数必须能完全表示下枚举编号才行。比如以上枚举的最大编号为 3，所以使用 1 个字节的 char 类型即可。（一个字节 8 位，可以表示 2^8=256 种枚举）
  缺点：无法前向声明枚举变量，因为（声明的时候）编译器不清楚底层数据类型的大小（定义的时候才确定），所以在用到此枚举类型时，也就不知道究竟该给变量分配多少空间。

- C++11 标准修订，可以指明用何种 “底层数据类型” 来保存枚举类型的变量。这样就可以前向声明枚举变量了，其写法为：

  ```objc
  enum EOCConnectionState ：NSInteger {
      EOCConnectionStateDisconnected,
      EOCConnectionStateConnecting,
      EOCConnectionStateConnected,
  };
  //前向声明
  enum EOCConnectionState ：NSInteger;
  ```

###### 用枚举定义选项 

各选项之间可以通过 “按位或” 运算来组合

```objc
enum UIViewAutoresizing  {
    UIViewAutoresizingNone                  = 0,
    UIViewAutoresizingFlexibleLeftMargin,   = 1 << 0,
    UIViewAutoresizingFlexibleWidth,        = 1 << 1,
    UIViewAutoresizingFlexibleRightMargin,  = 1 << 2,
};
typedef enum UIViewAutoresizing UIViewAutoresizing;

UIViewAutoresizing resizing = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
if (resizing & UIViewAutoresizingFlexibleLeftMargin) {
    ......
}
```

###### Foundation 中定义了关于枚举的辅助宏

1. 用这些宏可以指定用于保存枚举值的底层数据类型。
2. 这些宏还具备向后兼容能力 —— 如果目标平台的编译器支持新标准，就用新式语法，否则用旧式。
3. 这些宏是用 #define 预编译指令来定义的，其中一个用于定义 “状态” 枚举类型，另一个用于定义 “选项” 枚举类型。

```objc
typedef NS_ENUM(NSUInteger, EOCConnectionState) {
    EOCConnectionStateDisconnected,
    EOCConnectionStateConnecting,
    EOCConnectionStateConnected,
};
	
typedef NS_OPTIONS(NSUInteger, EOCPermittedDirection) {
    EOCPermittedDirectionUp    = 1 << 0,
    EOCPermittedDirectionDown  = 1 << 1,
    EOCPermittedDirectionLeft  = 1 << 2,
    EOCPermittedDirectionRight = 1 << 3,
};
```

NS_ENUM、NS_OPTIONS 宏定义

###### 应该用 NS_OPTIONS 来定义 “选项” 类型枚举

1. 提高通用性，免去类型强转操作

   > NS_OPTIONS 在 C++ 编译模式与非 C++ 模式下不同
   >
   > - 在非 C++ 模式下，其（展开方式）和 NS_ENUM 相同
   > - 在 C++ 模式下，如果还按 NS_ENUM 来的话就会编译错误。原因是，比如以下代码，C++ 认为按位或运算结果的数据类型应该是枚举的底层数据类型即 NSUInteger，而且 C++ 不允许将这个底层类型 “隐式转换” 枚举类型本身 EOCPermittedDirection，所以以下代码在 C++ 模式或者 Objective-C++模式下就会编译错误（error：cannot initialize a variable of type ‘EOCPermittedDirection’ with an rvalue of type ‘int’），需要显示转换一下。
   >
   > ```objc
   > EOCPermittedDirection permittedDirections = EOCPermittedDirectionLeft｜EOCPermittedDirectionRight；
   > ```
   >
   > 所以在 C++ 模式下，应该用 NS_OPTIONS 来定义 “选项” 类型枚举，因为它在 C++ 和非 C++ 模式下的 #define 是不一样的。

2. 提高可读性

###### 枚举在 switch 里的用法规范 

在处理枚举类型的 switch 语句中不要实现 default 分支。这样的话，如果我们新加了一种枚举类型，那么编译器就会给我们警告，提示新加的枚举类型没在 switch 中处理。而如果加了 default 分支就不会给警告了。这就不能确保 switch 语句能正确处理所有的枚举类型。

###### 用 `NS_ENUM` 和 `NS_OPTIONS` 来定义枚举类型，并指明其底层数据类型。这样可以确保枚举是用开发者所选的底层数据类型实现出来的，而不会采用编译器所选的类型。

---

### 第二章：对象、消息、运行期

#### 6. 理解 “属性” 这一概念

- 可以用 @property 语法来定义对象中所封装的数据。

- 通过 “特质” 来指定存储数据所需的正确语义。

- 在设置属性所对应的实例变量时，一定要遵从该属性所声明的语义。

- 开发 iOS 程序时应该使用 nonatomic 属性，因为 atomic 属性会严重影响性能。

属性用于封装对象中数据。可以用 `@property` 语法来定义属性。

###### `@synthesize` 和 `@dynamic`

可以通过 @synthesize 来指定实例变量名字，如果你不喜欢默认的以下划线开头来命名实例变量的话。但最好还是用默认的，否则别人可能看不懂。

如果不想令编译器合成存取方法，则可以自己实现。如果你只实现了其中一个存取方法 setter or getter，那么另一个还是会由编译器来合成。但是需要注意的是，如果你实现了属性所需的全部方法（如果属性是 readwrite 则需实现 setter and getter，如果是 readonly 则只需实现 getter 方法），那么编译器就不会自动进行@synthesize，这时候就不会生成该属性的实例变量，需要根据实际情况自己手动 @synthesize 一下。

[@synthesize 的使用场景]( https://blog.csdn.net/u014600626/article/details/107637195)

```objc
@synthesize name = _myName;
```

`@dynamic` 会告诉编译器：不要自动创建实现属性所用的实例变量，也不要为其创建存取方法，即告诉编译器你要自己做这些事。当使用了 `@dynamic`，即使你没有为其实现存取方法，编译器也不会报错，因为你已经告诉它你要自己来做。（比如NSManagedObject类里继承了一个子类，那么就需要在运行时动态创建存取方法，因为子类的某些属性不是实例变量，其数据来自后端的数据库）

###### 属性特质

通过 “特质” 来指定存储数据所需的正确语义 
属性关键字的类型有：原子性、读写权限、内存管理语义、方法名以及 Xcode 6.3 引入的可空性。 
[Link：《OC - 属性关键字和所有权修饰符》](https://juejin.im/post/6844904067425124366)

在设置属性所对应的实例变量时，一定要遵从该属性所声明的语义

> 注意：尽量不要在初始化方法和 dealloc 方法中调用存取方法。【🚩 7】

若是自己来实现存取方法，也应该保证其具备相关属性所声明的性质。

###### 开发 iOS 程序时，应使用 `nonatomic` 而非 `atomic`，因为 `atomic` 会严重影响性能。



#### 7. 在对象内部尽量直接访问实例变量

- 在对象内部读取数据时，应该直接通过实例变量来读，而写入数据时，则应通过属性来写。
- 在初始化方法及 dealloc 方法中，总是应该直接通过实例变量来读写数据。
- 有时会使用惰性初始化技术配置某份数据，这种情况下，需要通过属性来读取数据。

###### 直接访问实例变量和通过属性访问的区别：

1. 直接访问实例变量的速度比较快，编译器所生成的代码会直接访问保存对象实例变量的那块内存，而不是通过调用存取方法来访问。
2. 直接访问实例变量，不会调用 setter 方法，这就绕过了为相关属性所定义的 “内存管理语义”。比如一个声明为 copy 的属性，访问属性进行赋值的话，会 copy 新对象并 release 旧对象。而直接访问实例变量则是 retain 新对象并 release 旧对象。
3. 直接访问实例变量，就不会触发 KVO，因为 KVO 是通过在运行时生成派生类并重写 setter 方法以达到通知所有观察者的目的。这样做是否会产生问题，取决于具体的对象行为。
4. 通过属性方法有助于排查与之相关的错误，因为可以在 setter 和 getter 方法中设置断点来调试。

###### 在初始化方法和 dealloc 方法中不建议使用存取方法，应该直接访问实例变量

- 为什么在初始化方法中不建议使用存取方法？

  因为子类可能会重写 setter 方法从而可能导致一些问题的发生[深入浅出 Runtime（四）：super 的本质](https://juejin.cn/post/6844904072252751880)

方案：在对象内部读取数据时，应该直接通过实例变量来读，而写入数据时，则应该通过属性来写。这样既能提高读取操作的速度，又能控制对属性的写入操作。因为写入数据使用实例变量的话，就会绕过为相关属性所定义的 “内存管理语义”。如果我们直接通过访问实例变量来写入数据，则应该根据它的内存管理语义来设置。比如声明为 copy 的 name 属性：`_name = [name copy]`。



#### 8. 理解 “对象等同性” 这一概念

- 若想检测对象的等同性，请提供 “`isEqual:`” 与 “`hash`” 方法。

- 相同的对象必须具有相同的哈希码，但是两个哈希码相同的对象却未必相同。

- 不要盲目地检查每条属性，而是应该依照具体需求来制定检测方案。

- 编写 hash 方法时，应该使用计算速度快而且哈希码碰撞几率低的算法。

###### 同等性判断

`==` 操作符比较的是两个指针本身，而不是其所指的对象。所以有时候这结果不是我们想要的。
应该使用 NSObject 协议中声明的 `isEqual:` 方法来判断两个对象的等同性。某些对象提供了特殊的“等同性判定方法”，比如 NSString 的 `isEqualToString:`、NSArray 的 `isEqualToArray:`、NSDictionary 的 `isEqualToDictionary:`。

- `isEqualToString:` 参数必须是 NSString 类型，否则结果未定义，但不会抛出异常。
- `isEqualToArray:` 和 `isEqualToDictionary:` 的参数也必须是 NSArray 和 NSDictionary 类型，否则会抛出异常 `reason: ' -[NSArray isEqualToArray:]: array argument is not an NSArray'`。 我们也可以根据自己类的需求，编写自己的 “等同性判定方法”。

我们来看一段代码

```objc
NSString *foo = @"Badger 123";
NSString *bar = [NSString stringWithFormat:@"Badger %i", 123];
BOOL equalA = (foo == bar);               // equalA = NO
BOOL equalB = [foo isEqual:bar];          // equalB = YES
BOOL equalC = [foo isEqualToString:bar];  // equalC = YES
```

`==` 操作符判断 foo 和 bar 是两个不相等的字符串，因为它比较的是指针； 
调用 `isEqualToString:` 方法比调用 `isEqual:` 方法要快，因为后者还要执行额外的步骤，它不知道受测(比较)对象的类型。而 isEqualToString: 知道消息接收者和参数都以 NSString 类型来比较。

###### NSObject 协议中定义了两个 “等同性判定方法”

```objc
-(BOOL)isEqual:(id)object;
-(NSUInteger)hash;
```

这两个方法的默认实现是：当且仅当其指针值完全相等时，这两个对象才相等。也就是说其默认实现相当于 `==` 操作符

如果想正确重写这两个方法，来实现自定义对象的 “等同性判定”，就必须遵守规则：

1. 如果 `isEqual:` 方法判定两个对象相等，那么其 `hash` 方法也必须返回同一个值。
2. 但是，如果两个对象的 `hash` 方法返回同一个值，其 `isEqual:` 方法未必会认为两者相等。 举例如下：

```objc
@interface Person : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger age;
@end

@implementation Person

- (BOOL)isEqual:(id)other {

    if (other == self) return YES;
    if ([self class] != [other class]) return NO; // 有时候我们可能认为，一个 Person 的实例可以与其子类的实例相等，所以要考虑这一种情况

    Person *otherPerson = (Person *)other;
    if (![_firstName isEqualToString:otherPerson.firstName]) return NO;
    if (![_lastName isEqualToString:otherPerson.lastName]) return NO;
    if (_age != otherPerson.age) return NO;

    return YES;
}

- (NSUInteger)hash {

    NSUInteger firstNameHash = [_firstName hash];
    NSUInteger lastNameHash  = [_lastName hash];
    NSUInteger ageHash = _age;
    return firstNameHash ^ lastNameHash ^ ageHash;
}

@end
```

###### 重写的 hash 方法的效率问题 

根据等同性约定：若两个对象相等，则其 hash 也相等，但是两个 hash 相等的对象却未必相等。所以以下这样重写 hash 完全可行：

```objc
- (NSUInteger)hash {
    return 1337;
}
```

但是这么写的话，在 collection（Array、Dictionary、Set）中使用这种对象将产生性能问题，因为 collection 在检索哈希表时，会用对象的 hash 做索引。假如某个 collection 是用 set 实现的，那么 set 可能会根据 hash 把对象分装到不同的 “箱子数组” 中。在向 set 中添加新对象时，要根据其 hash 找到与之相关的那个数组，依次检查其中各个文件，看数组中已有的对象是否和将要添加的对象相等。如果相等，那就说明要添加的对象已经在 set 里面。由此可知，如果令每个对象都返回相同的 hash，那么在 set 中已有 1000000 个对象的情况下，若是继续向其中添加对象，则需将这 1000000 个对象全部扫面一遍，因为这些相同 hash 的对象都存在一个数组中。 

以下做法可行，但是这样做还需负担创建字符串的开销，所以比返回单一值要慢。把这种对象添加进 collection 也会有性能问题，因为要想添加必须先计算其 hash。

```objc
- (NSUInteger)hash {
    NSString *stringToHash = [NSString stringWithFormat:@"%@:%@:%i", _firstName, lastName, _age];
    return [stringToHash hash];
}
```

最佳做法如下。这种做法既能保持较高效率，又能使生成的 hash 至少位于一定范围之内，而不会过于频繁地重复。当然，此算法生成的 hash 还是会碰撞，不过至少可以保证 hash 有很多种可能的取值。在编写 hash 方法时，应该用当前的对象做做实验，以便在减少碰撞频度与降低运算复杂度之间取舍。

```objc
- (NSUInteger)hash {
    NSUInteger firstNameHash = [_firstName hash];
    NSUInteger lastNameHash  = [_lastName hash];
    NSUInteger ageHash = _age;
    return firstNameHash ^ lastNameHash ^ ageHash;
}
```

###### 自定义 “等同性判定方法”。

1. 好处：

   1. 无须检测参数类型，可以大大提升检测速度；
   2. 自己定义的方法名看上去可以更美观、更易读，就像 NSString 的 isEqualToString: 等一样。

2. 在编写自己的“等同性判定方法”时，也应一并重写 isEqual: 方法。该方法实现通常如下：

   ```objc
   - (BOOL)isEqualToPerson:(Person *)otherPerson {
       if (self == object) return YES;
   
       if (![_firstName isEqualToString:otherPerson.firstName]) return NO;
       if (![_lastName isEqualToString:otherPerson.lastName]) return NO;
       if (_age != otherPerson.age) return NO;
   
       return YES;
   }
   
   - (BOOL)isEqual:(id)other {
       if ([self class] == [other class]) {
           return [self isEqualToPerson:(Person *)other]
       } else {
           return [super isEqual:other];
       }
   }
   ```

3. 创建等同性判定方法时，需要决定是根据整个对象来判断等同性，还是仅根据其中几个字段来判断 —— 等同性判定的执行深度。

###### 等同性判定的执行深度

NSArray 的 isEqualToArray: 的检测方式：

1. 先看两个数组所含对象个数是否相同。
2. 若相同，则在每个对应位置的两个对象身上调用其 isEqual: 方法。
3. 如果对应位置上的对象均相等，那么这两个数组就相等。这叫做 “深度等同性判定”。

有时候也许我们只会根据标识符或者某些字段来判断等同性，所以是否需要在等同性判定方法中检测全部字段取决于受测对象。我们可以根据两个对象实例在何种情况下应判定为相等来编写等同性判定方法。

###### 容器中可变类的等同性 

在容器中放入某个对象的时候，就不应该再改变其 hash 值了，否则会有隐患。 
因为 collection 会把各个对象按照其 hash 分装到不同的 “箱子数组” 中，如果某对象在放入箱子后 hash 又变了，那么其现在所处的箱子对它来说就是 “错误” 的。 
所以，要确保添加到容器中对象的 hash 不是根据对象的 “可变部分” 计算出来的，或是保证之后不再改变对象内容。因此，我们最好不要往容器中添加 NSMutableArray 等可变对象，（例子： set中添加mutablearray，可能会出现含有相同两个array且互相相等的现象，使用copy可能不能和原本set一致）。



#### 9. 以 “类族模式” 隐藏实现细节

- 类族模式可以把实现细节隐藏在一套简单的公共接口后面。
- 系统框架中经常使用类族。
- 从类族的公共抽象基类中继承子类要当心，若有开发文档，则应首先阅读。

类族是一种设计模式：定义一个抽象基类，使用 “类族” 把具体行为放在它的子类们中，将它们的实现细节隐藏在抽象基类后面，以保持接口简洁。

类族模式的意义在于：使用者无须关心创建出来的实例具体是什么类型，也不用考虑其实现细节，只需调用基类方法来创建即可。(UIButton 就使用了类族，buttonWithType: 方法返回的 button 类型取决于传入的 type。)

```objc
//举例
typedef NS_ENUM(NSUInteger, EOCEmployeeType) {
  EOCEmployeeTypeDeveloper,
  EOCEmployeeTypeDesigner,
  EOCEmployeeTypeFinance
};
@inteface EOCEmployee : NSObject
  @property (copy) NSString *name;
  @property NSUInteger salary;
+ (EOCEmployee *)emplayeeWithType: (EOCEmployeeType) type;
- (void)doADaysWork;
@end
  
@implementation EOCEmployee
+ (EOCEmployee *)employeeWithType: (EOCEmployeeType)type {
  switch (type) {
    case EOCEmployeeTypeDeveloper:
      return [EOCEmployeeDeveloper new];
      break;
    case EOCEmployeeTypeDesigner:
      return [EOCEmployeeDesigner new];
      break;
    case EOCEmployeeTypeFinance:
      return [EOCEmployeeFinance new];
      break;
  }
}

- (void)doADaysWork {
  //subclasses implement this.
}

@interface EOCEmployeeDeveloper: EOCEmployee
@end
  
@implementation EOCEmployeeDeveloper
- (void) doADaysWork {
  [self writeCode];
}
@end
```

像这种 “工厂模式” 就是创建类族的办法之一。此外，NSArray、NSMutableArray 等大部分 collection 类都使用了类族模式。

如果对象所属类位于某个类族中，那么在查询其类型时就应该当心。应该使用 `isKindOfClass:` 而不是 `isMemberOfClass:` 或者 `[A class] == [B class]`。（实际上创建的是其子类的实例）

由于 OC 是没办法指明某个基类是 “抽象” 的，所以应该在文档中写明类的用法，以告诉使用者这是类族的抽象基类，不能使用 init 等方法来实例化抽象基类，而是应该使用指定方法创建实例。我们也可以在基类的方法中抛出异常，来提示使用者这是类族的抽象基类，不过这种做法比较极端，很少使用。

```objc
#define MASMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

- (void)setCenterOffset:(CGPoint __unused)centerOffset { MASMethodNotImplemented(); }
```

向类族中新增实体子类的时候要当心。如果有开发文档，应该首先阅读，了解规则。
比如新增一个 NSArray 类族的子类，要遵守以下规则：

1. 子类应该继承自类族中的抽象基类；
2. 子类应该定义自己的数据存储方式；
3. 子类应当覆写超类文档中指明需要覆写的方法 `count` 及 `objectAtIndex:`。



#### 10. 在既有类中使用关联对象存放自定义数据

- 可以通过 “关联对象” 机制来把两个对象连起来。
- 定义关联对象时可指定内存管理语义，用以模仿定义属性时所采用的 “拥有关系” 与 “非拥有关系”。
- 只有在其他做法不可行时才应选用关联对象，因为这种做法通常会引入难以查找的 bug。 

当需要在对象中存放相关信息，而通过继承在子类的实例中去存储值这条路行不通的时候，可以通过创建对象所属类的分类，并在分类中通过关联对象来存储值。

关联对象相关 API：

1. 以给定的键和策略为某对象设置关联对象值：

```objc
void objc_setAssociatedObject(id object, void *key, id value, objc_AssociationPolicy policy)
```

2. 根据给定的键从某对象中获取相应的关联对象值：

```objc
id objc_getAssociatedObject(id object, void *key)
```

3. 移除指定对象的全部关联对象

```objc
void objc_removeAssociatedObjects(id object)
```

关联策略由名为 objc_AssociationPolicy 的枚举所定义，其和属性关键字的对应关系如下：

| 关联类型                          | 等效的 @property 属性 |
| --------------------------------- | --------------------- |
| OBJC_ASSOCIATION_ASSIGN           | assign                |
| OBJC_ASSOCIATION_RETAIN_NONATOMIC | nonatomic, retain     |
| OBJC_ASSOCIATION_COPY_NONATOMIC   | nonatomic, copy       |
| OBJC_ASSOCIATION_RETAIN           | retain                |
| OBJC_ASSOCIATION_COPY             | copy                  |

[OC 底层探索 - Association 关联对象](https://juejin.cn/post/6844903972315070471)

```objc
//举例
- (void)askUserAQuestion {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Question" message:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTtitles:@"Continue", nil];
  [alert show];
}

//protocol method
- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if(buttonIndex ==0) {
    [self doCancel];
  } else {
    [self doContinue];
  }
}

//如果想在一个类里处理多个警告信息视图，那么代码就会变的复杂。我们需要在delegate方法中检查传入的alertview参数，并据此选用相应的逻辑。
//可以通过关联对象，创建完警告视图之后，设定一个与之关联的block，等到执行delegate方法时再将其读出来

#import <objc/runtime.h>
static void *EOCMyAlertViewKey = "EOCMyAlertViewKey";
- (void)askUserAQuestion {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Question" message:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTtitles:@"Continue", nil];
  void (^block)(NSInteger) = ^(NSInteger buttonIndex){
    if(buttonIndex == 0){
      [self doCancel];
    } else {
      [self doContinue];
    }
  };
  objc_setAssociatedObject(alert, EOCMyAlertViewKey, block, BJC_ASSOCIATION_COPY);
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  void (^block)(NSInteger) = objc_getAssociatedObject(alertView, EOCMyAlertViewKey);
  block(buttonIndex);
}
// 采用该方案需注意：block可能要capture某些变量，也许会造成“保留环”
// 创建这种UIAlertView还有哥办法，那就是从中继承子类，把block保存为子类中的属性。
```

```objc
// key 的常见用法
// ①
static const void *MyKey = &MyKey;
objc_setAssociatedObject(object, MyKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
objc_getAssociatedObject(object, MyKey];

// ② 
static const char MyKey;
objc_setAssociatedObject(object, &MyKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
objc_getAssociatedObject(object, &MyKey];

// ③ 使用属性名作为 key
#define MYHEIGHT @"height"
objc_setAssociatedObject(object, MYHEIGHT, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
objc_getAssociatedObject(object, MYHEIGHT];

// ④ 使用 getter 方法的 SEL 作为 key（可读性高，有智能提示）
objc_setAssociatedObject(object, @selector(getter), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
objc_getAssociatedObject(object, @selector(getter)];
// 或使用隐式参数 _cmd
objc_getAssociatedObject(object, _cmd];
```

###### 如果没有关联对象，怎么实现 Category 有成员变量的效果？

使用字典。创建一个全局的字典，将`self`对象在内存中的地址作为`key`。
 缺点：① 内存泄漏问题：全局变量会一直存储在内存中；
   ② 线程安全问题：可能会有多个对象同时访问字典，加锁可以解决；
   ③ 每添加一个成员变量就要创建一个字典，很麻烦。

```objc
#import "Person.h"
@interface Person (Test)
@property (nonatomic, assign) int height;
@end

#import "Person+Test.h"
#import <objc/runtime.h>
@implementation Person (Test)
NSMutableDictionary *heights_;
+ (void)load {
    heights_ = [NSMutableDictionary dictionary];
}
- (void)setHeight:(int)height {
    NSString *key = [NSString stringWithFormat:@"%@",self];
    heights_[key] = @(height);
}
- (int)height {
    NSString *key = [NSString stringWithFormat:@"%@",self];
    return [heights_[key] intValue];
}
```



#### 11. 理解 objc_msgSend 的作用

- 消息由接收者、选择子及参数构成。给某对象 “发送消息” 也就相当于在该对象上 “调用方法”。
- 发给某对象的全部消息都要由 “动态消息派发系统” 来处理，该系统会查出对应的方法，并执行其代码。

静态绑定与动态绑定：

- C 语言的函数调用方式是使用 “静态绑定”。在编译期就能决定运行时所应调用的函数。如果不考虑 “内联”，编译器在编译代码的时候就已经知道程序中哪些函数了，于是就会生成调用这些函数的指令，而函数地址实际上是硬编码在指令之中的。
- OC 中，如果向某对象传递消息，那就会使用 “动态绑定” 机制来决定需要调用的方法，所要调用的方法在运行时才确定。

在 OC 中，给对象发送消息的语法为：

```objc
id returnValue = [someObject messageName:parameter];
```

在这里，someObject 叫做 “`接收者`”，messageName 叫做 “`选择子`”，选择子与参数合起来称为 “`消息`”。编译器看到此消息后，会将其转换为一条标准的 C 语言函数调用，所调用的函数为消息机制的核心函数 `objc_msgSend`：

```objc
void objc_msgSend(id self, SEL _cmd, ...)
```

该函数参数个数可变，能接受两个或两个以上参数。前面两个参数 “self 消息接收者” 和 “_cmd 选择子” 即为 OC 方法的两个隐式参数，后续参数就是消息中的那些参数（也就是方法显式参数）。
OC 中的方法调用在编译后会转换成该函数调用，比如以上方法调用后转换为：

```objc
id returnValue = objc_msgSend(someObject, @selector(message:), parameter);
```

objc_msgSend函数会依据接受者与选择子的类型来调用适当的方法。为了完成此操作，该方法需要在接受者所属的类中搜寻其方法列表，如果能找到与选择子名称相符的方法，就跳至其实现代码。如果找不到，就沿着继承体系继续向上查找，等找到合适的方法之后跳转。如果还是找不到相符的方法，那就执行消息转发（见第12条）。

objc_msgSend会将匹配的结果缓存在fast map里，每个类都有这样一块缓存，提高方法的查找速度。

理解 objc_msgSend 函数执行流程 
[Link：《深入浅出 Runtime（三）：消息机制》](https://juejin.im/post/6844904072235974663#heading-3)

调用的方法会被缓存，这样可以提高方法的查找速度 
[Link：《深入浅出 Runtime（二）：数据结构》](https://juejin.im/post/6844904072215003143#heading-5)

其他 “边界情况（特殊情况）” 的消息交由其他函数处理，以下简单说明：

- objc_msgSend_stret：待发送的消息返回的是结构体
- objc_msgSend_fpret：待发送的消息返回的是浮点数
- objc_msgSendSuper：给超类发消息，[super messege:parameter] [Link：《深入浅出 Runtime（四）：super 的本质》](https://juejin.cn/post/6844904072252751880)

理解 “尾调用优化” 技术。



#### 12. 理解消息转发机制

- 对象无法响应某个选择子，则进入消息转发流程。
- 通过运行期的动态方法解析功能，我们可以在需要用到这个方法时再将其加入类中。
- 对象可以把其无法解读的某些选择子转交给其他对象来处理。
- 经过上述两步之后，如果还是没办法处理选择子，那就启动完整的消息机制。

该章节详细讲诉了 OC 消息机制中的 “消息转发 ”阶段。当对象在 “消息发送” 阶段无法处理消息（找不到方法实现）时，就会进入 “消息转发” 阶段，开发者可以在此阶段处理未知消息。

消息机制可分为 “消息发送”、“动态方法解析”、“消息转发” 三大阶段。而该书作者将 “动态方法解析” 归并到了 “消息转发“ 阶段中。

消息转发分为两大阶段：

- 动态方法解析：通过动态添加方法实现，来处理未知消息。
- 真正的消息转发，此阶段又分为 Fast 和 Normal 两个阶段：
  - Fast：找一个备用接收者，尝试将未知消息转发给备用接收者去处理。
  - Normal：启动完整的消息转发，将消息有关的全部细节都封装到 NSInvocation 对象中，再给接收者最后一次机会去处理未知消息。

###### 动态方法解析

```objc
+ (BOOL)resolveInstanceMethod:(SEL)selector;
+ (BOOL)resolveClassMethod:(SEL)selector
```

我们可以在消息接收者类中，根据是实例方法还是类方法，实现以上方法来启用 “动态方法解析”，通过动态添加方法实现，来处理未知消息。方法参数即为未知消息的选择子，返回值表示这个类是否已经动态添加方法实现来处理（实际上该返回值只是用来判断是否打印信息，影响不大，不过还是要规范编写）。 

使用这种办法的前提是：相关方法的实现代码已经写好，只等着运行的时候动态插在类里面就可以了。

常用来实现 `@dynamic` 属性，在运行时动态添加属性 setter 和 getter 方法的实现。书中以一个完整的例子示范了 “如何以动态方法解析来实现 @dynamic 属性”，感兴趣的可以去看看。

```objc
id autoDictionaryGetter(id self, SEL _cmd);
void autoDictionarySetter(id self, SEL _cmd, id value);

+ (BOOL) resolveInstanceMethod: (SEL) selector {
  NSString *selectorString = NSStringFromSelector(selector);
  if(/*selector is from a @dynamic property*/){
    if([selectorString hasPrefix:@"set"]){
      class_AddMethod(self, selector, (IMP)autoDictionarySetter, "v@:@");
    } else {
      class_addMthod(self, selector, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
  }   
  return [super resolveInstanceMthod:selector];
}
```

消息转发

- Fast - 找备用接收者：

  当前接受者还有第二次机会能处理未知的选择子，在这一步中，运行期系统会问它：能不能把这条消息转给其他接受者来处理。

```objc
+/- (id)forwordingTargetForSelector:(SEL)selector;
```

方法参数即为未知消息的选择子，返回值为备用接收者。 
通过此方案，我们可以用 “组合” 来模拟出 “多重继承” 的某些特性。在一个对象内部，可能还有一系列其他对象，该对象可经由此方法将能够处理某选择子的相关内部对象返回，这样的话，在外界看来，好像是该对象亲自处理来这些消息似的。 
请注意，在此阶段无法修改未知消息的内容，如果需要，请在 Normal 阶段去处理。

- Normal - 完整的消息转发：

```objc
+/- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
```

通过实现以上方法返回一个适合该未知消息的方法签名，Runtime 会根据这个方法签名，创建一个封装了未知消息的全部内容（target、selector、argument）的 `NSInvocation` 对象。然后调用以下方法并将该 NSInvocation 对象作为参数传入。

```objc
+/- (void)forwardInvocation:(NSInvocation *)invocation;
```

在该方法中只需改变 target 即可，但一般不会这样做，因为这样做不如在 Fast 阶段就处理。比较有用的实现方式是：改变消息内容，比如改变选择子，追加一个参数等，再转发给其他对象处理。

实现以上方法时，不应由本类处理的未知消息，应该调用父类的实现，这样继承体系中的每个类都有机会处理未知消息，直至 NSObject。

NSObject 的默认实现是最终调用 `doseNotRecognizeSelector` 方法，并抛出家喻户晓的异常 `unrecognized selector send to instance/class`，表明未知消息最终未能得到处理。 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b68c5b6548584fbfa79941d355475e09~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

以上几个阶段均有机会处理消息，但处理消息的时间越早，性能就越高。

- 最好在 “动态方法解析” 阶段就处理完，这样 Runtime 就可以将此方法缓存，这样稍后这个实例再接收到同一消息时就无须再启动消息转发流程。
- 如果在 “消息转发” 阶段只是单纯想将消息转发给备用接收者，那么最好在 Fast 阶段就完成。否则还得创建并处理 NSInvocation 对象。

关于方法缓存和消息机制的详细流程，感兴趣的可以阅读笔者的博客： 
[Link：《深入浅出 Runtime（二）：数据结构》](https://juejin.im/post/6844904072215003143#heading-5) 
[Link：《深入浅出 Runtime（三）：消息机制》](https://juejin.im/post/6844904072235974663#heading-3)

```objc
// 例子：

#import <Foundation/Foundation.h>
@interface EOCAutoDictionary : NSObject
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) id opaqueObject;
@end
  
#import "EOCAutoDictionary.h"
#import <objc/runtime.h>
  
@interface EOCAutoDictionary ()
@property (nonatomic, strong) NSMutableDictionary *backingStore;
@end
  
@implementation EOCAutoDictionary
@dynamic string. number, date, opaqueObject;

- (instanceType) init {
  if((self = [super init])) {
    _backingStore = [NSMutableDictionary new];
 
  }
  return self;
}

//关键
+ (BOOL) resolveInstanceMethod: (SEL) selector {
  NSString *selectorString = NSStringFromSelector(selector);
  if([selectorString hasPrefix:@"set"]){
    class_addMethod(self, selector, (IMP)autoDictionarySetter, "v@:@");
  } else {
    class_addMethod(self, selector, (IMP)autoDictionaryGetter, "@@:");
  } //最后参数表示待添加方法的类型编码
  return YES;
}
@end

id autoDictionaryGetter(id self, SEL _cmd) {
  EOCAutoDictionary *typedSelf = (EOCAutoDictionary*)self;
  NSMutableDictionary *backingStore = typedSelf.backingStore;
  
  //the key is simply the selector name
  NSString *key = NSStringFromSelector(_cmd);
  return [backingStore objectForKey:key];
}

void autoDictionarySetter(id self, SEL _cmd, id value) {
  EOCAutoDictionary *typedSelf = (EOCAutoDictionary*)self;
  NSMutableDictionary *backingStore = typedSelf.backingStore;
  NSString *selectorString = NSStringFromSelector(_cmd);
  NSString *key = [selectorString mutableCopy];
  [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
  [key deleteCharactersInRange: NSMakeRange(0,3)];
  NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
  [key replaceCharactersInRange: NSMakeRange(0,1) withString:lowercaseFirstChar];
  
  if(value){
    [backingStore setObject:value forKey:key];
  } else {
    [backingStore removeObjectForKey: key];
  }
}
```

CALayer 称为“兼容于键值变啊吗的”容器类，依赖于同样的实现方式。



#### 13. 用 “方法调配技术” 调试 “黑盒方法” method swizzling

- 在运行期，可以向类中新增或替换选择子所对应的方法实现。
- 使用另一份实现来替换原有的方法实现，这道工序叫做 “方法调配”，开发者常用此技术向原有实现中添加新功能。
- 一般来说，只有调试程序的时候才需要在运行期修改方法实现，这种做法不宜滥用

该篇标题很新奇，其实就是利用 Runtime 动态交换方法实现（`method swizzling`）。

通过 `method swizzling`，我们既不需要修改源代码，也不需要通过继承子类来覆写方法就能改变这个类本身的功能。可以为那些 “完全不透明（完全不知道具体实现）” 的黑盒方法增加日志记录功能，非常有助于程序调试。但我们应该合理使用它，不能仅仅因为它是 OC 的一个特性就一定要用，若是滥用反而会令代码变得不易读懂且难于维护。

方法其实就是 `SEL` 到 `IMP` 的映射。我们调用方法，实际上就是根据方法 SEL 查找 IMP。而 IMP 就是指向方法实现的函数指针。

动态交换方法实现的步骤如下，别忘了 #import <objc/runtime.h> 哦：

```objc
Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
Method swappedMethod  = class_getInstanceMethod([NSString class], @selector(uppercaseString));
method_exchangeImplementations(originalMethod, swappedMethod);
```

一般情况下，像以上这样直接交换两个方法实现的，意义不大。我们可以通过 `method swizzling` 来为既有的方法实现增添新功能。比方说在调用 lowercaseString 时记录某些信息，如下：

```objc
Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
Method swappedMethod  = class_getInstanceMethod([NSString class], @selector(eoc_myLowercaseString));
method_exchangeImplementations(originalMethod, swappedMethod);

- (NSString *)eoc_myLowercaseString {
    NSString *lowercase = [self eoc_myLowercaseString];
    NSLog(@"%@ => %@", self, lowercase);
    return lowercase;
}
```

放心，以上代码不会递归调用死循环的，因为方法交换实现后，eoc_myLowercaseString 的 SEL 对应的是 lowercaseString 方法的 IMP。



#### 14. 理解 “类对象” 的用意

- 每个实例都有一个指向 Class 对象的指针，用以表明其类型，而这些 Class 对象则构成了类的继承体系。

- 如果对象类型无法在编译期确定，那么就应该使用类型信息查询方法来探知。

- 尽量使用类型信息查询方法来确定对象类型，而不要直接比较类对象，因为某些对象可能实现了消息转发功能。

关于 id 类型：

- id 能指代任意的 OC 对象类型。一般情况下，应该指明消息接收者的具体类型，这样如果给该对象发送无法解读的消息，编译器就会给出警告。而 id 类型对象则不会，因为编译器假定它能响应所有消息。

- id 其实就是指向 objc_object 结构体的一个指针。

  ```objc
  // A pointer to an instance of a class.
  typedef struct objc_object *id;
  ```

每一个 OC 对象的底层结构都为 `objc_object` 结构体。类和元类对象的底层结构都为 `objc_class` 结构体，其继承自 `objc_object`，它们之间通过 “`is a`” 指针联系。 
关于 OC 对象底层数据结构，isa 指针等的详细讲解，可以参阅： 
[Link：《深入浅出 Runtime（二）：数据结构》](https://juejin.im/post/6844904072215003143)

super_class 指针确立了继承关系，而 isa 指针描述了实例所属的类。

编译器无法确定某类型对象能不能处理未知消息，因为运行期可以动态添加。但即便这样，编译器也觉得至少应该要有方法的声明，据此了解完整的 “方法签名(Type Encoding)”，并生成发送消息所需的正确代码。

类型信息查询方法 —— 在运行期检视对象类型。

```objc
-/+ (BOOL)isMemberOfClass:(Class)cls;
-/+ (BOOL)isKindOfClass:(Class)cls;
```

```
isMemberOfClass:
```

判断当前 instance/class 对象的 isa指向是不是 class/meta-class 对象类型（也就是判断当前对象是否为某个类的实例）；

```
isKindOfClass:
```

判断当前 instance/class 对象的 isa指向是不是 class/meta-class 对象或者它的子类类型（也就是判断当前对象是否为某个类或其子类的实例）。

以下这篇文章中详细讲解了一道关于这两个方法的面试题，感兴趣的可以看看。

[Link:《深入浅出 Runtime（五）：相关面试题》](https://juejin.cn/post/6844904072428912653#heading-10)

由于 OC 是动态运行时语言，所以 “类型信息查询方法” 非常有用。从 collection (Array、Dictionary、Set) 中获取对象时，通常会查询类型信息，因为它们取出来时通常是 id 类型而不是 “强类型” 的。查询类型信息可以避免意外的调用了该类型对象响应不了的方法而导致 Crash，就比如：

```objc
for (id object in array) {
    if ([object isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)object;
        NSString *uppercaseString  = [string uppercaseString];
        ...
    }
}
```

如果我们省去 “类型信息查询” 这一步，直接调用 

```
[object uppercaseString];
```

，那么如果该数组中意外的存储了一个非 NSString 实例，那么就会因响应不了未知消息（也就是找不到方法实现）而导致 Crash。

也可以通过比较类对象是否等同，直接使用 

```
==
```

 操作符就行，不必使用 

```
isEqual:
```

 方法。原因是，类对象是 “单例”，在应用程序范围内不存在同名的类。使用 isEqual: 方法只会产生不必要的性能开销。

```objc
if ([object class] == [NSString class]) {
    ...
}
```

在程序中尽量不要直接比较对象所属的类，而是调用 “类型信息查询方法” 来确定对象类型。因为后者可以正确处理那些使用了消息转发的对象。

比方说，某个对象可能会把它所接收的选择子都转发给另一个对象，这样的对象叫做代理 (proxy)，它们均以 NSProxy 为根类。

如果在此种代理对象上调用 class 方法，其返回的代理对象本身的类，而非接受的代理的对象所属的类。比如 HTProxy 继承于 NSProxy，其将消息都转发给一个叫 HTPerson 类的实例，现在有一个 HTProxy 的实例 proxy，那么：

```objc
Class cls = [proxy class];
```

cls 为 HTProxy 而非 HTPerson。 如果改用类型信息查询方法，那么代理对象就会把这条消息转发给 “接受的代理的对象”。

```objc
BOOL res = [proxy isKindOfClass:[HTPerson class]];
```

res 值为 YES。

因此，以上两种方法所查询处理的对象类型不同。

##### 拓展：理解Objective-C 运行时

[reference](https://cocoasamurai.blogspot.com/2010/01/understanding-objective-c-runtime.html)

objective c 是面向运行时的语言。它具体执行的时候从编译时或链接时推迟到它真正执行这段代码的时候。

这个特性赋予oc很大的灵活性，可以将消息重定向到适合的对象，或者甚至可以有意地交换方法的实现。

例子：

```objc
[self doSomethingWithVar:var1];
```

在汇编阶段， 依赖于Objective-C Runtime Library，代码被转换成

```objc
objc_msgSend(self,@selector(doSomethingWithVar:),var1);
```

> **Objective-C Runtime Library：**
>
> Objective-C 运行时是一个运行时库，主要由 C 和汇编语言写成，给 C 语言增加了面向对象的功能以创建 Objective-C
>
> This means it loads in Class information, does all method dispatching, method forwarding, etc. 
>
> The Objective-C runtime essentially creates all the support structures that make Object Oriented Programming with Objective-C Possible

##### 术语

1. The Modern Runtime (all 64 bit Mac OS X Apps & all iPhone OS Apps) & the Legacy Runtime (all 32 bit Mac OS X Apps) 

2. Instance Methods & Class Methods

3. Message

   一个 Objective-C 消息包含中方括号里面的全部内容：消息的发送目标、希望目标执行的方法以及任何你发送给目标的参数。

   The fact that you send a message to an object doesn't mean that it'll perform it. 

   The Object could check who the sender of the message is and based on that decide to perform a different method or forward the message onto a different target object.


###### 数据结构

1. id

   ```objc
   /// A pointer to an instance of a class.
   typedef struct objc_object *id;
   
   /// Represents an instance of a class.
   struct objc_object {
       Class isa  OBJC_ISA_AVAILABILITY;
   };
   ```

2. Class 

   当你查看运行时中的一个类你会看到这个：

   ```objc
   typedef struct objc_class *Class;
   typedef struct objc_object {
       Class isa;
   } *id;
   //a struct for an Objective-C Class & a struct for an object
   //isa pointer 
   //id pointer 
   
   struct objc_class : objc_object {
       // Class ISA;
       Class superclass;          // 指向父类
       cache_t cache;             // 方法缓存 formerly cache pointer and vtable
       class_data_bits_t bits;    // 用于获取具体的类信息 class_rw_t * plus custom rr/alloc flags
   
       class_rw_t *data() { 
           return bits.data();
       }
   };
   
   ```

3. Objective-C 类

   ```objc
   //基本实现
   @interface MyClass : NSObject {
     //vars
     NSInteger counter;
   }
   //methods
   -(void)doFoo;
   @end
      
   //但是运行时跟踪记录的比这要多
         #if !__OBJC2__
         Class super_class                                  OBJC2_UNAVAILABLE;
         const char *name                                   OBJC2_UNAVAILABLE;
         long version                                       OBJC2_UNAVAILABLE;
         long info                                          OBJC2_UNAVAILABLE;
         long instance_size                                 OBJC2_UNAVAILABLE;
         struct objc_ivar_list *ivars                       OBJC2_UNAVAILABLE;
         struct objc_method_list **methodLists              OBJC2_UNAVAILABLE;
         struct objc_cache *cache                           OBJC2_UNAVAILABLE;
         struct objc_protocol_list *protocols               OBJC2_UNAVAILABLE;
       #endif 
   ```

   有父类、名字、实例变量、方法、缓存和它声明要遵守的协议等的引用。

   运行时需要这些信息来响应你的类或实例的消息 when responding to messages 

4. Sel:

   Essentially a C data struct;

   Identify an Objective-C method you want an object to perform.

   In the runtime it's defined like so...

   ```cpp
   /// An opaque type that represents a method selector.
   typedef struct objc_selector *SEL;
   /// and used like so...
   SEL aSel = @selector(movieTitle); 
   ```

   - 结构体`objc_selector`的定义找不到
   - 可以将SEL理解为方法名的hash值，可以加快方法的查找速度
   - C中函数名是函数实现的地址，而SEL只跟函数名有关，不涉及函数实现的地址。将函数名和函数实现分离，可以实现函数交换等功能。
   - SEL只跟方法名有关，跟参数无关，没有C++中的函数重载功能
   - [Opaque Types](https://link.jianshu.com?t=https://developer.apple.com/library/content/documentation/CoreFoundation/Conceptual/CFDesignConcepts/Articles/OpaqueTypes.html)

5. Method

   在文件`objc/runtime.h`中

   ```cpp
   /// An opaque type that represents a method in a class definition.
   typedef struct objc_method *Method;
   
   struct objc_method {
       SEL method_name                                          OBJC2_UNAVAILABLE;
       char *method_types                                       OBJC2_UNAVAILABLE;
       IMP method_imp                                           OBJC2_UNAVAILABLE;
   }
   ```

   方法：SEL（函数名）、IMP（函数实现）、method_types（参数）的统一体。

6. Ivar

   在文件`objc/runtime.h`中

   ```cpp
   /// An opaque type that represents an instance variable.
   typedef struct objc_ivar *Ivar;
   
   struct objc_ivar {
       char *ivar_name                                          OBJC2_UNAVAILABLE;
       char *ivar_type                                          OBJC2_UNAVAILABLE;
       int ivar_offset                                          OBJC2_UNAVAILABLE;
   #ifdef __LP64__
       int space                                                OBJC2_UNAVAILABLE;
   #endif
   }
   ```

7. IMP

   ```cpp
   /// A pointer to the function of a method implementation. 
   #if !OBJC_OLD_DISPATCH_PROTOTYPES
   typedef void (*IMP)(void /* id, SEL, ... */ ); 
   #else
   typedef id (*IMP)(id, SEL, ...); 
   #endif
   //IMP 是编译器为你生成的方法实现的函数指针
   ```

8. Blocks

   Blocks themselves are designed to be compatible with the Objective-C runtime so they are treated as objects so they can respond to messages like `-retain`,`-release`,`-copy`,etc

###### meta class

![img](https://upload-images.jianshu.io/upload_images/1186939-7d93dc07abef756e.jpg?imageMogr2/auto-orient/strip|imageView2/2/format/webp)

## 

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/4/19/1718e0978b130480~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

[runtime深入理解文档](https://juejin.cn/post/6844904071480999949)



---

### 第三章：接口与 API 设计

#### 15. 用前缀避免命名空间冲突

- 选择与你的公司、应用程序或二者皆有关联之名称作为类名的前缀，并在所有代码中均使用这一前缀。
- 若自己所开发的程序库中用到了第三方库，则应该为其中的名称加上前缀。

用前缀避免命名空间冲突。OC 没有其他语言那种内置的命名空间机制，所以我们在起名时要注意。如果发生命名冲突，那么应用程序的链接过程就会因为出现重复符号而出错。比如在工程中的两个文件中都实现了名为 Person 类，那么就会导致 Person 所对应的类符号和元类符号各定义了两次，从而导致编译错误：

```objc
duplicate symbol '_OBJC_CLASS_$_Person' in:
    /Users/.../x86_64/Person.o
    /Users/.../x86_64/Person的副本.o
duplicate symbol '_OBJC_METACLASS_$_Person' in:
    /Users/.../x86_64/Person.o
    /Users/.../x86_64/Person的副本.o
ld: 2 duplicate symbols for architecture x86_64
```

出现这种情况的原因大多是因为我们把两个含有重名类的程序库都引入到当前项目中。 
比编译器无法链接更糟糕的是，在运行期载入含有重名类的程序库，从而导致程序 Crash。

###### 如何命名？以何前缀命名？

- 假如你所在的公司叫做 Effective Widgets，那么就可以在所有应用程序中都会用到的那部分代码中使用 EWS 作前缀。
- 如果有些代码只用于名为 Effective Browser 的浏览器项目中，那就在这部分代码中使用 EWB 作前缀。
- 需要注意的是，Apple 宣称其保留使用所有 “两字母前缀” 的权利，所以我们选用的前缀最好是三个字母的。 假如你不遵守这条规则，比如，你使用 TW 这两个字母作为前缀，那么就会出现问题。iOS 5.0 SDK 发布时包含了 Twitter 框架，此框架就使用 TW 作前缀。这就很可能出现重复符号错误。

###### 不仅是类名，应用程序中的所有名称都应加前缀

- 分类以及分类中方法。【🚩 25】中解释这么做的原因。
- 类实现文件中所用的纯 C 函数及全局变量。因为在编译好的目标文件中，这些名称是要算作 “顶级符号” 的。

###### 若自己所开发的程序库中用到了第三方库，则应该为其中的名称加上前缀。

- 如果你使用了第三方库（以手动导入管理而非 Cocoapods 管理），并准备将其再发布为程序库供他人开发使用时，尤其要注意重复符号问题。因为你的程序库所包含的那个三方库也许还会被他人的应用程序本身，或是其引入的其他三方库所引入，这样就很容易出现重复符号错误。
- 例如，你准备发布的程序库叫做 EOCLibrary，其中引入了名为 XYZLibrary 的第三方库，那么就应该把 XYZLibrary 中的所有名字都冠以 EOC。



#### 16. 提供 “全能初始化方法”

- 在类中提供一个全能初始化方法，并于文档里指明。其他初始化方法均应调用此方法。
- 若全能初始化方法与超类不同，则需覆写超类中的对应方法。
- 如果超类的初始化方法不适用于子类，那么应该覆写这个超类方法，并在其中抛出异常。

类实例的初始化方法可能不止一种，我们要选定一个作为全能初始化方法，令其他初始化方法均调用此方法。这样当初始化操作有变化时，只需要改动全能初始化方法，无须改动其他初始化方法。

对 init 等初始化方法做些改动
比如我们指定矩形类 EOCRectangle 的初始化方法为：

```objc
- (instancetype)initWithWidth:(float)width andHeight:(float)height {
    if (self = [super init]) {
        _width = width;
        _height = height;
    }
}

// 1.使用宏 NS_UNAVAILABLE 来禁用该初始化方法
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
// 2.Using default values
- (instancetype)init {
    return [self initWithWidth:5.0 andHeight:10.0];
}
// 3.Throwing an exception
- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                   reason:@"Must use initWithWidth:andHeight: instead." userInfo:nil];
}

```

正方形类 EOCSquare 继承于 EOCRectangle 指定它的初始化方法为

```objc
- (instancetype)initWithDimension:(float)dimension {
    return [super initWithWidth:dimension andHeight:dimension];
}
```

然后调用者可能会使用  initWithWidth:andHeight: 或者 init 方法来初始化 EOCSquare 实例 
所以当类继承时，如果子类的全能初始化方法与父类方法的名称不同，那么总应覆写父类的全能初始化方法，如下：

```objc
- (instancetype)initWithWidth:(float)width andHeight:(float)height {
    float dimension = MAX(width, height);
    return [self initWithDimension:dimension];
}
```

注意此时不需要再重写 init 方法，因为调用到的父类 EOCRectangle 中的 init 方法中调用的是  initWithWidth:andHeight: 方法，而该方法已被子类重写，所以调用的是子类的实现。 

如果超类的初始化方法不适用于子类： 
有时候我们不想覆写父类的全能初始化方法，因为那样做没有道理。比如以 float dimension = MAX(width, height); 方式计算边长来初始化 EOCSquare 对象，我们认为这是方法调用者自己犯了错误。这时候我们就可以覆写父类的全能初始化方法（如 initWithWidth:andHeight:）并抛出异常。同时，覆写 init 方法，让其调用自己的初始化方法，如果不覆写的话它也会抛出异常，因为它调用了 initWithWidth:andHeight:。

> 不过，在 OC 程序中，只有当发生严重错误时，才应该抛出异常【🚩 21】，所以，初始化方法抛出异常乃是不得已之举，表明实例真的没办法初始化了。

```objc
- (instancetype)init {
    return [self initWithDimension:5.0f];
}
```

如果某对象的实例有两种完全不同的创建方式，必须分开处理，那么就需要编写多个全能初始化方法。比如：

```objc
- (instancetype)initWithCoder:(NSCoder *)coder;
```

该方法要通过 “解码器”（decoder）将对象数据解压缩，所以其实现不调用其他全能初始化方法。实现应该如下所示：

```objc
// EOCRectangle
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _width = [decoder decodeFloatForKey:@"width"];
        _height = [decoder decodeFloatForKey:@"height"];
    }
}
// EOCSquare
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        // EOCSquare's specific initializer
    }
}
```

每个子类的全能初始化方法都应该调用其父类的对应方法，并逐级向上，实现 initWithCoder: 时也要这样。如果不这么做，EOCSquare 的该方法没有调用父类的该同名方法，而是调用自身或是父类的其他全能初始化方法，那么父类的 initWithCoder: 方法就没机会实现，也就无法将 _width 和 _height 两个实例变量解码了。




#### 17. 实现 description 方法

- 实现 `description` 方法返回一个有意义的字符串，用以描述该实例。
- 若想在调试时打印出更详尽的对象描述信息，则应实现 `debugDescription` 方法。

我们使用 NSLog 打印对象，就会给对象发送 description 消息，该方法返回一个字符串，所以打印对象用 %@。

该方法定义在 NSObject 协议里，而不是 NSObject 类里，因为 NSObject 不是唯一的根类，NSProxy 也是遵从了 NSObject 协议的根类。

如果我们没有重写 description 方法，那么调用 NSObject 类中的该方法的默认实现为：返回类名和对象的内存地址。如下：

```objc
id object = [NSObject new];
NSLog(@"object = %@", object);
// object = <NSObject: 0x600000724650>
```

如果我们想打印对象的详细信息，可以重写 description 方法并返回我们所需要的信息。比如：

```objc
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, \"%@ %@\">", [self class], self, _firstName, _lastName];
}
```

建议重写的 description 方法的实现中，也返回类名和对象的内存地址。

借助 NSDictionary 类的 description 方法来更好地打印对象属性信息：

```objc
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], self, @{@"title":_title, @"latitude":_latitude, @"longitude":_longitude}];
}
// location = <EOCLocation: 0x7f98f2e01d20>, {latitude = "51.506"; longitude = 0; title = London}>
```

这样比直接拼接打印属性信息写法更易维护。如果以后新增属性并且要在 description 中打印，那么只需修改字典内容即可。

还有个 debugDescription 方法，它和 description 的区别在于：它只在调试时在控制台命令打印对象时才调用 (断点，然后使用 LLDB 命令 `po` (print-object))。

- 在 NSObject 类中的 debugDescription 的默认实现是直接调用 description。
- 若不想在代码打印对象时输出太详尽的对象描述信息，而是在调试时才要这么做，比如在调试时再打印 “类名和对象的内存地址”（NSArray 类就是这么做的）。那么就实现 debugDescription 方法，返回比 description 更详尽的信息。



#### 18. 尽量使用不可变对象

- 尽量创建不可变的对象。

- 若某属性仅可于对象内部修改，则在 “class-continuation 分类（类扩展）” 中将其由 readonly 属性扩展为 readwrite 属性。

- 不要把可变的 collection 作为属性公开，而应提供相关方法，以此修改对象中的可变 collection。

该篇主要讲述 `readonly` 和 `readwrite` 这两个 “读写权限” 属性关键字及其用法：

- readwrite：默认，属性可读可写
- readonly：属性只读

应该尽量把对外公布的属性设为只读，而且只在确有必要时才将属性对外公布。

- 比方说一些模型对象通过初始化方法创建，其后无须改动其属性值（比如地图模型），那么属性对外应设为只读。这样只要使用方试着修改属性值就会编译错误，对象本身的数据结构也就不可能出现不一致的现象，比如地图模型的经纬度等数据不会发生变动。
- 在【🚩 8】中所述，如果把可变对象放入 collection 后又修改其内容，那么很容易就会破坏 set 的内部数据结构，使其失去固有的意义。所以要尽量减少对象的可变内容。

把属性设为只读后，可以不指定其内存管理语义而采用默认，因为其没有 setter 方法，比如：

```objc
@property (nonatomic, readonly) NSString *title;
复制代码
```

但虽说如此，我们还是应该至少在文档里指明实现里所用的内存管理语义，这样以后把它变为可读写属性时就会简单一些。

有时我们想在对象内部修改属性，但是对外只读。这时候就可以在类扩展中将属性重新声明为 readwrite：

```objc
// .h
@property (nonatomic, copy, readonly) NSString *title;
// .m
@property (nonatomic, copy, readwrite) NSString *title;
复制代码
```

- 如果该属性是 nonatomic 的，那么这样做可能会产生 “竞争条件”。在对象内部写入某属性时，外部观察者也许正读取该属性。若想避免此问题，可以在必要时通过 GCD 【🚩 41】等手段，将（包括在对象内部的）所有数据的存取操作都设为同步操作。
- 当属性是 collection 类型时，也建议对外只读并设为不可变属性（如 NSArray），而在对象内部则为可变属性（如 NSMutableArray），并对外供相关方法（插入、删除等）来供使用方操作对象中的可变 collection。 
  为什么不直接将可变 collection 直接暴露出去，而要多次一举呢？ 
  因为有时候我们可能需要在插入或删除方法中做一些其他操作，而让外部直接操作可变 collection 是达不到这一目的的，因为其直接操作底层数据。

即便属性对外设置了 readonly，使用方也可以使用 KVC 来修改值，这样的话出现问题需使用方自己来承当后果。
更不合规范的是，使用方甚至可能会直接用类型信息查询功能查出属性所对应的实例变量在内存布局中的偏移量，以此来人为设置这个实例变量的值。

不要在返回的对象上查询类型，比如使用 isKindOfClass: 方法，来确定其是否可变。 
开发者或许不建议使用方修改对象中的数据，但可能由于 collection 很大，copy 耗时 (书中friends例子），而直接将可变 collection 返回，但开发者对外声明为不可变 collection 了。我们不要假设其为可变 collection ，然后通过 isKindOfClass: 方法来确定其为可变 collection 后对它进行操作。



#### 19. 使用清晰而协调的命名方式

- 起名时应遵从标准的 Objective-C 命名规范，这样创建出来的接口更容易为开发者所理解。

- 方法名要言简意骇，从左至右读起来要像个日常用语中的句子才好。

- 方法名里面不要使用缩略后的类型名称。

- 给方法起名时的第一要务就是确保其风格与你自己的代码或所要集成的框架相符。

OC 中的方法命名虽长，但其所要表达的意思清晰。 
比如替换字符串的方法 `stringByReplaceOccurrencesOfString:withString:`， 
在其他语言中方法名仅是 `replace(@"A", @"B")`，不能清晰地表达出两个参数 A 和 B 到底是谁替换谁等等。

方法与变量名使用 “驼峰式大小写命名法” —— 以小写字母开头，其后每个单词首字母大写；
类名也用驼峰式命名法，不过其首字母大写，而且前面通常还有两三个大写的前缀字母。【🚩 15】

###### 方法命名

- 比如创建一个指定宽高的 Rectangle 实例

  在 C++ 中写法可能如下。这样回顾代码时看不出来两个参数是矩形尺寸，或者哪个是宽哪个是高，需要查看函数定义才能确定。

  ```C++
  Rectangle *rectangle = new Rectangle(5.0f, 10.0f);
  复制代码
  ```

  在 OC 中可以这样定义初始化方法，虽然语法上没有问题，但其和 C++ 构造器存在同样的问题 —— 命名不清晰，调用的时候每个变量的含义不清楚。

  ```objc
  - (instancetype)initWithSize:(float)width :(float)height;
  ```

  ```objc
  EOCRectangle *rectangle = [[EOCRectangle alloc] initWithSize:5.0f :10.0f];
  ```

  正确写法如下：

  ```objc
  - (instancetype)initWithWidth:(float)width height:(float)height;
  ```

  ```objc
  EOCRectangle *rectangle = [[EOCRectangle alloc] initWithWidth:5.0f height:10.0f];
  ```

- 方法命名要言简意骇，也不能太过长，清晰而不啰嗦，能准确表达方法所执行的任务即可。

- 命名规则

  - 如果方法的返回值是新创建的，那么方法名的首个词应该是返回值的类型，除非前面还有修饰符，例如 localizedString。属性的存取方法不遵循这种命名方式，因为一般认为这些方法不会创建新对象，即便有时返回内部对象的一份拷贝，我们也认为那相当于原有的对象。这些存取方法应该按照其所对应的属性来命名。

  - 应该把表示参数类型的名词放在参数前面。

  - 如果方法要在当前对象上执行操作，那么就应该包含动词；若执行操作时还需要参数，则应该在动词后面加上一个或多个名词。

  - 不要使用 str 这种简称，应该用 string 这样的全称。

  - Boolean 属性应加 is 前缀。如果某方法返回非属性的 Boolean 值，那么应该根据其功能，选用 has 或 is 当前缀。

    ```objc
    @property (nonatomic, assign, getter = isEnabled) BOOL enabled;
    // NSString
    - (BOOL)isEqualToString:(NSString *)string;
    复制代码
    ```

  - 将 get 这个前缀留给那些借由 “输出参数” 来保存返回值的方法，比如说把返回值填充到 “C语言式数组”(C-style array) 里的那种方法就可以使用这个词做前缀。

    ```objc
    - (void)getCharacters:(unichar *)buffer range:(NSRange)aRange;
    ```

###### 类与协议的命名

- 应该为类和协议的名次加上前缀，以避免命名空间冲突。【🚩 15】
- 命名同方法命名，使其从左至右读起来较为通顺。
- 继承时要遵守其命名惯例，比如继承自 UIView 的子类，命名末尾必须是 view。
- 自定义的委托协议，其名称中应该包含委托发起方的名称，后面再跟上 Delegate 一词，参照 UITableViewDeleagte。



#### 20. 为私有方法名加前缀

- 给私有方法的名称加上前缀，这样可以很容易地将其同公共方法区分开。
- 不要单用一个下划线做私有方法的前缀，因为这种做法是预留给苹果公司用的。

给私有方法的名称加上前缀的原因：

1. 加个前缀便于和公共方法区分开，有助于调试。
2. 便于修改方法名或方法签名。 
   修改公共方法的名称或签名之前要三思，因为公共 API 不便随意改动。如果改了的话，使用这个方法的所有开发者都必须更新其代码。而修改私有方法，则只需同时修改本类内部的相关代码即可，不会影响到公共 API。给私有方法加前缀就能很容易看出来哪些方法可以随意修改，哪些不应该轻易改动。
3. OC 是动态运行时语言，它不像 C++ 和 Java 那样可以真正声明为私有方法，所以一般我们要在命名中体现出 “私有方法” 语义。

使用何种前缀可根据个人喜好，比如可以使用 “ p_ ” 作为前缀，p 表示 private。

某次修订后编译器已经不要求使用方法前必须先行声明，所以私有方法一般只在实现的时候声明。

苹果喜欢单用一个下划线作为私有方法的前缀，因此苹果在文档中说开发者不应该单用一个下划线做前缀。如果我们这么做了，就可能会在子类中无意覆写父类（苹果类）的同名私有方法，这样会导致本该调用父类的实现而现在却调用自己覆写的实现，从而引发问题。
例如，UIViewController 有一个名叫 _resetViewController 的私有方法。你可能会无意间覆写但是你根本不会察觉到，除非你深入研究过 UIViewController。导致的问题是：你的子类的这个方法会被频繁调用。

此外，你可能会继承来自三方框架的类，你不知道它们的私有方法以什么名称前缀，除非该框架在文档中明示或者你阅读了源码。同样的别人也可能从你写的类中继承子类。所以为了避免重名问题，可以把自己一贯使用的类名前缀用作私有方法的前缀。



#### 21. 理解 Objective-C 错误模型

- 只有发生了可使整个应用程序崩溃的严重错误时，才应使用异常。
- 在错误不那么严重的情况下，可以指派 “委托方法”（delegate method）来处理错误，也可以把错误信息放在 NSError 对象里，经由 “输出参数” 返回给调用者。

[ios开发中的错误信息](http://boilwater.github.io/2017/05/31/NSError(%E9%94%99%E8%AF%AF%E4%BF%A1%E6%81%AF)/)

###### 异常

只有发生了可使整个应用程序崩溃的严重错误时，才应使用异常。
比如说，有人直接使用了抽象基类，在子类必须覆写的父类方法里抛出异常。

```objc
@throw [NSException exceptionWithName:@"ExceptionName" reason:@"There was an error" userInfo:nil];
```

在错误不那么严重的情况下，OC 所用的编程范式为：令方法返回 nil/0，或是使用 NSError，以表明其中有错误发生。 
比如说，如果初始化方法无法根据传入的参数来初始化当前实例，那么就可以令其返回 nil/0。 
NSError 的用法更加灵活，因为经由此对象，我们可以把导致错误的原因回报给调用者。

###### NSError 对象封装了三条信息：

- Error domain（错误范围）：错误发生的范围，也就是产生错误的根源。通常定义成 NSString 类型的全局常量。

  最好为你自己的库指定一个专用的 “错误范围” 字符串，这样使用方可以知道该错误在你的库中产生。

  ```objc
  // EOCErrors.h
  extern NSString *const EOCErrorDomain;
  // EOCErrors.m
  NSString *const EOCErrorDomain = @"EOCErrorDomain"; 
  ```

- Error code（错误码）：用以指明在某个范围内具体发生了何种错误。通常定义成枚举类型。

  ```objc
  typedef NS_ENUM(NSUInteger, EOCError) {
      EOCErrorUnknown = –1,
      EOCErrorInternalInconsistency = 100,
      EOCErrorGeneralFault = 105,
      EOCErrorBadInput = 500,
  };
  ```

  用枚举不仅可以解释错误码的含义，而且还给它们起了个有意义的名字。还可以在定义这些枚举的头文件里对每个错误类型详加说明。

- User info（用户信息）：有关此错误的额外信息。其中或许包含一段 localized description，或许还含有导致该错误发生的另外一个错误，经由此种信息，可以将相关错误串成一条错误链。

###### 创建 NSError 对象的方法：

```objc
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;
```

###### NSError 常见用法：

1. 通过委托协议来传递错误，有错误发生时，委托方会把错误信息经由协议方法传给 delegate 对象。
   这比抛出异常好，因为调用方可以自己决定是否要实现该协议方法，是否要处理此错误。

2. 经由方法的 “输出函数” 返回给调用者。如下。同样的，调用方如果不关心此错误，就可以给 error 参数传入 nil。

   ```objc
   NSError * __autoreleasing error = nil;
   BOOL ret = [object doSomething:&error];
   if (error) {
       // There was an error
   }
   ```

实际上，使用arc时，编译器会把方法签名中的`NSError**`转换成 `NSError* __autoreleasing*`, 也就是说，指针所指的对象会在方法执行完毕自动释放。这就与大部分方法（以new alloc copy mutablecopy 开头的方法不在此列）的返回值具备的语义相同了。

> 理解“解引用” dereference
>
> 在解引用之前，必须先保证error参数不是nil，因为空指针解引用会导致“段错误”segmentation fault并使程序崩溃。



#### 22. 理解 NSCopying 协议

拷贝的目的：

- 产生一个副本对象，跟源对象互不影响；
- 修改了源对象，不会影响副本对象；
- 修改了副本对象，不会影响源对象。

iOS 提供了 2 个拷贝方法：

- copy：不可变拷贝，产生不可变副本；
- mutableCopy：可变拷贝，产生可变副本。

如果想令自己的类支持拷贝操作，那就要实现NSCopying协议

```objc
- (id)copyWithZone:(NSZone*)zone;
```

> NSZone: 在之前开发程序是，会据此把内存分成不同的zone，而对象会创建在某个zone里。现在不用了，每个程序只有一个default zone。

实现协议中规定的方法

```objc
- (id)copyWithZone:(NSZone*)zone{
  EOCPersson *copy = [[self class] allocWithZone:zone] initWithFirstName:_firstName andLastName:_lastName];
  copy->friends = [_friends mutableCopy];
  //这里使用->语法，因为_friends不是属性，只是个在内部使用的实例变量。
  return copy;
}
```

深拷贝和浅拷贝：

| 拷贝类型 | 拷贝方式                                                     | 特点                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 深拷贝   | 内存拷贝，让目标对象指针和源对象指针指向 `两片` 内容相同的内存空间。 | 1. 不会增加被拷贝对象的引用计数； 2. 产生了一个内存分配，出现了两块内存。 |
| 浅拷贝   | 指针拷贝，对内存地址的复制，让目标对象指针和源对象指针指向 `同一片` 内存空间。 | 1. 会增加被拷贝对象的引用计数； 2. 没有进行新的内存分配。 注意：如果是小对象如 NSString，可能通过 Tagged Pointer 来存储，没有引用计数。 |

> 简而言之：
> \1. 深拷贝：内容拷贝，产生新对象，不增加对象引用计数
> \2. 浅拷贝：指针拷贝，不产生新对象，增加对象引用计数
> 区别：1. 是否影响了引用计数；2. 是否开辟了新的内存空间 ![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3edcc7bd64a848ff9c9a8c718479cac8~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

对 mutable 对象与 immutable 对象 进行 copy 与 mutableCopy 的结果：

| 源对象类型     | 拷贝方式    | 目标对象类型 | 拷贝类型（深/浅） |
| -------------- | ----------- | ------------ | ----------------- |
| mutable 对象   | copy        | 不可变       | 深拷贝            |
| mutable 对象   | mutableCopy | 可变         | 深拷贝            |
| immutable 对象 | copy        | 不可变       | `浅拷贝`          |
| immutable 对象 | mutableCopy | 可变         | 深拷贝            |

> 注：这里的 mutable 对象与 immutable 对象指的是系统类 NSArray、NSDictionary、NSSet、NSString、NSData 与它们的可变版本如 NSMutableArray 等。

以上对 collection 容器对象进行的深浅拷贝是指对容器对象本身的，对 collection 中的对象执行的默认都是浅拷贝。也就是说只拷贝容器对象本身，而不复制其中的数据。主要原因是，容器内的对象未必都能拷贝，而且调用者也未必想在拷贝容器时一并拷贝其中的每个对象。 

在自定义的类中以浅拷贝的方式实现copyWithZone:方法，如果有必要的话，也可以增加一个执行深拷贝的方法。以NSSet为例，该类提供了下面这个初始化方法，用以执行深拷贝：

```objc
- (id)initWithSet:(NSArray*)array copyItems:(BOOL)copyItems;
// 若copyItem参数置为YES, 则该方法会向数组中每个元素发送copy消息，用拷贝好的元素创建新的set，将其返回给调用者
```



![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1a62200d3246451080c30e1da14feeb7~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

如果想要实现对自定义对象的拷贝，需要遵守 `NSCopying` 协议，并实现 `copyWithZone:` 方法。

> NSZone 是什么？可参阅：[Link：《iOS - 老生常谈内存管理（三）：ARC 面世》](https://juejin.im/post/6844904130431942670#heading-9) 
> 对于现在的运行时系统（编译器宏 OBJC2 被设定的环境），不管是 MRC 还是 ARC 下，区域（NSZone）都已单纯地被忽略。

- 如果要浅拷贝，`copyWithZone:` 方法就返回同一个对象：return self；
- 如果要深拷贝，`copyWithZone:` 方法中就创建新对象，并给希望拷贝的属性赋值。

如果自定义对象支持可变拷贝和不可变拷贝，那么还需要遵守 `NSMutableCopying` 协议，并实现 `mutableCopyWithZone:` 方法，返回可变副本。而 `copyWithZone:` 方法返回不可变副本。使用方可根据需要调用该对象的 copy 或 mutableCopy 方法来进行不可变拷贝或可变拷贝。

###### 深拷贝还是浅拷贝？

无论是对象还是容器：

- 如果是不可变的，则copy是浅拷贝，mutableCopy是深拷贝
- 如果是可变的，copy和mutableCopy都是深拷贝
- 容器内部对象默认都是浅拷贝

###### 返回的是可变还是不可变对象？

对于对象来说：

- 不可变对象copy返回不可变，mutableCopy返回可变
- 可变对象copy和mutableCopy都是返回可变对象

对于容器来说：

- 不可变容器与不可变对象返回类型一致
- 可变容器也与不可变对象返回类型一致



---

### 第四章：协议与分类

#### 23. 通过委托与数据源协议进行对象间通信

- 委托模式为对象提供了一套接口，使其可由此将相关事件告知其他对象。

- 将委托对象应该支持的接口定义成协议，在协议中把可能需要处理的事件定义成方法。

- 当某对象需要从另外一个对象中获取数据时，可以使用委托模式。这种情况下，该模式亦称 “数据源协议” (data source protocol)。

- 若有必要，可实现含有位段的结构体，将委托对象是否能响应相关协议方法这一信息缓存至其中。

可以通过委托 （也就是我们平常所说的 “代理 delegate” ）与数据源（data source）协议进行对象间通信。

###### 协议中可以定义什么？方法和属性。

在协议中可以通过 `@optional` 和 `@required` 关键字来指定协议方法是可选择实现的还是必须实现的，如果使用方没有实现 @required 方法那么编译器就会给出警告。



###### 委托模式（亦称为 “代理模式”）

- 何为代理？一种软件设计模式；iOS 当中以 `@protocol` 形式体现；传递方式为一对一。

- 代理模式的主旨： 
  定义一个委托协议，若对象想接受另一个对象（委托方）的委托，则需遵守该协议，以成为 “代理方”。而委托方则可以通过协议方法给代理方回传一些信息，也可以在发生相关事件时通知代理方。这样委托方就可以把应对某个行为的责任委托给代理方去处理了。

- 代理的工作流程：

  - “委托方” 要求 “代理方” 需要实现的接口，全都定义在 “委托协议” 当中；
  - “代理方” 遵守 “协议” 并实现 “协议” 方法；
  - “代理方” 所实现的 “协议” 方法可能会有返回值，将返回值返回给 “委托方” ；
  - “委托方” 调用 “代理方” 遵从的 “协议” 方法。 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/05abe7e888db497a8dab182bdec25971~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

- delegate 属性一般定义为 weak 以避免循环引用。代理方强引用委托方，委托方弱引用代理方。

- 如果要向外界公布一个类遵守某协议，那么就在接口中声明；
  如果这个协议是委托协议，那么就在类扩展中声明，因为该协议通常只会在类的内部使用。

- 对于 @optional 方法，在委托方中调用时，需要先判断代理方是否能响应（也就是它是否实现了该方法），如果能响应才能给它发送协议消息，否则代理方可能没有实现该方法，调用时就会因找不到方法实现而导致 Crash：

  ```objc
  if ([_delegate respondsToSelector:@selector(protocolOptionalMethod)]) {
      [_delegate protocolOptionalMethod];
  }
  ```

  最好是判断一下 delegate 是否有值，并将此判断条件前置提升执行效率。

  ```less
  if (_delegate && [_delegate respondsToSelector:@selector(protocolOptionalMethod)]) {
      [_delegate protocolOptionalMethod];
  }
  ```

###### 数据源模式

- 委托模式的另一用法，旨在向类提供数据，所以也称 “数据源模式”。 
  数据源模式是用协议定义一套接口，令某类经由该接口获取其所需的数据。

###### 数据源模式与常规委托模式的区别在于：

- 数据源模式中，信息从数据源（Data Source）流向类（委托方）；
- 常规委托模式中，信息从类（委托方）流向受委托者（代理方）。 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5497d2447b7545dda6b3da5e9815bfcf~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)



通过 UITableView 就可以很好的理解 Data Source 和 Delegate 这两种模式：

- 通过 UITableViewDataSource 协议获取要在列表中显示的数据；

- 通过 UITableViewDelegate 协议来处理用户与列表的交互操作。

  ```objc
  @protocol UITableViewDataSource<NSObject>
  @required
  - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
  @optional
  - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 
  ...
  @end
  
  @protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>
  @optional
  -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
  ...
  @end
  ```



###### 性能优化 

在实现委托模式和数据源模式时，如果协议方法时可选的，那么在调用协议方法时就需要判断其是否能响应。

```objc
if (_delegate && [_delegate respondsToSelector:@selector(networkFetcher:didReceiveData)]) {
    [_delegate networkFetcher:self didReceiveData:data];
}
```

如果我们需要频繁调用该协议方法，那么仅需要第一次判断是否能响应即可。以上代码可做性能优化，将代理方是否能响应某个协议方法这一信息缓存起来：

1. 在委托方中嵌入一个含有位域（bitfield，又称 “位段”、“位字段”）的结构体作为其实例变量，而结构体中的每个位域则表示 delegate 对象是否实现了协议中的相关方法。该结构体就是用来缓存代理方是否能响应特定的协议方法的。

   ```objc
   @interface EOCNetworkFetcher () {
       struct {
           unsigned int didReceiveData      : 1;
           unsigned int didFailWithError    : 1;
           unsigned int didUpdateProgressTo : 1;
       } _delegateFlags;
   }
   ```

2. 重写 delegate 属性的 setter 方法，对 _delegateFlags 结构体里的标志进行赋值，实现缓存功能。

   ```objc
   - (void)setDelegate:(id<EOCNetworkFetcher>)delegate {
       _delegate = delegate;
       _delegateFlags.didReceiveData = [delegate respondsToSelector:@selector(networkFetcher:didReceiveData:)];
       _delegateFlags.didFailWithError = [delegate respondsToSelector:@selector(networkFetcher:didFailWithError:)];
       _delegateFlags.didUpdateProgressTo = [delegate respondsToSelector:@selector(networkFetcher:didUpdateProgressTo:)];
   }
   ```

3. 这样每次调用 delegate 的相关方法之前，就不用通过 respondsToSelector: 方法来检测代理方是否能响应特定协议方法了，而是直接查询结构体中的标志，提升了执行速度。

   ```objc
   if (_delegate && _delegateFlags.didReceiveData) {
       [_delegate networkFetcher:self didReceiveData:data];
   }
   ```

[位域 bitfield](https://www.cnblogs.com/bigrabbit/archive/2012/09/20/2695543.html)

```objc
struct 位域结构名 
{

 位域列表

};
// 位域列表形式 
// 类型说明符 位域名：位域长度

struct bs
{
　　int a:8;
　　int b:2;
　　int c:6;
} data; 
```



#### 24. 将类的实现代码分散到便于管理的数个分类之中

- 使用分类机制把类的实现代码划分成易于管理的小块。

- 将应该视为 “私有” 的方法归入名为 Private 的分类中，以隐藏实现细节。

###### 分类的使用场合：

1. 分解体积庞大的类文件，可以将一个类按功能拆解成多个模块，方便代码管理。

比如NSURLRequest类和其可变版本NSMutableURLRequest类，把所有HTTP有关的方法放在一处，共用CFURLRequest函数。

这样还便于调试：对于某个分类的所有方法来说，分类名称都会出现在其符号中。 
例如，“addFriend:” 方法的 “符号名”：

```objc
-[EOCPerson(Friendship) addFriend:]
```

这样根据符号名就可以精确定位到该方法所属的功能区（分类）。

2. 创建一个名为 Private 的分类，将私有方法都放在这里，这样使用者会在查看回溯信息时发现private一词，就知道这里面的方法不应该直接调用。

   在编写准备分享给其他开发者使用的程序库时，也可以考虑创建private分类。比如一些方法：他们不是公共api的一部分，然后非常适合在程序库之内使用。此时应该创建private分类。如果程序库中的某个地方用到这些方法，就引入此分类的头文件。而分类的头文件并不随程序库一并公开，于是该库的使用者也不知道库里还有这些私有方法。

关于分类详解，可以参阅：[Link:《OC 底层探索 - Category 和 Extension》](https://juejin.im/post/6844904067987144711)。

#### 25. 总是为第三方类的分类名称加前缀

- 向第三方类中添加分类时，总应给其名称加上你专用的前缀。
- 向第三方类中添加分类时，总应给其中的方法名加上你专用的前缀。

分类机制还通常用于向无源代码的既有类中新增功能。

分类是运行时决议。何为运行时决议？Category 编译之后的底层结构是 struct category_t，里面存储着分类的对象方法、类方法、属性、协议信息，这时候分类中的数据还没有合并到类中，而是在程序运行的时候通过 Runtime 机制将所有分类数据合并到类（类对象、元类对象）中去。这是分类最大的特点，也是分类和扩展的最大区别，扩展是在编译的时候就将所有数据都合并到类中去了。

需要注意的是：

1. 分类方法会 “覆盖” 同名的宿主类方法，如果使用不当会造成问题。方法被覆盖会导致执行结果和你预期的不同，且这种 bug 很难排查；
2. 同名分类方法谁能生效取决于编译顺序，最后参与编译的分类中的同名方法会最终生效；
3. 名字相同的分类会引起编译报错。

为避免以上问题，可以以命名空间来区别各个分类的名称与分类中所定义的方法。而在 OC 中实现命名空间功能只有一个办法，就是给相关名称都加上某个共用的前缀。这样分类和宿主类中出现同名方法导致方法被 “覆盖” 的问题的几率就会小很多。 
向第三方类中添加分类时，更应该注意这个问题。



#### 26. 勿在分类中声明属性

- 把封装数据所用的全部属性都定义在主接口里。
- 在 “class-continuation 分类”（类扩展）之外的其他分类中，可以定义存取方法，但尽量不要定义属性。

分类中可以添加属性，但应该尽量避免这样做。 

类扩展是编译时决议，在编译的时候就将扩展中的所有数据都合并到类中去了，所以扩展中添加属性没有任何问题。

而分类是运行时决议，类的内存布局在编译时就已经确定，所以分类中无法添加实例变量，分类中添加的属性也不会自动生成实例变量以及 setter 和 getter 方法的实现（因为属性就是对实例变量的封装）。

假如你在分类中添加了属性，编译器就会给出警告：

```objc
warning: Property ‘friends’ requires method ‘friends’ to be defined - use @dynamic or provide a method implementation in this category [-Wobjc-property-implementation]
warning: Property ‘friends’ requires method ‘setFriends’ to be defined - use @dynamic or provide a method implementation in this category [-Wobjc-property-implementation]
```

警告为：属性的 setter 和 getter 方法没有实现。因为分类中的属性不会自动生成实例变量以及 setter 和 getter 方法的实现，这样外部调用该属性的存取方法就会 Crash。

有两种解决方式：

1. 手动添加 setter 和 getter 方法的实现；
2. 使用 @dynamic 告诉编译器，你会在运行时再提供这些方法的实现，以消除警告。你可以使用动态方法解析为这些方法动态添加方法实现。但如果你没有去处理的话，@dynamic 就仅仅是消除了警告，如果外部调用了该属性的存取方法还是会 Crash。

可以通过关联对象来解决分类中无法添加实例变量的问题： 
由于分类底层结构的限制，不能直接给 Category 添加成员变量，但是可以通过关联对象间接实现 Category 有成员变量的效果。 
可参阅：[Link:《OC 底层探索 - Association 关联对象》](https://juejin.im/post/6844903972315070471) 

需要注意的是，存储关联对象时其内存管理语义需要与属性的一致。如果属性的内存管理语义更改，那么关联对象的关联策略也要修改，这是容易忽略的地方。

只读属性可以在分类中使用，我们为其实现 getter 方法。由于实现属性所需的全部方法（只读属性只需实现 getter 方法）都已实现，所以编译器就不会再为该属性自动合成实例变量，也不会发出警告。

类接口与类扩展是真正能够定义实例变量的地方，而属性只是定义实例变量及相关存取方法所用的 “语法糖”，所以也应该遵循同实例变量一样的规则。尽管分类中可以通过关联对象的手段来实现分类中可以添加实例变量的效果，但其目标在于扩展类的功能，而非封装数据。属性是用来封装数据的，所以在分类中可以定义存取方法，但尽量不要定义属性。



#### 27. 使用 “class-continuation 分类” 隐藏实现细节

- 通过 “class-continuation 分类”（类扩展）向类中新增实例变量。

- 如果某属性在主接口中声明为 “只读”，而类的内部又要用设置方法来修改此属性，那么就在 “class-continuation 分类” 中将其扩展为 “可读写”。

- 把私有方法的原型声明在 “class-continuation 分类” 里面。

- 若想使类所遵循的协议不为人所知，则可于 “class-continuation 分类” 中声明。

虽然 OC 的动态消息系统 Runtime【🚩 11】的工作方式决定了其不可能实现真正的私有方法或私有变量，但我们最好还是只把确实需要对外公布的那部分内容公开，而把无须对外公布的方法及属性、实例变量声明在类扩展中。

如果一个属性在类的内部需要进行存取值，而对外只允许使用方进行取值。那么可以在类声明中将该属性的读写权限设置为 `readonly` 只读，而在类扩展中再次声明该属性并设置为 `readwrite` 可读写。

若类所遵循的协议只应视为私有，比如委托协议和数据源协议，那么该协议就可以在类扩展中去遵从。

类扩展中除了可以声明属性、实例变量，遵从协议，还可以声明私有方法。虽然现在编译器不强制要求我们在使用方法之前必须先声明，直接在 class implementation 中实现即可。但其实在类扩展中声明一下私有方法还是有好处的，这样可以把类里所含的相关方法都统一描述于此，使代码可读性更高。

#### 28. 通过协议提供匿名对象

- 协议可在某种程度上提供匿名类型。具体的对象类型可以淡化成遵从某协议的 id 类型，协议里规定了对象所应实现的方法。
- 使用匿名对象来隐藏类型名称（或类名）。
- 如果具体类型不重要，重要的是对象能够响应（定义在协议里的）特定方法，那么可使用匿名对象来表示。

你可以通过协议提供匿名对象来隐藏类名，做法就是将对象声明为遵从某协议的 id 类型：`id <protocol> object`。

1. 比如 delegate 属性，其声明为：

   ```objc
   @property (nonatomic, weak) id <EOCDelegate> delegate;
   ```

   委托方无须关心代理方的具体类型，只需代理方遵守委托协议并实现协议方法即可，这样委托方就可以向代理方发送协议消息了。

2. 在字典中，键和值的标准内存管理语义分别是 “设置时拷贝” 和 “设置时保留”。因此 NSMutableDictionary 设置键值的方法为：

   ```objc
   - (void)setObject:(id)object forKey:(id<NSCopying>)key;
   ```

   参数 key 的类型为 id，因此你可以传入遵守 NSCopying 协议的任何类型的 OC 对象，这样字典就能向该对象发送拷贝消息了，而这个 key 参数就可以视为匿名对象。

可以在运行期查出匿名对象所属类型，但这样做不好，因为匿名对象已经表明它的具体类型无关紧要了，你仅需要通过它来调用协议方法就好。

###### 使用匿名对象的情况：

- 接口背后有多个不同的实现类，而你又不想指明具体使用哪个类。因为有时候这些类可能会变，有时候它们又无法容纳于标准的类继承体系中，因而不能以某个公共基类统一表示。 
  这样就可以将这些对象所具备的方法定义在协议中，用 id 类型指代并遵守该协议，即可调用协议中的方法，而在运行期则会根据对象具体类型，调用具体的方法实现。
- 对象具体类型不重要，重要的是对象能够响应（定义在协议里的）特定方法。即便该对象类型是固定的你也可以这么做，以表示类型在此处不重要。

---

### 内存管理

#### 29. 理解引用计数

- 引用计数机制通过可以递增递减的计数器来管理内存。对象创建好之后，其保留计数至少为 1。若保留计数为正，则对象继续存活。当保留计数降为 0 时，对象就被销毁了。
- 在对象生命期中，其余对象通过引用来保留或释放此对象。保留与释放操作分别会递增及递减保留计数。

苹果从 MacOS X 10.8 开始弃用了 GC（Garbage collector）机制，而使用 ARC 机制。而在 iOS 5 后 MRC 也被 ARC 所替代。虽说 ARC 已经帮我们实现了自动引用计数（也称 “保留计数” ），但掌握内存管理的种种细节是非常有必要的。

###### 引用计数工作原理

- 引用计数机制通过可以递增递减的计数器来管理内存。对象创建好之后，其保留计数至少为 1。若保留计数为正，则对象继续存活。当保留计数降为 0 时，对象就被销毁了。
- 在对象生命期中，其余对象通过引用来保留或释放此对象。保留与释放操作分别会递增及递减保留计数。
- 引用计数相关的内存管理方法（在 ARC 下这些方法都是禁止调用的）：
  - retain：递增保留引用计数
  - release：递减保留引用计数
  - autorelease：待稍后清理自动释放池时，再递减保留计数
  - retainCount： 查看保留计数，此方法不太好用，即便在调试时也如此，因此不推荐使用。原因之一是调用方可能通过 autorelease 来延迟释放对象，所以其保留计数值不是我们所期望的。【🚩 36】
- 按 “引用树” 回溯，有一个根对象对它们进行保留，在 iOS 中是 UIApplication 对象。在 MacOS 中是 NSApplication 对象，两者都是应用程序启动时创建的单例。
- 当引用计数降至 0 时，就不应该再使用它，这可能会导致 Crash。 
  当引用计数降至 0 时对象所占内存就会 “解除分配”，放回 “可用内存池(available pool)”，如果这时候使用该对象且该对象内存未被覆写，那么就不会 Crash。如果对象内存被覆写，那么就会 Crash。 
  为避免在不经意间使用了无效对象，一般调用完 release 之后都会清空指针 (置为nil)。这就能保证不会出现可能指向无效对象的指针，这种指针通常称为 “悬垂指针”。

###### 属性存取方法中的内存管理 

在 MRC 中声明为 retain 的属性，其 setter 方法的实现如下：

```objc
@property (nonatomic, retain) NSNumber *count;

- (void)setCount:(NSNumber *)newCount {
    [newCount retain];
    [_count release];
    _count = newCount;
}
```

必须先 retain 新值再 release 旧值，否则如果新旧对象是同一个对象的话，先 release 可能会导致其引用计数减为 0 而被销毁。而后续的 retain 操作无法令其起死回生，于是实例变量就成了悬垂指针，从而导致 Crash。

###### 自动释放池 

调用 release 会立刻递减对象的引用计数，而调用 autorelease 则是延迟 release 以延长对象生命期，对象会被添加进自动释放池。通常是在下一次 “事件循环(event loop)” 时给对象发送 release 消息，除非你将其添加进手动创建的自动释放池。 
autorelease 经常用于在方法中返回对象时，使对象在跨越方法调用边界后依然可以存活一段时间。而如果使用 release，在方法返回前系统就把该对象回收了。

###### 保留环 

如果两个对象相互强引用对方，或者多个对象，每个对象都强引用下一个对象直到回到第一个，那么就会产生 “保留环”，也就是平常所说的 “循环引用”。这时候循环中的所有对象的引用计数就不会降为 0，也就不会被释放，就产生了内存泄露。因此，我们要避免保留环的产生。通常采用 “弱引用” 或是从外界命令循环中的某个对象不再保留另外一个对象来避免或打破保留环，从而避免内存泄漏。



#### 30. 以 ARC 简化引用计数

- 有 ARC 之后，程序员就无须担心内存管理问题了。使用 ARC 来编程，可省去类中的许多 “样板代码”。

- ARC 管理对象生命期的办法基本上就是：在合适的地方插入 “保留” 及 “释放” 操作。在 ARC 环境下，变量的内存管理语义可以通过修饰符指明，而原来则需要手工执行 “保留” 及 “释放” 操作。

- 由方法返回的对象，其内存管理语义总是通过方法名来体现。ARC 将此确定为开发者必须遵守的规则。

- ARC 只负责管理 Objective-C 对象的内存。尤其要注意：Core Foundation 对象不归 ARC 管理，开发者必须适时调用 CFRetain/CFRelease

ARC 是一种编译器功能，它通过 `LLVM` 编译器和 `Runtime` 协作来进行自动管理内存。LLVM 编译器会在编译时在合适的地方为 OC 对象插入 retain、release 和 autorelease 代码来自动管理对象的内存。

在 ARC 下 retain、release、autorelease、dealloc、retainCount 等方法都是禁止调用的，否则编译错误，因为手动调用会干扰 ARC 分析对象生命期的工作。

ARC 在调用这些方法时，并不通过 OC 消息派发机制（也就是 objc_msgSend），而是直接调用其底层 C 语言版本。这样做性能更好，因为保留及释放等操作需要频繁执行，所以直接调用底层函数能节省很多 CPU 周期。 
比如调用与 `retain` 等价的底层函数 `objc_retain`。这也是不能覆写 retain、release 或 autorelease 的缘由，因为这些方法不会被调用。

###### 使用ARC必须遵循的方法命名规则：

若方法名以下列词语开头，则其返回的对象归调用者所有（这些对象的保留计数是正值）

- alloc
- new
- copy
- mutableCopy

###### ARC 带好来的优化：

1. 优化一：自动调用 “保留” 与 “释放” 方法。 
   在 MRC 中，若方法名以 alloc、new、copy、mutableCopy 开头，则返回的对象归调用者所有，因此调用这四种方法的那段代码要负责释放方法所返回的对象；若方法名不以上述四种词语开头，则返回的对象不归调用者所有，返回的对象会自动释放，所以调用方在使用该返回的对象前应该对其进行保留，并在使用完毕后对它进行释放。而在 ARC 中这些不用我们自己处理，ARC 通过命名约定将内存管理规则标准化。

2. 优化二：在编译期，ARC 会把能够相互抵消的 retain、release、autorelease 操作约简。 
   如果发现在同一个对象上执行了多次 “保留” 与 “释放” 操作，那么 ARC 有时可以成对地移除这两个操作。这是手工操作很难甚至无法完成的优化。

3. 优化三：如果调用方法返回一个本将(autorelease)添加进自动释放池的对象，其后紧跟着(retain)保留该对象操作，则 ARC 会调用其他函数来取代 autorelease 和 retain，让该对象不添加进自动释放池而是直接返回给调用方，以减去多余操作，提升性能。（考虑到向后兼容性，以兼容不使用 ARC 的代码，不能将 autorelease 与 retain 操作删去，也不能舍弃 autorelease，来进行这个优化）

   ARC 会在运行期进行检测：

   1. 在方法中返回自动释放的对象时，会调用 `objc_autoreleaseReturnValue` 函数而不是 `autorelease`，该函数会检视当前方法返回之后即将要执行的那段代码。若发现那段代码要在返回的对象上执行 retain 操作，则设置全局数据结构（此数据结构的具体内容因处理器而异）中的一个标志位，并直接返回该对象，否则执行 autorelease 再返回。

   2. 如果方法返回了一个自动释放的对象，而调用方法的代码要保留此对象，会调用 

      ```
      objc_retainAutoreleasedReturnValue
      ```

       函数而不是 

      ```
      retain
      ```

      该函数会检视那个标志位，若已经置位，则不执行 retain 操作，否则执行 retain。

      > 设置并检测标识位，要比调用 autorelease 和 retain 要快。
      >
      > 将内存管理交由编译器和运行期组件来做，使代码得到多种优化。

4. 优化四：ARC 也会处理局部变量和实例变量的内存管理。

   ARC 默认情况下，每个变量都是指向对象的强引用。

   在 ARC 下，我们编写 setter 方法只需这样：

   ```objc
   - (void)setObject:(id)object {
       _object = object;
   }
   ```

   其经过编译会变为：

   ```objc
   - (void)setObject:(id)object {
       [object retain];
       [_object release];
       _object = object;
   }
   ```

   替我们省去手工 retain 与 release 操作的同时，还避免了我们可能会先释放旧对象再保留新对象，而恰巧新旧又是同一对象导致 Crash 的问题。

5. 优化五：在对象销毁（dealloc）时帮我们执行实例变量的释放

   以下我们在 MRC 下必须要执行的操作，而 ARC 会自动帮我们处理。ARC 会借用 Objcetive-C++ 的一项特性来生成清理例程。回收 Objcetive-C++ 对象时，待回收的对象会调用所有 C++ 对象的析构函数。编译器如果发现这个对象里含有 C++ 对象，就会生成名为 .cxx_destruct 的方法。而 ARC 则借用此特性，在该方法中生成清理内存所需的代码。

   ```objc
   - (void)dealloc {
       [_foo release];
       [_bar release];
       [super release];
   }
   ```

   不过，如果有非 Objective-C 的对象，比如 CoreFoundation 中的对象或是由 malloc() 分配在堆中内存，需要手动清理。但不需要也不能调用 

   ```
   [super dealloc]
   ```

   因为 ARC 会在 .cxx_destruct 方法中生成并执行调用此方法的代码。

   ```objc
   - (void)dealloc {
       CFRelease(_coreFoundationObject);
       free(_heapAllocatedMemoryBlob);
   }
   ```

###### 所有权修饰符

- __strong: 默认，保留此值
- __unsafe_unretained: 不保留此值，不过其会产生悬垂指针，不安全
- _ _weak: 不保留此值，在对象销毁时会把 __weak 指针置空，所以安全
- __autoreleasing: 把对象 “按引用传递” 给方法时，使用这个修饰符。此值在方法返回时自动释放

在 MRC 下，我们可能会覆写内存管理方法。比方说，在实现单例类的时候我们经常会覆写 release 方法，将其替换为空操作，因为单例不可释放。 
而在 ARC 下，不能调用和覆写内存管理方法，因为这会干扰 ARC 分析对象生命期的工作。而且正由于不能这么做，ARC 就可以执行各种优化。比方说，ARC 能够优化 retain、release、autorelease 操作，使之不经过 OC 消息派发机制，而是直接调用隐藏在运行期库 objc 中的 C 函数。还有前面提到的 ARC 会优化 “如果方法命令即将返回的对象稍后 ‘自动释放’，而方法调用者立刻 ‘保留’ 这个返回后的对象” 中的 autorelease 和 retain 操作。



#### 31. 在 dealloc 方法中只释放引用并解除监听

- 在 dealloc 方法里，应该做的事情就是释放指向其他对象的引用，并取消原来订阅的 “键值观测”（KVO）或 NSNotificationCenter 等通知，不要做其他事情。

- 如果对象持有文件描述符等系统资源，那么应该专门编写一个方法来释放此种资源。这样的类要和其使用者约定：用完资源后必须调用 close 方法。

- 执行异步任务的方法不应在 dealloc 里调用；只能在正常状态下执行的那些方法也不应在 dealloc 里调用，因为此时对象已处于正在回收的状态了。

###### 在 dealloc 方法中应该做什么？

- 释放对象所拥有的引用。ARC 会通过生成 .cxx_destruct 方法在 dealloc 中为我们自动添加释放代码来释放 OC 对象，而非 OC 对象比如 CoreFoundation 对象就必须手动释放。

- 移除 KVO 观察者。在调用 KVO 注册方法后，KVO 并不会对观察者进行强引用，所以需要注意观察者的生命周期。至少需要在观察者销毁之前，调用 KVO 移除方法移除观察者，否则如果在观察者被销毁后，再次触发 KVO 监听方法就会导致 Crash。 
  [Link:《iOS - 关于 KVO 的一些总结》](https://juejin.cn/post/6844903972528979976#heading-22)

- 移除通知观察者。移除后通知中心就不会再把通知发送给已经销毁回收的对象，若是还向其发送通知，则必然导致 Crash。

  > iOS9 之后通知不必手动移除，原因是通知中心现在用 __weak 保留观察者，而以前是用 __unsafe_unretain 从而如果不移除观察者的话会产生悬垂指针，再给该对象发送通知就会 Crash。不过通过以下 API 注册的通知还是需要手动移除。
  >
  > ```objc
  > - (id <NSObject>)addObserverForName:(nullable NSNotificationName)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
  > 复制代码
  > ```

###### 在 dealloc 方法中不应该做什么？

- 不应该释放开销较大或系统内稀缺的资源，比如文件描述符、套接字、大块内存等。

  原因是：

  1. 不能指望 dealloc 方法会在自己期望的时机调用，因为可能会有一些无法预料的东西持有此对象，这样就不能在自己期望的时机释放稀缺资源。

     > 在应用程序终止时，系统会销毁所有未被销毁的对象，而这时候系统为了优化程序效率并不调用每个对象的 dealloc 方法。如果一定要清理某些对象，可以在以下方法中调用那些对象的清理方法，以下方法会在程序终止时调用。
     >
     > ```objc
     > // iOS，UIApplicationDelegate
     > - (void)applicationWillTerminate:(UIApplication *)application
     > // Mac OS X，NSApplicationDelegate
     > - (void)applicationWillTerminate:(NSNotification *)notification
     > ```

  2. 不能保证每个对象的 dealloc 方法都会执行，因为可能存在内存泄露。 通常的做法是，实现另外一个清理方法，当用完资源后就调用此方法释放资源。这样资源对象的生命期就变得更为明确了。

     而在 dealloc 中最好也要调用下清理方法，以防开发者忘了清理这些资源。并输出错误信息或是抛出异常，来提醒开发者在回收对象之前必须调用清理方法来释放资源。

     ```objc
     - (void)close {
         /* clean up resources */
         _closed = YES;
     }
     
     - (void)dealloc {
         if (!_closed) {
             NSLog(@"Error: close was not called before dealloc!"); // or @throw expression
             [self close];
         }
     }
     ```

- 不应该随便调用其他方法。 
  因为在 dealloc 中对象已经即将销毁回收。如果在这里调用的方法又要异步执行某些任务，或是又要继续调用它们自己的某些方法，那么等到那些任务执行完毕时，系统已经把当前的这个待回收的对象彻底销毁了。如果此时在回调中又使用该对象，就会 Crash。 
  再注意一个问题，调用 dealloc 方法的那个线程会执行 “最终的释放操作”，而某些方法必须在特定的线程里（比如主线程里）调用才行。若在 dealloc 方法中调用了那些方法，则无法保证当前这个线程就是那些方法所需的线程。

- 不应该调用属性的存取方法。 
  因为有人可能会覆写这些方法，并于其中做一些无法在回收阶段安全执行的操作。此外，属性可能正处于 KVO 机制的监控之下，该属性的观察者可能会在属性值改变时保留或使用这个即将回收的对象。这样会令运行期系统的状态完全失调，从而导致一些莫名其妙的错误。

#### 32. 编写 “异常安全代码” 时留意内存管理问题

- 捕获异常时，一定要注意将 try 块内所创立的对象清理干净。
- 在默认情况下，ARC 不生成安全处理异常所需的清理代码。开启编译器标志后，可生成这种代码，不过会导致应用程序变大，而且会降低运行效率。

编写 “异常安全代码 `try-catch-finally`” 时要留意内存管理问题，否则很容易发生内存泄漏。

一般情况下，只有当发生严重错误，应用程序必须因异常而终止时才应抛出异常，而程序若终止则是否还会发生内存泄漏就无关紧要了。

有时仍然需要编写代码来捕获并处理异常。比如使用 Objective-C++ 来编码时（C++ 与 Objective-C 的异常相互兼容），或是编码中用到了第三方库而该库所抛出的异常又不受你控制时。

捕获异常时，一定要注意将 try 块内所创立的对象清理干净。

- 如果在 MRC 下，如果对象 release 操作在 try 块中执行并且它前面的代码中抛出了异常，会导致 release 操作不会执行从而内存泄漏。解决办法是将 release 操作放在 finally 块中执行，而该对象就必须声明为全局。缺点就是，如果 try 块中的逻辑复杂，就很容易忘记对某个对象执行 release 而导致内存泄漏，如果对象是稀缺资源则更严重。

  ```objc
  EOCSomeClass *object;
  @try {
      object = [[EOCSomeClass alloc] init];
      [object doSomethingThatMayThrow];
  }
  @catch (...) {
      NSLog(@"Whoops, there was an error, Oh well...");
  }
  @finally {
      [object release];
  }
  ```

- 如果在 ARC 下，在 “异常安全代码” 中，ARC 默认是不会自动帮我们插入 release 操作的。其原因是加入大量的这些代码会严重影响运行期的性能，即便在不抛异常时也是如此，而且还会明显增加应用程序的大小。

  1. 可以通过开启编译器标志 -fobjc-arc-exceptions ，来生成这种附加代码（release）。其默认不开启的原因即为上面提到的：一般情况下，只有当发生严重错误，应用程序必须因异常而终止时才应抛出异常，而程序若终止则是否还会发生内存泄漏就无关紧要了，添加安全处理异常所用的附加代码（比如 release）也没有意义。而且开启还会导致应用程序变大，降低运行效率等。
  2. 有种情况下，编译器会自动开启  -fobjc-arc-exceptions，就是当文件是 Objective-C++ 文件时。

当发现大量异常捕获操作时，应考虑重构代码，用 NSError 式错误信息传递法来取代异常。

#### 33. 以弱引用避免保留环

- 将某些引用设为 weak，可避免出现 “保留环”。

- weak 引用可以自动清空，也可以不自动清空，自动清空（autonilling）是随着 ARC 而引入的新特性，由运行期系统来实现。在具备自动清空功能的弱引用上，可以随意读取其数据，因为这种引用不会指向回收过的对象。

###### 保留环：

- 两个对象通过彼此之间的强引用而构成保留环。
- 多个对象，每个对象都强引用下一个对象直到回到第一个，构成保留环。

###### 保留环会导致内存泄漏：

如果最后一个指向保留环里对象的引用被移除，那么保留环里的对象就无法被外界所访问，而这些对象彼此之间都互相强引用就不会销毁，于是就导致了内存泄漏。（内存泄漏是指没有释放已分配的不再被使用的内存。）

> 之前 Mac OS X 平台的 Objective-C 程序可以启用垃圾收集器（garbage collector），它会检测保留环，若发现外界不再引用其中的对象，则将其回收。但从 Mac OS X 10.8 开始，垃圾收集机制就被废弃了，而改用 ARC 机制。不管是 MRC 还是 ARC 机制都从未支持自动检测回收保留环，因此我们要避免保留环的产生。

###### 以弱引用避免保留环

- `unsafe_unretained`：顾名思义，不保留对象但也不安全。不安全的原因在于：如果指针所指向的对象被销毁，指针仍然指向该对象的内存地址，变成悬垂指针，如果这时候再去使用该指针就会导致 Crash。
- `weak`：ARC 下才能使用，与 unsafe_unretained 一样不会保留对象。不同的是，如果指针所指向的对象被销毁，指针会自动置为 nil，再去使用该指针也是安全的。 ![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/474c520b4f9f427fb7740a9432927b5d~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)



#### 34. 以 “自动释放池块” 降低内存峰值

- 自动释放池排布在栈中，对象收到 autorelease 消息后，系统将其放入最顶端的池里。
- 合理运用自动释放池，可降低应用程序中的内存峰值。
- @autoreleasepool 这种新式写法能创建出更为轻便的自动释放池。

调用 autorelease 方法的对象会被加入到自动释放池中，`@autoreleasepool{}` 自动释放池于左花括号处创建，于右花括号处销毁。当自动释放池销毁时，会给其当中的所有对象发送 release 消息。

如果在没有创建自动释放池的情况下给对象发送 autorelease 消息，那么控制台就会输出以下信息。

```objc
MISSING POOLS: (0xabcd1234) Object 0xabcd0123 of class __NSCFString autoreleased with no pool in place - just leaking - break on objc_autoreleaseNoPool() to debug
```

不过一般情况下无须担心自动释放池的创建问题，系统会自动创建一些线程，比如说主线程或是 GCD 机制中的线程，这些线程默认都有自动释放池，每次执行事件循环时就会将其清空。

合理运用自动释放池，可降低应用程序中的内存峰值（内存峰值指应用系统在某个特定时间段内的最大内存用量）。不过，尽管自动释放池的开销不大，但毕竟还是有的。使用其来优化效率前应该先监控内存用量来判断是否有用自动释放池的必要，不要滥用。 
以下每次执行循环中都创建并清空自动释放池，可以及时释放每次循环中产生的 autorelease 对象，以降低内存峰值。

```objc
for (int i = 0; i < 100000; i++) {
    @autoreleasepool {
        [self doSomethingWithInt:i];
    }
}
```

在 MRC 下，可以使用 NSAutoreleasePool 或者 @autoreleasepool 来创建自动释放池，但在 ARC 下只能使用后者。想比于 NSAutoreleasePool，@autoreleasepool 的优点有：

- 更轻量级，苹果说它比 NSAutoreleasePool 快大约六倍。NSAutoreleasePool 则更为重量级，通常用来创建偶尔需要清空的自动释放池。而 @autoreleasepool 可以在每次执行循环中创建并清空自动释放池。

  ```objc
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  for (int i = 0; i < 100000; i++) {
      [self doSomethingWithInt:i];
      // Drain the pool only every 10 cycles
      if (++i == 10) {
          [pool drain];
      }
  }
  // Also drain ai the end in case the loop is not a multiple of 10
  [pool drain];
  ```

- 其范围即是左右花括号，可以避免无意间误用了那些在清空池后已被系统所回收的对象。而 NSAutoreleasePool 则无法避免。

  ```objc
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  id object = [self createObject];
  [pool drain];
  [self useObject:object];
  ```

  ```objc
  @autoreleasepool {
      id object = [self createObject];
  }
  [self useObject:object]; // 访问不了 object，无法编译
  ```

关于自动释放池更详细的解析，可以参阅：[Link:《iOS - 聊聊 autorelease 和 @autoreleasepool》](https://juejin.cn/post/6844904094503567368#heading-1)



#### 35. 用 “僵尸对象” 调试内存管理问题

- 系统在回收对象时，可以不将其真的回收，而是把它转化为僵尸对象。通过环境变量 NSZombieEnabled 可开启此功能。

- 系统会修改对象的 isa 指针，令其指向特殊的僵尸类，从而使该对象变为僵尸对象。僵尸类能够响应所有的选择子，响应方式为：打印一条包含消息内容及其接收者的消息，然后终止应用程序。

向业已回收的对象发送消息是不安全的，对象所占内存在 “解除分配(deallocated)” 之后，只是放回可用内存池。如果对象所占内存还没有分配给别人，这时候访问没有问题，如果已经分配给了别人，再次访问就会崩溃。

> 更精确的解释是：如果被回收的对象的内存只被复用了其中一部分，那么对象中的某些二进制数据依然有效，所以可能不会导致崩溃。如果那块内存恰好为另外一个有效且存活的对象所占据。那么运行期系统会把消息发到新对象那里，而此对象也许能应答，也许不能。如果能，程序就不会崩溃，但接收消息的对象已经不是我们预想的那个了；如果不能响应，则程序依然会崩溃。 这在调试的时候可能不太方便，我们可以通过 “僵尸对象(Zombie Object)” 来更好地调试内存管理问题。

###### 僵尸对象的启用： 

通过环境变量 NSZombieEnabled 启用 “僵尸对象” 功能。

###### 僵尸对象的工作原理： 

它的实现代码深植与 Objective-C 的运行期库、Foundation 框架及 CoreFoundation 框架中。系统在即将回收对象时，如果发现 NSZombieEnabled == YES，那么就把对象转化为僵尸对象，而不是将其真的回收。接下来给该对象（此时已是僵尸对象）发送消息，就会在控制台打印一条包含消息内容及其接收者的信息（如下），然后终止应用程序。这样我们就能知道在何时何处向业已回收的对象发送消息了。

```objc
[EOCClass message] : message sent to deallocated instance 0x7fc821c02a00
```

###### 僵尸对象的实现原理：

1. 在启用僵尸对象后，运行期系统就会 swizzle 交换 dealloc 方法实现，当每个对象即将被系统回收时，系统都会为其创建一个 `_NSZombie_OriginalClass` 类。（`OriginalClass` 为对象所属类类名，这些类直接由 `_NSZombie_` 类拷贝而来而不是使用效率更低的继承，然后赋予类新的名字 `_NSZombie_OriginalClass` 来记住旧类名。记住旧类名是为了在给僵尸对象发送消息时，系统可由此知道该对象原来所属的类。）。 
   然后将对象的 isa 指针指向僵尸类，从而待回收的对象变为僵尸对象。（由于是交换了 dealloc 方法，所有 free() 函数就不会执行，对象所占内存也就不会释放。虽然这样内存泄漏了，但也只是调试手段而已，所以泄漏问题无关紧要）。
2. 由于 `_NSZombie_` 类（以及所有从该类拷贝出来的类 `_NSZombie_OriginalClass`）没有实现任何方法，所以给僵尸对象发送任何消息，都会进入 “完整的消息转发阶段”。而在 “完整的消息转发阶段” 中，`__forwarding__` 函数是核心。它首先要做的事情包括检查接收消息的对象所属的类名。若前缀为 `_NSZombie_` 则表明消息接收者是僵尸对象，需要特殊处理：在控制台打印一条信息（信息中指明僵尸对象所接收到的消息、原来所属的类、内存地址等，`[OriginalClass message] : message sent to deallocated instance 0x7fc821c02a00`），然后终止应用程序。



#### 36. 不要使用 retainCount

- 对象的保留计数看似有用，实则不然，因为任何给定时间上的 “绝对保留计数”（absolute retain count）都无法反映对象生命期的全貌。
- 引入 ARC 之后，retainCount 方法就正式废止了，在 ARC 下调用该方法会导致编译器报错。 

ARC 下已经禁止调用 retainCount 方法。但即便 MRC 下可以调用，或者只为了调试，我们也不应该使用 retainCount，其值是不精确的。

###### 不要使用 retainCount 的原因：

1. 它所返回的保留计数只是某个给定时间点上的值，它没有考虑到有些对象是调用 autorelease 方法添加进自动释放池的，这些对象会延迟释放（保留计数值 - 1），而 retainCount 只是直接把当前保留计数值返回，所以结果往往不符合预期。

   比如以下代码有两个错误。一是，如果 object 在自动释放池中，那么当自动释放池清空的时候，就会因过度释放 object 而导致程序崩溃；二是，retainCount 可能永远不返回 0，因为有时系统会优化对象的释放行为，在保留计数还是 1 的时候就把它回收了。这样对象回收之后 while 循环可能仍在执行，就会导致程序崩溃。

   ```objc
   while ([object retainCount]) {
       [object release];
   }
   ```

2. 当对象是字符串常量，或是使用 Tagged Point 来存储时，retainCount 的值会特别大，就没有查看的意义。单例对象的保留计数也不会变，因为单例不可释放，所以我们可能会覆写其内存管理方法，把保留和释放操作替换为空操作。 所以，我们不应该总是依赖保留计数的具体值来编码。假如你根据 NSNumber 对象的具体保留计数来增减其值，而系统却以 Tagged Point 来实现此对象，那么编出来的代码就错了。

---

### 第六章：块与大中枢派发

#### 37. 理解 “块” 这一概念

- 块是 C、C++、Objective-C 中的词法闭包。
- 块可接受参数，也可返回值。
- 块可以分配在栈或堆上，也可以是全局的。分配在栈上的块可拷贝到堆里，这样的话，就和标准的 Objective-C 对象一样，具备引用计数了。 

###### 块的基础知识

块是 C、C++、Objective-C 中的词法闭包。块本身也是 OC 对象。

```objc
// 语法结构
return_type (^block_name)(parameters)
```

块的强大之处是：在声明它的范围里，所有变量都可以为其所捕获。也就是说，那个范围里全部变量，在块里依然可用。默认情况下，为块所捕获的变量，是不可以在块里修改的。声明变量的时候可以加上__block修饰符，这样就可以在块内修改了。

如果块定义在objective c 类的实例方法中，那么除了可以访问类的所有实例变量之外，还可以使用self变量。块总能修改实例变量，所以在声明式无须加__block。

如果块中没有显式地使用 self 来访问实例变量，那么块就会隐式捕获 self，这很容易在我们不经意间造成循环引用。如下代码，编译器会给出警告，建议用 `self->_anInstanceVariable` 或 `self.anInstanceVariable` 来访问。

```objc
self.block = ^{
    _anInstanceVariable = @"Something"；// ⚠️ Block implicitly retains ‘self’; explicitly mention ‘self’ to indicate this is intended behavior
}
```

###### 块的内存布局

- isa 指针指向 Class 对象
- invoke 变量是个函数指针，指向块的实现代码
- descriptor 变量是指向结构体的指针，其中声明了块对象的总体大小，还声明了保留和释放捕获的对象的 copy 和 dispose 这两个函数所对应的函数指针
- 块还会把它所捕获的所有变量都拷贝一份，放在 descriptor 变量的后面 。拷贝的并不是对象本身，而是指向这些对象的指针变量。![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ebf284ed0ae449efa1874cfc35492656~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

###### 块的三种类型：栈块、堆块、全局块

- 栈块

  定义块的时候，其所占的内存区域是分配在栈中的。块只在定义它的那个范围内有效。

  ```objc
  void (^block)();
  if ( /* some condition */ ) {
      block = ^{
          NSLog(@"Block A");
      };
  } else {
      block = ^{
          NSLog(@"Block B");
      };
  }
  block();
  ```

  上面的代码有危险，定义在 if 及 else 中的两个块都分配在栈内存中，当出了 if 及 else 的范围，栈块可能就会被销毁。如果编译器覆写了该块的内存，那么调用该块就会导致程序崩溃。

  > 若是在 ARC 下，上面 block 会被自动 copy 到堆，所以不会有问题。但在 MRC 下我们要避免这样写。

- 堆块

  为了解决以上问题，可以给块对象发送 copy 消息将其从栈拷贝到堆区，堆块可以在定义它的那个范围之外使用。堆块是带引用计数的对象，所以在 MRC 下如果不再使用堆块需要调用 release 进行释放。

  ```objc
  void (^block)();
  if ( /* some condition */ ) {
      block = [^{
          NSLog(@"Block A");
      } copy];
  } else {
      block = [^{
          NSLog(@"Block B");
      } copy];
  }
  block();
  [block release];
  ```

- 全局块

  如果运行块所需的全部信息都能在编译期确定，包括没有访问自动局部变量等，那么该块就是全局块。全局块可以声明在全局内存中，而不需要在每次用到的时候于栈中创建。

  全局块的 copy 操作是空操作，因为全局块决不可能被系统所回收，其实际上相当于单例。

  ```objc
  void (^block)() = ^{
      NSLog(@"This is a block");
  };
  ```



#### 38. 为常用的块类型创建 typedef

- 以 typedef 重新定义块类型，可令块变量用起来更加简单。

- 定义新类型时应遵从现有的命名习惯，勿使其名称与别的类型相冲突。

- 不妨为同一个块签名定义多个类型别名。如果要重构的代码使用了块类型的某个别名，那么只需修改相应的 typedef 中的块签名即可，无须改动其他 typedef。

每个块都具备其 “固有类型（由其参数及返回值组成）”，因而可将其赋值给适当类型的变量。

以 typedef 关键字重新定义块类型：

```objc
typedef int(^EOCSomeBlock)(BOOL flag, int value);
EOCSomeBlock block = ^(BOOL flag, int value) {
    // Implementation
}
```

以 typedef 关键字重新定义块类型的好处

- 易读，定义、声明块方便 
  定义块变量语法与定义其他类型变量的语法不同，而定义方法参数所用的块类型语法又和定义块变量语法不同。这种语法很难记，所以以 typedef 关键字重新定义块类型，可令块变量用起来更加简单，起个更为易读的名字来表示块的用途，而把块的类型隐藏在其后面。
- 重构块的类型签名时很方便 
  当修改 typedef 类型定义语句时，使用到这个类型定义的地方都无法编译，可逐个修复。而若是不用类型定义直接写块类型，修改的地方就更多，而且很容易忘掉其中一两处的修改而引发难于排查的 bug。

最好在使用块类型的类中定义这些 typedef，而且新类型名称还应该以该类名开头，以阐明块的用途。

可以根据不同用途为同一个块签名定义多个类型别名。如果要重构的代码使用了块类型的某个别名，那么只需修改相应的 typedef 中的块签名即可，无须改动其他 typedef。

#### 39. 用 handler 块降低代码分散程度

- 在创建对象时，可以使用内联的 handler 块将相关业务逻辑一并声明。

- 在有多个实例需要监控时，如果采用委托模式，那么经常需要根据传入的对象来切换，而若改用 handler 块来实现，则可直接将块与相关对象放在一起。

- 设计 API 时，如果用到了 handler 块，那么可以增加一个参数，使调用者可通过此参数来决定应该把块安排在哪个队列上执行。

当异步方法在执行完任务之后，需要以某种手段通知相关代码时，我们可以使用委托模式，也可以将 completion handler 定义为块类型。在对象的初始化方法中添加 handle 块参数，在创建对象时就将 handler 块传入。这样可以降低代码分散程度，令代码更加清晰整洁，令 API 更紧致，同时也令开发者调用起来更加方便。

```objc
[fetcher startWithCompletionHandler:^(NSData *data) {
    self->_fetchedFooData = data;
}];
```

委托模式的缺点：在有多个实例需要监控时，如果采用委托模式，那么就得在 delegate 回调方法里根据传入的对象来判断执行何种操作，回调方法的代码就会变得很长。

```objc
- (void)networkFetcher:(EOCNetworkFetcher *)networkFetcher didFinishWithData:(NSData *)data {
    if (networkFetcher == _fooFetcher) {
        ...
    } else if (networkFetcher == _barFetcher) {
        ...
    }
    // etc.
}
```

改用 handler 块来实现，可直接将块与相关对象放在一起，就不用再判断是哪个对象。

```objc
[_fooFetcher startWithCompletionHandler:^(NSData *data) {
    ...
}];
[_barFetcher startWithCompletionHandler:^(NSData *data) {
    ...
}];
```

当异步的回调有成功和失败两种情况时，可以有两种 API 设计方式：

- 用两个 handler 块来分别处理成功和失败的回调，这样可以让代码更易读，还可以根据需要对不想处理的回调块参数传 nil。

  ```objc
  [fetcher startWithCompletionHandler:^(NSData *data) {
      // Handle success
  } failureHander:^(NSError *error) {
      // Handle failure
  }];
  ```

- 用一个 handler 块来同时处理成功和失败的回调，并给块添加一个 error 参数来处理失败情况。

  ```objc
  [fetcher startWithCompletionHandler:^(NSData *data, NSError *error) {
      if (error) {
          // Handle failure
      } else {
          // Handle success
      }
  }];
  ```

  - 缺点：全部逻辑放在一起会令块变得很长且复杂
  - 优点：更灵活（比如数据下载到一半故障了，这样可以据此判断问题并适当处理，还可以利用已下载好的这部分数据做些事情），成功和失败情况有时候可能要统一处理（共享同一份错误处理代码） twitter框架的TWRequest 和 MapKit框架中的MKLocalSearch都只使用一个handler块

有时需要在相关时间点执行回调参数，就比如下载时想在每次有下载进度时都得到通知，这种情况也可以用 handler 块处理。

设计 API 时，如果用到了 handler 块，那么可以增加一个参数，使调用者可通过此参数来决定应该把块安排在哪个队列上执行。可以参照通知的 API：

```objc
- (id)addObserverForName:(NSString *)name object:(id)object queue:(NSOperationQueue *)queue usingBlock:(void(^)(NSNotification *))block;
```

此处传入的NSOperationQueue参数就表示触发通知时用来执行块代码的那个队列。这是个operation queue 而非底层gcd队列，不过两者语义相同（详见43条）

#### 40. 用块引用其所属对象时不要出现保留环

- 如果块所捕获的对象直接或间接地保留了块本身，那么就得当心保留环问题。
- 一定要找个适当的时机解除保留环，而不能把责任推给 API 的调用者。 

本节讲的是块的循环引用问题。当使用块的时候很容易形成保留环，我们要分析它们间的引用关系，避免保留环的产生。如果形成了保留环，那么一定要找个适当的时机解除保留环。而且应该在内部去处理，而不能把断环的任务交给 API 的调用者去处理，因为无法保证调用者会这么做。

#### 41. 多用派发队列，少用同步锁

- 派发队列可用来表述同步语义，这种做法要比使用 @synchronized 块或 NSLock 对象更简单。

- 将同步与异步派发结合起来，可以实现与普通加锁机制一样的同步行为，而这么做却不会阻塞执行异步派发的线程。

- 使用同步队列及栅栏块，可以令同步行为更加高效。

用锁来实现同步，会有死锁的风险，而且效率也不是很高。

而用 GCD 能以更简单、更高效的形式为代码加锁。

###### 用锁实现同步

同步块：

- @synchronized

  ```objc
  - (void)synchronizedMethod {
      @synchronized(self) {
          // Safe
      }
  }
  ```

  - 原理：@synchronized 会根据给定的对象，自动创建一个锁，并等待块中的代码执行完毕，然后释放锁。
  - 缺点：滥用 @synchronized(self) 会降低代码效率，因为共用同一个锁的那些同步块，都必须按顺序执行，也就是说所有的 @synchronized(self) 块中的代码之间都同步了。若是在 self 对象上频繁加锁，那么程序可能要等另一段与此无关的代码执行完毕，才能继续执行当前代码，这样做其实并没有必要。

- NSLock 等

  ```objc
  _lock = [[NSLock alloc] init];
  
  - (void)synchronizedMethod {
      [_lock lock];
      // Safe
      [_lock unlock];
  }
  //也可以使用NSRecursiveLock这种递归锁 县城能够多次持有该锁 不会出现死锁现象
  ```

###### 用 GCD 实现同步

- GCD 串行同步队列

  将读取操作和写入操作都安排在同一个队列里，即可保证数据同步。

  ```objc
  _syncQueue = dispatch_queue_create("com.effectiveobjectivec.syncQueue", NULL);
  
  - (NSString *)someString {
      __block NSString *localSomeString;
      dispatch_sync(_syncQueue, ^{
          localSomeString = _someString;
      });
      return localSomeString;
  }
  
  - (void)setSomeString:(NSString *)someString {
      dispatch_sync(_syncQueue, ^{
          _someString = _someString;
      });
  }
  ```

  也可以将 setter 方法的代码异步执行。由于 getter 方法需要返回值，所以需要同步执行以阻塞线程来防止提前 return，而 setter 方法不需要返回值所以可以异步执行。

  异步执行时需要拷贝 block，所以这里异步执行是否能提高执行速度取决于 block 任务的繁重程度。如果拷贝 block 的时间超过执行 block 的时间，那么异步执行反而降低效率，而如果 block 任务繁重，那么是可以提高执行速度的。

  ```objc
  - (void)setSomeString:(NSString *)someString {
      dispatch_async(_syncQueue, ^{
          _someString = _someString;
      });
  }
  ```

- GCD 栅栏函数 （搭配并发队列）

  ```objc
  void dispatch_barrier_async(dispatch_queue_t queue, dispatch_block_t block);
  void dispatch_barrier_sync(dispatch_queue_t queue, dispatch_block_t block);
  ```

  一直等到所有并发块都执行完毕，才会单独执行这个栅栏块。

  以上虽保证了读写安全，但并不是最优方案，因为读取方法之间同步执行了。

  保证读写安全，只需满足三个条件即可：

  1. 同一时间，只能有一个线程进行写操作；
  2. 同一时间，允许有多个线程进行读操作；
  3. 同一时间，不允许既有读操作，又有写操作。 我们可以针对第二点进行优化，让读取方法可以并发执行。使用 GCD 栅栏函数：

  ```objc
  _syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
  - (NSString *)someString {
      __block NSString *localSomeString;
      dispatch_sync(_syncQueue, ^{
          localSomeString = _someString;
      });
      return localSomeString;
  }
  
  - (void)setSomeString:(NSString *)someString {
      // 这里也可以根据 block 任务繁重程度选择 dispatch_barrier_async
      dispatch_barrier_sync(_syncQueue, ^{ 
          _someString = _someString;
      });
  }
  ```

  关于 GCD 栅栏函数使用的详细说明可以参阅：

  [Link:《iOS - 关于 GCD 的一些总结》](https://juejin.cn/post/6844904077642432526)

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c47e8aa85838419f8c9b3fff83a9e174~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

#### 42. 多用 GCD，少用 performSelector 系列方法

- performSelector 系列方法在内存管理方面容易有疏失。它无法确定将要执行的选择子具体是什么，因而 ARC 编译器也就无法插入适当的内存管理方法。

- performSelector 系列方法所能处理的选择子太过局限了，选择子的返回值类型及发送给方法的参数个数都受到限制。

- 如果想把任务放在另一个线程上执行，那么最好不要用 performSelector 系列方法，而是应该把任务封装到块里，然后调用大中枢派发机制的相关方法来实现。

- NSObject 定义了几个 performSelector 系列方法，可以让开发者随意调用任何方法，可以推迟执行方法调用，也可以指定执行方法的线程等等。

```objc
- (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)object;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
- (void)performSelectorInBackground:(SEL)aSelector withObject:(nullable id)arg;
// ...
```

###### `performSelector:`方法有什么用处？

1. 如果你只是用来调用一个方法的话，那么它确实有点多余

2. 用法一：selector 是在运行期决定的

   ```objc
   SEL selector;
   if ( /* some condition */ ) {
       selector = @selector(foo);
   } else if ( /* some other condition */ ) {
       selector = @selector(bar);
   } else {
       selector = @selector(baz);
   }
   [object performSelector:selector];
   ```

3. 用法二：把 selector 保存起来等某个事件发生后再调用 performSelector:

###### 方法的缺点：

1. 存在内存泄漏的隐患：

   由于 selector 在运行期才确定，所以编译器不知道所要执行的 selector 是什么。如果在 ARC 下，编译器会给出警告，提示可能会导致内存泄漏。

   ```objc
   waring: PerformSelector may cause a leak because its selector is unknown [-Warc-performSelector-leaks]
   复制代码
   ```

   由于编译器不知道所要执行的 selector 是什么，也就不知道其方法名、方法签名及返回值等，所以就没办法运用 ARC 的内存管理规则来判定返回值是不是应该释放。鉴于此，ARC 采用了比较谨慎的做法，就是不添加释放操作，然而这样可能会导致内存泄漏，因为方法在返回对象时可能已经将其保留了。

   > 如果是调用以 `alloc/new/copy/mutableCopy` 开头的方法，创建时就会持有对象，ARC 环境下编译器就会插入 release 方法来释放对象，而使用 performSelector 的话编译器就不添加释放操作，这就导致了内存泄漏。而其他名称开头的方法，返回的对象会被添加到自动释放池中，所以无须插入 release 方法，使用 performSelector 也就不会有问题。

2. 返回值只能是 void 或对象类型 
   如果想返回基本数据类型，就需要执行一些复杂的转换操作，且容易出错；如果返回值类型是 C struct，则不可使用 performSelector 方法。

3. 参数类型和个数也有局限性 
   类型：参数类型必须是 id 类型，不能是基本数据类型； 
   个数：所执行的 selector 的参数最多只能有两个。而如果使用 performSelector 延后执行或是指定线程执行的方法，那么 selector 的参数最多只能有一个。

###### 使用 GCD 替代 performSelector

1. 如果要延后执行，可以使用 dispatch_after
2. 如果要指定线程执行，那么 GCD 也完全可以做到



#### 43. 掌握 GCD 及操作队列的使用时机

- 在解决多线程与任务管理问题时，派发队列并非唯一方案。
- 操作队列提供了一套高层的 Objective-C API，能实现纯 GCD 所具备的绝大部分功能，而且还能完成一些更为复杂的操作，那些操作若改用 GCD 来实现，则需另外编写代码。



在解决多线程与任务管理问题时，我们要根据实际情况使用 GCD 或者 NSOperation，如果选错了工具，则编写的代码就会难以维护。以下是它们的区别：

| 多线程方案  | 区别                                                         |
| ----------- | ------------------------------------------------------------ |
| GCD         | GCD 是 iOS4.0 推出的，主要针对多核 CPU 做了优化，是 C 语言的技术； GCD 是纯 C 的 API； GCD 是将任务（block）添加到队列（串行/并发/全局/主队列），并且以同步/异步的方式执行任务； GCD 提供了一些 NSOperation 不具备的功能：   ① 队列组   ② 一次性执行   ③ 延迟执行 |
| NSOperation | NSOperation 是 iOS2.0 推出的，iOS4 之后重写了 NSOperation，底层由 GCD 实现； NSOperation 是 OC 对象； NSOperation 是将操作（异步的任务）添加到队列（并发队列），就会执行指定操作； NSOperation 里提供的方便的操作：   ①  最大并发数   ② 队列的暂停/继续/取消操作   ③  指定操作之间的依赖关系（GCD 中可以使用同步实现） |

使用 NSOperation 和 NSOperationQueue 的优势：

- 取消某个操作 
  可以在执行操作之前调用 NSOperation 的 cancel 方法来取消，不过正在执行的操作无法取消。iOS8 以后 GCD 可以用 dispatch_block_cancel 函数取消尚未执行的任务，正在执行的任务同样无法取消。
- 指定操作间的依赖关系 
  使特定的操作必须在另外一个操作顺利执行完以后才能执行。
- 通过 KVO 监控 NSOperation 对象的属性 
  在某个操作任务变更其状态时得到通知，比如 isCancelled、isFinished。而 GCD 不行。
- 指定操作的优先级 
  指定一个操作与队列中其他操作之间的优先级关系，优先级高的操作先执行，优先级低的则后执行。GCD 没有直接实现此功能的办法，优先级只能针对整个队列。
- 重用 NSOperation 对象 
  可以使用系统提供的 NSOperation 子类（比如 NSBlockOperation），也可以自定义子类。

GCD 任务用块来表示，块是轻量级数据结构，而 NSOperation 则是更为重量级的 Objective-C 对象。虽说如此，但 GCD 并不是最佳方案。有时候采用对象所带来的开销微乎其微，反而它所到来的好处大大反超其缺点。另外，“应该尽可能选用高层 API，只在确有必要时才求助于底层” 这个说法并不绝对。某些功能确实可以用高层的 API 来做，但这并不等于说它就一定比底层实现方案好。要想确定哪种方案更佳，最好还是测试一下性能。

NSNotificationCenter使用了操作队列来注册监听器

```objc
- (id)addObserverForName:(NSString*) name
                  object:(id) object
                   queue:(NSOperationQueue*) queue
              usingBlock:(void(^)(NSNotification*))block;
```



#### 44. 通过 Dispatch Group 机制，根据系统资源状况来执行任务

- 一系列任务可归入一个 dispatch group 之中。开发者可以在这组任务执行完毕时获得通知。

- 通过 dispatch group，可以在并发式派发队列里同时执行多项任务。此时 GCD 会根据系统资源情况来调度这些并发执行的任务。开发者若自己来实现此功能，则需编写大量代码。

- GCD 队列组，又称 “调度组”，实现所有任务执行完成后有一个统一的回调。 
  GCD 有并发队列机制，所以能够根据可用的系统资源状况来并发执行任务，使用队列组，既可以并发执行一系列给定的任务，又能在这些给定的任务全部执行完毕时得到通知。 
  有时候我们需要在多个异步任务都并发执行完毕以后再继续执行其他任务，这时候就可以使用队列组。

- 创建一个队列组。

  ```objc
  dispatch_group_t dispatch_group_create(void);
  ```

- 异步执行一个 block，并与指定的队列组关联。

  ```objc
  void dispatch_group_async(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block);
  ```

- 也可以通过以下两个函数指定任务所属的队列组。

  需要注意的是，调用了 dispatch_group_enter 之后必须要有与之对应的 dispatch_group_leave，如果没有的话那么这个队列组的任务就永远执行不完。

  ```objc
  void dispatch_group_enter(dispatch_group_t group);
  void dispatch_group_leave(dispatch_group_t group);
  ```

- 同步等待先前 dispatch_group_async 添加的 block 都执行完毕或指定的超时时间结束为止才返回。可以传入 DISPATCH_TIME_FOREVER，表示函数会一直等待任务都执行完，而不会超时。

  > 注意：dispatch_group_wait 会阻塞线程

  ```objc
  // @return long 如果 block 在指定的超时时间内完成，则返回 0；超时则返回非 0。
  long dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
  ```

- 等待先前 dispatch_group_async 添加的 block 都执行完毕以后，将 dispatch_group_notify 中的 block 提交到指定队列。

  > dispatch_group_notify 不会阻塞线程

  ```objc
  void dispatch_group_notify(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block);
  ```

```objc
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 添加异步任务：把任务添加到队列，等所有任务都执行完毕，通知队列组
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"%@,执行任务1",[NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"%@,执行任务2",[NSThread currentThread]);
        }
    });
    // 所有（dispatch_group_async）任务都执行完毕，获得通知（异步执行），将（dispatch_group_notify）中的 block 任务添加到指定队列 
    // 这行代码是会立刻执行的
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 但是里面的任务需要等到队列组的都执行完毕，等待通知
        for (int i = 0; i < 3; i++) {
            NSLog(@"%@,执行任务3",[NSThread currentThread]);
        }
    });
/*
<NSThread: 0x600000cbd200>{number = 4, name = (null)},执行任务1
<NSThread: 0x600000c68440>{number = 7, name = (null)},执行任务2
<NSThread: 0x600000c68440>{number = 7, name = (null)},执行任务2
<NSThread: 0x600000cbd200>{number = 4, name = (null)},执行任务1
<NSThread: 0x600000c68440>{number = 7, name = (null)},执行任务2
<NSThread: 0x600000cbd200>{number = 4, name = (null)},执行任务1
<NSThread: 0x600000cedbc0>{number = 1, name = main},执行任务3
<NSThread: 0x600000cedbc0>{number = 1, name = main},执行任务3
<NSThread: 0x600000cedbc0>{number = 1, name = main},执行任务3
 */
```



#### 45. 使用 dispatch_once 来执行只需运行一次的线程安全代码

- 经常需要编写 “只需执行一次的线程安全代码”（thread-safe single-code execution）。通过 GCD 所提供的 dispatch_once 函数，很容易就能实现此功能。

- 标记应该声明在 static 或 global 作用域中，这样的话，在把只需执行一次的块传给 dispatch_once 函数时，传进去的标记也是相同的。

dispatch_once 可以用来实现 “只需执行一次的线程安全代码”。

使用 dispatch_once 来实现单例，它比 @synchronized 更高效。它没有使用重量级的同步机制，而是采用 “原子访问” 来查询标记，以判断其所对应的代码原来是否已经执行过。

```objc
// 普通单例，线程不安全
+ (id)sharedInstance {
    static EOCClass *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc]init];
    }
    return sharedInstance;
}
// 加锁，线程安全
+ (id)sharedInstance {
    static EOCClass *sharedInstance = nil;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}
// dispatch_once，线程安全，效率更高
+ (id)sharedInstance {
    static EOCClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
```

对于只需执行一次的 block 来说，每次调用函数时传入的标记都必须完全相同，通常标记变量声明在 static 或 global 作用域里。



#### 46. 不要使用 dispatch_get_current_queue

- dispatch_get_current_queue 函数的行为常常与开发者所预期的不同。此函数已经废弃，只应做调试之用。

- 由于派发队列是按层级来组织的，所以无法单用某个队列对象来描述 “当前队列” 这一概念。

- dispatch_get_current_queue 函数用于解决由不可重入的代码所引发的死锁，然而能用此函数解决的问题，通常也能改用 “队列特定数据” 来解决。

`dispatch_get_current_queue` 函数返回当前正在执行代码的队列，但从 iOS6.0 开始就已经正式弃用此函数了。我们只应该在调试时使用该函数。

`dispatch_get_current_queue` 函数有个典型的错误用法，就是用它检测当前队列是不是某个特定的队列，试图以此来避免执行同步派发时可能遭遇的死锁问题，但这样仍然可能会产生死锁。

由于队列间有层级关系，所以通过 `dispatch_get_current_queue` 函数来 “检察当前队列是否为执行同步派发所用的队列” 这种办法并不总是奏效。

> 什么是 “队列间的层级关系”？
>
> ![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/13985ec076d641ae9b8936d62fb2310d~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp) 
> 排在某条队列中的块，会在其上层队列（也叫父队列）中执行，层级里地位最高的那个队列总是全局并发队列。 
> 上图中，排在队列 B，C 中的块会在 A 里依序执行。于是排在 A、B、C 中的块总是要彼此错开执行。而排在 D 中的块有可能与 A（包括 B、C）的块并行，因为 A 和 D 的目标队列是个并发队列。 比方说，开发者可能会认为排在队列 C 中的块一定会在 C 中执行，通过 `dispatch_get_current_queue` 函数判断当前队列是 C，就认为在 A 中同步执行该块一定安全，然而该块可能会在队列 A 执行，就导致了死锁。

`dispatch_get_current_queue` 函数用于解决由不可重入的代码所引发的死锁，然而能用此函数解决的问题，通常也能改用 “队列特定数据” 来解决。

```objc
dispatch_queue_t queueA = dispatch_queue_create("com.effectiveobjectivec.queueA", NULL);
dispatch_queue_t queueB = dispatch_queue_create("com.effectiveobjectivec.queueB", NULL);
dispatch_set_target_queue(queueB, queueA); // 将 B 的目标队列设为 A

static int kQueueSpecific;
CFStringRef queueSpecificValue = CFSTR("queueA");
// 给队列 A 设置队列特定数据
dispatch_queue_set_specific(queueA, 
                    &kQueueSpecific, 
                    (void *)queueSpecificValue, 
                    (dispatch_function_t)CFRelease); 

dispatch_sync(queueB, ^{
    dispatch_block_t block = ^{ NSLog(@"NO deadlock"); };

    CFStringRef retrievedValue = dispatch_get_specific(&kQueueSpecific);
    // 根据队列特定数据判断，如果当前是队列 A，则直接执行 Block，否则将同步块提交到队列 A
    if (retrievedValue) { 
        block();
    } else {
        dispatch_sync(queueA, block);
    }
});
```

---

### 第七章：系统框架

- 许多系统框架都可以直接使用。其中最重要的是 Foundation 与 CoreFoundation，这两个框架提供了构建应用程序所需的许多核心功能。

- 很多常见任务都能用框架来做，例如音频与视频处理、网络通信、数据管理等。

- 请记住：用纯 C 写成的框架与用 Objective-C 写成的一样重要，若想成为优秀的 Objective-C 开发者，应该掌握 C 语言的核心概念。

该篇主要介绍了一些系统框架，在编写新的工具类之前，最好查一下系统是否有提供所需功能的框架可直接使用。

- Foundation 与 CoreFoundation：基础框架 toll free bridging (nsstring -> cfstring)
- UIKit 与 AppKit：核心 UI 框架
- CFNetwork：提供 C 语言级别的网络通信能力
- CoreAudio：提供 C 语言 API 用来操作设备上的音频硬件
- AVFoundation：提供的 Objective-C 对象可用来回放并录制音频和视频
- CoreData：提供的 Objective-C 接口可将对象放入数据库，便于持久保存
- CoreText：提供的 C 语言接口可以高效执行文字排版及渲染操作
- CoreAnimation：用来渲染图形并播放动画
- CoreGraphics：提供 2D 渲染所必备的数据结构(CGPoint, CGSize, CGRect等)与函数 c语言写成
- MapKit：提供地图功能
- Social：提供社交网络功能

Foundation 与 CoreFoundation 框架分别是用 Objective-C 和 C 实现的，它们之间可以 “无缝桥接”（toll-free bridging）。

用 C 实现的 API 可以绕过 Objective-C 的运行期系统，从而提高执行速度。但由于 ARC 只负责 Objective-C 对象，所以使用这些 API 时尤其需要注意内存管理问题。

#### 48. 多用块枚举，少用 for 循环

- 遍历 collection 有四种方式。最基本的办法是 for 循环，其次是 NSEnumerator 遍历法及快速遍历法，最新、最先进的方式则是 “块枚举法”。

- “块枚举法” 本身就能够通过 GCD 来并发执行遍历操作，无须另行编写代码。而采用其他遍历方式则无法轻易实现这一点。

- 若提前知道待遍历的 collection 含有何种对象，则应修改块签名，指出对象的具体类型。

遍历 collection 有以下四种方式，我们应该多用块枚举，少用 for 循环。

###### for 循环

```objc
// Array
NSArray *anArray = /* ... */;
for (int i = 0; i < anArray.count; i++) {
    id object = anArray[i];
    // Do something with 'object'
}

// Dictionary
NSDictionary *aDictionary = /* ... */;
NSArray *keys = [aDictionary allKeys];
for (int i = 0; i < keys.count; i++) {
    id key = keys[i];
    id value = aDictionary[key];
    // Do something with 'key' and 'value'
}

// Set
NSSet *aSet = /* ... */;
NSArray *objects = [aSet allObjects];
for (int i = 0; i < objects.count; i++) {
    id object = objects[i];
    // Do something with 'object'
}
```

字典和 set 是无序的，所以无法根据下标来访问值，于是需要创建一个有序数组来帮助遍历，但创建和销毁数组却产生了额外的开销。而其他遍历方式则无须创建这种中介数组。

在执行反向遍历时，使用 for 循环会比其他方式简单许多。

###### 使用 Objective-C 1.0 的 NSEumerator 来遍历

```objc
// Array
NSArray *anArray = /* ... */;
NSEnumerator *enumerator = [anArray objectEnumerator];
// NSEnumerator *enumerator = [anArray reverseObjectEnumerator]; //反向遍历
id object;
while ((object = [enumerator nextObject]) != nil) {
    // Do something with 'object'
}

// Dictionary
NSDictionary *aDictionary = /* ... */;
NSEnumerator *enumerator = [aDictionary objectEnumerator];
id key;
while ((key = [enumerator nextObject]) != nil) {
    id value = aDictionary[key];
    // Do something with 'object'
}

// Set
NSSet *aSet = /* ... */;
NSEnumerator *enumerator = [aSet objectEnumerator];
id object;
while ((object = [enumerator nextObject]) != nil) {
    // Do something with 'object'
}
```

nextObject 方法返回枚举（NSEnumerator）里的下个对象。等到枚举中的全部对象都已返回之后，再调用就将返回 nil，表示达到枚举末端，也就是遍历结束了。

NSEnumerator 相比 for 循环：

1. 代码多了些，无法获取下标
2. 优势在于遍历数组、字典、集合的写法都相似
3. 对于反向遍历，使用 NSEnumerator 来实现，代码读起来更顺畅

###### 快速遍历（Objective-C 2.0 引入）

```objc
// Array
NSArray *anArray = /* ... */;
for (id object in anArray) {
    // Do something with 'object'
}

// Dictionary
NSDictionary *aDictionary = /* ... */;
for (id key in aDictionary) {
    id value = aDictionary[key];
    // Do something with 'key' and 'value'
}

// Set
NSSet *aSet = /* ... */;
for (id object in aSet) {
    // Do something with 'object'
}

// 反向遍历，由于 NSEumerator 对象实现了 NSFastEnumeration 协议，故其支持快速遍历
NSArray *anArray = /* ... */;
for (id object in [anArray reverseObjectEnumerator]) {
    // Do something with 'object'
}
```

如果要让某个类的对象支持快速遍历，只需遵守 NSFastEnumeration 协议并实现协议中定义的唯一的方法即可。

```objc
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len;
```

快速遍历语法更简洁更高效，它为 for 循环开设了 in 关键字。缺点是无法轻松获取当前遍历的元素的下标。

###### “块枚举法” 遍历

```objc
// Array
NSArray *anArray = /* ... */;
[anArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop){
    // Do something with 'object'
    if (shouldStop) {
        *stop = YES; 
    }
}];

// Dictionary
NSDictionary *aDictionary = /* ... */;
[aDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop){
    // Do something with 'key' and 'object'
    if (shouldStop) {
        *stop = YES;
    }
}];

// Set
NSSet *aSet = /* ... */;
[aSet enumerateObjectsUsingBlock:^(id object, BOOL *stop){
    // Do something with 'object'
    if (shouldStop) {
        *stop = YES;
    }
}];
```

块枚举法拥有其他遍历方式都具备的优势。虽然其代码量较多，但带来了很多好处：

1. 提供遍历时所针对的下标

2. 遍历字典时能同时提供键与值，无须额外编码

3. 可以使用 NSEnumerationOptions 来指定遍历方式，比如 NSEnumerationReverse 反向遍历，NSEnumerationConcurrent 并发执行遍历操作等（底层通过 GCD 来实现）

   ```objc
   - (void)enumerateObjectsWithOptions:(NSEnumerationOptions)options usingBlock:(void(^)(id obj, NSUInteger idx, BOOL *stop))block;
   - (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)options usingBlock:(void(^)(id obj, NSUInteger idx, BOOL *stop))block;
   // NSEnumerationOptions类型是个enum，其各种取值可用“按位或”链接，用以表明遍历方式
   ```

4. 可以通过设定 stop 变量值来终止遍历操作，其他遍历方式可以用 break

5. 能够修改块的方法签名（参数类型），以免去类型转换操作

   之所以能这么做，是因为 id 类型可以被其他类型所覆写。

   指定对象的具体类型，编译器就可以检测出开发者是否调用了该对象所不具备的方法，并在发现这种问题时报错。如果知道 collection 里的对象的具体类型，那就应该使用这种方式指明其类型。

   ```objc
   // 其他遍历方式需要进行类型强转操作
   for (NSString *key in aDictionary) {
       NSString *object = (NSString *)aDictionary[key];
       // Do something with 'key' and 'object'
   }
   
   // 块枚举法可以直接修改块的方法签名，以免去类型转换操作
   NSDictionary *aDictionary = /* ... */;
   [aDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop){
       // Do something with 'key' and 'obj'
   }];
   ```

#### 49. 对自定义其内存管理语义的 collection 使用无缝桥接

- 通过无缝桥接技术，可以在 Foundation 框架中的 Objective-C 对象与 CoreFoundation 框架中的 C 语言数据结构之间来回转换。

- 在 CoreFoundation 层面创建 collection 时，可以指定许多回调函数，这些函数表示此 collection 应如何处理其元素。然后，可运用无缝桥接技术，将其转换成具备特殊内存管理语义的 Objective-C collection。

###### 有 `__bridge` 、 `__bridge_retained` 、 `__bridge_transfer` 三种桥接方案，它们的区别为：

1. `__bridge`：不改变对象的内存管理权所有者。
2. `__bridge_retained`：用在 Foundation 对象转换成 Core Foundation 对象时，进行 ARC 内存管理权的剥夺。
3. `__bridge_transfer`：用在 Core Foundation 对象转换成 Foundation 对象时，进行内存管理权的移交。 详细可以参阅：[Link:《iOS - 老生常谈内存管理（三）：ARC 面世 - Managing Toll-Free Bridging》](https://juejin.cn/post/6844904130431942670#heading-32)

###### 我们用纯 Objective-C 来编写应用程序，为何要用到 CoreFoundation 框架对象以及桥接技术呢？ 

因为 Foundation 框架中的 Objective-C 类所具备的某些功能，是 CoreFoundation 框架中的 C 语言数据结构所不具备的，反之亦然。

作者举了一个使用到 CoreFoundation 对象的例子：在使用 Foundation 框架中的字典对象时会遇到一个大问题，其键的内存管理语义为 “拷贝”，而值的语义是 “保留”。也就是说，在向 NSMutableDictionary 中加入键和值时，字典会自动 “拷贝” 键并 “保留” 值。如果用做键的对象不支持拷贝操作（如果要支持，就必须遵守 NSCopying 协议，并实现 copyWithZone: 方法），那么编译器会给出警告并在运行期 Crash：

```objc
NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
[mDict setObject:@"" forKey:[Person new]]; // ⚠️ warning : Sending 'Person *' to parameter of incompatible type 'id<NSCopying> _Nonnull'

Runtime:
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: '-[Person copyWithZone:]: unrecognized selector sent to instance 0x60000230c210'
```

我们是无法直接修改 NSMutableDictionary 的键和值的内存管理语义的。这时候我们可以通过创建 CoreFoundation 框架的 CFMutableDictionary C 数据结构，修改内存管理语义，对键执行 “保留” 而非 “拷贝” 操作，然后再通过无缝桥接技术，将其转换 NSMutableDictionary 对象。

> 也可以使用 NSMapTable，指定 key 和 value 的内存管理语义。

在 CoreFoundation 层面创建 collection 时，可以指定许多回调函数，这些函数表示此 collection 应如何处理其元素。然后，可运用无缝桥接技术，将其转换成具备特殊内存管理语义的 Objective-C collection。 
下面我们就以 CFMutableDictionary 为例，解决上述问题。

1. 我们先来看一下创建字典的方法定义：

   ```objc
   /**
    * 创建字典
    * @param allocator 表示将要使用的内存分配器（CoreFoundation 对象里的数据结构需要占用内存，而分配器负责分配和回收这些内存）。通常传 NULL，表示采用默认的分配器。
    * @param capacity  字典的初始大小，同 NSMutableDictionary 的 initWithCapacity:
    * @param keyCallBacks
    * @param valueCallBacks  最后两个参数都是指向结构体的指针，它们定义了很多回调函数，用于指示字典中的键和值在遇到各种事件时应该执行何种操作。其定义见如下的 CFDictionaryKeyCallBacks 和 CFDictionaryValueCallBacks
    */
   CFMutableDictionaryRef CFDictionaryCreateMutable(
       CFAllocatorRef allocator, 
       CFIndex capacity, 
       const CFDictionaryKeyCallBacks *keyCallBacks, 
       const CFDictionaryValueCallBacks *valueCallBacks
   ); 
   
   /** 
    * 键的回调函数
    * @param version  版本号，目前应设为 0
    * @param retain、release、copyDescription、equal、hash  都为函数指针，定义了当各种事件发生时应该采用哪个函数来执行相关任务。比如往字典中添加键值对就会调用 retain 函数，其定义见如下的 CFDictionaryRetainCallBack
    */
   typedef struct {
       CFIndex				version;
       CFDictionaryRetainCallBack		retain;
       CFDictionaryReleaseCallBack		release;
       CFDictionaryCopyDescriptionCallBack	copyDescription;
       CFDictionaryEqualCallBack		equal;
       CFDictionaryHashCallBack		hash;
   } CFDictionaryKeyCallBacks;
   
   /** 
    * 值的回调函数
    * 同 CFDictionaryKeyCallBacks
    */
   typedef struct {
       CFIndex				version;
       CFDictionaryRetainCallBack		retain;
       CFDictionaryReleaseCallBack		release;
       CFDictionaryCopyDescriptionCallBack	copyDescription;
       CFDictionaryEqualCallBack		equal;
   } CFDictionaryValueCallBacks;
   
   /** 
    * retain 函数定义
    * @param allocator 
    * @param value  即将加入字典中的键
    * @return void*  表示要加到字典里的最终值
    */
   typedef const void *(*CFDictionaryRetainCallBack)(CFAllocatorRef allocator, const void *value);
   ```

2. 示例代码，实现对键执行 “保留” 而非 “拷贝” 操作的字典 NSMutableDictionary：

   ```objc
   #import <Foundation/Foundation.h>
   #import <CoreFoundation/CoreFoundation.h>
   
   const void * EOCRetainCallBack(CFAllocatorRef allocator, const void *value) {
       return CFRetain(value);  // 将加入字典中的键或值 retain 后返回，而不进行 copy
   }
   
   void EOCReleaseCallBack(CFAllocatorRef allocator, const void *value) {
       CFRelease(value);
   }
   
   CFDictionaryKeyCallBacks keyCallBacks = {
       0,
       EOCRetainCallBack,
       EOCReleaseCallBack,
       NULL,    // copyDescription 传 NULL，代表采用默认实现
       CFEqual, // CFEqual 最终会调用 NSObject 的 isEqual: 方法
       CFHash   // CFHash  最终会调用 NSObject 的 hash 方法
   };
   
   CFDictionaryValueCallBacks valueCallBacks = {
       0,
       EOCRetainCallBack,
       EOCReleaseCallBack,
       NULL,
       CFEqual
   };
   
   CFMutableDictionaryRef aCFDictionary = CFDictionaryCreateMutable(
       NULL,
       0,
       &keyCallBacks,
       &valueCallBacks
   );
   // 进行无缝桥接
   NSMutableDictionary *aNSDictionary = (__bridge_transfer NSMutableDictionary *)aCFDictionary;
   ```



#### 50. 构建缓存时选用 NSCache 而非 NSDictionary

- 实现缓存时应选用 NSCache 而非 NSDictionary 对象。因为 NSCache 可以提供优雅的自动删减功能，而且是 “线程安全” 的，此外，它与字典不同，并不会拷贝键。

- 可以给 NSCache 对象设置上限，用以限制缓存中的对象总个数及 “总成本”，而这些尺度则定义了缓存删减其中的对象的时机。但绝对不要把这些尺度当成可靠的 “硬限制”（hard limit），它们仅对 NSCache 起指导作用。

- 将 NSPurgeableData 与 NSCache 搭配使用，可实现自动清除数据的功能，也就是说，当 NSPurgeableData 对象所占内存为系统所丢弃时，该对象自身也会从缓存中移除。

- 如果缓存使用得当，那么应用程序的响应速度就能提高。只有那种 “重新计算起来很费事的” 数据，才值得放入缓存，比如那些需要从网络获取或从磁盘读取的数据。

###### 构建缓存时选用 NSCache 而非 NSDictionary，NSCache 的优势在于：

1. 当系统资源将要耗尽时，它可以优雅的自动删减缓存，且会先行删减最久未使用的缓存。使用 NSDictionary 虽也可以自己实现但很复杂。

   > [nscache](http://events.jianshu.io/p/3f1d08fbe20c)
   >
   > 简单来说，在Swift中的`NSCache`进行缓存时，先添加后移除，会根据`totalCostLimit`和`countLimit`的大小移除超出上限的缓存，但没有平均访问数，而是根据`cost`排序，移除`cost`较小的数据。

2. NSCache 不会拷贝键，而是保留它。使用 NSDictionary 虽也可以实现但比较复杂，见 【🚩 49】。

3. NSCache 是线程安全的。不编写加锁代码的前提下，多个线程可以同时访问 NSCache。而 NSDictionary 不是线程安全的。

###### 可以操控 NSCache 删减缓存的时机

1. `totalCostLimit` 限制缓存中所有对象的总开销
2. `countLimit` 限制缓存中对象的总个数
3. `- (void)setObject:(ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g;` 将对象添加进缓存时，可指定其开销值 可能会删减缓存对象的时机：
4. 当对象总数或者总开销超过上限时
5. 在可用的系统资源趋于紧张时 需要注意的是：
6. 可能会删减某个对象，并不意味着一定会删减
7. 删减对象的顺序，由具体实现决定的
8. 想通过调整开销值来迫使缓存优先删减某对象是不建议的，绝对不要把这些尺度当成可靠的 “硬限制”，它们仅对 NSCache 起指导作用。

###### 使用 

```
- (void)setObject:(ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g;
```

 可以在将对象添加进缓存时指定其开销值。但这种情况只适用于开销值能很快计算出来的情况，因为缓存的本意就是为了增加应用程序响应用户操作的速度。

1. 比方说，计算开销值时必须访问磁盘或者数据库才能确定文件大小，那么就不适用这种方法。
2. 如果要加入缓存的是 NSData 对象，其数据大小已知，直接访问属性即可 `data.length`。

###### NSPurgeableData

1. NSPurgeableData 继承自 NSMutableData，它与 NSCache 搭配使用，可实现自动清除数据的功能。它实现了 NSDiscardableContent 协议（如果某个对象所占内存能够根据数据需要随时丢弃，就可以实现该协议定义的接口），将其加入 NSCache 后当该对象被系统所丢弃时，也会自动从缓存中清除。可以通过 NSCache 的 evictsObjectWithDiscardedContent 属性来开启或关闭此功能。
2. 使用 NSPurgeableData 的方式和 “引用计数” 很像，当需要访问某个 NSPurgeableData 对象时，可以调用`beginContentAccess`进行 “持有”，并在用完时调用 `endContentAccess`进行 “释放”。NSPurgeableData 在创建的时候其 “引用计数” 就为 1，所以无须调用 `beginContentAccess`，只需要在使用完毕后调用`endContentAccess`就行。
   - `beginContentAccess`：告诉它现在还不应该丢弃自己所占据的内存
   - `endContentAccess`：告诉它必要时可以丢弃自己所占据的内存

###### NSPurgeableData 与 NSCache 一起实现缓存的代码示例：

```objc
// Network fetcher class
typedef void(^EOCNetworkFetcherCompletionHandler)(NSData *data);

@interface EOCNetworkFetcher : NSObject

- (id)initWithURL:(NSURL*)url;
- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler)handler;

@end

// Class that uses the network fetcher and caches results
@interface EOCClass : NSObject
@end

@implementation EOCClass {
    NSCache *_cache;
}

- (id)init {

    if ((self = [super init])) {
        _cache = [NSCache new];

        // Cache a maximum of 100 URLs
        _cache.countLimit = 100;

        /**
         * The size in bytes of data is used as the cost,
         * so this sets a cost limit of 5MB.
         */
        _cache.totalCostLimit = 5 * 1024 * 1024;
    }
    return self;
}

- (void)downloadDataForURL:(NSURL*)url { 

    NSPurgeableData *cachedData = [_cache objectForKey:url];

    if (cachedData) {
        [cachedData beginContentAccess];
        // Cache hit：存在缓存，读取
        [self useData:cachedData];
        [cachedData endContentAccess];
    } else {
        // Cache miss：没有缓存，下载
        EOCNetworkFetcher *fetcher = [[EOCNetworkFetcher alloc] initWithURL:url];      

        [fetcher startWithCompletionHandler:^(NSData *data){
            NSPurgeableData *purgeableData = [NSPurgeableData dataWithData:data];
            [_cache setObject:purgeableData forKey:url cost:purgeableData.length];    
            [self useData:data];
            [purgeableData endContentAccess];
        }];
    }
}
@end
```

#### 51. 精简 initialize 与 load 的实现代码

- 在加载阶段，如果类实现了 load 方法，那么系统就会调用它。分类里也可以定义此方法，类的 load 方法要比分类中的先调用。与其他方法不同，load 方法不参与覆写机制。

- 首次使用某个类之前，系统会向其发送 initialize 消息。由于此方法遵从普通的覆写规则，所以通常应该在里面判断当前要初始化的是哪个类。

- load 与 initialize 方法都应该实现得精简一些，这有助于保持应用程序的响应能力，也能减少引入 “依赖环”（interdependency cycle，也称 “环状依赖”）的几率。

- 无法在编译期设定的全局常量，可以放在 initialize 方法里初始化。

###### 掌握 load 和 initialize 方法的调用时刻、调用方式、调用顺序等。 

可以参阅 [Link:《OC 底层探索 - load 和 initialize》](https://juejin.cn/post/6844904068071194638)

| 区别     | load                                                         | initialize                                                   |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 调用时刻 | 在`Runtime`加载类、分类时调用 （不管有没有用到这些类，在程序运行起来的时候都会加载进内存，并调用`+load`方法）。  每个类、分类的`+load`，在程序运行过程中只调用一次（除非开发者手动调用）。 | 在`类`第一次接收到消息时调用。  如果子类没有实现`+initialize`方法，会调用父类的`+initialize`，所以父类的`+initialize`方法可能会被调用多次，但不代表父类初始化多次，每个类只会初始化一次。 |
| 调用方式 | ① 系统自动调用`+load `方式为直接通过函数地址调用； ② 开发者手动调用`+load `方式为消息机制`objc_msgSend`函数调用。 | 消息机制`objc_msgSend`函数调用。                             |
| 调用顺序 | ① 先调用类的`+load `，按照编译先后顺序调用（先编译，先调用），调用子类的`+load `之前会先调用父类的`+load `； ② 再调用分类的`+load `，按照编译先后顺序调用（先编译，先调用）（注意：分类的其它方法是：后编译，优先调用）。 | ① 先调用父类的`+initialize`， ② 再调用子类的`+initialize` （先初识化父类，再初始化子类）。 |

###### 使用 load 方法的问题和注意事项：

1. 在 load 方法中使用其他类是不安全的。比方说，类 A 和 B 没有继承关系，它们之间 load 方法的执行顺序是不确定的，而你在类 A 的 load 方法中去实例化 B，而类 B 可能会在其 load 方法中去完成实例化 B 前的一些重要操作，此时类 B 的 load 方法可能还未执行，所以不安全。
2. load 方法务必实现得精简一些，尽量减少其所执行的操作，不要执行耗时太久或需要加锁的任务，因为整个应用程序在执行 load 方法时都会阻塞。
3. 如果任务没必要在类加载进内存时就执行，而是可以在类初始化时执行，那么改用 initialize 替代 load 方法。

initialize 除了在调用时刻、调用方式、调用顺序方面与 load 有区别以外。initialize 方法还是安全的。 
运行期系统在执行 initialize 时，是处于正常状态的，因为这时候可以安全使用并调用任意类中的任意方法了。而且运行期系统也能确保 initialize 方法一定会在 “线程安全的环境” 中执行，只有执行 initialize 的那个线程可以操作类或类实例，其他线程都要先阻塞等着 initialize 执行完。

如果子类没有实现 initialize 方法，那么就会调用父类的，所以通常会在 initialize 实现中对消息接收者做一下判断：

```objc
+ (void)initialize {
    if (self == [EOCBaseClass class]) {
        NSLog(@"%@ initialized", self);
    }
}
```

###### initialize 的实现也要保持精简，其原因在于：

1. 如果在主线程初始化一个类，那么初始化期间就会一直阻塞。
2. 无法控制类的初始化时机。编写代码时不能令代码依赖特定的时间点执行，否则如果以后运行期系统更新改变了类的初始化方式，那么就会很危险。
3. 如果在 initialize 中给其他类发送消息，那么会迫使这些类都进行初始化。如果其他类在执行 initialize 时又依赖该类的某些数据，而该类的这些数据又在 initialize 中完成，就会发生问题，产生 “环状依赖”。 
   所以，initialize 方法只应该用来设置内部数据，例如无法在编译期设定的全局常量，可以放在 initialize 方法里初始化。不应该调用其他方法，即便是本类自己的方法，也最好别调用。

实现 load 和 initialize 方法时，一定要注意以上问题，精简代码。除了初始化全局状态之外，如果还有其他事情要做，那么可以专门创建一个方法来执行这些操作，并要求该类的使用者必须在使用本类之前调用此方法。比如说，如果 “单例类” 在首次使用之前必须执行一些操作，那就可以采用这个办法。



#### 52. 别忘了 NSTimer 会保留其目标对象

- NSTimer 对象会保留其目标，直到计时器本身失效为止，调用 invalidate 方法可令计时器失效，另外，一次性的计时器在触发完任务之后也会失效。

- 反复执行任务的计时器（repeating timer），很容易引入保留环，如果这种计时器的目标对象又保留了计时器本身，那么肯定会导致保留环。这种环状保留关系，可能是直接发生的，也可能是通过对象图里的其他对象间接发生的。

- 可以扩充 NSTimer 的功能，用 “块” 来打破保留环。不过，除非 NSTimer 将来在公共接口里提供此功能，否则必须创建分类，将相关实现代码加入其中。（笔者注：NSTimer 现已提供此功能）

如果使用传 target 参数的方法来创建定时器，要注意定时器是会保留 target 的。如果使用不当，很容易造成内存泄露。

###### 以下代码中，EOCClass 实例和 _pollTimer 之间形成了保留环，断环的方式有两种。

1. 该实例被系统回收，然后在 dealloc 方法中令定时器实效。然而由于定时器保留了该实例，所以在定时器实效前该实例是不会回收的，所以这个办法不可行，必定造成内存泄漏。

2. 主动调用 stopPolling 方法打破保留环，但这种通过主动调用某方法来避免内存泄露的做法，也不是个好主意。

   ```objc
   #import <Foundation/Foundation.h>
   
   @interface EOCClass : NSObject
   - (void)startPolling;
   - (void)stopPolling;
   @end
   
   @implementation EOCClass {
       NSTimer *_pollTimer;
   }
   
   - (id)init {
       return [super init];
   }
   
   - (void)dealloc {
       [_pollTimer invalidate];
   }
   
   - (void)stopPolling {
       [_pollTimer invalidate];
       _pollTimer = nil;
   }
   
   - (void)startPolling {
       _pollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                     target:self
                                                   selector:@selector(p_doPoll)
                                                   userInfo:nil
                                                    repeats:YES];
   }
   
   - (void)p_doPoll {
       // Poll the resource
   }
   
   @end
   ```

解决这个问题的方法有很多种，比如：

1. 在 viewWillDisappear 方法中令定时器实效。但是这种方式不推荐，原因是 push 的时候 vc 并没有销毁，但也会调用该方法。以下代码也有局限性。

   ```objc
   - (void)viewWillDisappear:(BOOL)animated {
       [super viewWillDisappear:animated];
       if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
           [self.timer invalidate];
           self.timer = nil;
       }
   }
   ```

2. didMoveToParentViewController。缺点是不能用于多个控制器情况。

   ```objc
   - (void)didMoveToParentViewController:(UIViewController *)parent {
       if (parent == nil) {
           [self.timer invalidate];
           self.timer = nil;
       }
   }
   ```

3. 使用 block 的方式创建 timer

   ```objc
   __weak typeof(self) weakSelf = self;
   self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
       [weakSelf message];
   }];
   ```

   然后在 self 的析构方法中令定时器实效即可。

4. 封装一层 NSTimer

5. 使用中间变量 NSProxy

   1. timer 对 proxy 持有强引用
   2. proxy 对 self 持有弱引用，并将消息转发给 self
   3. 在 self 的析构方法中正常释放定时器

作者给出的方式是给 NSTimer 封装一个以 block 方式创建的方法，将 NSTimer 类对象作为 target 传入，因为类对象是个单例，所以定时器保留它也无所谓。由于现在苹果已经提供了通过传 block 方式创建 NSTimer 的方法，故没必要再像该作者这样再自己封装一个方法，这里也就不贴代码了。

---



##### BOOL vs Bool

The `BOOL` type is used for boolean values in Objective-C. It has two values, `YES`, and `NO`, in contrast to the more common "true" and "false".

Its behavior is straightforward and identical to the C language's.

```
BOOL areEqual = (1 == 1);    // areEqual is YES
BOOL areNotEqual = !areEqual    // areNotEqual is NO
NSCAssert(areEqual, "Mathematics is a lie");    // Assertion passes

BOOL shouldFlatterReader = YES;
if (shouldFlatterReader) {
    NSLog(@"Only the very smartest programmers read this kind of material.");
}
```

A `BOOL` is a primitive, and so it cannot be stored directly in a Foundation collection. It must be wrapped in an `NSNumber`. Clang provides special syntax for this:

```
NSNumber * yes = @YES;    // Equivalent to [NSNumber numberWithBool:YES]
NSNumber * no = @NO;    // Equivalent to [NSNumber numberWithBool:NO]
```

------

The `BOOL` implementation is directly based on C's, in that it is a typedef of the C99 standard type `bool`. The `YES` and `NO` values are defined to `__objc_yes` and `__objc_no`, respectively. These special values are compiler builtins introduced by Clang, which are translated to `(BOOL)1` and `(BOOL)0`. If they are not available, `YES` and `NO` are defined directly as the cast-integer form. The definitions are found in the Objective-C runtime header objc.h

##### 消息传递

Objective-C最大的特色是承自Smalltalk的消息传递模型（message passing）

对象互相调用方法: 一个方法必定属于一个类别，而且在编译时（compile time）就已经紧密绑定，不可能调用一个不存在类别里的方法。

消息传递: 但在Objective-C，类别与消息的关系比较松散，调用方法视为对对象发送消息，所有方法都被视为对消息的回应。所有消息处理直到运行时（runtime）才会动态决定，并交由类别自行决定如何处理收到的消息, 并交由类别自行决定如何处理收到的消息

一个类别不保证一定会回应收到的消息，如果类别收到了一个无法处理的消息，程序只会抛出异常，不会出错或崩溃

时空对象nil接受消息后默认为不做事，所以送消息给nil也不用担心程序崩溃

##### 属性

属性是用来代替声明存取方法的便捷方式

属性不会在你的类声明中创建一个新的实例变量。他们仅仅是定义方法访问已有的实例变量的速记方式而已

类还可以使用属性暴露一些“虚拟”的实例变量，他们是部分数据动态计算的结果，而不是确实保存在实例变量内的

属性节约了你必须要写的大量多余的代码。因为大多数存取方法都是用类似的方式实现的，属性避免了为类暴露的每个实例变量提供不同的getter和setter的需求。取而代之的是，你用属性声明指定你希望的行为，然后在编译期间合成基于声明的实际的getter和setter方法。

属性可以利用传统的消息表达式、点表达式或"valueForKey:"/"setValue:forKey:"方法对来访问。

```objective-c
Person *aPerson = [[Person alloc] initWithAge: 53];
aPerson.name = @"Steve"; // 注意：点表达式，等于[aPerson setName: @"Steve"];
NSLog(@"Access by message (%@), dot notation(%@), property name(%@) and direct instance variable access (%@)",
      [aPerson name], aPerson.name, [aPerson valueForKey:@"name"], aPerson->name);
```

##### 快速枚举

```objective-c
// 使用NSEnumerator
NSEnumerator *enumerator = [thePeople objectEnumerator];
Person *p;
while((p = [enumerator nextObjext]) != nil){
  NSLog(@"%@ is %i years old", [p name], [p age]);
}

// 使用依次枚举
for ( int i = 0; i < [thePeople count]; i++ ) {
    Person *p = [thePeople objectAtIndex:i];
    NSLog(@"%@ is %i years old.", [p name], [p age]);
}

// 使用快速枚举
for (Person *p in thePeople) {
    NSLog(@"%@ is %i years old.", [p name], [p age]);
}
```



##### 协议

协议是一组没有实现的方法列表，任何的类均可采纳协议并具体实现这组方法。

Objective-C 2.0版本允许标记协议中某些方法为可选的（Optional），这样编译器就不会强制实现这些可选的方法

使用场景：

插件（可以在不关心插件的实现的情况下定义其希望的行为）

委托及事件触发 协议经常应用于Cocoa中的委托及事件触发

例如文本框类通常会包括一个委托（delegate）对象，该对象可以实现一个协议，该协议中可能包含一个实现文字输入的自动完成方法。若这个委托对象实现了这个方法，那么文本框类就会在适当的时候触发自动完成事件，并调用这个方法用于自动完成功能。

  ```objc
  @protocol Locking
  - (void)lock;
  - (void)unlock;
  @end
  ```

下面的SomeClass宣称他采纳了Locking协议：

```objc
@interface SomeClass : SomeSuperClass <Locking>
@end
```

一旦SomeClass表明他采纳了Locking协议，SomeClass就有义务实现Locking协议中的两个方法。

```objc
@implementation SomeClass
- (void)lock {
  // 實現lock方法...
}
- (void)unlock {
  // 實現unlock方法...
}
@end
```





##### 预处理

[reference](https://blog.csdn.net/Cloudox_/article/details/70833277)

- 头文件包含（#include、#import）

  而对于#include和#import这两者，区别在于#import可以确保头文件只被引用一次，这样就可以防止递归包含，什么叫递归包含，A引用B和C，B也引用了C，那就都包含了C，这就重复包含了。因此，如果非要用#include，那必须额外地写指令来判断有没有包含过，来避免递归包含。
  
- 条件编译（#if、#elif、#else、#endif、#ifdef和#ifndef）

- 诊断（#error、#warning和#line）

  一般都用在条件判断语句内容中，后面都跟着双引号带着的消息，error指令会直接中止编译，抛出错误消息，warning也会抛出警告消息，但不会中止编译。

- \#pragma指令

这个#pragma mark指令可以在Xcode 中的该文件的方法列表中插入标记，#pragma mark -就可以插入一个分隔线，后跟文字就可以插入文字标签。

除此之外，#pragma指令还包含很多别的选项，上面的是用的最多的，其他的可以查看文档。

- 预处理器之宏

注意要多对参数使用括号

[常用场景](https://www.jianshu.com/p/3ff0098245d1)



##### Category vs Extension

category

概念：Category 动态为已经存在的类（即使没有类源代码的情况下）添加方法。

优势：

1. 可以 把类的实现分开在几个不同的文件里面：
   - 减少单个文件的体积
   - 不同的功能组知道不同的category里
   - 由多个开发者共同完成一个类
   - 按需加载

2. 

使用：

```objectivec
//为类 People 创建一个分类
//分类的.h 文件
#import "People.h"

@interface People (eat)
//声明分类方法
- (void)eat;

@end
```



```objectivec
//分类的.m文件
#import "People+eat.h"

@implementation People (eat)
//实现分类方法
- (void)eat{
    NSLog(@"吃饭");
}
```



extension

- Extension（类扩展）是Category的一个特例，其名字为匿名（为空）。

- extension在**编译期**决议，它就是类的一部分，在编译期和头文件里的@interface以及实现文件里的@implement一起形成一个完整的类，它伴随类的产生而产生，亦随之一起消亡

使用：

1. 单独创建.h文件：创建一个类扩展后，生成一个.h文件，在.h文件中声明扩展方法，然后在类的.m文件中实现扩展方法。这个扩展方法是一个私有方法，外界不可以调用。

```objectivec
//为类 People 创建一个扩展
#import "People.h"

@interface People ()
//声明扩展方法
- (void)sleep;

@end
```

2. 在.m文件中声明

使用场景：

- It is also generally common for a class to have a publicly declared API and to then have additional methods declared privately for use solely by the class or the framework within which the class resides. Class extensions allow you to declare additional *required* methods for a class in locations other than within the primary class `@interface` block

- A common use for class extensions is to redeclare property that is publicly declared as read-only privately as readwrite:



相同点：都可以为一个类添加方法

不同点：

1. Categories是运行期决议的，在@implementation中不提供实现，编译器不会报错，运行调用时出错；Extensions在编译器决议，是类的一部分，在编译器和头文件的@interface和实现文件里的@implement一起形成了一个完整的类，在@implementation中不提供实现，编译器警告；

2. Category只能用于添加方法，不能用于添加成员变量。extension中声明的方法和添加的成员变量是私有的，只有主implement能调用，外部的类无法调用。

3. Category 增加的方法如果与类的方法同名，会覆盖原类的方法，因为Category的优先级更高！Extensions则会冲突报错。

4. 从某个类新建一个Category，会生成类名称+Category名称.h和类名称+Category名称.m两个文件；而从某个类新建一个Extension，只会生成一个类名称_Extension.h一个文件。

扩展阅读：[属性声明在@implementation里与extension里的区别](https://blog.csdn.net/jeffasd/article/details/51330390)



##### kvo/kvc



##### NSNotification





##### swizzleMethod （runtime）

```objc
// e.g. array extension
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_mb_swizzleMethodSrcClass:[self getMeatclass:[NSArray class]] srcSel:@selector(safe_mb_arrayWithObjects:count:) tarClass:[self getMeatclass:[NSArray class]] tarSel:@selector(arrayWithObjects:count:)];
    });
}
```

```objc
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "SafeKitMacro.h"

@implementation NSObject(Swizzle)

+ (Class)getMeatclass:(Class)srcClass {
    Class objectMeatClass = object_getClass(srcClass); ///> 元类对象
    return objectMeatClass;
}

+ (void)safe_mb_swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel{
    Class clazz = [self class];
    [self safe_mb_swizzleMethodSrcClass:clazz srcSel:srcSel tarClass:clazz tarSel:tarSel];
}

+ (void)safe_mb_swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel{
    if (!tarClassName) {
        return;
    }
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    [self safe_mb_swizzleMethodSrcClass:srcClass srcSel:srcSel tarClass:tarClass tarSel:tarSel];
}

+ (void)safe_mb_swizzleMethodSrcClass:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel{
    if (!srcClass) {
        return;
    }
    if (!srcSel) {
        return;
    }
    if (!tarClass) {
        return;
    }
    if (!tarSel) {
        return;
    }
    Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
    Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
    method_exchangeImplementations(srcMethod, tarMethod);
}

@end
```



##### 动态存储



---

noteboard (待理解事项)

- [ ] oc runtime - 宏
- [ ] oc runtime - 动态存储
- [ ] oc runtime - [nsnotification](http://cloverkim.com/ios_notification-principle.html)
- [ ] 多线程进阶：barrier group sophomore queue的种类



---

### 对象、属性、方法 

> reference：[Objective-C(一)-对象、属性、方法](https://www.jianshu.com/p/c326015be40b)

在OC中，数据的载体就是**实例变量**，我们可以通过**属性**便捷的访问到**实例变量**，**行为**其实就是对象的**方法**，也可以称为**发消息**，方法内部可以传递数据和操作数据。

**OC对象的本质其实就是指向某块内存地址的指针**





![img](https://upload-images.jianshu.io/upload_images/970120-1c80acb4d2b45d2d.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/690/format/webp)

一个实例对象通过class方法获取的Class就是它的isa指针指向的类对象，而类对象不是元类，类对象的isa指针指向的对象是元类。

Objective-c类本身也是对象，而运行时通过创建Meta类处理这一点。 当你发送一个消息，如[NSObject alloc]，你实际上是发送一个消息到类对象，该类对象需要是一个MetaClass的实例，它本身是根元类的实例。 而如果你说NSObject的子类，你的类指向NSObject作为它的超类。 然而，所有元类都指向根元类作为它们的超类。 所有的元类都只有它们响应的消息的方法列表的类方法。 所以当你发送消息到类对象，如[NSObject alloc]，然后objc_msgSend（）实际上通过元类查看它的响应，然后如果它找到一个方法，操作类对象。





[getter setter：](https://criptutorial.com/objective-c/example/5950/custom-getters-and-setters)

This can be useful to provide, for example, lazy initialization (by overriding the getter to set the initial value if it has not yet been set)







%@: objc object

%ld: 64位unsigned integer



confusing points：

objectType vs instanceType vs id?

`@dynamic`(即运行时Runtime)

block

Objective-C中public、protected、private的使用











一个由C/C++编译的程序占用的[内存](https://so.csdn.net/so/search?q=内存&spm=1001.2101.3001.7020)分为以下几个部分：

1、栈区（stack）— 由编译器自动分配释放 ，存放函数的参数值，局部变量的值等。其操作方式类似于数据结构中的栈。

2、堆区（heap） — 一般由程序员分配释放， 若程序员不释放，程序结束时可能由OS回收 。注意它与数据结构中的堆是两回事，分配方式倒是类似于链表。

3、全局区（静态区）（static）— [全局变量](https://so.csdn.net/so/search?q=全局变量&spm=1001.2101.3001.7020)和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域， 未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。程序结束后有系统释放

4、文字常量区 — 常量字符串就是放在这里的。 程序结束后由系统释放。

5、程序代码区 — 存放函数体的二进制代码。







[小括号内联复合表达式](https://blog.csdn.net/lijuan3203/article/details/51481538)

[Chapter 10. Error and exception handling - Objective-C Fundamentals](https://livebook.manning.com/book/objective-c-fundamentals/chapter-10/6)



---



##### 1. Modifier:

`__bridge` transfers a pointer between Objective-C and Core Foundation with no transfer of ownership.



##### 2. `FOUNDATION_EXPORT`, `UIKIT_EXTERN`

该宏的作用类似于`extern`，使用方法也与`extern`类似，在`.m`文件中，定义如下

```ini
    NSString *const kFoundationExportString = @"Hello World";
    
    NSString *const kExternString = @"Hello World";
```

然后在`.h`文件中加上以下声明， 就可以在导入该`.h`文件的类中访问该常量。

```objectivec
    FOUNDATION_EXPORT NSString *const kFoundationExportString;
    
    extern NSString *const kExternString;  
```

如果要在未导入该`.h`文件的类中访问这两个常量， 则应该将上面的代码放入该类的`.m`文件中。 `UIKIT_EXTERN`相比`extern`只是增加了兼容性，使用方法一样。

使用如下：

```ini
    NSString *str = @"Hello World";
    if (str == kConstantString) {
        NSLog(@"equal");
    }
```

使用`FOUNDATION_EXPORT`声明的字符串常量比较的是指针的地址， 而`#define`宏定义的常量字符串只能使用`isEqualToString`来比较， 前者更加高效。

##### 3. 头文件引用（#include,#import,@import,@class）

[reference](https://blog.csdn.net/huangfei711/article/details/76340383)

@import: 倒入framework 只有需要时才copy源码



##### 4. typedef NS_ENUM

```objc
/* NS_ENUM supports the use of one or two arguments. The first argument is always the integer type used for the values of the enum. The second argument is an optional type name for the macro. When specifying a type name, you must precede the macro with 'typedef' like so:

 

typedef NS_ENUM(NSInteger, NSComparisonResult) {

  ...

};

 

If you do not specify a type name, do not use 'typedef'. For example:

 

NS_ENUM(NSInteger) {

  ...

};

*/
```

##### 5. [Adopting Modern Objective-C](https://developer.apple.com/library/archive/releasenotes/ObjectiveC/ModernizationObjC/AdoptingModernObjective-C/AdoptingModernObjective-C.html)



6. 

Array string 的一些混用

```objc
2.删除URL中的某个参数：

- (NSString *)deleteParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl {

    NSString *finalStr = [NSString string];
    
    NSMutableString * mutStr = [NSMutableString stringWithString:originUrl];
    
    NSArray *strArray = [mutStr componentsSeparatedByString:parameter];
    
    NSMutableString *firstStr = [strArray objectAtIndex:0];
    
    NSMutableString *lastStr = [strArray lastObject];
    
    NSRange characterRange = [lastStr rangeOfString:@"&"];

    if (characterRange.location !=NSNotFound) { 
      //找不到时，location为最大值，length为null。NSNotFound = NSIntegerMax;

        NSArray *lastArray = [lastStr componentsSeparatedByString:@"&"];
        
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:lastArray];
        
        [mutArray removeObjectAtIndex:0];
        
        NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"];
        
        finalStr = [[strArray objectAtIndex:0]stringByAppendingString:modifiedStr];
        
    } else {
        
        //以'?'、'&'结尾
        finalStr = [firstStr substringToIndex:[firstStr length] -1];
        
    }

    return finalStr;
}
```

- [ ] [objcruntime常用宏](https://gitkong.github.io/2017/05/10/NSObjCRuntime.h%E4%B8%AD%E4%BD%A0%E4%B8%8D%E7%9F%A5%E9%81%93%E7%9A%84%E5%AE%8F/)

  objc_AssociationPolicy

  __has_include: 此宏传入一个你想引入文件的名称作为参数，如果该文件能够被引入则返回1，否则返回0。

  ```objc
  #if __has_include(<AFNetworking/AFNetworking.h>)
  #import <AFNetworking/AFNetworking.h>
  #else
  #import "AFNetworking.h"
  #endif
  ```

  

- [ ] NSPointerFunctionsOptions,  NSMapTable

  > An NSMapTable is modeled after a dictionary, although, because of its options, is not a dictionary because it will behave differently. The major option is to have keys and/or values held "weakly" in a manner that entries will be removed at some indefinite point after one of the objects is reclaimed. In addition to being held weakly, keys or values may be copied on input or may use pointer identity for equality and hashing.

- [ ] enum string 理解 字符串枚举，enum类名是一堆字符串的集合体，单独的case名代表的是字符串本身是吗

- [ ]  @autoreleasepool 使用理解

- [ ] [@weakify and @strongify macros](https://holko.pl/2015/05/31/weakify-strongify/)

- [ ] @synchronised(self){}

- [ ] if (options & SDWebImageDelayPlaceholder))  //位操作 

  ```objc
  typedef NS_OPTIONS(NSUInteger, SDWebImageOptions) {
  ...
  SDWebImageDelayPlaceholder = 1 << 8,
  ...
  }
  ```

  

- [ ] objc runtime `objc_getAssociatedObject(**self**, **@selector**(sd_imageProgress))`





#### NSInteger

`NSInteger` is not an Objective-C class. It's a typedef for an integral type. As such, an object is never going to be a NSInteger.

What you're looking for is the `NSNumber` class, which is an Objective-C class.

初始化integer 

Returning `nil` is an error here since you're returning an integer primitive, not an object. (You're getting a cast warning because `nil` is actually a `#define` that evaluates to `((void *)0)`, which is a null pointer, not an integer zero.) The best option for Objective-C code that interfaces with Cocoa is probably to use **`NSNotFound`**, a `#define` for `NSIntegerMax` which is used throughout Cocoa to signify that a given value does not exist in the receiver, etc. (Another option is to use `-1`, which is more common in C code. What works best depends on what the calling code expects and can handle.

---



[面试题](https://honkersk.github.io/2018/09/12/iOS%E9%9D%A2%E8%AF%95%E9%A2%984-Objective-C/)

[面试题2](https://juejin.cn/post/7065600617430908959)





---

算法



```objective-c
//
//  SortUtil.h
//  SortUtil
//
//  Created by Mac on 14-4-17.
//  Copyright (c) 2014年 KnightKing. All rights reserved.
//
 
#import <Foundation/Foundation.h>
 
@interface SortUtil : NSObject
 
//快速排序
+ (void)quickSort:(NSMutableArray *)array low:(int)low high:(int)high;
 
//冒泡排序
+ (void)buddleSort:(NSMutableArray *)array;
 
//选择排序
+ (void)selectSort:(NSMutableArray *)array;
 
//插入排序
+ (void)inserSort:(NSMutableArray *)array;
 
//打印数组
+ (void)printArray:(NSArray *)array;
 
@end
```



```objective-c
//
//  SortUtil.m
//  SortUtil
//
//  Created by Mac on 14-4-17.
//  Copyright (c) 2014年 KnightKing. All rights reserved.
//
 
#import "SortUtil.h"
 
@implementation SortUtil
 
#pragma - mark 快速排序
+ (void)quickSort:(NSMutableArray *)array low:(int)low high:(int)high
{
    if(array == nil || array.count == 0){
        return;
    }
    if (low >= high) {
        return;
    }
    
    //取中值
    int middle = low + (high - low)/2;
    NSNumber *prmt = array[middle];
    int i = low;
    int j = high;
    
    //开始排序，使得left<prmt 同时right>prmt
    while (i <= j) {
//        while ([array[i] compare:prmt] == NSOrderedAscending) {  该行与下一行作用相同
        while ([array[i] intValue] < [prmt intValue]) {
            i++;
        }
//        while ([array[j] compare:prmt] == NSOrderedDescending) { 该行与下一行作用相同
        while ([array[j] intValue] > [prmt intValue]) {
            j--;
        }
        
        if(i <= j){
            [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            i++;
            j--;
        }
        
        printf("排序中:");
        [self printArray:array];
    }
    
    if (low < j) {
        [self quickSort:array low:low high:j];
    }
    if (high > i) {
        [self quickSort:array low:i high:high];
    }
}
 
#pragma - mark 冒泡排序
+ (void)buddleSort:(NSMutableArray *)array
{
    if(array == nil || array.count == 0){
        return;
    }
    
    for (int i = 1; i < array.count; i++) {
        for (int j = 0; j < array.count - i; j++) {
            if ([array[j] compare:array[j+1]] == NSOrderedDescending) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
            
            printf("排序中:");
            [self printArray:array];
        }
    }
 
}
 
#pragma - mark 选择排序
+ (void)selectSort:(NSMutableArray *)array
{
    if(array == nil || array.count == 0){
        return;
    }
    
    int min_index;
    for (int i = 0; i < array.count; i++) {
        min_index = i;
        for (int j = i + 1; j<array.count; j++) {
            if ([array[j] compare:array[min_index]] == NSOrderedAscending) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:min_index];
            }
            
            printf("排序中:");
            [self printArray:array];
        }
    }
}
 
#pragma - mark 插入排序
+ (void)inserSort:(NSMutableArray *)array
{
    if(array == nil || array.count == 0){
        return;
    }
    
    for (int i = 0; i < array.count; i++) {
        NSNumber *temp = array[i];
        int j = i-1;
        
        while (j >= 0 && [array[j] compare:temp] == NSOrderedDescending) {
            [array replaceObjectAtIndex:j+1 withObject:array[j]];
            j--;
            
            printf("排序中:");
            [self printArray:array];
        }
        
        [array replaceObjectAtIndex:j+1 withObject:temp];
    }
}
 
+ (void)printArray:(NSArray *)array
{
    for(NSNumber *number in array) {
        printf("%d ",[number intValue]);
    }
    
    printf("\n");
}
 
@end
```

