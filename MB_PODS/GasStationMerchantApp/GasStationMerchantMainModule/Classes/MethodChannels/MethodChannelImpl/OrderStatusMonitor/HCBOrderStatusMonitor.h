//
//  HCBOrderStatusMonitor.h
//  Runner
//
//  Created by heyAdrian on 2018/10/11.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface HCBOrderStatusMonitor : NSObject

+ (void)startListenOrder:(NSString *)orderNo onCompleteBlock:(void(^)(NSString *content))completeBlock;

// TODO: 原能源商户 flutter base vc 在 view will disappear时机调用了这个方法
+ (void)stopListenOnResult:(FlutterResult)result;

@end
