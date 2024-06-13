//
//  MBService.h
//  YMMModuleLib
//
//  Created by Xiaohui on 2020/4/10.
//

#import <Foundation/Foundation.h>
#import "MBContext.h"
#import "YMMModuleManager.h"
#import "MBServiceCenter.h"

NS_ASSUME_NONNULL_BEGIN

//（已弃用）导出模块服务类（已弃用）
//@parameter service_impl - 服务实现
#define service($service_impl) \
class NSObject; \
char * k_service_##$service_impl \
__attribute((used, section("__DATA, YMMServices"))) = ""#$service_impl"";

//（已弃用）找到服务接口多个实现
#define FIND_SERVICE_LIST($service_protocol) \
    [[YMMModuleManager sharedManager] servicesForProtocol:@protocol($service_protocol)]

//服务注册
//@parameter $service_impl - 服务实现
//@parameter $service_protocol - 服务协议
#define serviceEX($service_impl, $service_protocol) \
class NSObject; \
char * k_service_##$service_impl \
__attribute((used, section("__DATA, YMMServiceEX"))) = ""#$service_impl","#$service_protocol""; \
@implementation $service_impl \
@synthesize fromContext;

#define serviceComposeEX($service_impl) \
class NSObject; \
char * k_service_##$service_impl \
__attribute((used, section("__DATA, YMMServices"))) = ""#$service_impl""; \
@implementation $service_impl \
@synthesize fromContext;

#define BIND_SERVICE($context, $service_protocol) \
(id<$service_protocol>)[[MBService shared] takeOneServiceForProtocol:@protocol($service_protocol) fromContext:$context];

#define GET_SERVICE($moduleClass, $service_protocol) \
(id<$service_protocol>)[[MBModule contextOf:$moduleClass] findServiceWithProtocol:@protocol($service_protocol)];

#define BIND_SPECIFIED_SERVICE($context, $service_protocol, $service_name) \
(id<$service_protocol>)[[MBService shared] takeOneServiceForProtocol:@protocol($service_protocol) withName:$service_name fromContext:$context];

#define BIND_ALL_SERVICES($context, $service_protocol) \
(NSArray<id<$service_protocol>> *)[[MBService shared] servicesForProtocol:@protocol($service_protocol) fromContext:$context];


@interface MBService: NSObject

+ (instancetype)shared;


/// 设置service白名单，未设置时全部注册的service在获取service都能找到，否则只能找到白名单中的
/// @param protocolWhiteList service协议白名单
- (void)setServiceWhiteList:(NSArray<Protocol *> *)protocolWhiteList;

//注册服务类
//@parameter service - 服务实现类
- (void)registerServiceImplStr:(NSString *)serviceImplStr forProtocolStr:(NSString *)serviceProtocolStr;

- (void)registerServiceImplStr:(NSString *)serviceStr;

- (void)registerServiceImplClass:(Class)ServiceImplClass forProtocol:(Protocol *)serviceProtocol;

//通过模块名称和服务协议查找服务实例
//@parameter moduleName - 服务所属模块名称
//@parameter serviceProtocol - 服务协议
//@return 服务实例
- (id<YMMServiceProtocol> _Nullable)takeOneServiceForProtocol:(Protocol *)serviceProtocol
                                        fromContext:(nullable id<MBContextProtocol>)context;


/// 通过服务协议和服务名称查找服务实例
/// @param serviceProtocol - 服务协议
/// @param serviceName - 服务名称，唯一标识
/// @param context 调用模块信息
- (id<YMMServiceProtocol> _Nullable)takeOneServiceForProtocol:(Protocol *)serviceProtocol withName:(nullable NSString *)serviceName fromContext:(nullable id<MBContextProtocol>)context;

- (NSArray<id<YMMServiceProtocol>> * _Nullable)servicesForProtocol:(Protocol *)serviceProtocol
                                             fromContext:(nullable id<MBContextProtocol>)context;

@end

NS_ASSUME_NONNULL_END
