//
//  MBShipperXXXAdapterModule.m
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import "MBShipperXXXAdapterModule.h"
#import "MBShipperXXXAdapter.h"
#import "MBXXXModuleAdapterProtocol.h"
#import "MBXXXModuleAdapterUniqueProtocol.h"
#import "YMMModuleLib_Example-Swift.h"

@moduleEX(MBShipperXXXAdapterModule)

+ (nonnull NSString *)moduleName {
    return @"xxx";
}

// 注册adapter
- (void)moduleDidSetup {
    // 服务注册
    // Note: adapter module 通过实现 YMMModuleProtocol 自定义注册adapter的时机方法，本实例在moduleDidSetup时机进行注册。
    [[MBAdapter shared] registerAdapterOfProtocol:@protocol(MBXXXModuleAdapterProtocol) usedImplClass:[MBShipperXXXAdapter class]];
    // Note: adapter module 通过实现 YMMModuleProtocol 自定义注册adapter的时机方法，本实例在moduleDidSetup时机进行注册。
    [[MBAdapter shared] registerAdapterOfProtocol:@protocol(MBShipperXXXAdapterProtocol) usedImplClass:[MBShipperXXXAdapterUnique class]];
    NSLog(@"注册adapter成功");
}



@end
