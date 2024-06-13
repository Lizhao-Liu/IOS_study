//
//  MBAPMDataLog.m
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import "MBAPMDataLog.h"
#import "MBAPMMetric.h"
#import "MBAPMLogDef.h"

@import YYModel;

@implementation MBAPMDataLog

- (void)exportMetricData:(MBAPMMetric *)metric {
    MBAPMDebug(@"MBAPM log metric: %@", [metric yy_modelToJSONString]);
}


@end
