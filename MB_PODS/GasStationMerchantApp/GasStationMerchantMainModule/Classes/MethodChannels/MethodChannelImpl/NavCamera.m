//
//  NavCamera.m
//  Runner
//
//  Created by heyAdrian on 2018/10/30.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavCamera.h"
#import "HCBCodeScanerViewControllerPetrol.h"
#import "UIViewController+Extends.h"

@implementation NavCamera

- (void)registerScan:(NSArray *)arguments {
    HCBCodeScanerViewControllerPetrol *vc = [[HCBCodeScanerViewControllerPetrol alloc] init];
    vc.actionAfterScan = ^(HCBScanResultType scanType, NSString *msg) {
        !self.channel ?: [self.channel invokeMethod:self.call.method arguments:msg];
        [[UIViewController getCurrentVC].navigationController popViewControllerAnimated:YES];
    };
    [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)unRegisterScan:(NSArray *)arguments {
    
}

@end
