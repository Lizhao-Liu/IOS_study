//
//  MBModule.m
//  YMMModuleLib
//
//  Created by Xiaohui on 2018/6/12.
//

#import "MBModule.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBContext.h"
#import "MBModuleInfo.h"
#import "MBModuleLogger.h"
#import "YMMModuleLib-Swift.h"
@import MBBuildPreLib;

static NSString *kModuleDidSetupSelector = @"moduleDidSetup";
static NSString *kModuleMainPageAppearSelector = @"moduleDidMainPageAppearEvent:";
static NSString *kModuleAgreePrivacySelector = @"moduleDidAgreePrivacyEvent:";
static NSString *kModuleCostomEventSelector = @"moduleDidCustomEvent:";

@implementation MBModuleEventContext

+ (instancetype)shareInstance {
    static MBModuleEventContext *eventContextInstance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        eventContextInstance = [[[self class] alloc] init];
    });
    return eventContextInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    MBModuleEventContext *context = [[self.class allocWithZone:zone] init];
    context.customEvent = self.customEvent;
    context.customParam = self.customParam;
    return context;
}

@end

@implementation MBModuleEvent

- (instancetype)init {
    if (self = [super init]) {
        _eventCategory = MBModuleEventCategoryCommon;
    }
    return self;
}

@end

@implementation MBModuleEventObserver

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (object && [object isMemberOfClass:[self class]]) {
        MBModuleEventObserver *aObserver = object;
        BOOL ret = YES;
        ret = ret && [self.observerModule isEqual:aObserver.observerModule];
        ret = ret && [self.eventSelectorStr isEqualToString: aObserver.eventSelectorStr];
        return ret;
    }
    return NO;
}

@end

#pragma mark - 模块管理类
@interface MBModule() {
    NSMutableArray<id<YMMModuleProtocol>> *_moduleObjectArray;
    NSMutableArray<MBModuleContext *> *_moduleContextArray;
    BOOL _isSetup;
    NSArray<NSString *> *_moduleWhiteList;
}


/// 模块预置生命周期事件，事件类型与回调selector映射字典
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *mbSelectorByEvent;
/// 模块预置生命周期事件，事件类型与模块实例映射字典
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<id<YMMModuleProtocol>> *> *mbModulesByEvent;


/// 自定义事件，事件类型与事件对象映射字典
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<MBModuleEvent *> *> *mbStickyEventDict;

/// 自定义事件，事件group与事件类型映射字典
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSNumber *> *> *mbStickyEventGroupDict;

/// 自定义事件，事件类型与事件观察者映射字典
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<MBModuleEventObserver *> *> *mbObserversByEvent;

@end

@implementation MBModule

+ (instancetype)shared {
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MBModule alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _isSetup = NO;
        _moduleContextArray = [[NSMutableArray alloc] init];
        _moduleObjectArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setup {
    if (_isSetup) {
        return;
    }
    _isSetup = YES;
    for (MBModuleContext *context in _moduleContextArray) {
        if ([context getModuleInfo].moduleClass && class_conformsToProtocol([context getModuleInfo].moduleClass, @protocol(YMMModuleProtocol))) {
            id<YMMModuleProtocol> moduleObject = [[[context getModuleInfo].moduleClass alloc] init];
            [_moduleObjectArray addObject:moduleObject];
            [self registerRouter:moduleObject];
        }
    }
    [self registerAllCommonEvents];
    [self triggerEvent:MBModuleDidSetup];
}

- (void)setHandler:(id<MBModuleHandler>)handler {
    [[MBModuleLogger shared] startLogHandler:handler];
}

- (NSArray<id<YMMModuleProtocol>> *)getAllModules {
    if (!_isSetup) {
        return nil;
    }
    return _moduleObjectArray.copy;
}

- (void)setModuleWhiteList:(NSArray<NSString *> *)whiteList {
    _moduleWhiteList = whiteList.copy;
    if (![MBFMacro ymm_buildRelease]) {
        [self checkAllRegisteredModuleValid];
    }
}

- (BOOL)validateContext:(id<MBContextProtocol>)context {
    BOOL isValid = NO;
    NSString *errorMsg = nil;
    if (!context) {
        isValid = YES;
//        errorMsg = @"context can't be nil when call service";
    } else if (![context respondsToSelector:@selector(getModuleInfo)]) {
        isValid = NO;
        errorMsg = [NSString stringWithFormat:@"context doesn't implement getModuleInfo method when call service, context class name is %@", NSStringFromClass(context.class)];
    } else {
        MBModuleInfo *moduleInfo = [context getModuleInfo];
        isValid = [self checkModuleNameValid:moduleInfo.moduleName withClassName:moduleInfo.moduleClassName];
        if (!isValid) {
            errorMsg = [NSString stringWithFormat:@"context is invalid when call service, context class name is %@, module name is %@", NSStringFromClass(context.class), moduleInfo.moduleName];
        }
    }
    if(!isValid){
        [MBModuleLogger errorLog:errorMsg extra:nil];
    }
    return isValid;
}

- (BOOL)validateModuleInfo:(MBModuleInfo *)moduleInfo {
    if (!moduleInfo || moduleInfo.moduleName || moduleInfo.moduleName.length == 0) {
        return NO;
    }
    return [self checkModuleNameValid:moduleInfo.moduleName withClassName:moduleInfo.moduleClassName];
}

#pragma mark - router

- (void)registerRouter:(id<YMMModuleProtocol>)module {
    if ([module respondsToSelector:@selector(routers)]) {
        [[YMMRouterCenter shared] addRouters:[module routers]];
    }
}


#pragma mark - module

//注册模块
- (void)registerModule:(NSString *)module {
    NSAssert(NSClassFromString(module) && class_conformsToProtocol(NSClassFromString(module), @protocol(YMMModuleProtocol)), @"%@ need implement YMMModuleProtocol!", module);
    if (!NSClassFromString(module) || !class_conformsToProtocol(NSClassFromString(module), @protocol(YMMModuleProtocol))) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@ doesn't implement module protocol", module] extra:nil];
    }
    MBModuleContext * moduleContext = [[MBModuleContext alloc] initWithClassName:module];
    MBModuleInfo *info = [moduleContext getModuleInfo];
    if (![MBFMacro ymm_buildRelease]) {
        BOOL isValid = [self checkModuleNameValid:module withClassName:info.moduleName];
        if (!isValid) {
            [MBModuleLogger errorLog:[NSString stringWithFormat:@"module name %@ of class %@ is invalid", info.moduleName, module] extra:nil];
        }
    }
    NSInteger index = 0;
    for (MBModuleContext *context in _moduleContextArray) {
        if (info.priority >= [context getModuleInfo].priority) {
            break;
        }
        index++;
    }
    [_moduleContextArray insertObject:moduleContext atIndex:index];
}

#pragma mark - event

- (void)registerCustomEvent:(NSInteger)eventType withModuleInstance:(id)moduleInstance andSelector:(SEL)selector {
    NSParameterAssert(eventType > 1000);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (eventType <= 1000) {
            return;
        }
        if (!selector || ![moduleInstance respondsToSelector:selector]) {
            return;
        }
        NSString *selectorStr = NSStringFromSelector(selector);
        NSNumber *eventTypeNumber = @(eventType);
        if (!self.mbObserversByEvent[eventTypeNumber]) {
            [self.mbObserversByEvent setObject:@[].mutableCopy forKey:eventTypeNumber];
        }
        NSMutableArray<MBModuleEventObserver *> *eventModules = [self.mbObserversByEvent objectForKey:eventTypeNumber];
        MBModuleEventObserver *registerModuleObserver = [[MBModuleEventObserver alloc]init];
        registerModuleObserver.observerModule = moduleInstance;
        registerModuleObserver.eventSelectorStr = selectorStr;
        if (![eventModules containsObject:registerModuleObserver]) {
            [eventModules addObject:registerModuleObserver];
            [eventModules sortUsingComparator:^NSComparisonResult(MBModuleEventObserver *moduleObserver1, MBModuleEventObserver *moduleObserver2) {
                NSInteger module1Priority = 0;
                NSInteger module2Priority = 0;
                if ([moduleObserver1.observerModule respondsToSelector:@selector(priority)]) {
                    module1Priority = [moduleObserver1.observerModule priority];
                }
                if ([moduleObserver2.observerModule respondsToSelector:@selector(priority)]) {
                    module2Priority = [moduleObserver2.observerModule priority];
                }
                return module1Priority < module2Priority;
            }];
        }
        if (self.mbStickyEventDict && self.mbStickyEventDict.count > 0) {
            NSArray<MBModuleEvent *> *stickyEventArray = [self.mbStickyEventDict objectForKey:@(eventType)];
            if (stickyEventArray && stickyEventArray.count > 0) {
                for (MBModuleEvent *event in stickyEventArray) {
                    if (!event.targetModule || event.targetModule == moduleInstance) {
                        [self handleCustomModuleEvent:event.eventType forTarget:moduleInstance withSeletorStr:selectorStr andCustomParam:event.customParams];
                    }
                }
            }
        }
    });
}

- (void)registerEvent:(NSInteger)eventType
   withModuleInstance:(id)moduleInstance
          andSelector:(SEL)selector {
    NSParameterAssert(eventType <= 1000);
    if (eventType > 1000) {
        return;
    }
    if (!selector || ![moduleInstance respondsToSelector:selector]) {
        return;
    }
    NSString *selectorStr = NSStringFromSelector(selector);
    NSNumber *eventTypeNumber = @(eventType);
    if (!self.mbSelectorByEvent[eventTypeNumber]) {
        [self.mbSelectorByEvent setObject:selectorStr forKey:eventTypeNumber];
    }
    if (!self.mbModulesByEvent[eventTypeNumber]) {
        [self.mbModulesByEvent setObject:@[].mutableCopy forKey:eventTypeNumber];
    }
    NSMutableArray *eventModules = [self.mbModulesByEvent objectForKey:eventTypeNumber];
    if (![eventModules containsObject:moduleInstance]) {
        [eventModules addObject:moduleInstance];
        [eventModules sortUsingComparator:^NSComparisonResult(id<YMMModuleProtocol> moduleInstance1, id<YMMModuleProtocol> moduleInstance2) {
            NSInteger module1Priority = 0;
            NSInteger module2Priority = 0;
            if ([moduleInstance1 respondsToSelector:@selector(priority)]) {
                module1Priority = [moduleInstance1 priority];
            }
            if ([moduleInstance2 respondsToSelector:@selector(priority)]) {
                module2Priority = [moduleInstance2 priority];
            }
            return module1Priority < module2Priority;
        }];
    }
}

- (void)triggerEvent:(NSInteger)eventType {
    [self triggerEvent:eventType withCustomParam:nil];
}

- (void)triggerEvent:(NSInteger)eventType withCustomParam:(NSDictionary *)customParam {
    [self handleModuleEvent:eventType forTarget:nil withCustomParam:customParam];
}

- (void)triggerModuleEvent:(MBModuleEvent *)event {
    if (!event) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBModuleLogger infoLog:[NSString stringWithFormat:@"receive module eventType: %ld, eventCategory: %ld", event.eventType, event.eventCategory] extra:nil];
        if (event.eventCategory == MBModuleEventCategorySticky) {
            NSMutableArray *eventRecords = [self.mbStickyEventDict objectForKey:@(event.eventType)];
            // 清空互斥的缓存事件
            NSString *groupIdentity = event.groupIdentity;
            if (groupIdentity && groupIdentity.length > 0) {
                NSMutableArray<NSNumber *> *sameGroupEventTypes =  [self.mbStickyEventGroupDict objectForKey:groupIdentity];
                if (sameGroupEventTypes && sameGroupEventTypes.count > 0) {
                    for(NSNumber *eventTypeNum in sameGroupEventTypes) {
                        [self.mbStickyEventDict removeObjectForKey:eventTypeNum];
                    }
                } else {
                    sameGroupEventTypes = [NSMutableArray new];
                }
                [sameGroupEventTypes addObject:@(event.eventType)];
                [self.mbStickyEventGroupDict setObject:sameGroupEventTypes forKey:groupIdentity];
            }
            if (!eventRecords) {
                eventRecords = [NSMutableArray new];
            }
            [eventRecords addObject:event];
            [self.mbStickyEventDict setObject:eventRecords forKey:@(event.eventType)];
        }
        [self handleModuleEvent:event.eventType forTarget:event.targetModule withCustomParam:event.customParams];
    });
   
}

- (NSMutableDictionary<NSNumber *, NSString *> *)mbSelectorByEvent
{
    if (!_mbSelectorByEvent) {
        _mbSelectorByEvent = @{
                               @(MBModuleDidSetup):kModuleDidSetupSelector,
                               @(MBModuleDidAgreePrivacy):kModuleAgreePrivacySelector,
                               @(MBModuleDidMainPageAppear):kModuleMainPageAppearSelector,
                               @(MBModuleDidCustomEvent): kModuleCostomEventSelector,
                               }.mutableCopy;
    }
    return _mbSelectorByEvent;
}

- (NSMutableDictionary<NSNumber *, NSMutableArray<id<YMMModuleProtocol>> *> *)mbModulesByEvent
{
    if (!_mbModulesByEvent) {
        _mbModulesByEvent = @{}.mutableCopy;
    }
    return _mbModulesByEvent;
}

- (NSMutableDictionary<NSNumber *,NSMutableArray<MBModuleEventObserver *> *> *)mbObserversByEvent {
    if (!_mbObserversByEvent) {
        _mbObserversByEvent = [NSMutableDictionary new];
    }
    return _mbObserversByEvent;
}

- (NSMutableDictionary<NSNumber *,NSMutableArray<MBModuleEvent *> *> *)mbStickyEventDict {
    if (!_mbStickyEventDict) {
        _mbStickyEventDict = [NSMutableDictionary new];
    }
    return _mbStickyEventDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<NSNumber *> *> *)mbStickyEventGroupDict {
    if (!_mbStickyEventGroupDict) {
        _mbStickyEventGroupDict = [NSMutableDictionary new];
    }
    return _mbStickyEventGroupDict;
}

- (void)handleModuleEvent:(NSInteger)eventType
                forTarget:(id<YMMModuleProtocol>)target
          withCustomParam:(NSDictionary *)customParam
{
    NSString *selectorStr = [self.mbSelectorByEvent objectForKey:@(eventType)];
    if (selectorStr) {
        // 处理预置的系统事件
        [self handleModuleEvent:eventType forTarget:nil withSeletorStr:selectorStr andCustomParam:customParam];
    } else {
        // 处理自定义事件
        [self handleCustomModuleEvent:eventType forTarget:target withSeletorStr:nil andCustomParam:customParam];
    }
}

- (void)handleCustomModuleEvent:(NSInteger)eventType forTarget:(id<YMMModuleProtocol>)target withSeletorStr:(NSString *)selectorStr andCustomParam:(NSDictionary *)customParam {
    NSArray<MBModuleEventObserver *> *moduleObservers = [self.mbObserversByEvent objectForKey:@(eventType)];
    if (!moduleObservers || moduleObservers.count <= 0) {
        [MBModuleLogger infoLog:[NSString stringWithFormat:@"%@:%ld", @"handleCustomModuleEvent eventType can't be found observer", (long)eventType] extra:nil];
        return;
    }
    MBModuleEventContext *context = [MBModuleEventContext shareInstance].copy;
    context.customParam = customParam;
    context.customEvent = eventType;
    [moduleObservers enumerateObjectsUsingBlock:^(MBModuleEventObserver *eventObserver, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!eventObserver.observerModule) {
            return;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (target && selectorStr && selectorStr.length > 0) {
            if ([eventObserver.observerModule isEqual:target]) {
                if ([selectorStr isEqualToString:eventObserver.eventSelectorStr]
                    && [target respondsToSelector:NSSelectorFromString(eventObserver.eventSelectorStr)]) {
                    [MBModuleLogger infoLog:[NSString stringWithFormat:@"dispatch directional eventType: %ld, target: %@, selector: %@", eventType, NSStringFromClass(target.class), selectorStr] extra:nil];
                    [target performSelector:NSSelectorFromString(eventObserver.eventSelectorStr) withObject:context];
                }
            }
        } else {
            if ([eventObserver.observerModule respondsToSelector:NSSelectorFromString(eventObserver.eventSelectorStr)]) {
                [MBModuleLogger infoLog:[NSString stringWithFormat:@"dispatch eventType: %ld, target: %@, selector: %@", eventType, NSStringFromClass(eventObserver.observerModule.class), selectorStr] extra:nil];
                [eventObserver.observerModule performSelector:NSSelectorFromString(eventObserver.eventSelectorStr) withObject:context];
            }
        }
#pragma clang diagnostic pop
    }];
}


- (void)handleModuleEvent:(NSInteger)eventType
                forTarget:(id<YMMModuleProtocol>)target
           withSeletorStr:(NSString *)selectorStr
           andCustomParam:(NSDictionary *)customParam
{
    MBModuleEventContext *context = [MBModuleEventContext shareInstance].copy;
    context.customParam = customParam;
    context.customEvent = eventType;
    if (!selectorStr.length) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@:%ld", @"handleModuleEvent eventType can't be found selector", (long)eventType] extra:nil];
        
        return;
    }
    SEL seletor = NSSelectorFromString(selectorStr);
    if (!seletor) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@:%ld:%@", @"handleModuleEvent eventType can't be found selector", (long)eventType, selectorStr] extra:nil];
        return;
    }
    if ([self.beforeLifecycle respondsToSelector:seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.beforeLifecycle performSelector:seletor withObject:context];
#pragma clang diagnostic pop
    }
    NSArray<id<YMMModuleProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    } else {
        moduleInstances = [self.mbModulesByEvent objectForKey:@(eventType)];
    }
    [moduleInstances enumerateObjectsUsingBlock:^(id<YMMModuleProtocol> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([moduleInstance respondsToSelector:seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(seletor) module:moduleInstance];
            if (!shouldInvoke) {
                return;
            }
            [moduleInstance performSelector:seletor withObject:context];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleInstance];
#pragma clang diagnostic pop
        }
    }];
    if ([self.afterLifecycle respondsToSelector:seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.afterLifecycle performSelector:seletor withObject:context];
#pragma clang diagnostic pop
    }
}

- (void)registerAllCommonEvents
{
    [_moduleObjectArray enumerateObjectsUsingBlock:^(id<YMMModuleProtocol> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerEventsByModuleInstance:moduleInstance];
    }];
}

- (void)registerEventsByModuleInstance:(id<YMMModuleProtocol>)moduleInstance
{
    NSArray<NSNumber *> *events = self.mbSelectorByEvent.allKeys;
    [events enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *eventSelectorStr = [self.mbSelectorByEvent objectForKey:obj];
        if (eventSelectorStr && eventSelectorStr.length > 0) {
            SEL eventSelector = NSSelectorFromString(eventSelectorStr);
            [self registerEvent:obj.integerValue withModuleInstance:moduleInstance andSelector:eventSelector];
        }
    }];
}

#pragma mark - context
+ (MBModuleContext *)contextOf:(Class)moduleClass {
    NSAssert(moduleClass && class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol)), @"moduleClass isinvalid!");
//    if(!moduleClass || !class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))) {
//        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@ doesn't implement module protocol", moduleClass] extra:nil];
//    }
    //  线上监控class_conformsToProtocol会出现卡顿，先注释此方法
    for (MBModuleContext *context in [MBModule shared]->_moduleContextArray) {
        if (moduleClass
            && [context respondsToSelector:@selector(getModuleInfo)]
            && [[context getModuleInfo].moduleClass isEqual:moduleClass]) {
            return context;
        }
    }
    return nil;
}

#pragma mark - check module white list

- (void)checkAllRegisteredModuleValid {
    for (MBModuleContext *context in _moduleContextArray) {
        MBModuleInfo *info = [context getModuleInfo];
        BOOL isValid = [self checkModuleNameValid:info.moduleName withClassName:info.moduleClassName];
        if (!isValid) {
            [MBModuleLogger errorLog:[NSString stringWithFormat:@"module name %@ of class %@ is invalid", info.moduleName, info.moduleClassName] extra:nil];
        }
    }
}

- (BOOL)checkModuleNameValid:(NSString *)moduleName withClassName:(NSString *)moduleClassName {
    if (!_moduleWhiteList || _moduleWhiteList.count == 0) {
        return YES;
    }
    BOOL isValid = NO;
    if (!moduleName || moduleName.length == 0) {
        isValid = NO;
    } else {
        if ([_moduleWhiteList containsObject:moduleName]) {
            isValid = YES;
        } else {
            isValid = NO;
        }
    }
    return isValid;
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application willFinishLaunchingWithOptions:launchOptions];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return YES;
            }
            [moduleObject application: application willFinishLaunchingWithOptions:launchOptions];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application willFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application didFinishLaunchingWithOptions:launchOptions];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return YES;
            }
            [moduleObject application:application didFinishLaunchingWithOptions:launchOptions];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle applicationDidEnterBackground:application];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject applicationDidEnterBackground:application];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle applicationDidEnterBackground:application];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle applicationWillEnterForeground: application];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject applicationWillEnterForeground:application];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle applicationWillEnterForeground: application];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle applicationWillResignActive:application];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject applicationWillResignActive:application];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle applicationWillResignActive:application];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle applicationDidBecomeActive:application];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject applicationDidBecomeActive:application];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle applicationDidBecomeActive:application];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle applicationWillTerminate:application];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject applicationWillTerminate:application];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle applicationWillTerminate:application];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application didFailToRegisterForRemoteNotificationsWithError:error];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application: application didFailToRegisterForRemoteNotificationsWithError: error];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application: application didReceiveRemoteNotification: userInfo];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application: application didReceiveRemoteNotification: userInfo];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application: application didReceiveRemoteNotification: userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application: application didReceiveRemoteNotification: userInfo fetchCompletionHandler: completionHandler];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application: application didReceiveRemoteNotification: userInfo fetchCompletionHandler: completionHandler];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application: application didReceiveRemoteNotification: userInfo fetchCompletionHandler: completionHandler];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application: application didReceiveLocalNotification: notification];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application: application didReceiveLocalNotification: notification];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application: application didReceiveLocalNotification: notification];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0) {
    BOOL result = NO;
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        result = [self.beforeLifecycle application:app openURL:url options:options];
    }
    if (result) {
        return YES;
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return YES;
            }
            result = [moduleObject application:app openURL:url options:options];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
        if (result) {
            return YES;
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        result = [self.afterLifecycle application:app openURL:url options:options];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    BOOL result = NO;
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        result = [self.beforeLifecycle application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    }
    if (result) {
        return YES;
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return YES;
            }
            result = [moduleObject application:application
                          continueUserActivity:userActivity
                            restorationHandler:restorationHandler];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (result) {
                break;
            }
        }
        
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        result = [self.afterLifecycle application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    }
    return result;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIInterfaceOrientationMask result = UIInterfaceOrientationMaskPortrait;
    BOOL setted = NO;
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return UIInterfaceOrientationMaskPortrait;
            }
            UIInterfaceOrientationMask moduleResult = [moduleObject application: application supportedInterfaceOrientationsForWindow: window];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (moduleResult) {
                if (!setted) {
                    setted = YES;
                    result = moduleResult;
                    
                } else {
                    NSAssert(NO, @"UIInterfaceOrientationMask 只能在MainModule实现，请检查是否有多个地方实现了");
                }
            }
        }
    }
    return result;
}

- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application
      didRegisterUserNotificationSettings:notificationSettings];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application:application
          didRegisterUserNotificationSettings:notificationSettings];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application
     didRegisterUserNotificationSettings:notificationSettings];
    }
}

- (void)application:(UIApplication*)application
performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem
  completionHandler:(void (^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0) {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application
             performActionForShortcutItem:shortcutItem
                        completionHandler:completionHandler];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application:application
                 performActionForShortcutItem:shortcutItem
                            completionHandler:completionHandler];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application
            performActionForShortcutItem:shortcutItem
                       completionHandler:completionHandler];
    }
}

- (void)application:(UIApplication*)application
  handleEventsForBackgroundURLSession:(nonnull NSString*)identifier
  completionHandler:(nonnull void (^)(void))completionHandler {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application
      handleEventsForBackgroundURLSession:identifier
                        completionHandler:completionHandler];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application:application
          handleEventsForBackgroundURLSession:identifier
                            completionHandler:completionHandler];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application
     handleEventsForBackgroundURLSession:identifier
                       completionHandler:completionHandler];
    }
}

- (void)application:(UIApplication*)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if ([self.beforeLifecycle respondsToSelector:_cmd]) {
        [self.beforeLifecycle application:application
        performFetchWithCompletionHandler:completionHandler];
    }
    for (id<YMMModuleProtocol> moduleObject in _moduleObjectArray) {
        if ([moduleObject respondsToSelector:_cmd]) {
            BOOL shouldInvoke = [self functionShouldInvoke:NSStringFromSelector(_cmd) module:moduleObject];
            if (!shouldInvoke) {
                return;
            }
            [moduleObject application:application
            performFetchWithCompletionHandler:completionHandler];
            [self functionDidInvoke:NSStringFromSelector(_cmd) module:moduleObject];
        }
    }
    if ([self.afterLifecycle respondsToSelector:_cmd]) {
        [self.afterLifecycle application:application
       performFetchWithCompletionHandler:completionHandler];
    }
}

#pragma mark - benchmark

- (BOOL)functionShouldInvoke:(NSString *)function module:(id<YMMModuleProtocol>)module {
    MBModuleContext *moduleContext = [MBModule contextOf:module.class];
    if (!self.intercept) {
        return YES;
    }
    return [self.intercept functionShouldInvoke:function module:module];
}

- (void)functionDidInvoke:(NSString *)function module:(id<YMMModuleProtocol>)module {
    MBModuleContext *moduleContext = [MBModule contextOf:module.class];
    [self.intercept functionDidInvoke:function module:module];
}

@end
