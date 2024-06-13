//
//  GasStationActivityRouterFilter.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/20.
//

@import MBUIKit;
@import MBProjectConfig;

#import "GasStationActivityRouterFilter.h"

@implementation GasStationActivityRouterFilter
// <scheme://host/path>
- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response
           chain:(id<YMMRouterFilterChainProtocol>)chain {
    if ([routable.host isEqualToString:@"activity"] &&
               [routable.path isEqualToString:@"/MCS"]) {
        UIViewController *vc = [[NSClassFromString(@"HCBMsgSystemListVC") alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.hidesBottomBarWhenPushed = YES;
            UIViewController *currentVC = [UIViewController mb_currentViewController];
            [currentVC.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([routable.host isEqualToString:@"activity"] &&
        [self.hcbDriverPaths containsObject:routable.path]) {
        NSString *newUrl = [NSString stringWithFormat:@"%@://%@%@",routable.scheme,@"hcbdriver",routable.path];
        YMMRouterRequest *result = [[YMMRouterRequest alloc] initWithURLString:newUrl params:routable.params];
        response.status = YMMRouterStatusRedirect;
        response.result = result;
        return;
    } else if ([routable.host isEqualToString:@"activity"] &&
               [self.hcbShipperPaths containsObject:routable.path]) {
        NSString *newUrl = [NSString stringWithFormat:@"%@://%@%@",routable.scheme,@"hcbshipper",routable.path];
        YMMRouterRequest *result = [[YMMRouterRequest alloc] initWithURLString:newUrl params:routable.params];
        response.status = YMMRouterStatusRedirect;
        response.result = result;
        return;
    } else if ([routable.host isEqualToString:@"activity"] &&
               [routable.path isEqualToString:@"/privacyAuthorize"]) {
        
        NSString *host = ((MBAppDelegate.projectConfig.appTypeForBiz == MBAppTypeForBizHCBDriver) ? @"hcbdriver" : @"hcbshipper");
        NSString *newUrl = [NSString stringWithFormat:@"%@://%@%@",routable.scheme,host,routable.path];
        YMMRouterRequest *result = [[YMMRouterRequest alloc] initWithURLString:newUrl params:routable.params];
        response.status = YMMRouterStatusRedirect;
        response.result = result;
        return;
    }
    // 继续执行透传到Handler
    [chain doFilter:routable response:response];
}

- (NSArray *)hcbDriverPaths {
    return @[@"/setting",
             @"/setting_about",
             @"/tip_bind_succeed",
             @"/push_center",
             @"/pdf_reader",
             @"/MCS",
             @"/CodeScaner",
             @"/customer",
             @"/jurisdictionDeclare",
             @"/home_activity",
             @"/freewayHelp"];
}

- (NSArray *)hcbShipperPaths {
    return @[@"/home_all_tabs"];
}

@end
