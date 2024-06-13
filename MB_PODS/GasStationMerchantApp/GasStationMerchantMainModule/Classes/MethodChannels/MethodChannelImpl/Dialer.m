//
//  Dialer.m
//  Runner
//
//  Created by heyAdrian on 2018/10/30.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "Dialer.h"

@implementation Dialer

- (void)openDialer:(NSArray *)arguments {
    NSString *tel = arguments.count > 0 ? arguments[0] : nil;
    if (tel.length == 0) {
        !self.result ?: self.result(@"电话号码不能为空!");
        return;
    }
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@", tel];
    NSURL *url = [NSURL URLWithString:telUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) { 
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
