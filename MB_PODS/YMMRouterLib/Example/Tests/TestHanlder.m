//
//  TestHanlder.m
//  YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/3/4.
//  Copyright © 2019 knop. All rights reserved.
//

#import "TestHanlder.h"
#import "YMMRouterTable.h"
#import "YMMRouter.h"

@implementation TestHanlder

- (void)handle:(id<YMMRouterRoutable>)routable
    callback:(nullable HandlerCallback)callback {
    self.host = routable.host;
    self.path = routable.path;
    if (callback) {
        callback(@"callback");
    }
}

@end
