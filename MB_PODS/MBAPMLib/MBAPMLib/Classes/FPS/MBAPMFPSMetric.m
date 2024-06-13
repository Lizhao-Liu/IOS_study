//
//  MBAPMFPSMetric.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/7/17.
//

#import "MBAPMFPSMetric.h"
@import MBFoundation;

@implementation MBAPMFPSMetric

- (NSString *)apmVersion {
    return [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
}

@end
