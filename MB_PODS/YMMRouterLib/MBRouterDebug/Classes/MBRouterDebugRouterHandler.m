//
//  MBRouterDebugRouterHandler.m
//  MBRouterDebug
//
//  Created by xp on 2022/11/10.
//

#import "MBRouterDebugRouterHandler.h"
#import "MBRouterDebugSetResultTestViewController.h"

@implementation MBRouterDebugRouterHandler


- (void)handle:(id<YMMRouterRoutable>)routable callback:(nullable HandlerCallback)callback {
    if ([routable.path isEqualToString:@"/debug/router_setresult"]) {
        MBRouterDebugSetResultTestViewController *testVC = [MBRouterDebugSetResultTestViewController new];
        if (callback) {
            callback(testVC);
        }
    }
}





@end
