//
//  YMMRouterLowVersionFilter.m
//  YMMRouterModule
//
//  Created by xp on 2022/5/19.
//

#import "YMMRouterLowVersionFilter.h"

@implementation YMMRouterLowVersionFilter




- (void)doFilter:(nonnull id<YMMRouterRoutable>)routable response:(nonnull YMMRouterResponse *)response chain:(nonnull id<YMMRouterFilterChainProtocol>)chain {
    response.status = YMMRouterStatusLowVersion;
    return;
}

@end
