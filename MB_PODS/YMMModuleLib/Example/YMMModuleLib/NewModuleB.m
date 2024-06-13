//
//  NewModuleB.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import "NewModuleB.h"
#import <YMMModulelib/YMMModuleManager.h>
#import "OldServiceA.h"
#import "NewServiceB.h"
#import "SingletonServiceC.h"

@interface NewModuleB ()<YMMModuleProtocol>

@end

@moduleEX(NewModuleB)

+ (NSUInteger)priority {
    return 1000;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __func__);
//    id<ServiceXProtocol> serviceX1 = FIND_SERVICE(ServiceXProtocol);
//    [serviceX1 testServiceX];
//
//    id<ServiceXProtocol> serviceX2 = BIND_SERVICE([NewModuleB getContext], ServiceXProtocol);
//    [serviceX2 testServiceX];
//
//    id<ServiceYProtocol> serviceY1 = FIND_SERVICE(ServiceYProtocol);
//    [serviceY1 testServiceY];
//
//    id<ServiceYProtocol> serviceY2 = BIND_SERVICE([NewModuleB getContext], ServiceYProtocol);
//    [serviceY2 testServiceY];
    
    id<ServiceZProtocol> serviceZ1 = BIND_SERVICE([NewModuleB getContext], ServiceZProtocol);
    [serviceZ1 testServiceZ];
    
    id<ServiceZProtocol> serviceZ2 = BIND_SERVICE([NewModuleB getContext], ServiceZProtocol);
    [serviceZ2 testServiceZ];
    
//    id<ServiceZProtocol> serviceZ3 = BIND_SERVICE([MBModule shared].defaultContext, ServiceZProtocol);
//    [serviceZ3 testServiceZ];

    return YES;
}

@end
