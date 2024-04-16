# YYModel

[YYModel 学习探究](https://juejin.cn/post/6844903974030540814)

https://www.jianshu.com/p/fb33e6f4fe2e

[iOS高性能Model转换框架----YYModel学习](https://blog.csdn.net/Deft_MKJing/article/details/79800997)



## 理解Objective-C 运行时

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

4. 

   

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

## 框架



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/6/10/1729da8cfb7966c4~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)





![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/6/17/172c113b51afa1ed~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)







## 封装

### YYClassInfo文件

##### YYEncodingType

- 自定义的类型，是一种`NS_OPTIONS`
- 将类型，修饰符等信息整合在一个变量中，效率较高。总共用到了3个字节。由不同的mask来整合。
- `YYEncodingType YYEncodingGetType(const char *typeEncoding);` 这个全局函数用来将字符转化为自定义的类型
- [Type Encoding](https://link.jianshu.com?t=https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)
- [Declared Properties](https://link.jianshu.com?t=https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html)



##### YYClassIvarInfo

```objc
//YYClassIvarInfo 对objc_ivar封装对比

//YYClassIvarInfo 对象声明
@interface YYClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) YYEncodingType type;    ///< Ivar's type
- (instancetype)initWithIvar:(Ivar)ivar;
@end
  
//Runtime中objc_ivar的定义
struct objc_ivar {
    char * _Nullable ivar_name OBJC2_UNAVAILABLE; // 变量名称
    char * _Nullable ivar_type OBJC2_UNAVAILABLE; // 变量类型
    int ivar_offset OBJC2_UNAVAILABLE; // 变量偏移量
#ifdef __LP64__ // 如果已定义 __LP64__ 则表示正在构建 64 位目标
    int space OBJC2_UNAVAILABLE; // 变量空间
#endif
}

```

> 对应`Ivar`数据结构
>
> 构建方法也是从`Ivar`作为输入参数
>  `- (instancetype)initWithIvar:(Ivar)ivar;`
>
> 用到的系统API
>  `const char *ivar_getName(Ivar v);`
>  `const char *ivar_getTypeEncoding(Ivar v);`
>  `ptrdiff_t ivar_getOffset(Ivar v);`



##### YYClassMethodInfo

```objc
//YYClassMethodInfo对象声明：
@interface YYClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method; ///< 方法
@property (nonatomic, strong, readonly) NSString *name; ///< 方法名称
@property (nonatomic, assign, readonly) SEL sel; ///< 方法选择器
@property (nonatomic, assign, readonly) IMP imp; ///< 方法实现，指向实现方法函数的函数指针
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< 方法参数和返回类型编码
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding; ///< 返回值类型编码
@property (nullable, nonatomic, strong, readonly) NSArray<nsstring *> *argumentTypeEncodings; ///< 参数类型编码数组
- (instancetype)initWithMethod:(Method)method;
@end

//Runtime中objc_method的定义：
struct objc_method {
    SEL _Nonnull method_name OBJC2_UNAVAILABLE; // 方法名称
    char * _Nullable method_types OBJC2_UNAVAILABLE; // 方法类型
    IMP _Nonnull method_imp OBJC2_UNAVAILABLE; // 方法实现（函数指针）
}


@implementation YYClassMethodInfo
- (instancetype)initWithMethod:(Method)method {
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}
```

> 对应`Method`数据结构
>
> `- (instancetype)initWithMethod:(Method)method;`通过`Method`创建
>
> 用到的系统API
>  `SEL method_getName(Method m);`
>  `IMP method_getImplementation(Method m);`
>  `const char *method_getTypeEncoding(Method m);`
>  `char *method_copyReturnType(Method m);`
>  `unsigned int method_getNumberOfArguments(Method m);`
>  `char *method_copyArgumentType(Method m, unsigned int index);`



##### YYClassPropertyInfo

```objc
//YYClassPropertyInfo对象声明：
@interface YYClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< 属性
@property (nonatomic, strong, readonly) NSString *name; ///< 属性名称
@property (nonatomic, assign, readonly) YYEncodingType type; ///< 属性类型
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< 属性类型编码
@property (nonatomic, strong, readonly) NSString *ivarName; ///< 变量名称
@property (nullable, nonatomic, assign, readonly) Class cls; ///< 类型
@property (nullable, nonatomic, strong, readonly) NSArray<nsstring *> *protocols; ///< 属性相关协议
@property (nonatomic, assign, readonly) SEL getter; ///< getter 方法选择器
@property (nonatomic, assign, readonly) SEL setter; ///< setter 方法选择器
- (instancetype)initWithProperty:(objc_property_t)property;

//Runtime中property_t的定义：
struct property_t {
    const char *name; // 名称
    const char *attributes; // 修饰
};
```

> 对应`struct objc_property_t`数据结构
>
> ```
> - (instancetype)initWithProperty:(objc_property_t)property;
> ```
>
> 用到的系统API
>  `const char *property_getName(objc_property_t property) ;`
>  `objc_property_attribute_t *property_copyAttributeList(objc_property_t property, unsigned int *outCount);`
>  `SEL NSSelectorFromString(NSString *aSelectorName);`
>
> 如果是类，通过函数`Class objc_getClass(const char *name);`获取属性的类型信息
>
> getter和setter函数，如果没有，会生成默认的



##### YYClassInfo

```objc
//YYClassInfo对象声明：
@interface YYClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< 类
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< 超类
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< 元类
@property (nonatomic, readonly) BOOL isMeta; ///< 元类标识，自身是否为元类
@property (nonatomic, strong, readonly) NSString *name; ///< 类名称
@property (nullable, nonatomic, strong, readonly) YYClassInfo *superClassInfo; ///< 父类（超类）信息
@property (nullable, nonatomic, strong, readonly) NSDictionary<nsstring *, yyclassivarinfo *> *ivarInfos; ///< 变量信息
@property (nullable, nonatomic, strong, readonly) NSDictionary<nsstring *, yyclassmethodinfo *> *methodInfos; ///< 方法信息
@property (nullable, nonatomic, strong, readonly) NSDictionary<nsstring *, yyclasspropertyinfo *> *propertyInfos; ///< 属性信息
- (void)setNeedUpdate;
- (BOOL)needUpdate;
+ (nullable instancetype)classInfoWithClass:(Class)cls;
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;
@end
  
// objc.h
typedef struct objc_class *Class;
// runtime.h
struct objc_class {
    Class _Nonnull isa OBJC_ISA_AVAILABILITY; // isa 指针
#if !__OBJC2__
    Class _Nullable super_class OBJC2_UNAVAILABLE; // 父类（超类）指针
    const char * _Nonnull name OBJC2_UNAVAILABLE; // 类名
    long version OBJC2_UNAVAILABLE; // 版本
    long info OBJC2_UNAVAILABLE; // 信息
    long instance_size OBJC2_UNAVAILABLE; // 初始尺寸
    struct objc_ivar_list * _Nullable ivars OBJC2_UNAVAILABLE; // 变量列表
    struct objc_method_list * _Nullable * _Nullable methodLists OBJC2_UNAVAILABLE; // 方法列表
    struct objc_cache * _Nonnull cache OBJC2_UNAVAILABLE; // 缓存
    struct objc_protocol_list * _Nullable protocols OBJC2_UNAVAILABLE; // 协议列表
#endif
} OBJC2_UNAVAILABLE;
```

> - 对应`Class`数据结构
> - `+ (instancetype)classInfoWithClass:(Class)cls;`
> - (instancetype)classInfoWithClass:这里用了两个静态的字典来存储类信息。key是`Class`，value是`YYClassInfo`。考虑到类型嵌套，会有一大堆的类型信息需要保存。
>
> ```objectivec
> //这里用了Core Fountdation的字典。这两个字典是单例。
> static CFMutableDictionaryRef classCache;
> static CFMutableDictionaryRef metaCache;
> static dispatch_once_t onceToken;
> dispatch_once(&onceToken, ^{
>     classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
>     metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
>     lock = dispatch_semaphore_create(1);
> });
>    // 也用到了线程保护，使用的GCD
>     dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
>     YYClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
>     if (info && info->_needUpdate) {
>         [info _update];
>     }
>     dispatch_semaphore_signal(lock);
>     if (!info) {
>         info = [[YYClassInfo alloc] initWithClass:cls];
>         if (info) {
>             dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
>             CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
>             dispatch_semaphore_signal(lock);
>         }
>     }
> ```
>
> 用到的系统API
>  `Class class_getSuperclass(Class cls) ;`
>  `BOOL class_isMetaClass(Class cls);`
>  `Class objc_getMetaClass(const char *name);`
>  `const char *class_getName(Class cls);`
>  `NSString *NSStringFromClass(Class aClass);`
>  `Method *class_copyMethodList(Class cls, unsigned int *outCount);`
>  `objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount);`
>  `Ivar *class_copyIvarList(Class cls, unsigned int *outCount);`

#### NSObject+YYModel文件

##### _YYModelPropertyMeta

```objc
@interface _YYModelPropertyMeta : NSObject {
    @package
    NSString *_name;             ///< 属性名称
    YYEncodingType _type;        ///< 属性类型
    YYEncodingNSType _nsType;    ///< 属性在 Foundation 框架中的类型
    //是一个Foundation类型，还是一个C数值类型，或者是一个范型类型等
    BOOL _isCNumber;             ///< 是否为 CNumber
    Class _cls;                  ///< 属性类
    Class _genericCls;           ///< 属性包含的泛型类型，没有则为 nil
    SEL _getter;                 ///< getter
    SEL _setter;                 ///< setter
    BOOL _isKVCCompatible;       ///< 如果可以使用 KVC 则返回 YES
    BOOL _isStructAvailableForKeyedArchiver; ///< 如果可以使用 archiver/unarchiver 归/解档则返回 YES
    BOOL _hasCustomClassFromDictionary; ///< 类/泛型自定义类型，例如需要在数组中实现不同类型的转换需要用到
    /*
     property->key:       _mappedToKey:key     _mappedToKeyPath:nil            _mappedToKeyArray:nil
     property->keyPath:   _mappedToKey:keyPath _mappedToKeyPath:keyPath(array) _mappedToKeyArray:nil
     property->keys:      _mappedToKey:keys[0] _mappedToKeyPath:nil/keyPath    _mappedToKeyArray:keys(array)
     */
    NSString *_mappedToKey;      ///< 映射 key
    NSArray *_mappedToKeyPath;   ///< 映射 keyPath，如果没有映射到 keyPath 则返回 nil
    NSArray *_mappedToKeyArray;  ///< key 或者 keyPath 的数组，如果没有映射多个键的话则返回 nil
    YYClassPropertyInfo *_info;  ///< 属性信息，详见上文 YYClassPropertyInfo && property_t 章节
    _YYModelPropertyMeta *_next; ///< 如果有多个属性映射到同一个 key 则指向下一个模型属性元
}
@end
```

##### _YYModelMeta

```objc
@interface _YYModelMeta : NSObject {
    @package
    YYClassInfo *_classInfo;
    /// Key:被映射的 key 与 keyPath, Value:_YYModelPropertyMeta.
    NSDictionary *_mapper;
    /// Array<_YYModelPropertyMeta>, 当前模型的所有 _YYModelPropertyMeta 数组
    NSArray *_allPropertyMetas;
    /// Array<_YYModelPropertyMeta>, 被映射到 keyPath 的 _YYModelPropertyMeta 数组
    NSArray *_keyPathPropertyMetas;
    /// Array<_YYModelPropertyMeta>, 被映射到多个 key 的 _YYModelPropertyMeta 数组
    NSArray *_multiKeysPropertyMetas;
    /// 映射 key 与 keyPath 的数量，等同于 _mapper.count
    NSUInteger _keyMappedCount;
    /// 模型 class 类型
    YYEncodingNSType _nsType;
    ///作用：判断YYModel一系列协议方法是否实现
    BOOL _hasCustomWillTransformFromDictionary;//解析前是否需要更改字典
    BOOL _hasCustomTransformFromDictionary;//字典转模型后是否需要补充处理
    BOOL _hasCustomTransformToDictionary;//模型转字典后是否需要补充处理
    BOOL _hasCustomClassFromDictionary;//是否需要根据dic的内容转换为不同类型的模型
}
@end
```

> 遍历类所有的属性，直到根类
>
> ```objc
> // Create all property metas.
> NSMutableDictionary *allPropertyMetas = [NSMutableDictionary new];
> YYClassInfo *curClassInfo = classInfo;
> while (curClassInfo && curClassInfo.superCls != nil) { // recursive parse super class, but ignore root class (NSObject/NSProxy)
>     for (YYClassPropertyInfo *propertyInfo in curClassInfo.propertyInfos.allValues) {
>         if (!propertyInfo.name) continue;
>         if (blacklist && [blacklist containsObject:propertyInfo.name]) continue;
>         if (whitelist && ![whitelist containsObject:propertyInfo.name]) continue;
>         _YYModelPropertyMeta *meta = [_YYModelPropertyMeta metaWithClassInfo:classInfo
>                                                                 propertyInfo:propertyInfo
>                                                                      generic:genericMapper[propertyInfo.name]];
>         if (!meta || !meta->_name) continue;
>         if (!meta->_getter || !meta->_setter) continue;
>         if (allPropertyMetas[meta->_name]) continue;
>         allPropertyMetas[meta->_name] = meta;
>     }
>     curClassInfo = curClassInfo.superClassInfo;
> }
> if (allPropertyMetas.count) _allPropertyMetas = allPropertyMetas.allValues.copy;
> ```
>
> 
>
> 处理代理函数`modelPropertyBlacklist`---黑名单
>
> 处理代理函数`modelPropertyWhitelist`---白名单
>
> 处理代理函数`modelContainerPropertyGenericClass`---容器类型指定，支持class类型和字符串的类名
>
> 将类所有的属性转换为_YYModelPropertyMeta数组
>
> 处理代理函数`modelCustomPropertyMapper`---属性和JSON键名称的对应关系。这种对应关系支持.格式的链式关系和一对多的数组。保存在相应的`_YYModelPropertyMeta`成员中。
>
> 做标记，判断用户是否自定义了以下协议函数：
>  `modelCustomWillTransformFromDictionary`
>  `modelCustomTransformFromDictionary`
>  `modelCustomTransformToDictionary`
>  `modelCustomClassForDictionary`



##### ModelSetContext

```cpp
typedef struct {
    void *modelMeta;  ///< _YYModelMeta
    void *model;      ///< id (self)
    void *dictionary; ///< NSDictionary (json)
} ModelSetContext;
```

- 这是一个结构体
- 将类信息（_YYModelMeta），类（model），JSON（NSDictionary）等放在一起。
- model --- modelMeta --- dictionary；相互转化的两种结构通过一个中间过渡数据结构，整合在一起
- 类型都是void *，是C的指针



## 使用

#### JSON数据 转换为 model

json数据转model数据: `+ (nullable instancetype)yy_modelWithJSON:(id)json;`

NSDictionary数据转model数据:  `+ (nullable instancetype)yy_modelWithDictionary:(NSDictionary *)dictionary;`

```objc
LGModel *model = [LGModel yy_modelWithDictionary:dict];
```

json数据为model对象赋值: `- (BOOL)yy_modelSetWithJSON:(id)json;` （实例方法）

NSDictionary数据为model对象赋值: `- (BOOL)yy_modelSetWithDictionary:(NSDictionary *)dic;` （实例方法）

```objc
LGModel *model1 = [[LGModel alloc]init];
[model1 yy_modelSetWithDictionary:dict];
```



#### model数据转换为JSON数据

model转为json数据: `- (nullable id)yy_modelToJSONObject;`

model转为NSData: `- (nullable NSData *)yy_modelToJSONData;`

model转为json字符串:`- (nullable NSString *)yy_modelToJSONString;`



#### 其他方法

对象深拷贝 `- (nullable id)yy_modelCopy;`

对象数据持久化存储

- 存：`- (void)yy_modelEncodeWithCoder:(NSCoder *)aCoder;`
- 取：`- (id)yy_modelInitWithCoder:(NSCoder *)aDecoder;`

对象hash值 `- (NSUInteger)yy_modelHash;`

对象是否相等 `- (BOOL)yy_modelIsEqual:(id)model;`

对象描述 `- (NSString *)yy_modelDescription;`



#### 集合相应方法

`+ (nullable NSArray *)yy_modelArrayWithClass:(**Class**)cls json:(id)json;`

`+ (nullable NSDictionary *)yy_modelDictionaryWithClass:(**Class**)cls json:(id)json;`



#### 协议方法 --- 用来处理映射中的各种问题

1. Model 属性名和 JSON 中的 Key 不相同 `+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;`

```objc
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"messageId":@[@"id",@"ID",@"book_id"]};
}
```

你可以把一个或一组`json key (key path)`映射到一个或多个属性。如果一个属性没有映射关系，那默认会使用相同属性名作为映射。

在 json->model 的过程中：如果一个属性对应了多个json key，那么转换过程会按顺序查找，并使用第一个不为空的值。

在 model->json 的过程中：如果一个属性对应了多个 json key (key path)，那么转换过程仅会处理第一个 json key (key path)；如果多个属性对应了同一个 json key，则转换过过程会使用其中任意一个不为空的值。

2. 自定义容器中的实体类型映射 `+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;`

```objc
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass{
return @{@"books" : LGSubModel.class,
             @"infoDict" : [LGPerson class],
             @"likedUserIds" : @"NSNumber"
             };
}
//在实际使用过过程中，[LGPerson class]，LGPerson.class，@"LGPerson"没有明显的区别。
```

3. 根据dic来实例不同类的类型 `+ (nullable Class)modelCustomClassForDictionary:(NSDictionary *)dictionary;`

```objc
@implementation LGPerson
+(Class)modelCustomClassForDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"gender"] integerValue] == 1) {
        return LGMan.class;
    }
    return self;
}
@end
```

4. 黑名单（不处理的属性）`+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;`

5. 白名单（只处理的属性） `+ (nullable NSArray<NSString *> *)modelPropertyWhitelist;`

```objc
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+(NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"subject"];
}
// 如果实现了该方法，则处理过程中不会处理该列表外的属性
+ (NSArray<NSString *> *)modelPropertyWhitelist {
    return @[@"name",@"age",@"num"];
}
```

6. 解析前更改字典信息 `- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;`,发生在字典转模型之前，最后对网络字典做一次处理；

```objc
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic{
    if ([dic[@"gender"] integerValue] == 1) {
        return nil;//不接受男性
    }
    return dic;
}
```

7. 数据校验与自定义转换，字典转模型补充,`- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;`,YYModel无法处理或处理后格式类型等不正确，可以在这里重新赋值处理；

```objc
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
   NSNumber *interval = dic[@"timeInterval"];
    if (![interval isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    _createTime = [NSDate dateWithTimeIntervalSince1970:[interval floatValue]];
    return YES;
}
```

8. 数据校验与自定义转换，模型转字典补充，`- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;`，同样，转为json时一样有格式或类型不正确，可以在这里重新赋值处理；

```objc
// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!_createTime) {
        return NO;
    }
    dic[@"timeInterval"] = @([_createTime timeIntervalSince1970]) ;
    return YES;
}
```



## 相关知识点

###### 1. objc_msgSend

OC中，对象调用方法，也叫给对象发送消息，实际上是使用了动态绑定机制。在底层，所有方法都是普通的C语言函数，然而对象收到消息之后，究竟该调用哪个方法则完全于运行期决定，甚至可以在程序运行时改变，这些特性使得Objective-C成为一门真正的动态语言。
 通常我们在OC中这样发送消息：

```objectivec
id returnValue = [someObject messageName:parameter];
```

someObject是消息的接受者,messageName是一个选择器，parameter则为参数。选择器+参数 就是我们所称为的消息。
 在底层，编译器将我们的消息转换文标准的C函数形式，如下：

```objectivec
void objc_msgSend(id self,SEL cmd,…)
```

self 为消息接收者，cmd为选择器，省略号为参数，表示可变长度参数。
 因此，以上的消息转换为标准的C函数后如下：

```kotlin
id returnValue = objc_msgSend(someObject,@selector(messageName),paramter)
```

之所以objc_msgSend方法总能找到正确的函数去执行，原因如下：

其实每个类中都有一张方法列表去存储这个类中有的方法，当发出objc_msgSend
 方法时候，就会顺着列表去找这个方法是否存在，如果不存在，则向该类的父类继续查找，直到找到位置。如果始终没有找到方法，那么就会进入到消息转发机制（后续知识，以后章节会介绍） 。
 OC runtime还有一个机制在于方法缓存，每调用完这个方法后，一个方法映射就会被缓存起来，如果之后调用相同的方法，那么就能直接从映射表里确定方法的位置，而不用每次都需要查找，这样执行速度会快一点。



###### 2. CFDictionary ：意思是他是一套底层的API,拥有原始的数据类型,各种与Foundation无缝结合的全集



###### 3. __bridge

- 在ARC下，将Object-C指针转换为C指针
- [Object-C 指针 和 C 指针的相互转换 与ARC 并验证__bridge关键字的作用](https://link.jianshu.com?t=http://blog.csdn.net/ChSaDiN/article/details/38275303)



```objectivec
ModelSetContext context = {0};
context.modelMeta = (__bridge void *)(modelMeta);
context.model = (__bridge void *)(self);
context.dictionary = (__bridge void *)(dic);
```

> ModelSetContext是一个C的struct

