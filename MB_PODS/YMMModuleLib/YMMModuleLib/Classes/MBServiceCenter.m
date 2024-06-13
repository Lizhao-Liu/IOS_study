//
//  MBServiceManager.m
//  YMMModuleLib
//
//  Created by Lizhao on 2023/3/6.
//

#import "MBServiceCenter.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBContext.h"
#include <pthread/pthread.h>
#import "MBModuleLogger.h"
#import "YMMModuleManager.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>

@import MBBuildPreLib;

@interface MBServiceCenter (){
    NSMutableDictionary<NSString *, NSMutableArray *> *_serviceClassDict;
    NSMutableDictionary<NSString *, id<YMMServiceProtocol>> *_serviceDict;
    pthread_mutex_t _mutex;
    dispatch_semaphore_t _serviceClassDictSema;
}
@end

@implementation MBServiceCenter

- (id)init {
    self = [super init];
    if (self) {
        _serviceClassDict = [[NSMutableDictionary alloc] init];
        _serviceDict = [[NSMutableDictionary alloc] init];
        _serviceClassDictSema = dispatch_semaphore_create(1);
        [self initMutex];
    }
    return self;
}


/// 初始化递归锁
- (void)initMutex {
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&_mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
}

#pragma mark - 服务注册

- (void)registerServiceOfProtocolStr: (NSString *)serviceProtocolStr withImplClassStr:(NSString *)serviceImplStr {
    Protocol *serviceProtocol = NSProtocolFromString(serviceProtocolStr);
    Class serviceImplClass = NSClassFromString(serviceImplStr);
    if(serviceProtocol && serviceImplClass){
        [self registerServiceOfProtocol:serviceProtocol withImplClass:serviceImplClass];
    }
}

- (void)registerServiceOfProtocol: (Protocol *)serviceProtocol withImplClass: (Class)serviceImplClass {
    NSAssert([serviceImplClass conformsToProtocol:serviceProtocol], @"%@ must implement %@!", NSStringFromClass(serviceImplClass), NSStringFromProtocol(serviceProtocol));
    if (![serviceImplClass conformsToProtocol:serviceProtocol]) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@ service doesn't implement %@",  NSStringFromClass(serviceImplClass), NSStringFromProtocol(serviceProtocol)] extra:nil];
    }
    // NSAssert(protocol_conformsToProtocol(serviceProtocol, @protocol(YMMServiceProtocol)), @"%@ must implement YMMServiceProtocol!", NSStringFromProtocol(serviceProtocol));
    dispatch_semaphore_wait(_serviceClassDictSema, DISPATCH_TIME_FOREVER);
    NSString *key = NSStringFromProtocol(serviceProtocol);
    id object = [_serviceClassDict objectForKey:key];
    NSMutableArray *serviceClassList = nil;
    if (object) {
        if ([object isKindOfClass:[NSMutableArray class]]) {
            serviceClassList = (NSMutableArray *)object;
        }
    }
    if (!serviceClassList) {
        serviceClassList = [NSMutableArray array];
        [_serviceClassDict setObject:serviceClassList forKey:key];
    }
    if (![serviceClassList containsObject:serviceImplClass]) {
        [serviceClassList addObject:serviceImplClass];
    }
    dispatch_semaphore_signal(_serviceClassDictSema);
}

- (void)registerAllServicesWithImplClassStr: (NSString *)serviceImplStr {
    Class serviceImplClass = NSClassFromString(serviceImplStr);
    NSAssert(serviceImplClass != nil, @"%@ is not found!", serviceImplStr);
    if (!serviceImplClass) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@ service doesn't be found", serviceImplStr] extra:nil];
    }
    [self registerAllServicesOfProtocol:nil withImplClass:serviceImplClass];
}

- (void)registerAllServicesOfProtocol:(Protocol * _Nullable)baseServiceProtocol withImplClass:(Class)serviceImplClass {
    if(!baseServiceProtocol){
        baseServiceProtocol = @protocol(YMMServiceProtocol);
    }
    NSArray *serviceProtocolList = [self protocolListOfClass:serviceImplClass withBaseProtocol:baseServiceProtocol];
    NSAssert(serviceProtocolList.count > 0, @"%@ must implement %@!", NSStringFromClass(serviceImplClass), NSStringFromProtocol(baseServiceProtocol));
    if (serviceProtocolList.count <= 0) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@ service doesn't implement %@",  NSStringFromClass(serviceImplClass), NSStringFromProtocol(baseServiceProtocol)] extra:nil];
    }
    for (Protocol *serviceProtocol in serviceProtocolList) {
        [self registerServiceOfProtocol:serviceProtocol withImplClass:serviceImplClass];
    }
}

#pragma mark - 服务发现

- (id<YMMServiceProtocol> _Nullable)serviceOfProtocol:(Protocol *)serviceProtocol fromContext:(nullable id<MBContextProtocol>)context {
    return [self serviceOfProtocol:serviceProtocol withName:nil fromContext:context];
}

- (id<YMMServiceProtocol> _Nullable)serviceOfProtocol:(Protocol *)serviceProtocol withName:(nullable NSString *)serviceName fromContext:(nullable id<MBContextProtocol>)context {
    NSArray *services = [self servicesOfProtocol:serviceProtocol withName:serviceName fromContext:context];
    if (!services || services.count <= 0) {
        return nil;
    }
    NSAssert(services.count == 1, @"more than one service!(%@)", NSStringFromProtocol(serviceProtocol));
    if (services.count > 1) {
        [MBModuleLogger errorLog:[NSString stringWithFormat:@"%@ more than one service", NSStringFromProtocol(serviceProtocol)] extra:nil];
    }
    return services.firstObject;
}

- (NSArray<id<YMMServiceProtocol>> * _Nullable)servicesOfProtocol:(Protocol *)serviceProtocol fromContext:(nullable id<MBContextProtocol>)context {
    return [self servicesOfProtocol:serviceProtocol withName:nil fromContext:context];
}

- (NSArray<id<YMMServiceProtocol>> * _Nullable)servicesOfProtocol:(Protocol *)serviceProtocol withName:(nullable NSString *)serviceName fromContext:(nullable id<MBContextProtocol>)context {
    if (![MBFMacro ymm_buildRelease]) {
        [[MBModule shared]validateContext:context];
    }
    // NSAssert(protocol_conformsToProtocol(serviceProtocol, @protocol(YMMServiceProtocol)), @"%@ must implement YMMServiceProtocol", NSStringFromProtocol(serviceProtocol));
    NSArray *serviceClassList = [self serviceClassListOfServiceProtocol:serviceProtocol];
    if(serviceClassList && serviceClassList.count > 0){
        return [self servicesWithClassList:serviceClassList withName:serviceName fromContext:context];
    } else {
        return nil;
    }
}

#pragma mark - private methods

//获取服务实现类类名数组
- (NSArray * _Nullable)serviceClassListOfServiceProtocol:(Protocol *)serviceProtocol {
    NSString *protocolStr = NSStringFromProtocol(serviceProtocol);
    dispatch_semaphore_wait(_serviceClassDictSema, DISPATCH_TIME_FOREVER);
    id object = [_serviceClassDict objectForKey:protocolStr];
    dispatch_semaphore_signal(_serviceClassDictSema);
    if (object && [object isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *serviceClassList = (NSMutableArray *)object;
        return serviceClassList;
    }
    // if ([MBFMacro ymm_buildRelease]){ //线上环境: 执行兜底方法，通过运行时查询所有实现协议的类，并执行注册
    //     return [self implClassesInBundleForServiceProtocol:protocolStr];
    // }
//    return [self implClassesInBundleForServiceProtocol:protocolStr];
    return nil;
}

- (NSArray * _Nullable)implClassesInBundleForServiceProtocol:(NSString *)protocolStr {
    static dispatch_once_t onceToken;
    static NSMutableDictionary<NSString *, NSMutableArray *> *globalUnRegisteredServiceClassDict;
    dispatch_once(&onceToken, ^{
        globalUnRegisteredServiceClassDict = [self unRegisteredServiceClassDict];
    });
    return [globalUnRegisteredServiceClassDict objectForKey:protocolStr];
}

//获取服务实现实例数组
- (NSArray<id<YMMServiceProtocol>> * _Nullable)servicesWithClassList:(NSArray *)serviceClassList withName:(nullable NSString *)serviceName fromContext:(nullable id<MBContextProtocol>)context {
    NSMutableArray *services = [NSMutableArray array];
    pthread_mutex_lock(&_mutex);
    for (Class serviceClass in serviceClassList) {
        NSString * serviceClassKey = NSStringFromClass(serviceClass);
        id<YMMServiceProtocol> service = nil;
        if((![MBServiceCenter isNilOrEmpty:serviceName]) && [serviceClass respondsToSelector:@selector(serviceName)]) {
            NSString *foundServiceName = [serviceClass performSelector:@selector(serviceName)];
            if(![MBServiceCenter isNilOrEmpty:foundServiceName] && ![serviceName isEqualToString:foundServiceName]) {
                continue;
            }
        }
        if ([serviceClass respondsToSelector:@selector(singleton)] && [serviceClass singleton]) {
            service = [_serviceDict objectForKey:serviceClassKey];
            if (!service) {
                service = [[serviceClass alloc] init];
                [_serviceDict setObject:service forKey:serviceClassKey];
            }
            [services addObject: service];
        } else {
            service = [[serviceClass alloc] init];
            [services addObject:service];
        }
        if (service && [service respondsToSelector:@selector(setFromContext:)]) {
            service.fromContext = context;
        }
    }
    pthread_mutex_unlock(&_mutex);
    return services;
}

#pragma mark - runtime helpers

- (NSArray *)protocolListOfClass:(Class)implClass withBaseProtocol:(Protocol * _Nullable)baseProtocol {
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(implClass, &count);
    if(count <= 0) {
        return @[];
    }
    NSMutableArray *resultProtocolList = [NSMutableArray array];
    if (protocolList) {
        for (unsigned int i = 0; i<count; i++) {
            NSArray *foundProtocols = [self protocolListOfProtocol:protocolList[i] withBaseProtocol:baseProtocol];
            if (foundProtocols) {
                [resultProtocolList addObjectsFromArray:foundProtocols];
            }
        }
        free(protocolList);
    }
    if (resultProtocolList.count <= 0) {
        return @[];
    }
    return resultProtocolList;
}

- (NSArray *)protocolListOfProtocol:(Protocol *)protocol withBaseProtocol:(Protocol *)baseProtocol{
    if (!protocol) {
        return nil;
    }
    NSMutableArray *resultProtocolList = [NSMutableArray array];
    if (protocol_conformsToProtocol(protocol, baseProtocol)) {
        [resultProtocolList addObject:protocol];
        return resultProtocolList;
    }
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = protocol_copyProtocolList(protocol, &count);
    if (protocolList) {
        for (unsigned int i = 0; i<count; i++) {
            NSArray *foundProtocols = [self protocolListOfProtocol:protocolList[i] withBaseProtocol:baseProtocol];
            if (foundProtocols) {
                [resultProtocolList addObjectsFromArray:foundProtocols];
            }
        }
        free(protocolList);
    }
    return resultProtocolList;
}

- (NSMutableDictionary<NSString *,NSMutableArray *> *)unRegisteredServiceClassDict {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary<NSString *, NSMutableArray *> *_unRegisteredServiceClassDict = @{}.mutableCopy;
    unsigned int classCount;
    const char **classes;
    Dl_info info;

    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &classCount);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_apply(classCount, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSString *className = [NSString stringWithCString:classes[index] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        NSArray *serviceProtocolList = [self protocolListOfClass:class withBaseProtocol:@protocol(YMMServiceProtocol)];
        for (Protocol *serviceProtocol in serviceProtocolList) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSString *key = NSStringFromProtocol(serviceProtocol);
            id object = [_unRegisteredServiceClassDict objectForKey:key];
            NSMutableArray *serviceClassList = nil;
            if (object) {
                if ([object isKindOfClass:[NSMutableArray class]]) {
                    serviceClassList = (NSMutableArray *)object;
                }
            }
            if (!serviceClassList) {
                serviceClassList = [NSMutableArray array];
                [_unRegisteredServiceClassDict setObject:serviceClassList forKey:key];
            }
            if (![serviceClassList containsObject:class]) {
                [serviceClassList addObject:class];
            }
            dispatch_semaphore_signal(semaphore);
        }
    });
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"方法耗时: %f ms", endTime * 1000.0);
    return _unRegisteredServiceClassDict;
}

#pragma mark - utility methods

+ (BOOL)isNilOrEmpty:(NSString *)str {
    if (!str || ![str isKindOfClass:[NSString class]] || str.length == 0) {
        return YES;
    }
    return NO;
}

@end
