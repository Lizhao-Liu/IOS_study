//
//  YMMPluginManager.h
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/25.
//  Copyright © 2019 尹成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMMPluginRequest.h"
#import "YMMPluginResponse.h"
#import "MBPluginResponse.h"
#import "YMMPluginProtocol.h"
#import "MBBridgeLogModel.h"
#import "YMMPluginDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * v1 版本callback
 */
typedef void(^YMMPluginResponseBlock)(YMMPluginResponse *response);

/**
 * v1 && v2 版本callback
 */
typedef void(^MBPluginResponseBlock)(MBPluginResponse *response);

@interface MBBridgePluginConfig : NSObject

@property (nonatomic, assign) BOOL useNew;

// 是否debug环境
@property (nonatomic, assign) BOOL isDebug;
// 执行过程中提示信息,回调可能是异步线程
@property (nonatomic, copy, nullable) void(^messageHandle)(NSString *message);
// monitor
@property (nonatomic, copy, nullable) void(^monitorHandle)(MBBridgeLogModel *model);

@end

@interface YMMPluginManager : NSObject

+ (instancetype)shared;

- (void)config:(MBBridgePluginConfig *)config;


/// v1 - 注册bridge实现,老bridge不包含bizName，新bridge需要实现YMMPluginProtocol bizName方法
/// @param pluginClass 类别，不可为空
/// @param module 模块名，不可为空
- (void)registerPlugin:(Class)pluginClass
         supportModule:(NSString *)module;

/**
 * v1 - 注册bridge实现
 * @param pluginClass 类名，不可为空
 * @param module 模块名,不可为空
 * @param bizName 业务名，可以为空
 */
- (void)registerPlugin:(Class)pluginClass
         supportModule:(NSString *)module
               bizName:(NSString *)bizName;

/**
 * v2 - 注册bridge实现
 * @param pluginClass 类名，不可为空
 * @param module 模块名,不可为空
 * @param bizName 业务名，可以为空
 */
- (void)registerTigaPlugin:(Class)pluginClass
             supportModule:(NSString *)module
                   bizName:(NSString *)bizName;

/**
 * v2 - 注册bridge实现，plugin插件的bizName需要在Plugin中通过bizName定义
 * @param pluginClasses bridge插件数组
 * @param module 模块名,不可为空
 */
- (void)registerTigaPluginArray:(NSArray<Class> *) pluginClasses
             supportModule:(NSString *)module;

/**
 * 注册bridge实现 - 支持版本选择(v1、v2)
 * @param pluginClass 类名，不可为空
 * @param module 模块名,不可为空
 * @param bizName 业务名，可以为空
 * @param option 版本
 */
- (void)registerPlugin:(Class)pluginClass
         supportModule:(NSString *)module
               bizName:(NSString *)bizName
              protocol:(MBBridgeRegisterProtocolOption)option;

/**
 * 调用bridge请求 - 只支持v1
 * @param request 请求数据
 * @param responseBlock 结果callback
 */
- (void)performPlugin:(YMMPluginRequest *)request
             callBack:(YMMPluginResponseBlock)responseBlock;

/**
 * 调用bridge请求 - 支持v1 && v2
 * @param request 请求数据
 * @param responseBlock 结果callback
 */
- (void)performCommonBridge:(YMMPluginRequest *)request
                   callBack:(MBPluginResponseBlock)responseBlock;

@end

NS_ASSUME_NONNULL_END
