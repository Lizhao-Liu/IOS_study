//
//  NavGetNativeData.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavGetNativeData.h"

@implementation NavGetNativeData

- (void)getData:(NSArray *)arguments {
    if (!arguments || arguments.count == 0) {
        !self.result ?: self.result(@"请传入获取参数key");
    } else {
        id param =  arguments.count > 0 ? arguments[0] : nil;
        if (!param || ![param isKindOfClass:[NSString class]]) {
            !self.result ?: self.result(@"入参类型错误，请传入String类型的参数key");
        }
        !self.result ?: self.result(@"");
    }
}

@end
