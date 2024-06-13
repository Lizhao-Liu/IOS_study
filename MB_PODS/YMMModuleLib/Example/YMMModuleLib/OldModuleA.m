//
//  OldModuleA.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import "OldModuleA.h"
#import <YMMModuleLib/YMMModuleManager.h>
#import "SingletonServiceC.h"

@interface OldModuleA ()<YMMModuleProtocol>

@end

//@module(OldModuleA)
@implementation OldModuleA

+ (NSUInteger)priority {
    return 5000;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __func__);
//    id<ServiceZProtocol> serviceZ3 = FIND_SERVICE(ServiceZProtocol);
//    [serviceZ3 testServiceZ];
//    
//    id<ServiceZProtocol> serviceZ4 = FIND_SERVICE(ServiceZProtocol);
//    [serviceZ4 testServiceZ];
    
    return YES;
}

@end
