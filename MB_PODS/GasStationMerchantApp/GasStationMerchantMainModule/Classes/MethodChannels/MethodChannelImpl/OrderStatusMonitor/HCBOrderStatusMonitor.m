//
//  HCBOrderStatusMonitor.m
//  Runner
//
//  Created by heyAdrian on 2018/10/11.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HCBOrderStatusMonitor.h"
#import "HCBOrderRequest.h"
#import "HCBOrderDetailModel.h"
#import <JSONKIT/JSONKIT.h>

static NSTimer *timer;
static BOOL isLoading = NO;
const int kDefalutOrderStatusMonitorTimeInterval = 5;


@interface HCBOrderStatusMonitor (){}
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HCBOrderStatusMonitor

+ (void)startListenOrder:(NSString *)orderNo onCompleteBlock:(void (^)(NSString *))completeBlock {
    if (!timer || ![timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    if (!completeBlock) {
        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:kDefalutOrderStatusMonitorTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (isLoading) {
            return;
        }
        isLoading = YES;
        [HCBOrderRequest reqOrderDetailWithOrderNo:orderNo onCompleteBlock:^(NSDictionary *dic) {
            HCBOrderDetailModel *item = [[HCBOrderDetailModel alloc] initWithDictionary:dic error:nil];
            if (![item.orderStatus isEqualToString:@"10"]) {
                [self stopListenOnResult:nil];
                completeBlock([dic JSONStringHCB]);
            }
            isLoading = NO;
        } onFailedBlock:^(HCBError *error) {
            isLoading = NO;
        }];
    }];
}

+ (void)stopListenOnResult:(FlutterResult)result {
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    !result ?: result(@"OK");
}



@end
