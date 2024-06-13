//
//  MBContext.h
//  YMMModuleLib
//
//  Created by Xiaohui on 2020/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMMServiceProtocol;
@class MBModuleInfo;

///上下文协议
@protocol MBContextProtocol <NSObject>

@required

/// 获取模块信息，此方法必须实现
- (MBModuleInfo *)getModuleInfo;

@end

@interface MBBaseContext : NSObject<MBContextProtocol>

@property (nonatomic, strong, getter=getModuleInfo) MBModuleInfo *moduleInfo;

@end


///模块上下文
@interface MBModuleContext : NSObject<MBContextProtocol>

///模块名称
@property (nonatomic, copy, readonly) NSString *moduleName;

- (instancetype)initWithClassName:(NSString *)className;

- (instancetype)initWithModuleName:(NSString *)moduleName;

/// 查找服务实现
/// @param serviceProtocol 需要查找实现的服务协议
/// @return 返回找到的服务实现
- (id)findServiceWithProtocol:(Protocol *)serviceProtocol;

/// 通过服务协议和服务名称查找服务实现
/// @param serviceProtocol - 服务协议
/// @param serviceName - 服务名称，唯一标识
- (id<YMMServiceProtocol> _Nullable)findServiceWithProtocol:(Protocol *)serviceProtocol withName:(nullable NSString *)serviceName;

/// 查找所有服务实现
/// @param serviceProtocol 需要查找实现的服务协议
/// @return 返回找到的所有服务实现
- (NSArray *)findAllServicesWithProtocol:(Protocol *)serviceProtocol;

@end

NS_ASSUME_NONNULL_END
