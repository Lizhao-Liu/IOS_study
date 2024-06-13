//
//  MBNavRouterInterceptor.m
//  YMMRouterLib
//
//  Created by xp on 2023/8/15.
//

#import "MBNavRouterInterceptor.h"
#import "YMMRouterResponse.h"
#import "UIViewController+MBNav.h"
#import "MBRouterLogger.h"

@implementation MBNavRouterInterceptor



- (void)routerDidHandle:(nonnull id<YMMRouterRoutable>)routable response:(nonnull YMMRouterResponse *)response {
    if (response.status == YMMRouterStatusSuccess) {
        if ([response.result isKindOfClass:UIViewController.class]) {
            UIViewController *destinationViewController = (UIViewController *)response.result;
            MBNavPageInfo *pageInfo = destinationViewController.mbNavPageInfo;
            if (!pageInfo) {
                pageInfo = [MBNavPageInfo new];
            }
            pageInfo.viewController = destinationViewController;
            pageInfo.routable = response.request;
            destinationViewController.mbNavPageInfo = pageInfo;
            MBRouterInfo(@"MBNav router interceptor viewController(%@) associated url(%@)", destinationViewController, pageInfo.routable.originUrlString);
        }
    }
}

- (BOOL)routerShouldHandle:(nonnull id<YMMRouterRoutable>)routable {
    return YES;
}

@end
