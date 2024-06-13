//
//  MBAPMWhiteScreenMetric.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/7/24.
//

#import "MBAPMWhiteScreenMetric.h"
@import MBFoundation;

@implementation MBAPMWhiteScreenMetric

- (NSString *)apmVersion {
    return [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
}

@end
