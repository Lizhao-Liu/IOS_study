//
//  YMMModuleManager.m
//  YMMModuleLib
//
//  Created by Xiaohui on 2018/6/12.
//

#import "YMMModuleManager.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <mach-o/ldsyms.h>
#include <dlfcn.h>
#import "MBModule.h"
#import "MBService.h"
#import "MBModuleInfo.h"


@interface YMMModuleManager()<MBContextProtocol>

@end


@implementation YMMModuleManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YMMModuleManager alloc] init];
    });
    return sharedManager;
}

- (id)serviceForModuleName:(NSString *)moduleName andProtocol:(Protocol *)serviceProtocol {
    return [self takeOneServiceForProtocol: serviceProtocol];
}

- (id)takeOneServiceForProtocol:(Protocol *)serviceProtocol {
    return [[MBService shared] takeOneServiceForProtocol:serviceProtocol
                                             fromContext:self];
}

- (NSArray *)servicesForProtocol:(Protocol *)serviceProtocol {
    return [[MBService shared] servicesForProtocol:serviceProtocol
                                       fromContext:self];
}

#pragma mark - MBContextProtocol

- (MBModuleInfo *)getModuleInfo {
    MBModuleInfo *moduleInfo = [MBModuleInfo new];
    moduleInfo.moduleName = @"app";
    moduleInfo.subModuleName = @"DEPRECATED";
    return moduleInfo;
}

- (NSString *)name {
    return @"app";
}

#pragma mark - Module和Service注册处理
NSArray<NSString *>* LoadAnnotationData(char *sectionName,const struct mach_header *mhp);
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    //解析SEG_DATA中标注的module
    NSArray *modules = LoadAnnotationData("YMMModules", mhp);
    for (NSString *module in modules) {
        if (!module || module.length <= 0) {
            continue;
        }
        [[MBModule shared] registerModule:module];
    }
    
    //解析SEG_DATA中标注的service
    NSArray *services = LoadAnnotationData("YMMServices", mhp);
    for (NSString *service in services) {
        if (!service || service.length <= 0) {
            continue;
        }
        [[MBService shared] registerServiceImplStr:service];
    }
    
    //解析SEG_DATA中标注的service
    NSArray *servicesEX = LoadAnnotationData("YMMServiceEX", mhp);
    for (NSString *service in servicesEX) {
        if (!service || service.length <= 0) {
            continue;
        }
        NSArray<NSString *> *serviceArray = [service componentsSeparatedByString:@","];
        if (serviceArray.count == 2) {
            [[MBService shared] registerServiceImplStr:serviceArray[0]
                                        forProtocolStr:serviceArray[1]];
        }
    }
}

__attribute__((constructor))
void init(void) {

    _dyld_register_func_for_add_image(dyld_callback);
}

//解析SEG_DATA中标注的内容
NSArray<NSString *>* LoadAnnotationData(char *sectionName, const struct mach_header *mhp) {
    NSMutableArray *annotationList = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long count = size/sizeof(void*);
    for(int idx = 0; idx < count; ++idx) {
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(str == nil)
            continue;
        [annotationList addObject:str];
    }
    return annotationList;
}

@end
