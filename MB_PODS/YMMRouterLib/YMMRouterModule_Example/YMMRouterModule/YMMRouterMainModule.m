//
//  YMMRouterMainModule.m
//  YMMRouterModule_Example
//
//  Created by xp on 2021/4/22.
//  Copyright © 2021 knop. All rights reserved.
//

#import "YMMRouterMainModule.h"
@import YMMModuleLib;
@import MBFoundation;

@moduleEX(YMMRouterMainModule)

+ (nonnull NSString *)moduleName {
    return @"router_main";
}


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [MBToolsManager setupWithCompany:NO];
    return YES;
}

- (NSDictionary *)attachMBLaunchTaskConfigData {
    return @{};
}

- (void)onMBLaunchLogWithLevel:(MBLaunchLogLevel)level message:(nonnull NSString *)msg {
    
}

- (void)onMBLaunchReportSceneStatistics:(nonnull MBLaunchSceneStatistics *)statistics {
    
}

- (void)onMBLaunchReportTaskStatistics:(nonnull MBLaunchTaskItemStatistics *)statistics {
    
}

@end
