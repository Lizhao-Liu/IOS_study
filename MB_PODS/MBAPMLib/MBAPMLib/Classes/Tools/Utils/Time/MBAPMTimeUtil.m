//
//  MBAPMTimeUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/7/15.
//

#import "MBAPMTimeUtil.h"
#import <sys/time.h>

@implementation MBAPMTimeUtil

+ (long long)currentTimestamp {
    struct timeval t;
    gettimeofday(&t,NULL);
    long long dwTime = ((long long)1000000 * t.tv_sec + (long long)t.tv_usec)/1000;
    return dwTime;
}

@end
