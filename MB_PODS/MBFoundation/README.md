# 接入

使用  `pod "MBFoundation"` 接入

代码中使用  `@import MBFoundation` 接入即可。

## 配置 Util
MBFoundationExceptionUtil

用于对接 Safe Extension 抛出的错误，可以在对接时候记录，上传等。


## 注意
### Safe Extension
方法中有一些 hook 数组，字典空值越界崩溃的操作。。
1. 在 Debug 会抛出 OC 错误，帮助开发纠正
2. 会通过 MBFoundationExceptionUtil 吐出结果给上层



# 文档和简单说明

## Algorithm
新的加解密算法，**未使用，使用前请先测试**

## Collection
线程安全的数组，字典，Set

## ContactsKit
只在 Bridge 使用了 isAuthorized，**其他未使用，使用前请先测试**

## CoreTelephonyKit
MBCoreTelephony
使用 iOS10 废弃的api，需要迁移

## Extensions
Swift基础类型拓展

## Global
一些 AppInfo，GlobalDefines，MBNotificationsKey，MBSingletonDefine 信息

## HTMLParser
解析HTMl

## ManagerCenter

依靠 MBManagerProtocol 通知相应的类进入某些状态。

**需要通过 GET_MANAGER 初始化，在初始化同时被管理**

public protocol MBManagerProtocol {
    // 是否退出登录后也需要常驻内存，默认是NO
    @objc optional func isManagerPersistent() -> Bool
    // Manager初始化时调用
    @objc optional func onManagerInit()
    // 重新登录时会调用
    @objc optional func onManagerReloadData()
    // 进入后台运行
    @objc optional func onManagerEnterBackground()
    // 进入前台运行
    @objc optional func onManagerEnterForeground()
    // 程序退出
    @objc optional func onManagerTerminate()
    // 内存警告
    @objc optional func onManagerMemoryWarning()
    // 退出登录时调用，用于清理和释放资源
    @objc optional func onManagerClearData()
}

## OpenUDID
OpenUDID 依靠剪切板存储程序唯一ID，即将下掉。

static > UserDefault > UIPasteboard

## Protocols
NibLoadable 支持load nib
Example：ServiceEvaluateViewContent.load(in: Bundle.imCenter)

Reusable 支持table重用一些语法糖

Then 语法糖

## SafeExtensions
空值越界扩展，防止崩溃，且上报 hubble

## SwiftyJSON
Swift的 Json 解析。

## ToolKit
从 ToolKit 迁移过来的一些方法

### MBIdleTimerManager
屏幕常亮功能，使用Set count决定是否亮，
map，ect，cargo 有在使用

### NSObject+MBExtends
- 页面埋点协议 未使用
- 控件埋点协议 未使用
- NSObject (MBJournal) 一些方便的NSObject扩展 如下
```
+ (BOOL)ymm_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_;
+ (BOOL)ymm_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_;
- (BOOL)isKindOfClazz:(Class)aClass;
- (id)glt_performSelector:(SEL)selector
               withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION;
+ (NSArray *)ymm_allPropertyKeys:(BOOL)includeSuper;
+ (Class)ymm_classForPropertyName:(NSString *)propertyName;
```
### MBToolKitBundle - Private 可以优化
取 bundle

### Tools
MBDateFormatterManager 日历控件，使用 gregorian 公历
MBNetworkInfoProvider 卡信息，手机信息，连接信息
MBPluginInfos 组件信息
MBToolsManager setupWithCompany(_ isHCB: Bool)

### Util
MBAppUtil app type
MBCountDownManager timer 其中发了一个推送？？？没用到？？
MBFileUtil 文件增删改查
MBIdentifyUtil 取一个临时UUID，不建议使用
MBImageUtil metadata信息
MBJsonUtil dic/arr <-> json
MBSafeWeakTimer Timer不强持有target
MBThreadsSafeMutableArray 如名
MBThreadsSafeMutableDictionary 如名
MBTypeCheckUtil 有效数据检查
MBUITool 屏幕，模拟器，安全区域
YMMUIToolDefine 宏定义

## Util
MBFoundationExceptionUtil

对外接口，用于初始化等设置。
