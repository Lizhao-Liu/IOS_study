//
//  NavLaunch.m
//  Runner
//
//  Created by DXY on 2021/12/3.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

#import "NavLaunch.h"

@implementation NavLaunch

- (void)tel:(NSArray *)arguments {
    id phoneNum = arguments.count > 0 ? arguments[0] : nil;
    if (!phoneNum || ![phoneNum isKindOfClass:NSString.class] || [(NSString *)phoneNum length] == 0) {
        !self.result ?: self.result(@"phoneNum is invalid! can not tel!");
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
    !self.result ?: self.result(@"OK");
}

@end
