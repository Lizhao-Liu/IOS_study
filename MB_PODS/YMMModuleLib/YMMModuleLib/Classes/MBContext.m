//
//  MBContext.m
//  YMMModuleLib
//
//  Created by Xiaohui on 2020/3/3.
//

#import "MBContext.h"

#import "MBService.h"
#import "MBModule.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBModuleInfo.h"
#import "MBModule.h"

///缺省模块优先级
static const NSInteger MODULE_PRIORITY_DEFAULT = 1000;

@implementation MBBaseContext

- (MBModuleInfo *)getModuleInfo {
    if (!_moduleInfo) {
        _moduleInfo = [MBModuleInfo new];
    }
    if (!_moduleInfo.moduleName || _moduleInfo.moduleName.length <= 0) {
        _moduleInfo.moduleName = @"app";
    }
    if (!_moduleInfo.bundleType || _moduleInfo.bundleType.length <= 0) {
        _moduleInfo.bundleType = @"native";
    }
    BOOL isBundleNameEmpty = !_moduleInfo.bundleName || _moduleInfo.bundleName.length <= 0;
    BOOL isBundleVersionEmpty = !_moduleInfo.bundleVersion || _moduleInfo.bundleVersion.length <= 0;
    if ([_moduleInfo.bundleType isEqualToString: @"native"] && (isBundleNameEmpty|| isBundleVersionEmpty)) {
        NSBundle *currentBundle = [NSBundle bundleForClass:MBBaseContext.class];
        if(currentBundle) {
            if (isBundleNameEmpty) {
                _moduleInfo.bundleName = currentBundle.bundleIdentifier;
            }
            if (isBundleVersionEmpty) {
                _moduleInfo.bundleVersion = [[currentBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            }
        }
    }
    return _moduleInfo;
}

@end

@interface MBModuleContext () {
    MBModuleInfo *_moduleInfo;
}

@end

@implementation MBModuleContext

- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (self) {
        _moduleInfo = [self createModuleInfoByClassName:className];
    }
    return self;
}

- (instancetype)initWithModuleName:(NSString *)moduleName {
    self = [super init];
    if (self) {
        _moduleInfo = [self createModuleInfoByModuleName:moduleName];
    }
    return self;
}



- (id<YMMServiceProtocol>)findServiceWithProtocol:(Protocol *)serviceProtocol {
    return [[MBService shared] takeOneServiceForProtocol:serviceProtocol
                                             fromContext:self];
}

- (id<YMMServiceProtocol> _Nullable)findServiceWithProtocol:(Protocol *)serviceProtocol withName:(nullable NSString *)serviceName {
    return [[MBService shared] takeOneServiceForProtocol:serviceProtocol withName:serviceName fromContext:self];
}

- (NSArray<id<YMMServiceProtocol>> *)findAllServicesWithProtocol:(Protocol *)serviceProtocol {
    return [[MBService shared] servicesForProtocol:serviceProtocol
                                       fromContext:self];
}

#pragma mark - private methods
- (MBModuleInfo *)createModuleInfoByClassName:(NSString *)className {
    Class moduleClass = NSClassFromString(className);
    MBModuleInfo *info = [MBModuleInfo new];
    info.moduleClassName = className;
    info.moduleClass = moduleClass;
    info.moduleName = [self moduleName:moduleClass];
    info.subModuleName = [self subModuleName:moduleClass];
    info.priority = [self priority:moduleClass];
    info.bundleName = [self bundleName:moduleClass];
    if (info.bundleName) {
        info.bundleType = [self bundleType:moduleClass];
        info.bundleVersion = [self bundleVersion:moduleClass];
    }
    return info;
}
    
- (MBModuleInfo *)createModuleInfoByModuleName:(NSString *)moduleName {
    MBModuleInfo *info = [MBModuleInfo new];
    info.moduleName = moduleName;
    info.priority = MODULE_PRIORITY_DEFAULT;
    info.bundleName = [self bundleName:nil];
    if (info.bundleName) {
        info.bundleType = [self bundleType:nil];
        info.bundleVersion = [self bundleVersion:nil];
    }
    return info;
}

- (NSString *)moduleName:(Class)moduleClass {
    NSString *moduleName = NSStringFromClass(moduleClass);
    if (class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))
        && [moduleClass respondsToSelector:@selector(moduleName)]) {
        moduleName = [moduleClass moduleName];
    }
    return moduleName;
}

- (NSString *)subModuleName:(Class)moduleClass {
    NSString *subModuleName = nil;
    if (class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))
        && [moduleClass respondsToSelector:@selector(subModuleName)]) {
        subModuleName = [moduleClass subModuleName];
    }
    return subModuleName;
}

- (NSUInteger)priority:(Class)moduleClass {
    if (class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))
        && [moduleClass respondsToSelector:@selector(priority)]) {
        return [moduleClass priority];
    }
    return MODULE_PRIORITY_DEFAULT;
}

- (NSString *)bundleName:(Class)moduleClass {
    if (class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))
        && [moduleClass respondsToSelector:@selector(bundleName)]) {
        return [moduleClass bundleName];
    } else {
        NSBundle *currentBundle = nil;
        if (moduleClass) {
            currentBundle = [NSBundle bundleForClass:moduleClass];
        } else {
            currentBundle = [NSBundle mainBundle];
        }
        if(currentBundle) {
            return currentBundle.bundleIdentifier;
        }
    }
    return nil;
}

- (NSString *)bundleType:(Class)moduleClass {
    if (class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))
        && [moduleClass respondsToSelector:@selector(bundleType)]) {
        return [moduleClass bundleType];
    } else {
        return @"native";
    }
}

- (NSString *)bundleVersion:(Class)moduleClass {
    if (class_conformsToProtocol(moduleClass, @protocol(YMMModuleProtocol))
        && [moduleClass respondsToSelector:@selector(bundleVersion)]) {
        return [moduleClass bundleVersion];
    } else {
        NSBundle *currentBundle = nil;
        if (moduleClass) {
            currentBundle = [NSBundle bundleForClass:moduleClass];
        } else {
            currentBundle = [NSBundle mainBundle];
        }
        if(currentBundle) {
            return [[currentBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        };
    }
    return nil;
}

#pragma mark - MBContextProtocol

- (MBModuleInfo *)getModuleInfo {
    return _moduleInfo;
}

@end

