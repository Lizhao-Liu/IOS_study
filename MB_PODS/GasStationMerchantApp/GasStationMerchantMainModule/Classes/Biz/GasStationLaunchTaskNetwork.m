//
//  GasStationLaunchTaskNetwork.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2024/2/20.
//

#import "GasStationLaunchTaskNetwork.h"
@import MBLauncherLib;
@import MBNetworkLib;
@import MBAppBasisModule;



@MBLaunchTaskEX(GasStationLaunchTaskNetwork)

@interface GasStationLaunchTaskNetwork() <MBLaunchTask>

@end


@implementation GasStationLaunchTaskNetwork


- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneBasicSDK;
}

- (MBLaunchPriority)taskPriority {
    return MBMainLaunchBasicTaskPriorityNetwork;
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    [[YMMNetworkScheduler sharedInstance] setStartRefreshEnd];
    return YES;
}

- (nonnull NSString *)taskName {
    return @"network_config";
}


@end
