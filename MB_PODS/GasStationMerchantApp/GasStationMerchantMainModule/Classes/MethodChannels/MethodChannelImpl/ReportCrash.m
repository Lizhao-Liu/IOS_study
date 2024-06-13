//
//  ReportCrash.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "ReportCrash.h"

#import <Bugly/Bugly.h>

@implementation ReportCrash

- (void)bugly:(NSArray *)arguments {
    id reason = arguments.count > 0 ? arguments[0] : nil;
    id stack = arguments.count >1 ? arguments[1] : nil;
    if (!stack) {
        !self.result ?: self.result(@"stackTrace is empty! can not upload!");
    }
    [Bugly reportExceptionWithCategory:3 name:@"Flutter UncaughtError" reason:[NSString stringWithFormat:@"%@", reason] callStack:@[stack] extraInfo:@{} terminateApp:NO];
    !self.result ?: self.result(@"OK");
}

@end
