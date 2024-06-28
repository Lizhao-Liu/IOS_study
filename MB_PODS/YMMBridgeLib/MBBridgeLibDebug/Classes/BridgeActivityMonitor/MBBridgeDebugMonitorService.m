//
//  MBBridgeDebugMonitorService.m
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/9/21.
//

#import "MBBridgeDebugMonitorService.h"
#import "MBBridgeDebugMonitorDataSource.h"
@import YMMModuleLib;
@import MBDebug;


#define MBBridgeMonitorSwitch @"bridgeMonitorSwitch"

@serviceEX(MBBridgeDebugMonitorService, MBDebugMonitorServiceProtocol)

@synthesize title;
@synthesize monitorVCBlock;
@synthesize isMonitoring;
@synthesize monitorStatusChangedBlock;

- (NSString *)title {
    return @"Bridge";
}

- (MBDebugMonitorPanelBlock)monitorVCBlock {
    return ^(){
        MBDebugActivityMonitorDefaultViewController *vc = [[MBDebugActivityMonitorDefaultViewController alloc] initWithDataSource:[MBBridgeDebugMonitorDataSource sharedDataSource]];
        return vc;
    };
}


- (BOOL)isMonitoring {
    return [MBBridgeDebugMonitorManager defaultManager].isMonitoring;
}

- (MBDebugMonitorStatusChangedBlock)monitorStatusChangedBlock {
    return ^(BOOL isOn){
        [MBBridgeDebugMonitorManager defaultManager].isMonitoring = isOn;
        if(!isOn){
            [[MBBridgeDebugMonitorDataSource sharedDataSource] clear];
        }
    };
}

- (void)monitorToolDidLoad {}

- (MBDebugMonitorPageInfoBlock)pageInfoBlock{
    return ^(UIViewController *pageVC){
        return [[MBBridgeDebugMonitorDataSource sharedDataSource] pageInfosWithPageVC:pageVC];
    };
}

@end


@implementation MBBridgeDebugMonitorManager

+ (instancetype) defaultManager {
    static dispatch_once_t once;
    static MBBridgeDebugMonitorManager *instance;
    dispatch_once(&once, ^{
        instance = [[MBBridgeDebugMonitorManager alloc] init];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:MBBridgeMonitorSwitch]) {
            instance.isMonitoring = [[NSUserDefaults standardUserDefaults] boolForKey:MBBridgeMonitorSwitch];
        } else {
            instance.isMonitoring = YES;
        }
    });
    return instance;
}


- (void)setIsMonitoring:(BOOL)isOn {
    _isMonitoring = isOn;
    [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey:MBBridgeMonitorSwitch];
}

@end
