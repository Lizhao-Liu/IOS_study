//
//  MBDriverXXXAdapterModule.m
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import "MBDriverXXXAdapterModule.h"
#import "MBDriverXXXAdapter.h"
#import "MBXXXModuleAdapterProtocol.h"
//@import MBXXXModule;


@moduleEX(MBDriverXXXAdapterModule)

+ (nonnull NSString *)moduleName {
    return @"xxx";
}

- (void)moduleDidSetup {
    // 服务注册
    // Note: adapter module 通过实现 YMMModuleProtocol 自定义注册adapter的实际。
//    [[MBAdapter shared] registerAdapterOfProtocol:@protocol(MBXXXModuleAdapterProtocol) usedImplClass:[MBDriverXXXAdapter class]];
}

@end
