//
//  MBBridgeDebugMonitorDataSource.m
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/11/25.
//

#import "MBBridgeDebugMonitorDataSource.h"
@import MBDebug;

@implementation MBBridgeDebugMonitorDataSource

+ (MBDebugMonitorLogDataSource *)sharedDataSource {
    static dispatch_once_t once;
    static MBDebugMonitorLogDataSource *instance;
    dispatch_once(&once, ^{
        instance = [[MBDebugMonitorLogDataSource alloc] initWithMonitorTitle:@"Bridge"];
        instance.countLimit = 500;
    });
    return instance;
}

@end
