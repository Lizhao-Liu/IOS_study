//
//  BeforeLifecycle.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/1.
//  Copyright © 2020 knop. All rights reserved.
//

#import "BeforeLifecycle.h"

@implementation BeforeLifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __func__);
    return YES;
}

@end
