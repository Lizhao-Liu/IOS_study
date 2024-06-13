//
//  MBAPMRouterIntercepter.m
//  Pods
//
//  Created by xp on 2023/4/10.
//

#import "MBAPMRouterIntercepter.h"
#import "MBAPMEventTimeTrackMgrPro.h"
#import "MBAPMEventTimeTrackTask.h"
#import "UIViewController+MBAPMRenderMonitor.h"
#import "MBAPMPageLaunchDivideCenter.h"

@interface MBAPMRouterIntercepter()

@end

@implementation MBAPMRouterIntercepter

- (void)routerDidHandle:(nonnull id<YMMRouterRoutable>)routable response:(nonnull YMMRouterResponse *)response {
    if (response.status == YMMRouterStatusSuccess) {
        [self createPageTrackId:routable params:routable.params routerResult:response.result];
    }
}

- (BOOL)routerShouldHandle:(nonnull id<YMMRouterRoutable>)routable {
    return YES;
}

#pragma mark - Private Methods
- (void)createPageTrackId:(id<YMMRouterRoutable>)routable params:(NSDictionary *)params routerResult:(id)result {
    if ([result isKindOfClass:[UIViewController class]]) {
        UIViewController *targetVC = (UIViewController *)result;
        if ([params objectForKey:@"isFromMainTabBar"] != nil) {
            return;
        }
        id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgrPro createTrackWithContainer:targetVC path:@""];
        if ([routable respondsToSelector:@selector(startTimestamp)] && routable.startTimestamp > 0) {
            [trackTask begin:nil beginAt:routable.startTimestamp];
        }
        // 有类似 bizpop 的 router 调用，会影响current page 相关，暂时注释
        //[[MBAPMPageLaunchDivideCenter sharedInstance] beginRouterWithViewController:targetVC];
    }
}
@end
