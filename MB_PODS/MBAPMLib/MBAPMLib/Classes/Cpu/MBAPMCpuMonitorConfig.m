//
//  MBAPMCpuMonitorConfig.m
//  MBAPMLib
//
//  Created by FDW on 2022/5/24.
//

#import "MBAPMCpuMonitorConfig.h"

@implementation MBAPMCpuMonitorConfig

- (instancetype)initWithConfigDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary.allKeys.count) {
            _isEnable = ((NSNumber *)dictionary[@"is_enable"]).boolValue;
            _gather_interval = ((NSNumber *)dictionary[@"gather_interval_sec"]).integerValue;
            _gather_count = ((NSNumber *)dictionary[@"gather_count"]).integerValue;
            _gather_threshold = ((NSNumber *)dictionary[@"thread_overuse"]).integerValue;
            _total_gather_threshold = ((NSNumber *)dictionary[@"overuse"]).integerValue;
            _exception_gather_interval = ((NSNumber *)dictionary[@"exception_gather_interval_sec"]).integerValue;
            _exception_gather_count = ((NSNumber *)dictionary[@"exception_gather_count"]).integerValue;
        } else {
            _isEnable = NO;
            _gather_interval = 5;
            _gather_count = 24;
            _gather_threshold = 5;
            _total_gather_threshold = 80;
            _exception_gather_interval = 1;
            _exception_gather_count = 60;
        }
    }
    return self;
}
@end
