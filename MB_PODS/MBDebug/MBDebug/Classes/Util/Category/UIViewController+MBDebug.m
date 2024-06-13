//
//  UIViewController+MBDebug.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/5.
//

#import "UIViewController+MBDebug.h"
@import MBUIKit;

@implementation UIViewController (MBDebug)

+ (UIViewController *)topPresentedVC {
    UIWindow *screenWindow = [UIApplication sharedApplication].delegate.window;
    UIViewController *presentedViewController = screenWindow.rootViewController;
    while (presentedViewController.presentedViewController) {
        presentedViewController = presentedViewController.presentedViewController;
        
    }
    return presentedViewController;
}


+ (BOOL)presentDebugVC:(UIViewController *)debugVC {
    UIWindow *screenWindow = [UIApplication sharedApplication].delegate.window;
    UIViewController *presentedViewController = screenWindow.rootViewController;
    while (presentedViewController.presentedViewController) {
        if([presentedViewController.presentedViewController isKindOfClass:[UIAlertController class]]){
            [MBProgressHUD showToastAddedTo:[UIApplication sharedApplication].delegate.window image:nil labelText:@"请先关闭弹窗" hideAfterDelay:2 isTapToHideEnable:YES withGroupId:0];
            return NO;
        }
        presentedViewController = presentedViewController.presentedViewController;
        
    }
    [presentedViewController presentViewController:debugVC animated:YES completion:nil];
    return YES;
}

+ (BOOL)dismissDebugVC:(UIViewController *)debugVC {
    [debugVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

@end
