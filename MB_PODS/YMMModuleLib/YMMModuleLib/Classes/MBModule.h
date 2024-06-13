//
//  MBModule.h
//  YMMModuleLib
//
//  Created by Xiaohui on 2020/3/3.
//

#import <Foundation/Foundation.h>
#import "MBContext.h"
#import "MBModuleHandler.h"
@import YMMRouterLib;
NS_ASSUME_NONNULL_BEGIN

///导出模块类， 需要用于替代@implementation
///@param module_class - 模块实现类名称
#define moduleEX($module_class) \
class NSObject; \
char * k_module_##$module_class \
__attribute((used, section("__DATA, YMMModules"))) = ""#$module_class""; \
@implementation $module_class \
+ (MBModuleContext *)getContext { \
return [MBModule contextOf:[$module_class class]]; \
}

@protocol YMMModuleProtocol;

/// 生命周期相关拦截
@protocol MBInterceptDelegate <NSObject>
/// 生命周期方法将要被执行
/// @param function 声明周期方法名称
/// @param module 声明周期方法所属模块
/// @return 后续是否执行生命周期方法，返回YES执行，NO不执行
- (BOOL)functionShouldInvoke:(NSString *)function module:(id<YMMModuleProtocol>)module;
/// 生命周期方法被执行
/// @param function 声明周期方法名称
/// @param module 声明周期方法所属模块
- (void)functionDidInvoke:(NSString *)function module:(id<YMMModuleProtocol>)module;

@end

/// 事件编号
typedef NS_ENUM(NSInteger, MBModuleEventType) {
    MBModuleDidSetup = 997,            // 模块初始化
    MBModuleDidAgreePrivacy = 998,     // 同意隐私协议
    MBModuleDidMainPageAppear = 999,   // 首页加载完成
    MBModuleDidCustomEvent = 1000,
    MBModuleEventDidLogin = 1001,      // 用户登录完成
    MBModuleEventDidLogout = 1002      // 用户退登完成
};

/// 事件类型
typedef NS_ENUM(NSInteger, MBModuleEventCategory) {
    MBModuleEventCategoryCommon, // 普通事件，在事件发送之前注册的Observer才能接收到
    MBModuleEventCategorySticky  // 粘滞事件，在事件发送后注册的Observer在注册时会接收到事件
};

/// 模块事件模型
@interface MBModuleEvent : NSObject


/// 事件编号
@property (nonatomic, assign) MBModuleEventType eventType;


/// 事件类型
@property (nonatomic, assign) MBModuleEventCategory eventCategory;


/// 针对一组互斥事件的标记
@property (nonatomic, copy) NSString *groupIdentity;


/// 事件目标接收对象
@property (nonatomic, strong) id<YMMModuleProtocol> targetModule;


/// 事件自定义参数
@property (nonatomic, copy) NSDictionary *customParams;

@end

@interface MBModuleEventObserver : NSObject

@property (nonatomic, strong) id<YMMModuleProtocol> observerModule;

@property (nonatomic, copy) NSString *eventSelectorStr;

@end


/// 事件上下文
@interface MBModuleEventContext : NSObject <NSCopying>

// customEvent的取值需要大于1000
@property(nonatomic, assign) NSInteger customEvent;

@property(nonatomic, copy) NSDictionary *customParam;

+ (instancetype)shareInstance;

@end

@protocol MBModuleEventDelegate <NSObject>

@optional


/// 模块初始化，用于替换load方法，注册router、bridge等
- (void)moduleDidSetup;


/// 首页DidAppear事件回调
/// @param context 事件上下文
- (void)moduleDidMainPageAppearEvent:(MBModuleEventContext *)context;


/// 同意隐私协议回调
/// @param context 事件上下文
- (void)moduleDidAgreePrivacyEvent:(MBModuleEventContext *)context;


/// 模块自定义事件
/// @param context 事件上下文
- (void)moduleDidCustomEvent:(MBModuleEventContext *)context;

@end

/// App生命周期协议
@protocol MBLifecycleDelegate <NSObject, UIApplicationDelegate, MBModuleEventDelegate>

@end

/// 模块协议
@protocol YMMModuleProtocol <NSObject, MBLifecycleDelegate>

///业务模块名称，需要在业务模块白名单中
+ (NSString *)moduleName;

@optional
/// 子模块名称，在需要区分模块中子模块时使用
+ (NSString *)subModuleName;

/// 包名，不实现此方法，默认取所在bundle的Bundle Identifier
+ (NSString *)bundleName;

/// 包类型，不实现此方法，默认为native
+ (NSString *)bundleType;

/// 包版本，不实现此方法，默认取所在bundle的CFBundleShortVersionString
+ (NSString *)bundleVersion;

///定义模块优先级，值越大优先级越高
///缺省值MODULE_PRIORITY_DEFAULT  1000
+ (NSUInteger)priority;

///支持的路由列表
- (NSArray<YMMRouter *> *)routers;

@required
///模块上下文，在通过@moduleEX模块导出时会默认添加该方法
+ (MBModuleContext *)getContext;


@end

/// 模块管理类
@interface MBModule : NSObject

/// 每一个生命周期函数之前的调用
@property (nonatomic, strong) id<MBLifecycleDelegate> beforeLifecycle;
/// 每一个生命周期函数之后的调用
@property (nonatomic, strong) id<MBLifecycleDelegate> afterLifecycle;
/// 每一个生命周期函数时的拦截
@property (nonatomic, strong) id<MBInterceptDelegate> intercept;

+ (instancetype)shared;
 
/// 模块管理设置
- (void)setup;


/// 设置模块白名单，用于检查模块名是否合法
/// @param whiteList 白名单
- (void)setModuleWhiteList:(NSArray<NSString *> *)whiteList;


/// 校验上下文，主要判断模型名是否在白名单中
/// @param context 上下文对象
- (BOOL)validateContext:(id<MBContextProtocol>)context;

/// 设置Handler,负责抛出日志和一些事件
/// @param handler handler对象，多次调用会被覆盖
- (void)setHandler:(id<MBModuleHandler>)handler;


/// 获取所有注册的模块
- (NSArray<id<YMMModuleProtocol>> *)getAllModules;

///注册模块类
///@param module 注册模块类名
- (void)registerModule:(NSString *)module;

///通过名称查找上下文
///@param moduleClass 模块类
///@return MBModuleContext
+ (MBModuleContext *)contextOf:(Class)moduleClass;



/// 触发模块预置事件，同步执行，需要在主线程中触发
/// @param eventType 预置事件类型
- (void)triggerEvent:(NSInteger)eventType;


/// 触发模块预置事件，同步执行，需要在主线程中触发
/// @param eventType 预置事件类型
/// @param customParam 预置事件参数
- (void)triggerEvent:(NSInteger)eventType withCustomParam:(NSDictionary * _Nullable)customParam;


/// 注册自定义事件
/// @param eventType 自定义事件类型
/// @param moduleInstance 模块实例对象
/// @param selector 执行事件的selector
- (void)registerCustomEvent:(NSInteger)eventType
         withModuleInstance:(id)moduleInstance
             andSelector:(SEL)selector;

/// 触发自定义事件，异步执行，在主队列中触发
/// @param event 事件对象
- (void)triggerModuleEvent:(MBModuleEvent *)event;

#pragma mark - 生命周期相关方法
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationWillResignActive:(UIApplication *)application;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0);

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;

- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings;

- (void)application:(UIApplication*)application
performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem
  completionHandler:(void (^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0);

- (void)application:(UIApplication*)application
  handleEventsForBackgroundURLSession:(nonnull NSString*)identifier
  completionHandler:(nonnull void (^)(void))completionHandler;

- (void)application:(UIApplication*)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end

NS_ASSUME_NONNULL_END
