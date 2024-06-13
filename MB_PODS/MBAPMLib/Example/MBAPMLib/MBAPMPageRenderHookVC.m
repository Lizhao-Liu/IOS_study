//
//  MBAPMPageRenderHookVC.m
//  MBAPMLib_Example
//
//  Created by xp on 2020/7/28.
//  Copyright © 2020 seal. All rights reserved.
//

#import "MBAPMPageRenderHookVC.h"
@import MBAPMServiceLib;


@interface MBAPMPageRenderHookVC ()<MBAPMViewPageProtocol>

@end

@implementation MBAPMPageRenderHookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Hook埋点检测方案";
}

- (MBAPMViewPageRenderType)renderTypeForAPM {
    return MBAPMViewPageRenderTypeNative;
}

- (MBAPMViewPageRenderDetectType)renderDetectTypeForAPM {
    return MBAPMViewPageRenderDetectTypeLifeCycle;
}

- (UIView *)detectViewForAPM {
    return self.view;
}

- (NSString *)pageNameForAPM {
    return @"apm_render_hook_test";
}

- (void)dealloc {
    NSLog(@"xpxp dealloc");
}

@end
