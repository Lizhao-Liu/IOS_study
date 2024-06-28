//
//  YMMPluginManager.m
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/25.
//  Copyright © 2019 尹成. All rights reserved.
//

#import "YMMPluginManager.h"
#import <objc/runtime.h>
#import "YMMPluginDefine.h"
#import "NSDictionary+BridgeSafe.h"
#import "MBBridgeAccessModel.h"
#import "YMMBridgeLib-Swift.h"

/**
 bridge注册提示码

 - YMMBridgeRegisterCode_Success: 注册成功
 - YMMBridgeRegisterCode_Repeat: 重复注册
 - YMMBridgeRegisterCode_MethodNull: 注册模块方法为空
 - YMMBridgeRegisterCode_ModuleNull: 注册模块名为空
 - YMMBridgeRegisterCode_ProtocolNull: 未遵循协议
 */
typedef NS_ENUM(NSUInteger, YMMBridgeRegisterCode) {
    YMMBridgeRegisterCode_Success = 1,
    YMMBridgeRegisterCode_Repeat,
    YMMBridgeRegisterCode_MethodNull,
    YMMBridgeRegisterCode_ModuleNull,
    YMMBridgeRegisterCode_ProtocolNull
};

/**
 bridge执行提示码

 - YMMBridgePerformCode_Success: 通道执行成功
 - YMMBridgePerformCode_ParamsError: 通道参数错误
 - YMMBridgePerformCode_MethodNotFound: 方法未找到
 - YMMBridgePerformCode_UnknownError: 未知错误
 - YMMBridgePerformCode_Timeout: 超时
 */
typedef NS_ENUM(NSUInteger, YMMBridgePerformCode) {
    YMMBridgePerformCode_Success = 1,
    YMMBridgePerformCode_ParamsError,
    YMMBridgePerformCode_MethodNotFound,
    YMMBridgePerformCode_UnknownError,
    YMMBridgePerformCode_Timeout
};

static NSString * defaultMethodRule = @":callBack:";

// 默认有容器对象透传方法，容器方法名
static NSString * defaultContainerMethodName = @":container";

static NSString * defaultVisitorMethodName = @":container:visitor";

@implementation MBBridgePluginConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end


@interface YMMPluginManager () {
    NSLock *_dataLock;
}
/**
 组件类缓存
 key:method、model、biz拼接字符串
 value:pluginclass
 */
@property (nonatomic, strong) NSMutableDictionary *pluginMethodMap;
/**
 实例缓存
 key:类字符串
 value:实例
 */
@property (nonatomic, strong) NSMutableDictionary *pluginInstanceCache;

/**
 组件类缓存
 key:method、model、biz拼接字符串
 value:pluginclass
 */
@property (nonatomic, strong) NSMutableDictionary *pluginMethodV2Map;
/**
 实例缓存
 key:类字符串
 value:实例
 */
@property (nonatomic, strong) NSMutableDictionary *pluginInstanceV2Cache;

/**
 配置信息
 */
@property (nullable, nonatomic, strong) MBBridgePluginConfig *config;

/**
 权控信息
 */
@property (nullable, nonatomic, strong) NSMutableDictionary<NSString *, MBBridgeAccessModel *> *accessCache;

@end

@implementation YMMPluginManager

static YMMPluginManager *_pluginManager;

#pragma mark - lifeCycle method
+ (YMMPluginManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pluginManager = [[self alloc] init];
    });
    return _pluginManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataLock = [[NSLock alloc] init];
    }
    return self;
}

#pragma mark - public method
- (void)config:(MBBridgePluginConfig *)config {
    self.config = config;
}

- (void)registerPlugin:(Class)pluginClass supportModule:(NSString *)module {
    NSString *bizName = nil;
    if (pluginClass && module &&
        [pluginClass conformsToProtocol:@protocol(YMMPluginProtocol)] && [pluginClass respondsToSelector:@selector(bizName)]) {
        bizName = [pluginClass bizName];
    }
    [self registerPlugin:pluginClass supportModule:module bizName:bizName];
}

- (void)registerPlugin:(Class)pluginClass supportModule:(NSString *)module bizName:(NSString *)bizName {
    [self registerPlugin:pluginClass supportModule:module bizName:bizName version:MBPluginRequestProtocol_V1];
}

- (void)registerPlugin:(Class)pluginClass supportModule:(NSString *)module bizName:(NSString *)bizName version:(MBPluginRequestProtocol)verNum {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setValue:NSStringFromClass(pluginClass) forKey:@"pluginClass"];
    [mDict setValue:module forKey:@"module"];
    if (bizName && bizName.length > 0) {
        [mDict setValue:bizName forKey:@"business"];
    }
    [mDict setValue:@(verNum) forKey:@"protocol"];
    
    if (pluginClass && module &&
        [pluginClass conformsToProtocol:@protocol(YMMPluginProtocol)]) {
        NSMutableArray *methodList = [NSMutableArray array];
        
        unsigned int count;
        Method *methods = class_copyMethodList(pluginClass, &count);
        for (int i = 0; i < count; i++) {
            Method method = methods[i];
            SEL selector = method_getName(method);
            NSString *name = NSStringFromSelector(selector);
            if ([name hasSuffix:defaultMethodRule]) {
                //TODO:校验类型
                //            struct objc_method_description methodDescription = *method_getDescription(method);
                //            char *types = methodDescription.types;
                //            NSLog(@"type : %s",@encode(int));
                //            NSLog(@"type : %s",@encode(id));
                //            NSLog(@"type : %s",@encode(SEL));
                [methodList addObject:[name stringByReplacingOccurrencesOfString:defaultMethodRule withString:@""]];
                NSString *methodKey = [self mapKey:name module:module biz:bizName];
                if ([[self realMethodMap:verNum] objectForKey:methodKey]) {
                    [mDict setValue:[name stringByReplacingOccurrencesOfString:defaultMethodRule withString:@""]
                             forKey:@"repeat"];
                    [mDict setValue:@(YMMBridgeRegisterCode_Repeat) forKey:@"code"];
                    [self journalForRegister:mDict];
                }
                [[self realMethodMap:verNum] setValue:pluginClass forKey:methodKey];
            }
        }
        if ([self realMethodMap:verNum].count > 0) {
            [mDict setValue:methodList forKey:@"pluginMethod"];
            [mDict setValue:@(YMMBridgeRegisterCode_Success) forKey:@"code"];
            [self journalForRegister:mDict];
        } else {
            [mDict setValue:@(YMMBridgeRegisterCode_MethodNull) forKey:@"code"];
            [self journalForRegister:mDict];
        }
        free(methods);
        
    } else {
        if (module) {
            [mDict setValue:@(YMMBridgeRegisterCode_ProtocolNull) forKey:@"code"];
            [self journalForRegister:mDict];
        } else {
            [mDict setValue:@(YMMBridgeRegisterCode_ModuleNull) forKey:@"code"];
            [self journalForRegister:mDict];
        }
    }
}

- (void)registerPlugin:(Class)pluginClass
         supportModule:(NSString *)module
               bizName:(NSString *)bizName
              protocol:(MBBridgeRegisterProtocolOption)option {
    // V1
    if ((option & MBBridgeRegisterProtocolOption_V1)) {
        [self registerPlugin:pluginClass supportModule:module bizName:bizName version:MBPluginRequestProtocol_V1];
    }

    // V2
    if ((option & MBBridgeRegisterProtocolOption_V2)) {
        [self registerPlugin:pluginClass supportModule:module bizName:bizName version:MBPluginRequestProtocol_V2];
    }
}

- (void)registerTigaPlugin:(Class)pluginClass
             supportModule:(NSString *)module
                   bizName:(NSString *)bizName {
    [self registerPlugin:pluginClass supportModule:module bizName:bizName version:MBPluginRequestProtocol_V2];
}

- (void)registerTigaPluginArray:(NSArray<Class> *)pluginClasses supportModule:(NSString *)module {
    for (Class pluginClass in pluginClasses) {
        NSString *bizName = nil;
        if (pluginClass &&
            [pluginClass conformsToProtocol:@protocol(YMMPluginProtocol)]) {
            if ([pluginClass respondsToSelector:@selector(bizName)]) {
                bizName = [pluginClass bizName];
            } else {
                NSAssert(NO, @"plugin必须实现bizName方法");
            }
            [self registerPlugin:pluginClass supportModule:module bizName:bizName version:MBPluginRequestProtocol_V2];
        }
    }
}

- (void)performPlugin:(YMMPluginRequest *)request callBack:(YMMPluginResponseBlock)responseBlock {
    
    if ([self isBaseAvailableMethod:request callBack:responseBlock]) {
        // bridge使用情况埋点
        [self journalForUseage:request];
        
        return ;
    }

    // bridge使用情况埋点
    [self journalForUseage:request];
    
    if ([self isAvailableMethod:request]) {
        
        [self performSuccessPlugin:request callBack:responseBlock];
        
    } else if (responseBlock) {
        YMMPluginResponse *error = [YMMPluginResponse defaultErrorResponse];
        error.code = YMMPluginCode_NoSupport;
        if (![request avaliableRequest]) {
            error.reason = kYMMPluginError_ParamsError;
            [self journalForBridge:request response:error code:YMMBridgePerformCode_ParamsError];
        } else {
            error.reason = kYMMPluginError_NotFindMethodError;
            [self journalForBridge:request response:error code:YMMBridgePerformCode_MethodNotFound];
        }
        responseBlock(error);
    }
    
}

- (void)performCommonBridge:(YMMPluginRequest *)request
                   callBack:(MBPluginResponseBlock)responseBlock {
    
    [self performPlugin:request callBack:^(YMMPluginResponse * _Nonnull response) {
        if (responseBlock) {
            responseBlock([self conversionByResponse:response version:request.protocol]);
        }
    }];
}

#pragma mark - private
- (MBPluginResponse *)conversionByResponse:(YMMPluginResponse *)response version:(MBPluginRequestProtocol)version {
    if (response == nil) return nil;
    if (MBPluginRequestProtocol_V1 == version) {
        return [self conversionV1ByResponse:response];
    } else if (MBPluginRequestProtocol_V2 == version) {
        return [self conversionV2ByResponse:response];
    }
    
    MBPluginResponse *pluginResponse = [[MBPluginResponse alloc] init];
    pluginResponse.code = MBBridgeLibCode_NoProtocolError;
    pluginResponse.reason = @"不支持协议版本";
    return pluginResponse;
}

- (MBPluginResponse *)conversionV1ByResponse:(YMMPluginResponse *)response {
    MBPluginResponse *pluginResponse = [[MBPluginResponse alloc] init];
    
    pluginResponse.code = response.code;
    pluginResponse.reason = response.reason;
    
    if (response.data) {
        NSMutableDictionary *methodRespons = [NSMutableDictionary dictionary];
        [methodRespons setValue:@(response.data.code) forKey:@"code"];
        [methodRespons setValue:response.data.reason forKey:@"reason"];
        [methodRespons setValue:response.data.data forKey:@"data"];
        pluginResponse.data = methodRespons;
    }
    
    return pluginResponse;
}

- (MBPluginResponse *)conversionV2ByResponse:(YMMPluginResponse *)response {
    MBPluginResponse *pluginResponse = [[MBPluginResponse alloc] init];
    
    if (response.code == YMMPluginCode_Success) {
        pluginResponse.code = MBBridgeLibCode_Success;
        pluginResponse.reason = kYMMPluginSuccess;
    } else if (response.code == YMMPluginCode_NopermissionError) {
        pluginResponse.code = MBBridgeLibCode_NopermissionError;
        pluginResponse.reason = kYMMPluginError_Nopermission;
    }  else if (response.code == YMMPluginCode_BizMethodError) {
        pluginResponse.code = MBBridgeLibCode_BizMethodError;
        pluginResponse.reason = @"方法实现存在问题.";
    }  else if (response.code == YMMPluginCode_UnknownError) {
        pluginResponse.code = MBBridgeLibCode_InternalError;
        pluginResponse.reason = kYMMPluginError_InternalError;
    }  else {
        pluginResponse.code = MBBridgeLibCode_NoSupport;
        pluginResponse.reason = kYMMPluginError_ModuleNoFound;
    }
    
    if (response.data && [response.data isKindOfClass:[YMMMethodResponse class]]) {
        YMMMethodResponse *methodResponse = response.data;
        pluginResponse.code = methodResponse.code;
        pluginResponse.reason = methodResponse.reason;
        pluginResponse.data = methodResponse.data;
    }
    
    return pluginResponse;
}

- (BOOL)supportMethod:(YMMPluginRequest *)request {
    /**
     检查顺序：
     1. 带container和visitor参数, method:container:visitor:callBack
     2. 带container参数, method:container:callBack
     3. method:callBack
     */
    
    NSString *mapKey = [self mapKey:[self realWithVisitorMethod:request.method] module:request.module biz:request.business];
    Class PluginClass = [[self realMethodMap:request.protocol] objectForKey:mapKey];
    if (PluginClass && ![PluginClass isEqual:[NSNull null]]) {
        return YES;
    }
    
    mapKey = [self mapKey:[self realWithContainerMethod:request.method] module:request.module biz:request.business];
    // 首先检查带container参数方法是否存在
    PluginClass = [[self realMethodMap:request.protocol] objectForKey:mapKey];
    if (PluginClass && ![PluginClass isEqual:[NSNull null]]) {
        return YES;
    }
    
    // 检测不带container参数方法是否存在
    mapKey = [self mapKey:[self realMethodName:request.method] module:request.module biz:request.business];
    PluginClass = [[self realMethodMap:request.protocol] objectForKey:mapKey];
    
    return PluginClass && ![PluginClass isEqual:[NSNull null]];
}

- (Class)classByRequest:(YMMPluginRequest *)request {
    if (![request avaliableRequest]) {
        return nil;
    }
    /**
     检查顺序：
     1. 带container和visitor参数, method:container:visitor:callBack
     2. 带container参数, method:container:callBack
     3. method:callBack
     */
    NSString *key = [self mapKey:[self realWithVisitorMethod:request.method] module:request.module biz:request.business];
    Class pluginClass = [[self realMethodMap:request.protocol] objectForKey:key];
    if (pluginClass) {
        return pluginClass;
    }
    
    key = [self mapKey:[self realWithContainerMethod:request.method] module:request.module biz:request.business];
    pluginClass = [[self realMethodMap:request.protocol] objectForKey:key];
    if (pluginClass) {
        return pluginClass;
    }
    
    key = [self mapKey:[self realMethodName:request.method] module:request.module biz:request.business];
    return [[self realMethodMap:request.protocol] objectForKey:key];
}

- (MBBridgeAccessModel *)accessByRequest:(YMMPluginRequest *)request plugin:(id)pluginInstance container:(BOOL)haveContainer visitor:(BOOL)haveVisitor {
    NSString *key = nil;
    if (haveVisitor) {
        key = [self mapKey:[self realWithVisitorMethod:request.method] module:request.module biz:request.business];
    } else if (haveContainer) {
        key = [self mapKey:[self realWithContainerMethod:request.method] module:request.module biz:request.business];
    } else {
        key = [self mapKey:[self realMethodName:request.method] module:request.module biz:request.business];
    }
    
    MBBridgeAccessModel *model = [self.accessCache bridge_objectForKey:key];
    if (model == nil) {
        model = [self accessForPluginInstance:pluginInstance method:request.method methodkey:key];
    }
    return model;
}

// 是否要阻断
- (BOOL)checkBlockAccess:(MBBridgeAccessModel *)model forRequest:(YMMPluginRequest *)request {
    
    if (model == nil) {
        // 没有设置权限，默认所有访问者都可以访问
        return NO;
    }
    
    BOOL haveAccess = [model matchAccess:request.visitor];
    if (haveAccess) {
        return NO;
    }
    if (model.level == MBBridgeAccessLevelError && self.config.isDebug) {
        // 没有权限 && Error级别 && debug环境 则需要阻断调用，返回无权限错误码
        return YES;
    } else if (self.config.isDebug) {
        // 没有权限 && warning级别 && debug环境 不阻断调用，toast提示
        if (self.config.messageHandle) {
            NSString *bridgeName = [self originName:request.method module:request.module biz:request.business];
            NSString *alertStr = [NSString stringWithFormat:@"%@未授权使用%@", request.visitor, bridgeName];
            self.config.messageHandle(alertStr);
        }
        return NO;
    } else {
        // 没有权限 && release环境 不阻断调用，埋点上报
        // 只需要埋点
        MBBridgeLogModel *model = [[MBBridgeLogModel alloc] init];
        model.type = MBBridgeLogTypeNoAccess;
        model.bridgeName = [self originName:request.method module:request.module biz:request.business];
        model.source = request.source;
        model.visitor = request.visitor;
        model.protocol = request.protocol;
        model.bundleName = request.bundleName;
        model.bundleVersion = request.bundleVersion;
        if (self.config.monitorHandle) {
            self.config.monitorHandle(model);
        }
        return NO;
    }
    
    return NO;
}

- (NSString *)mapKey:(NSString *)method module:(NSString *)module biz:(NSString *)bizName {
    if (method == nil || module == nil) {
        return @"";
    }
    if (bizName == nil || bizName.length <= 0) {
        return [NSString stringWithFormat:@"%@_%@",method,module];
    } else {
        return [NSString stringWithFormat:@"%@_%@_%@",method,module,bizName];
    }
}

- (NSString *)originName:(NSString *)method module:(NSString *)module biz:(NSString *)bizName {
    if (method == nil || module == nil) {
        return @"";
    }
    if (bizName == nil || bizName.length <= 0) {
        return [NSString stringWithFormat:@"%@.%@",module,method];
    } else {
        return [NSString stringWithFormat:@"%@.%@.%@",module,bizName,method];
    }
}

- (NSString *)realMethodName:(NSString *)methodName {
    return methodName ? [methodName stringByAppendingString:defaultMethodRule] : nil;
}

// 包含container参数的method
- (NSString *)realWithContainerMethod:(NSString *)methodName {
    return methodName ? [methodName stringByAppendingFormat:@"%@%@", defaultContainerMethodName, defaultMethodRule] : nil;
}

// 包含visitor参数的method
- (NSString *)realWithVisitorMethod:(NSString *)methodName {
    return methodName ? [methodName stringByAppendingFormat:@"%@%@", defaultVisitorMethodName, defaultMethodRule] : nil;
}

- (void)performSuccessPlugin:(YMMPluginRequest *)request callBack:(YMMPluginResponseBlock)responseBlock {
    [_dataLock lock];
    Class pluginClass = [self classByRequest:request];
    NSString *className = NSStringFromClass(pluginClass);
    //缓存
    id pluginInstance = nil;
    pluginInstance = [[self realInstanceCache:request.protocol] bridge_objectForKey:NSStringFromClass(pluginClass)];
    if (pluginInstance == nil || [pluginInstance isEqual:[NSNull null]]) {
        pluginInstance = [[pluginClass alloc] init];
        // 对象缓存
        if (className != nil) {
            [[self realInstanceCache:request.protocol] setObject:pluginInstance forKey:className];
        }
    }
    
    [_dataLock unlock];
    
    if (pluginClass == nil || className == nil) {
        YMMPluginResponse *error = [YMMPluginResponse defaultErrorResponse];
        error.code = YMMPluginCode_NoSupport;
        error.reason = kYMMPluginError_ModuleLoadFail;
        [self journalForBridge:request response:error code:YMMBridgePerformCode_UnknownError];
        responseBlock(error);
        return;
    }
    // 方法调用
    [self performPlugin:pluginInstance
          withClassName:className
            withRequest:request
               callBack:responseBlock];
}

- (void)performPlugin:(id)plugin withClassName:(NSString *)className withRequest:(YMMPluginRequest *)request callBack:(YMMPluginResponseBlock)responseBlock {
    
    __weak typeof(self) weakSelf = self;
    YMMMethodResponseBlock callBack = ^(YMMMethodResponse * response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf performResultForRequest:request response:response callBack:responseBlock];
    };
    Class class = NSClassFromString(className); // 使用局部变量
    
    /**
     1. 先查找 method:container:visitor:callBack:
     2. 再查找 method:container:callBack:
     3. 最后查找 method:callBack:
     */
    SEL selector = NSSelectorFromString([self realWithVisitorMethod:request.method]);
    NSMethodSignature *signature = [class instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        selector = NSSelectorFromString([self realWithContainerMethod:request.method]);
        signature = [class instanceMethodSignatureForSelector:selector];
    }
    
    if (signature == nil) {
        selector = NSSelectorFromString([self realMethodName:request.method]);
        signature = [class instanceMethodSignatureForSelector:selector];
    }
    
    if (signature == nil) {
        YMMPluginResponse *errorResponse = [YMMPluginResponse defaultErrorResponse];
        errorResponse.code = YMMPluginCode_UnknownError;
        errorResponse.reason = kYMMPluginError_NotFindMethodError;
        responseBlock(errorResponse);
        [self journalForBridge:request response:errorResponse code:YMMBridgePerformCode_UnknownError];
        return;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = plugin;
    invocation.selector = selector;
    
    /**
     参数个数，强校验以下条件
     一、2 或 3 个参数才算做正常bridge method
     二、如果是2个参数，则无需传递容器
     三、如果是3个参数，则第一参数为容器
     四、如果是4个参数，则包含visitor
     */
    NSUInteger argsCount = signature.numberOfArguments - 2;
    NSDictionary *params = request.params;
    if ([params isKindOfClass:[NSNull class]]) {
        params = nil;
    }
    
    // 权限判断
    [_dataLock lock];
    MBBridgeAccessModel *access = [self accessByRequest:request plugin:plugin container:(argsCount == 3 ? YES : NO) visitor:(argsCount == 4 ? YES : NO)];
    [_dataLock unlock];
    
    if ([self checkBlockAccess:access forRequest:request]) {
        
        YMMPluginResponse *error = [YMMPluginResponse defaultErrorResponse];
        error.code = YMMPluginCode_NopermissionError;
        error.reason = kYMMPluginError_Nopermission;
        responseBlock(error);
        [self journalForBridge:request response:error code:YMMBridgePerformCode_UnknownError];
        return;
    }
    
    if (argsCount == 2) {
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&callBack atIndex:3];
        [invocation invoke];
    } else if (argsCount == 3) {
        id container = request.container;
        if ([container isKindOfClass:[NSNull class]]) {
            container = nil;
        }
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&container atIndex:3];
        [invocation setArgument:&callBack atIndex:4];
        [invocation invoke];
    } else if (argsCount == 4) {
        id container = request.container;
        if ([container isKindOfClass:[NSNull class]]) {
            container = nil;
        }
        MBBridgeVisitor *visitor = [[MBBridgeVisitor alloc] initWithRequest:request];
        
        if ([visitor isKindOfClass:[NSNull class]]) {
            visitor = nil;
        }
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&container atIndex:3];
        [invocation setArgument:&visitor atIndex:4];
        [invocation setArgument:&callBack atIndex:5];
        [invocation invoke];
    } else {
        YMMPluginResponse *errorResponse = [YMMPluginResponse defaultErrorResponse];
        errorResponse.code = YMMPluginCode_UnknownError;
        errorResponse.reason = kYMMPluginError_NotFindMethodError;
        responseBlock(errorResponse);
        [self journalForBridge:request response:errorResponse code:YMMBridgePerformCode_UnknownError];
    }
}

- (void)performResultForRequest:(YMMPluginRequest *)request response:(YMMMethodResponse *)response callBack:(YMMPluginResponseBlock)responseBlock {
    YMMPluginResponse *pluginResponse = [YMMPluginResponse defaultSuccessResponse];
    if (MBPluginRequestProtocol_V2 == request.protocol) {
        if (response.code < 0) {
            pluginResponse.code = YMMPluginCode_BizMethodError;
            pluginResponse.reason = @"业务错误码需要定义为正数。";
        } else {
            pluginResponse.data = response;
        }
    } else {
        pluginResponse.data = response;
    }
    
    [self journalForBridge:request response:pluginResponse code:YMMBridgePerformCode_Success];
    if (responseBlock) {
        responseBlock(pluginResponse);
    }
}

- (BOOL)isAvailableMethod:(YMMPluginRequest *)request {
    return [request avaliableRequest] && [self supportMethod:request];
}

- (BOOL)isBaseAvailableMethod:(YMMPluginRequest *)request callBack:(YMMPluginResponseBlock)responseBlock {
    BOOL isBaseAvailableMethod;
    if (MBPluginRequestProtocol_V2 == request.protocol) {
        isBaseAvailableMethod = [request.module isEqualToString:@"app"] && [request.business isEqualToString:@"api"] && [request.method isEqualToString:@"canIUse"];
    } else {
        isBaseAvailableMethod = [request.module isEqualToString:@"base"] && [request.method isEqualToString:@"isAvailableMethod"];
    }
    
    if (responseBlock && isBaseAvailableMethod) {
        
        YMMPluginRequest *methodRequest = [self copyfromRequest:request];
        
        BOOL isAvailableMethod = [self isAvailableMethod:methodRequest];
        YMMPluginResponse *response = [YMMPluginResponse defaultSuccessResponse];
        YMMMethodResponse *methodResponse = [[YMMMethodResponse alloc] init];
        if (MBPluginRequestProtocol_V2 == request.protocol) {
            methodResponse.code = isAvailableMethod ? YMMPluginCode_Success : MBBridgeLibCode_NoSupport;
        } else {
            methodResponse.code = isAvailableMethod ? YMMPluginCode_Success : YMMPluginCode_NoSupport;
        }
        response.data = methodResponse;
        [self journalForBridge:request response:response code:YMMBridgePerformCode_Success];
        responseBlock(response);
    }
    return isBaseAvailableMethod;
}

- (YMMPluginRequest *)copyfromRequest:(YMMPluginRequest *)request {
    YMMPluginRequest *methodRequest = [[YMMPluginRequest alloc] init];
    methodRequest.protocol = request.protocol;
    methodRequest.module = [request.params bridge_stringForKey:@"module"];
    methodRequest.method = [request.params bridge_stringForKey:@"method"];
    methodRequest.business = [request.params bridge_stringForKey:@"businessName"];
    return methodRequest;
}

// 分析权限数据
- (MBBridgeAccessModel *)accessForPluginInstance:(id<YMMPluginProtocol>)pluginInstance
                                          method:(NSString *)methodName
                                       methodkey:(NSString *)methodKey {
    
    /**
     如果对该方法设置了权限，则直接进行缓存
     如果没有对方法设置权限，则查看是否有全局设置，如果有全局设置 对该方法进行缓存
     如果以上都没有，则new一个nolimit的权限model进行缓存
     */
    // 解析方法级别权限
    MBBridgeAccessModel *accessModel = nil;
    if ([pluginInstance respondsToSelector:@selector(bridgeAccessControlsForMethod)]) {
        NSDictionary<NSString *, MBBridgeAccessModel *> *dic = [pluginInstance bridgeAccessControlsForMethod];
        if (methodName && methodKey && [dic objectForKey:methodName]) {
            MBBridgeAccessModel *model = [dic objectForKey:methodName];
            [self.accessCache setObject:model forKey:methodKey];
            accessModel = model;
        }
    }
    
    // 如果配置了方法级别的权限，则不需要继续查询
    if (accessModel != nil) {
        return accessModel;
    }
    
    if ([pluginInstance respondsToSelector:@selector(bridgeAccessControlsForAllMethods)]) {
        accessModel = [pluginInstance bridgeAccessControlsForAllMethods];
    }
    
    if (accessModel == nil) {
        accessModel = [[MBBridgeAccessModel alloc] init];
        accessModel.nolimit = YES;
    }
    
    if (accessModel && methodKey) {
        [self.accessCache setObject:accessModel forKey:methodKey];
    }
    
    return accessModel;
}

#pragma mark - journal

- (void)journalForUseage:(YMMPluginRequest *)request {
    
    MBBridgeLogModel *model = [[MBBridgeLogModel alloc] init];
    model.type = MBBridgeLogTypeUseage;
    model.bridgeName = [self originName:request.method module:request.module biz:request.business];
    model.source = request.source;
    model.visitor = request.visitor;
    model.protocol = request.protocol;
    model.bundleName = request.bundleName;
    model.bundleVersion = request.bundleVersion;
    if (self.config.monitorHandle) {
        self.config.monitorHandle(model);
    }
}

- (void)journalForBridge:(YMMPluginRequest *)request response:(YMMPluginResponse *)response code:(YMMBridgePerformCode)performCode {
    if (response && response.code == YMMPluginCode_Success) {
        if (response.data && [response.data isKindOfClass:[YMMMethodResponse class]] && response.data.code == YMMPluginCode_Success) {
            // 调用成功不埋失败点
            return;
        }
    }
    // bridge调用失败埋点
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    
    //请求内容
    [mdict setValue:request.module forKey:@"module"];
    if (request.business) {
        [mdict setValue:request.business forKey:@"business"];
    }
    [mdict setValue:request.method forKey:@"method"];
    [mdict setValue:request.source forKey:@"source"];
    
    //通道执行结果
    [mdict setValue:@(performCode) forKey:@"performCode"];
    
    NSInteger errorCode = YMMPluginCode_UnknownError;
    if (response.code != YMMPluginCode_Success) {
        if (MBPluginRequestProtocol_V2 == request.protocol) {
            if (response.code == YMMPluginCode_NopermissionError) {
                errorCode = MBBridgeLibCode_NopermissionError;
            }  else if (response.code == YMMPluginCode_BizMethodError) {
                errorCode = MBBridgeLibCode_BizMethodError;
            }  else if (response.code == YMMPluginCode_UnknownError) {
                errorCode = MBBridgeLibCode_InternalError;
            }   else {
                errorCode = MBBridgeLibCode_NoSupport;
            }
        }
    } else if ([response.data isKindOfClass:[YMMMethodResponse class]]) {
        errorCode = response.data.code;
    }
    [mdict setValue:@(errorCode) forKey:@"code"];
    
    NSString *reason = @"";
    if (response.code != YMMPluginCode_Success) {
        reason = response.reason;
    } else if ([response.data isKindOfClass:[YMMMethodResponse class]]) {
        reason = response.data.reason;
    }
    [mdict setValue:reason forKey:@"reason"];
    
    [mdict setValue:@(request.protocol) forKey:@"protocol"];
    
    //方法执行结果
    if (response.data) {
        YMMMethodResponse *methodResponse = response.data;
        NSMutableDictionary *methodDict = [NSMutableDictionary dictionary];
        [methodDict setValue:@(methodResponse.code) forKey:@"code"];
        [methodDict setValue:methodResponse.reason forKey:@"reason"];
        [mdict setValue:methodDict forKey:@"data"];
    }
    
    MBBridgeLogModel *model = [[MBBridgeLogModel alloc] init];
    model.type = MBBridgeLogTypePerformFailed;
    model.bridgeName = [self originName:request.method module:request.module biz:request.business];
    model.source = request.source;
    model.visitor = request.visitor;
    model.extras = mdict;
    model.protocol = request.protocol;
    model.bundleName = request.bundleName;
    model.bundleVersion = request.bundleVersion;
    if (self.config.monitorHandle) {
        self.config.monitorHandle(model);
    }
}

- (void)journalForRegister:(NSDictionary *)bridgeInfo {
    if (bridgeInfo) {
// TODO bridge注册时埋点SDK还未初始化，需要先保存在特定时间点上报
//        [MBDoctorUtil techWithModel:@"bridge"
//                             scenario:@"register"
//                             extraDic:bridgeInfo];
//        NSLog(@"[app][bridge] register bridgeInfo : %@", bridgeInfo);
    }
}

#pragma mark - property

- (NSMutableDictionary *)realMethodMap:(MBPluginRequestProtocol)ver {
    if (MBPluginRequestProtocol_V1 == ver) {
        return self.pluginMethodMap;
    }
    return self.pluginMethodV2Map;
}

- (NSMutableDictionary *)realInstanceCache:(MBPluginRequestProtocol)ver {
    if (MBPluginRequestProtocol_V1 == ver) {
        return self.pluginInstanceCache;
    }
    return self.pluginInstanceV2Cache;
}

- (NSMutableDictionary *)pluginMethodMap {
    if (!_pluginMethodMap) {
        _pluginMethodMap = [NSMutableDictionary dictionary];
    }
    return _pluginMethodMap;
}
    
- (NSMutableDictionary *)pluginInstanceCache {
    if (!_pluginInstanceCache) {
        _pluginInstanceCache = [NSMutableDictionary dictionary];
    }
    return _pluginInstanceCache;
}

- (NSMutableDictionary *)pluginMethodV2Map {
    if (!_pluginMethodV2Map) {
        _pluginMethodV2Map = [NSMutableDictionary dictionary];
    }
    return _pluginMethodV2Map;
}
    
- (NSMutableDictionary *)pluginInstanceV2Cache {
    if (!_pluginInstanceV2Cache) {
        _pluginInstanceV2Cache = [NSMutableDictionary dictionary];
    }
    return _pluginInstanceV2Cache;
}

- (NSMutableDictionary<NSString *, MBBridgeAccessModel *> *)accessCache {
    if (!_accessCache) {
        _accessCache = [NSMutableDictionary dictionary];
    }
    return _accessCache;
}

@end
