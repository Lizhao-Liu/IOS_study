//
//  YMMRouterConfigManager.h
//  YMMRouterLib
//
//  Created by xp on 2021/3/22.
//

#import <Foundation/Foundation.h>
#import "MBRouterLogger.h"
#import "YMMRouter.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBRouterLogHandler)(MBRouterLogLevel level, NSString *logMsg);

/// 获取路由错误页面viewController
typedef UIViewController *_Nonnull(^MBRouterErrorViewControllerConfigBlock)(id<YMMRouterRoutable> request, YMMRouterResponse *response);

@interface YMMRouterConfig : NSObject


/// 控制YMMRouterRequest中urlString使用新逻辑还是老逻辑，作用是防止迁移到新逻辑之后存在问题，能够降级到老逻辑
@property (nonatomic, assign) BOOL useOldRequestUrlstringFunction;


@property (nonatomic, assign) BOOL useNewURLEncodeFunction;

@property (nonatomic, assign) BOOL encodeParamInUrlString;


@property (nonatomic, assign) BOOL encodeParamInOriginUrlString;


/// 日志打印Handler，内部日志抛到外部打印
@property (nonatomic, copy) MBRouterLogHandler logHandler;


@property (nonatomic, copy) MBRouterErrorViewControllerConfigBlock errorViewControllerConfigBlock;


@end

@interface YMMRouterConfigManager : NSObject

+ (void)setConfig:(YMMRouterConfig *)config;

+ (YMMRouterConfig *)getConfig;

+ (MBRouterLogHandler)getLogHandler;

+ (BOOL)useOldRequestUrlstringFunction;

+ (BOOL)useNewURLEncodeFunction;

@end

NS_ASSUME_NONNULL_END
