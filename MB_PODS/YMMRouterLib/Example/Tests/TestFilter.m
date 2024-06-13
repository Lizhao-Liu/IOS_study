//
//  TestFilter.m
//  YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/3/4.
//  Copyright © 2019 knop. All rights reserved.
//

#import "TestFilter.h"
#import "YMMRouterFilterChain.h"
#import "YMMRouterResponse.h"

@implementation TestFilter

- (void)doFilter: (id<YMMRouterRoutable>)request
        response: (YMMRouterResponse *)response
           chain: (id<YMMRouterFilterChainProtocol>)chain {
    if ([request.path isEqualToString:@"/test"]) {
        self.invoked = YES;
        return;
    }
    [chain doFilter:request response:response];
    self.invoked = NO;
}

@end
