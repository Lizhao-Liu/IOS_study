//
//  MBService.m
//  YMMModuleLib
//
//  Created by Xiaohui on 2020/4/10.
//

#import "MBService.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBContext.h"
#include <pthread/pthread.h>
#import "MBModuleLogger.h"
#import "MBServiceCenter.h"

@import MBBuildPreLib;

@interface MBService () {
    NSArray<Protocol *> *_serviceProtocolWhiteList;
}

@property (nonatomic, strong) MBServiceCenter *serviceManager;

@end


@implementation MBService

+ (instancetype)shared {
    static id shared = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shared = [[MBService alloc] init];
    });
    return shared;
}

- (id)init {
    self = [super init];
    if (self) {
        _serviceManager = [[MBServiceCenter alloc] init];
    }
    return self;
}

#pragma mark - white list

- (void)setServiceWhiteList:(NSArray<Protocol *> *)protocolWhiteList {
    _serviceProtocolWhiteList = protocolWhiteList;
}

- (void)registerServiceImplStr:(NSString *)serviceImplStr {
    [self.serviceManager registerAllServicesWithImplClassStr:serviceImplStr];
}

//注册服务
- (void)registerServiceImplStr:(NSString *)serviceImplStr
                forProtocolStr:(NSString *)serviceProtocolStr {
    [self.serviceManager registerServiceOfProtocolStr:serviceProtocolStr withImplClassStr:serviceImplStr];
}

- (void)registerServiceImplClass:(Class)serviceImplClass
                     forProtocol:(Protocol *)serviceProtocol {
    [self.serviceManager registerServiceOfProtocol:serviceProtocol withImplClass:serviceImplClass];
}

- (id<YMMServiceProtocol>)takeOneServiceForProtocol:(Protocol *)serviceProtocol
                                        fromContext:(nullable id<MBContextProtocol>)context {
    return [self takeOneServiceForProtocol:serviceProtocol withName:nil fromContext:context];
}

- (id<YMMServiceProtocol>)takeOneServiceForProtocol:(Protocol *)serviceProtocol withName:(NSString *)serviceName fromContext:(id<MBContextProtocol>)context {
    if (_serviceProtocolWhiteList && _serviceProtocolWhiteList.count > 0) {
        if (![_serviceProtocolWhiteList containsObject:serviceProtocol]) {
            return nil;
        }
    }
    id<YMMServiceProtocol> service = [self.serviceManager serviceOfProtocol:serviceProtocol withName:serviceName fromContext:context];
    if(service == nil) {
    // 未找到已注册的实现类
    [MBModuleLogger errorLog:[NSString stringWithFormat:@"service [%@] not found", NSStringFromProtocol(serviceProtocol)] extra:nil]; // 错误日志
    }
    
    return service;
}

- (NSArray<id<YMMServiceProtocol>> *)servicesForProtocol:(Protocol *)serviceProtocol fromContext:(nullable id<MBContextProtocol>)context {
    return [self servicesForProtocol:serviceProtocol withName:nil fromContext:context];
}

- (NSArray<id<YMMServiceProtocol>> *)servicesForProtocol:(Protocol *)serviceProtocol withName:(nullable NSString *)serviceName
                                             fromContext:(nullable id<MBContextProtocol>)context {
    if (_serviceProtocolWhiteList && _serviceProtocolWhiteList.count > 0) {
        if (![_serviceProtocolWhiteList containsObject:serviceProtocol]) {
            return nil;
        }
    }
    NSArray<id<YMMServiceProtocol>> *services = [self.serviceManager servicesOfProtocol:serviceProtocol withName:serviceName fromContext:context];
    if(services == nil){
        // 未找到已注册的实现类
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"service [%@] not found", NSStringFromProtocol(serviceProtocol)] extra:nil]; // 错误日志
    }
    return services;
}

@end
