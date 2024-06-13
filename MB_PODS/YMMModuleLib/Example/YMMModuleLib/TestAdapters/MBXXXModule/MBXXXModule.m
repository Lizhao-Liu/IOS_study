//
//  MBXXXModule.m
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import "MBXXXModule.h"
#import "MBXXXModuleAdapterProtocol.h"
#import "MBXXXModuleAdapterUniqueProtocol.h"

@moduleEX(MBXXXModule)

GET_ADAPTER([MBXXXModule getContext], MBShipperXXXAdapterProtocol, shipperAdapter)
GET_ADAPTER([MBXXXModule getContext], MBXXXModuleAdapterProtocol, commonAdapter)

+ (nonnull NSString *)moduleName { 
    return @"xxx";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [[self commonAdapter] run];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[self commonAdapter] run];
    [[self shipperAdapter] runShipper];
}

- (void)targetMethodToRun {
    NSLog(@"did run a target method");
}


@end
