//
//  HCBAppDelegate.m
//  HCBCodeScaner
//
//  Created by 张鹏 on 03/19/2018.
//  Copyright (c) 2018 张鹏. All rights reserved.
//

#import "HCBAppDelegate.h"
#import <HCBCodeScaner/HCBCodeScaner.h>
#import <MBToolKit/MBToolKit.h>

@interface UIViewController (HCBCodeScaner)

- (__kindof UIViewController *)hcb_code_scaner_dismiss;

@end

@implementation UIViewController (HCBCodeScaner)

- (__kindof UIViewController *)hcb_code_scaner_dismiss {
    BOOL isEmbedded = self.navigationController != nil;
    BOOL isNotRoot = [self.navigationController.viewControllers indexOfObject:self] > 0;
    BOOL pop = isEmbedded && isNotRoot;
    __kindof UIViewController *viewController = self;
    if (pop) {
        viewController = [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return viewController;
}

@end

@implementation HCBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 配置默认的无法识别二维码处理 block
    [HCBCodeScaner setUnrecognizedScanResultHandler:^(HCBCodeScanerViewController *_Nullable viewController, NSString *_Nullable result) {
        [viewController hcb_code_scaner_dismiss];
        [MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"无效的二维码"];
    }];

    // 配置二维码识别规则及命中后的行为
    HCBCodeScanerRegulation *qr_pay_regulation = [HCBCodeScanerRegulation regulationWithRule:^BOOL(NSString *_Nonnull result) {
        return [result rangeOfString:@"QrPay"].location != NSNotFound;
    } handler:^(HCBCodeScanerViewController *_Nullable viewController, NSString *_Nonnull result) {
        NSLog(@"QrPay hit with result: %@, controller: %@", result, viewController);
        [MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"有效二维码"];
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [HCBCodeScaner addRegulation:qr_pay_regulation];

    HCBCodeScanerRegulation *retrieve_coupon_regulation = [HCBCodeScanerRegulation regulationWithRule:^BOOL(NSString *_Nonnull result) {
        return [result rangeOfString:@"retrievecoupon"].location != NSNotFound;
    } handler:^(HCBCodeScanerViewController *_Nonnull viewController, NSString *_Nonnull result) {
        NSLog(@"retrievecoupon hit with result: %@, controller: %@", result, viewController);
        [MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"有效二维码"];
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [HCBCodeScaner addRegulation:retrieve_coupon_regulation];

    return YES;
}

@end
