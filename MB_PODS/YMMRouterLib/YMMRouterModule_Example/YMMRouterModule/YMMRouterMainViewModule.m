//
//  YMMRouterMainViewModule.m
//  YMMRouterModule_Example
//
//  Created by xp on 2021/4/22.
//  Copyright © 2021 knop. All rights reserved.
//

#import "YMMRouterMainViewModule.h"
#import "YMMViewController.h"
@import MBRouterDebug;

@moduleEX(YMMRouterMainViewModule)

+ (nonnull NSString *)moduleName {
    return @"router_demo_view";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:[[YMMRouterDebugViewController alloc]init]];
    UIWindow *window = application.delegate.window;
    [window setRootViewController:navigationVC];
    [window makeKeyAndVisible];
    return YES;
}

@end
