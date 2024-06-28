//
//  YMMPluginProtocol.h
//  GoodTransport
//
//  Created by 尹成 on 2019/2/24.
//  Copyright © 2019 Yunmanman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMMMethodResponse.h"
#import "YMMPluginManager.h"
#import "YMMPluginDefine.h"
#import "MBBridgeContainer.h"
#import "MBBridgeAccessModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 注：
 js_name、module、bizName 字符串都不可包含 “.” 字符
 */
/// (已弃用) 使用 MB_BRIDGE_PLUGIN_EXPORT(module, biz_name)
#define YMM_PLUGIN_EXPORT(js_name) \
+ (void)load { [[YMMPluginManager shared] registerPlugin:self supportModule:@#js_name];}

/// 注册bridge业务模块
#define MB_BRIDGE_PLUGIN_EXPORT(module, biz_name) \
+ (void)load { [[YMMPluginManager shared] registerPlugin:self supportModule:@#module bizName:@#biz_name];}

/// 注册 v2 bridge 业务模块
//#define MB_BRIDGE_TIGA_PLUGIN_EXPORT(module, biz_name) \
//+ (void)load { [[YMMPluginManager shared] registerTigaPlugin:self supportModule:@#module bizName:@#biz_name];}

/// 支持版本选择 注册 bridge 业务模块
//#define MB_BRIDGE_OPTION_PLUGIN_EXPORT(module, biz_name, option) \
//+ (void)load {\
//[[YMMPluginManager shared] registerPlugin:self supportModule:@#module bizName:@#biz_name protocol:option];\
//}

typedef void(^YMMMethodResponseBlock)(YMMMethodResponse *response);

@protocol YMMPluginProtocol <NSObject>

@optional
+ (NSString * _Nonnull)bizName;

/**
 设置方法访问权限
 注：该设置会覆盖 [bridgeAccessControlsForAllMethods] 权限设置
 @return 权控列表数据
         key: 方法名 比如-(void)methodA:(NSDictionary *)dic callback:void(^)(void)，传 methodA
         value：控制参数(具体值格式可查看对象属性注释)
 */
- (NSDictionary<NSString *, MBBridgeAccessModel *> *)bridgeAccessControlsForMethod;

/**
 设置当前类内所有bridge方法访问权限
 注：对plugin进行的权限设置优先级低于对特定方法的权限设置
 @return 权控数据，具体值格式可查看对象属性注释。
 */
- (MBBridgeAccessModel *)bridgeAccessControlsForAllMethods;

@end

NS_ASSUME_NONNULL_END
