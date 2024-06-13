//
//  YMMRouterDebugMonitorDataSource.m
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/11/28.
//

#import "YMMRouterDebugMonitorDataSource.h"
#import "MBRouterDebugMonitorDefine.h"
@import MBDebug;

@implementation YMMRouterDebugMonitorDataSource

+ (MBDebugMonitorLogDataSource *)sharedDataSource{
    static dispatch_once_t once;
    static MBDebugMonitorLogDataSource *instance;
    dispatch_once(&once, ^{
        instance = [[MBDebugMonitorLogDataSource alloc] initWithMonitorTitle:MBRouterDebugMonitorTitle];
        instance.countLimit = 500;
    });
    return instance;
}

@end
