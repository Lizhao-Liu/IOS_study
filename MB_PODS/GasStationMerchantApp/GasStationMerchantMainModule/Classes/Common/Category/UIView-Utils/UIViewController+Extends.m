//
//  UIViewController+Extends.m
//  Consignor4ios
//
//  Created by 苼茹夏花 on 13-7-31.
//  Copyright (c) 2013年 苼茹夏花. All rights reserved.
//

#import "UIViewController+Extends.h"
#import <objc/runtime.h>

@implementation UIViewController (Extends)


+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    if ([window subviews].count == 0) {
        return nil;
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    
    BOOL isContinue = YES;
    while (isContinue) {
        if ([result isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navc = (UINavigationController *)result;
            result = [navc visibleViewController];
        } else if ([result isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabBar = (UITabBarController *)result;
            result = tabBar.selectedViewController;
        } else if (result.presentedViewController){
            result = result.presentedViewController;
        }else{
            isContinue = NO;
        }
    }
    
    return result;
}

@end
