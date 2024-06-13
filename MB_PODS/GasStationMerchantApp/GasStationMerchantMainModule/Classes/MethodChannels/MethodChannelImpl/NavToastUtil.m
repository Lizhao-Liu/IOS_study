//
//  NavToastUtil.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavToastUtil.h"
@import MBUIKit;

@implementation NavToastUtil

- (void)showToast:(NSArray *)arguments {
    if (!arguments || arguments.count ==0) {
        !self.result ?: self.result(@"入参错误，请传入toast msg");
    } else {
        id msg =  arguments.count > 0 ? arguments[0] : nil;
        if (!msg || ![msg isKindOfClass:[NSString class]]) {
            !self.result ?: self.result(@"入参类型错误，请传入String类型的toast msg");
        }
        [MBProgressHUD showToastAddedTo:[UIApplication sharedApplication].delegate.window imageName:nil labelText:msg];
        !self.result ?: self.result(@"OK");
    }
}

@end
