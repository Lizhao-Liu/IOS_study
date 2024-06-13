//
//  YMMModuleManager.h
//  YMMModuleLib
//
//  Created by Xiaohui on 2018/6/12.
//

//#ifndef YMMModuleManager_h
//#define YMMModuleManager_h

#import "MBModule.h"
#import "MBService.h"
#import "MBContext.h"
#import "MBAppDelegate.h"

#pragma mark - 模块管理类
@interface YMMModuleManager: NSObject

+ (instancetype)sharedManager;

//通过模块名称和服务协议查找服务实例
//@parameter moduleName - 服务所属模块名称
//@parameter serviceProtocol - 服务协议
//@return 服务实例
- (id)serviceForModuleName:(NSString *)moduleName andProtocol:(Protocol *)serviceProtocol DEPRECATED_MSG_ATTRIBUTE("Use [MBService takeOneServiceForProtocol:fromContext:] instead");

//取第0个符合指定服务协议的实例
//@parameter serviceProtocol - 服务协议
//@return 服务实例
- (id)takeOneServiceForProtocol:(Protocol *)serviceProtocol DEPRECATED_MSG_ATTRIBUTE("Use [MBService takeOneServiceForProtocol:fromContext:] instead");

//取所有符合指定服务协议的实例
//@parameter serviceProtocol - 服务协议
//@return 服务实例列表
- (NSArray *)servicesForProtocol:(Protocol *)serviceProtocol DEPRECATED_MSG_ATTRIBUTE("Use [MBService servicesForProtocol:fromContext:] instead");

@end

//#endif /* YMMModuleManager_h */
