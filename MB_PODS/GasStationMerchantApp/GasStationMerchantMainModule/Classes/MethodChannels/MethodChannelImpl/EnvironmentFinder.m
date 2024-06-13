//
//  EnvironmentFinder.m
//  Runner
//
//  Created by heyAdrian on 2018/11/1.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "EnvironmentFinder.h"

@import YMMModuleLib;
@import HCBNetwork;
@import MBProjectConfig;

@implementation EnvironmentFinder

- (void)findEnvironment:(NSArray *)arguments {
    
    MBNetworkEnvironment networkType = [MBAppDelegate projectConfig].currentNetworkEnv;
    int serverEnv = 2;
    switch(networkType){
        case MBNetworkEnvironmentDev:
            serverEnv = 0;
            break;
        case MBNetworkEnvironmentQA:
            serverEnv = 1;
            break;
        default:
            serverEnv = 2;
    }
    
    !self.result ?: self.result(@(serverEnv));
    
}

@end
