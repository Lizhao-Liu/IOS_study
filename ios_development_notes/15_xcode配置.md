

### iOS项目Project和Target配置详解

[配置详解](http://www.liugangqiang.com/2018/03/22/iOS%E9%A1%B9%E7%9B%AEProject%E5%92%8CTarget%E9%85%8D%E7%BD%AE%E8%AF%A6%E8%A7%A3/)

[参考官方文档](https://developer.apple.com/library/content/featuredarticles/XcodeConcepts/Concept-Projects.html#//apple_ref/doc/uid/TP40009328-CH5-SW1)



#### 名词解释

###### [Project](https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Projects.html#//apple_ref/doc/uid/TP40009328-CH5-SW1)

一个 project 是构建一个或多个软件产品所需的所有文件、资源、信息/配置的存储库（repository）。

一个 project 包含所有用于构建产品（build your products）的元素，并维护这些元素之间的关系。

它可以包含一个或多个 Targets。一个project 为所有的 targets 定义默认的 build setting（每一个 target 可以自定义它们的 build setting，这些自定义的 setting会覆盖 project 默认的 build setting）。

An Xcode project file contains the following information:

1. References to source files

2. Groups used to organize the source files in the structure navigator

3. Project-level build configurations

4. Targets

5. The executable environments that can be used to debug or test the program

You use Xcode schemes to specify which target, build configuration, and executable configuration is active at a given time.

###### [Target](https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Targets.html#//apple_ref/doc/uid/TP40009328-CH4-SW1)

一个 target 确定一个产品（product）的构建，包括一些指令（instructions）——怎么从一个 project 或者 workspace 的一堆文件导出一个产品。

构建一个 product 的 instructions （指令）的表现形式是 build settings 和 build phases，可以在 Xcode project editor 中检查和编辑。一个 target 的 build settings 继承 project 的 build settings，但是可以重写覆盖 project settings。同一时间里只有一个 active target ，由 Xcode Scheme 指定。

There can be only one active target at a time; the Xcode scheme specifies the active target.

explicit target dependencies vs implicit dependency

###### [Build Settings](https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Build_Settings.html#//apple_ref/doc/uid/TP40009328-CH6-SW1)

Each target organizes the source files needed to build one product. A build configuration specifies a set of build settings used to build a target's product in a particular way.

###### [Xcode Scheme](https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Schemes.html#//apple_ref/doc/uid/TP40009328-CH8-SW1)

一个 Xcode Scheme（方案）定义三样东西：一个要生成的目标（targets to build）的集合、building 时使用的配置（configuration）、以及要执行的测试集合。

你可以拥有任意数量的 scheme，但一次只能有一个是活跃状态（active），你可以指定 scheme 是否储存在 project 中（这种方案下，scheme 在每一个包含这个 project 的 workspace 中都可用），或者储存在 workspace 中（仅在当前 workspace 中可用）。选择要激活的 scheme 时，可以选择运行目标（设备）



#### Project 和 Target 的属性设置

##### Info

###### Deployment  Target

主要是本 project 生成的 APP 的可运行的最低版本进行配置

###### Configurations

用来配置 iOS 项目的`xcconfig`文件, 主要用于在几套不同的开发环境编译

`xcconfig`文件其实就是 Xcode 里的`config`文件，本质是一个用来保存`Build Settings`键值对的**纯文本文件**。这些键值对会覆盖`Build Settings`中的值，所以当在`xcconfig`文件中配置了的选项，在`Build Settings`中设置将失效。

Cocoapods 的项目配置管理很多都是依赖`xcconfig`文件去实现的

###### Localizations

本地化，这里的功能主要是添加我们的App所支持的语言



##### Build Settings (同target)

**优先级顺序：带 Target 图标列 >> 带 Project 图标列 >> iOS Default 列**。（如果安装pod，新产生的一列优先级介于带 Target 图标列和带 Project 图标列之间）



###### Debug Information Format

这个选项决定了记录debug信息的文件格式。选项有DWARF with dSYM File和DWARF。建议选择DWARF with dSYM File。DWARF是较老的文件格式，会在编译时将debug信息写在执行文件中。



###### Validate Built Product

这个选项决定了是否在编译的时候进行验证。验证的内容和app store的审查内容一致。默认选项是debug时不验证，release时验证，这样就保证了每个release版本都会通过validate，让被拒的风险在提交app store之前就暴露出来，减少损失。



###### Build Active Architecture Only

如果此项为YES，则在Xcode会根据设备的版本只将相应的Architecture编译入app。如连接了iPhone4进行编译，Build Active Architecture Only为YES，则编译时只会构建Armv7的二进制文件。若连接的是iPhone5，则构建出Armv7s的二进制文件。



##### General



##### Signing & Capability

我们也可以在info.plist添加一些权限或性能开关之后，在target的capabilities中也会进行相应的修改的

签名，进行证书管理在真机调试或者打包时都需要进行签名进行认证才可以。

- Automatically manage signing：Xcode 8推出的自动签名功能，可以直接使用 Xcode 把 App 打包到真机上去测试，[具体使用参考](https://blog.csdn.net/java3182/article/details/78885145)。
- Team：开发团队，即开放者账号名称。
- Provisioning Profile：提供的配置文件。
- Signing Certificate：签名证书



##### 例外域

如果您的 app 仍然需要与特定域进行不安全连接，您可以只针对这些域配置 ATS 例外。

- 点按“+”图标，添加您的 app 需要通过不安全方式连接的域。 在此处输入域，以便通过 HTTP 连接到该域及其子域。如果您需要修改这些设置，可直接在 Info.plist 中进行更改。
- 如果您的 app 需要通过 WKWebView 进行不安全连接，请将“Allows Arbitrary Loads In Web Content”添加到 Info.plist：





##### Info

###### URL Types

URL类型，用来定义URL以便让应用程序理解应用间交换的数据结构。可用于：IOS唤醒其他程序，程序间相互调用。例如：在 URLTypes 中 URLSchemes 中注册 AAPP；在B程序中，openUrl:[NSURL urlWithString:@”AAPP:”]；注意”:”冒号,没有冒号是不能成唤醒另一个程序的。其次如果参数中有“&”特殊字符穿，建议对参数进行 base64 转换。



##### Build phases

###### Target Dependencies

Target 对象依赖阶段：某些 target 可能依赖某个 target 输出的值，这里设置依赖。依赖于其他 target 的输出的时候，在编译时系统会自动先编译被依赖的 target，得到输出值，再编译当前 target。对象依赖阶段可以让 Xcode 知道必须在当前选择的对象编译之前先编译的其它依赖对象（比如应用扩展、插件等等）。如单元测试 target，依赖于 App target，所以必须等 App target 编译完成之后再进行编译



###### Compile Sources

源文件阶段：是指将有哪些源代码被编译，可以通过对应的【+】【-】按钮进行添加或删除资源来控制编译的代码文件。并且可以通过修改此阶段的 Compiler Flags（编译器标识）来为每个单独文件设置其编译器标示，比如设置是否支持ARC。



###### Link Binary With Libraries

链接二进制库阶段：是指编译过程中会引用哪些库文件，我们同样可以通过【+】【-】按钮进行添加或删除编译所引用的库文件。



###### Copy Bundle Resources

拷贝 Bundle 资源阶段：是指生成的 product 的 .app 内将包含哪些资源文件，同样可以通过红框中的【+】【-】按钮进行添加或删除资源来控制编译的资源文件。该阶段定义了对象中的资源文件，包括应用程序、图标、storyboard、视频、模板等等。这些资源都会被复制到安装包的 Contents／Resources 文件夹下。



---

名词

- Nib 文件： 在 OS X 和 iOS 创建应用程序中起着重要的作用。使用 nib 文件，您可以使用 Xcode 以图形方式创建和操作用户界面（而不是以编程方式）