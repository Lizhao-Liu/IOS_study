//
//  TMSBaseRouterHandler.m
//  TMSBaseModule
//
//  Created by zht on 2021/5/13.
//

#import "TMSBaseRouterHandler.h"
#import "TMSUserManager.h"
#import "TMSCommonMacros.h"
#import "MBTMSModule-Swift.h"
@import MBCommonUILib;
@import YMMRouterLib;
@import MBLocationLib;
@import MBFoundation;

@implementation TMSBaseAsyncRouterHandler

- (void)handle:(id<YMMRouterRoutable>)routable callback:(HandlerCallback)callback {
    if (!routable.isValid) {
        if (callback) {
            callback(nil);
        }
        return ;
    }
    
    NSDictionary *params = routable.params;
    
    if ([@"/citypicker" isEqualToString:routable.path]) {
        [self gotoCityPicker:params callback:callback];
    }
}

- (void)gotoCityPicker:(NSDictionary *)params callback:(void (^)(YMMRouterResponse *))callback{
    
    NSNumber *code = [params objectForKey:@"code"]; //-1 0
    NSNumber *type = [params objectForKey:@"type"]; //0 1
    NSNumber *defaultSelectCommon = [params objectForKey:@"defaultselectcommon"]; //0 1
    
    NSString *referpageName = [params objectForKey:@"referName"];
    NSString *traceId = [params objectForKey:@"traceId"];
    NSInteger showDistrict = [[params objectForKey:@"country"] boolValue];
    NSString *title = [params objectForKey:@"title"]; //0 1
    NSString *fixspecial = [params objectForKey:@"fixspecial"];
    NSString *primarycolor = [params objectForKey:@"primarycolor"];
    
    YMMRegion *originRegion = nil;
    if (code.integerValue > 0) {
        originRegion = [YMMRegionManager regionWithCode:code.integerValue];
    }
    
    MBPublishRegionView *view = [[MBPublishRegionView alloc] initWithRegion:originRegion
                                                                isSpecialLine:NO
                                                           regionSelectorType:type.integerValue];
    view.primarycolor = (primarycolor && primarycolor.length > 0) ? [NSString stringWithFormat:@"#%@", primarycolor] : nil;
    view.title = title;
    view.regionSelectorType = type.integerValue;
    view.referpageName = referpageName;
    view.traceId = traceId;
    view.showDistrict = showDistrict;
    view.params = params;
    view.isHaveFixedCity = fixspecial.integerValue ? YES : NO;
    view.defaultSelectCommon = defaultSelectCommon.integerValue ? YES : NO;
    view.valueCallback = ^(YMMRegion * _Nonnull region, MBPublishRegionSelectType type) {
        MBAMapBridgeManager *manager = GET_MANAGER(MBAMapBridgeManager);
        NSInteger code = [region isCounty] ? region.superCode : region.code;
        NSString *township = @"";
        
        if ([region isCounty] && [manager isStraightCity:code]) {
            township = region.name;
        }
        
        NSString *searchLevel = @"city";
        if ([region isCounty] && [manager isOnlySearchDistrict:code]) {
            searchLevel = @"district";
        }
        
        
        NSMutableDictionary *params = @{@"code": @(region.code?:0),
                                        @"parentCode":@(region.superCode?:0),
                                        @"name":region.fullName?:@"",
                                        @"shortName":region.name?:@"",
                                        @"deep":@(region.level?:0),
                                        @"lon":@(region.lon?:0),
                                        @"lat":@(region.lat?:0),
                                        @"status":@(region.status?:0),
                                        @"grandId":@(region.superior.superCode?:0),
                                        @"pyName":region.pyName ? region.pyName : @"",
                                        @"formatName": region.wholeRegionName?:@"",
                                        @"parentName": region.superior.fullName?:@"",
                                        @"source":@(type?:0),
                                        @"township" : township?:@"",
                                        @"searchLevel" : searchLevel}.mutableCopy;
        
        [params setValue:[self jsonStringEncodedWithJson:params] forKey:@"place"];
        
        if (callback) {
            YMMRouterResponse *model = [YMMRouterResponse new];
            model.result = params;
            callback(model);
        }
    };
    
    view.cancelCallback = ^ {
        NSDictionary *params = @{@"source":@(-1)};
        if (callback) {
            YMMRouterResponse *model = [YMMRouterResponse new];
            model.result = params;
            callback(model);
        }
    };
    
    [view show];
}

#pragma mark - 其他辅助

- (NSString *)jsonStringEncodedWithJson:(NSDictionary *)json {
    if ([NSJSONSerialization isValidJSONObject:json]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

@end


@implementation TMSBaseUserSyncRouterHandler


- (nullable id)handle:(id<YMMRouterRoutable>)routable {
    
    if (!routable.isValid) {
        return nil;
    }
    
    if ([routable.path isEqualToString:@"/login"]) {
        /// 唤起“登录”
        /// 检测当前VC栈内已包含登录页面，直接return nil，并pop返回命中登录页，防止多次重复调登录（例如：在登录页跳转h5场景）
        if ([TMSUserManager sharedTMSUserManager].currentNavStackHasLoginVC == YES) {
            TMSBaseModule_dispatch_main_async_safe(^{
                UIViewController *currentVC = [UIViewController mb_currentViewController];
                NSArray *viewControllers = currentVC.navigationController.viewControllers;
                if (viewControllers.count > 0) {
                    for (int i=0; i<viewControllers.count; i++) {
                        UIViewController *obj = viewControllers[i];
                        if ([[TMSUserManager sharedTMSUserManager].loginRelatedClasses containsObject:obj.class]) {
                            [currentVC.navigationController popToViewController:obj animated:YES];
                            return ;
                        }
                    }
                }
            });
            return nil;
        }
        
        /// 弹起登录页面
        TMSBaseModule_dispatch_main_async_safe(^{
            UIViewController *currentVC = [UIViewController mb_currentViewController];
            if ([currentVC isKindOfClass:[UIViewController class]]) {
                Class cls = [[TMSUserManager sharedTMSUserManager] getLoginFirstViewControllerClass];
                UIViewController *vc = [[cls alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [currentVC presentViewController:nav animated:YES completion:nil];
            }
        });
        
        return nil;
    }
    
    return nil;
}


@end


@implementation TMSBaseSyncRouterHandler

- (nullable id)handle:(id<YMMRouterRoutable>)routable {
    
    if (!routable.isValid) {
        return nil;
    }
    
    NSDictionary *params = routable.params;
    if ([routable.path isEqualToString:@"/main"]) {
        return [self gotoMainWithParams:params];
    }
    if ([routable.path isEqualToString: @"/workbench"]) {
        UIViewController *vc = [TMSWorkViewController new];
        return vc;
    }
    if ([routable.path isEqualToString: @"/mine"]) {
        UIViewController *vc = [TMSNewMineVC new];
        return vc;
    }
    
    return nil;
}

#pragma mark - 路由跳转

- (UIViewController *)gotoMainWithParams:(NSDictionary *)params {
    
    if (!TMSUserManager.sharedTMSUserManager.isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TMSKEY_NOTI_USERLOGOUT_WILL object:nil];
        return nil;
    }
    
    NSInteger index = [params[@"index"] integerValue];
    
    UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;

    if(![vc isKindOfClass:[UINavigationController class]]){
        return nil;
    }
    UIViewController *rootVC = [((UINavigationController *)vc).viewControllers firstObject];
    
    if (![rootVC conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]){
        return nil;
    }
    
    UIViewController<MBUITabBarControllerProtocol> *tabBarVC = (UIViewController<MBUITabBarControllerProtocol> *)rootVC;

    if (index >= tabBarVC.viewControllers.count) {
        return nil;
    }
        
    if (tabBarVC.navigationController.presentedViewController) {
        [tabBarVC.navigationController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        if (tabBarVC.presentedViewController) {
            [tabBarVC.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    [tabBarVC.navigationController popToRootViewControllerAnimated:YES];
    
    for (UINavigationController *childNavVC in tabBarVC.viewControllers) {
        if (childNavVC.viewControllers.count > 1) {
            childNavVC.viewControllers = [NSArray arrayWithObject:[childNavVC.viewControllers objectAtIndex:0]];
        }
        if (childNavVC.parentViewController) {
            [childNavVC.parentViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    [tabBarVC setSelectedIndex:index];
    
    return nil;
}

@end
