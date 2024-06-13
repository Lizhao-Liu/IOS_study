//
//  NavRouter.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavRouter.h"

#import "UIViewController+Extends.h"
#import "HCBModifyMobileVC.h"
#import "HCBAboutUsVC.h"
#if (COMBILE_MODE == COMBILE_MODE_Debug || COMBILE_MODE == COMBILE_MODE_Adhoc)
#import "HCBBetaController.h"
#endif
@import YMMRouterLib;
@import MBFoundation;
@import MBUIKit;

@implementation NavRouter

- (void)goModifyPhone:(NSArray *)arguments {
    HCBModifyMobileVC *vc = [HCBModifyMobileVC new];
    vc.modifySuccessHandler = ^{
        !self.channel ?: [self.channel invokeMethod:self.call.method arguments:nil];
    };
    [[UIViewController mb_currentViewController].navigationController setNavigationBarHidden:NO];
    [[UIViewController mb_currentViewController].navigationController pushViewController:vc animated:YES];
    !self.result ?: self.result(@"OK");
}

- (void)goAboutUs:(NSArray *)arguments {
    HCBAboutUsVC *vc = [HCBAboutUsVC new];
    [[UIViewController mb_currentViewController].navigationController setNavigationBarHidden:NO];
    [[UIViewController mb_currentViewController].navigationController pushViewController:vc animated:YES];
    !self.result ?: self.result(@"OK");
}

- (void)goHome:(NSArray *)arguments {
    [[UIViewController mb_currentViewController].navigationController popToRootViewControllerAnimated:YES];
    !self.result ?: self.result(@"OK");
}

- (void)openModifyHostPage:(NSArray *)arguments {
#if (COMBILE_MODE == COMBILE_MODE_Debug || COMBILE_MODE == COMBILE_MODE_Adhoc)
    [[UIViewController mb_currentViewController].navigationController setNavigationBarHidden:NO];
    [[UIViewController mb_currentViewController].navigationController pushViewController:[HCBBetaController new] animated:YES];
#endif
}

- (void)openNativeWebView:(NSArray *)arguments {
    if (arguments.count == 0) {
        return;
    }
    NSString *url = arguments[0];
    [self openURL:url];
}

- (void)goPage:(NSArray *)arguments{
    if (arguments.count == 0) {
        return;
    }
    NSString *method = arguments[0];
    if ([method isEqualToString:@"PermissionSetting"]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication] canOpenURL:url] ) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                }];
            }else{
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}


- (void)openURL:(NSString *)url {
    [[YMMRouterCenter shared] performWithURLString:url params:nil completion:^(YMMRouterResponse *response) {
        if (response.result && [response.result isKindOfClass:UIViewController.class]) {
            UINavigationController *navVC = [UIViewController mb_topNavigationController];
            [navVC pushViewController:response.result animated:YES];
        }
    }];
}

- (void)route:(NSArray *)arguments {
    NSString *url = arguments[0];
    [[YMMRouterCenter shared] performWithURLString:url params:nil completion:^(YMMRouterResponse *response) {
        if (response.result && [response.result isKindOfClass:UIViewController.class]) {
            UINavigationController *navVC = [UIViewController mb_topNavigationController];
            [navVC pushViewController:response.result animated:YES];
        }
    }];
}

- (void)routeForResult:(NSArray *)arguments {
    NSString *url = arguments[0];
    YMMRouterRequest *request = [[YMMRouterRequest alloc] initWithURLString:url
                                                                     params:@{@"need_result":@(1)}
                                                                handleBlock:^(NSError * _Nullable error, id  _Nonnull data) {
        if (!error && data) {
            !self.result ?: self.result(data);
        }
    }];
    [[YMMRouterCenter shared] perform:request
                              completion:^(YMMRouterResponse * _Nullable response) {
        if ([response.result isKindOfClass:[UIViewController class]]) {
            [[UIViewController mb_topNavigationController] pushViewController:response.result animated:YES];
        }
    }];
}



@end
