//
//  MBAPMConfiguration.m
//  MBAPMServiceLib
//
//  Created by xp on 2020/8/7.
//

#import "MBAPMConfiguration.h"

@implementation MBAPMConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lagChannel = MBAPMReportChannelAPMLib;
    }
    return self;
}

@end
