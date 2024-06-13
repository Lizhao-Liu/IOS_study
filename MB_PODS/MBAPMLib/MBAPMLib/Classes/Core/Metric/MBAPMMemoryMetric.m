//
//  MBAPMMemoryMetric.m
//  MBAPMLib
//
//  Created by xp on 2021/10/14.
//

#import "MBAPMMemoryMetric.h"
@import MBUIKit;
@import MBFoundation;

@implementation MBAPMMemoryMetric

- (NSString *)apmVersion {
    return [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
}

- (NSString *)pageName {
    NSString *ymmPageName = nil;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    UIViewController *currentViewController = [UIViewController mb_currentViewController];
    if (currentViewController) {
        if ([currentViewController respondsToSelector:@selector(mb_pageName)]) {
            ymmPageName = [currentViewController performSelector:@selector(mb_pageName)];
        }
    }
    #pragma clang diagnostic pop
    if (!ymmPageName) {
        ymmPageName = NSStringFromClass([currentViewController class]);
    }
    return ymmPageName;
}

@end
