//
//  MBAPMLagMetric.m
//  MBAPMLib
//
//  Created by xp on 2020/8/17.
//

#import "MBAPMLagMetric.h"

@implementation MBAPMLagMetric

- (NSString *)stackType {
    return @"lag";
}

- (NSDictionary *)attrs {
    return @{@"stack_type": self.stackType?:@"", @"stack":self.stack?:@"", @"cpu":self.cpuInfo?:@"", @"fps":self.fpsInfo?:@"", @"memory":self.memoryInfo?:@"", @"bundles":self.bundles?:@[], @"mapping_type":@"dsym", @"system_info":self.systemInfo ?: @{}};
}

- (NSDictionary *)exts {
    return @{@"lagStartTime":@(self.lagStartTime*1000 ?: 0), @"lagTotalTime":@(self.lagTotalTime?:0)};
}

@end
