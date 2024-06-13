//
//  MBAPMMatrixPlugin.m
//  MBAPMLib
//
//  Created by xp on 2022/5/25.
//

#import "MBAPMMatrixPlugin.h"
#import "MBMatrixWechatManager.h"
#import "MBAPMContext.h"
#import "MBAPMLogDef.h"
#import "MBDeviceInfo.h"
@import MBAPMServiceLib;

@implementation MBAPMMatrixPlugin

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagMatrix;
}

- (void)start {
    [super start];
    if (![MBDeviceInfo canEnableMonitor]) {
        MBAPMLogInfo(@"matrix can't be started on simulator or debugging status");
        return;
    }
    MBMatrixConfig *config = [MBMatrixConfig new];
    config.enableCrashMonitor = self.context.configuration.enableCrashMonitor;
    config.enableBlockMonitor = self.context.configuration.enableLagMonitor & (self.context.configuration.lagChannel == MBAPMReportChannelMatrix);
    BOOL enableFOOMMonitor = self.context.configuration.enableFOOMMonitor;
    MBAPMLogInfo(@"matrix plugin start enableCrashMonitor = %d, enableBlockMonitor = %d, enableFOOMMonitor = %d", config.enableCrashMonitor, config.enableBlockMonitor, enableFOOMMonitor);
    NSDictionary *momeryConfigDic =
    @{@"skipMinMallocSize": @(self.context.configuration.foomConfigSkipMinMallocSize ?: (int)vm_page_size),
      @"skipMaxStackDepth": @(self.context.configuration.foomConfigSkipMaxStackDepth ?: 8),
      @"dumpCallStacks": @(self.context.configuration.foomConfigDumpCallStacks ?: 1),
      @"reportStrategy": @(self.context.configuration.foomConfigReportStrategy ?: 0)};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (enableFOOMMonitor) {
            [[MBMatrixWechatManager sharedInstance] installMemoryPluginWithConfigDic:momeryConfigDic];
            [[[MBMatrixWechatManager sharedInstance] getMemoryStatPlugin]start];
        }
        [[MBMatrixWechatManager sharedInstance] installBlockPlugin:config];
        [[[MBMatrixWechatManager sharedInstance] getCrashBlockPlugin] startBlockMonitor];
    });
}

- (void)stop {
    [super stop];
    if (![MBDeviceInfo canEnableMonitor]) {
        MBAPMLogInfo(@"matrix can't started on simulator or debugging status");
        return;
    }
    MBAPMLogInfo(@"matrix plugin stop");
    if (self.context.configuration.enableFOOMMonitor) {
        [[[MBMatrixWechatManager sharedInstance] getMemoryStatPlugin]stop];
    }
    [[[MBMatrixWechatManager sharedInstance] getCrashBlockPlugin] stopBlockMonitor];
}


@end
