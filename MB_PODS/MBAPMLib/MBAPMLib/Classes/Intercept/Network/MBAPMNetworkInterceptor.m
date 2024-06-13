//
//  MBAPMNetworkInterceptor.m
//  AAChartKit
//
//  Created by xp on 2023/4/10.
//

#import "MBAPMNetworkInterceptor.h"
#import "MBAPMNetworkDateManager_Private.h"

@import MBNetworkLib;

@interface MBAPMNetworkInterceptor () <MBBaseNetworkPluginProtocol>
@end

@implementation MBAPMNetworkInterceptor

+ (void)configPlugin {
    [[MBBaseNetworkConfig sharedInstance] addCommonPlugin:self];
}

/// 开始准备 YES 不拦截, NO 拦截
/// 返回值表示是否需要拦截，拦截之后不再执行后续的Plugin，也不再执行后续的request流程
/// @param request 请求
- (BOOL)mb_requestPrepare:(__kindof MBBaseNetworkRequest *)request {
    if (request.path.length > 0) {
        [[MBAPMNetworkDateManager sharedInstance] startUrl:request.path];
    }
    
    return YES;
}

/// 请求处理结束，即将通知业务侧
/// @param request 请求
- (void)mb_requestEnd:(__kindof MBBaseNetworkRequest *)request {
    if (request.path.length > 0) {
        [[MBAPMNetworkDateManager sharedInstance] endUrl:request.path];
    }
}

@end
