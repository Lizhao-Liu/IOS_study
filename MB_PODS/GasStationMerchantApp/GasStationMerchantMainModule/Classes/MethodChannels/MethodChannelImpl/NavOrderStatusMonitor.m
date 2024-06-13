//
//  NavOrderStatusMonitor.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavOrderStatusMonitor.h"
#import "HCBOrderStatusMonitor.h"

@implementation NavOrderStatusMonitor

- (void)listen:(NSArray *)arguments {
    if (!arguments || arguments.count == 0) {
        !self.result ?: self.result(@"请传入要监听状态运单的运单号");
    } else {
        NSString *orderNo =  arguments.count > 0 ? arguments[0] : nil;
        if (!orderNo || ![orderNo isKindOfClass:[NSString class]]) {
            !self.result ?: self.result(@"入参类型错误，请传入String类型的参数key");
        }
        [HCBOrderStatusMonitor startListenOrder:orderNo onCompleteBlock:^(NSString *content) {
            if (self.channel && self.call) {
                [self.channel invokeMethod:self.call.method arguments:content];
            }
        }];
    }
}

- (void)unListen:(NSArray *)arguments {
    [HCBOrderStatusMonitor stopListenOnResult:self.result];
}

@end
