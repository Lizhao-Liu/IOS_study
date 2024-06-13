//
//  MBAPMPageRenderTextVC.m
//  MBAPMLib_Example
//
//  Created by xp on 2020/7/28.
//  Copyright © 2020 seal. All rights reserved.
//

#import "MBAPMPageRenderTextVC.h"
@import MBAPMServiceLib;


@interface MBAPMPageRenderTextVC () <MBAPMViewPageProtocol>

@end

@implementation MBAPMPageRenderTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文本检测方案";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.textLabel1.hidden = NO;
        self.textLable2.hidden = NO;
    });
}

- (MBAPMViewPageRenderType)renderTypeForAPM {
    return MBAPMViewPageRenderTypeNative;
}

- (MBAPMViewPageRenderDetectType)renderDetectTypeForAPM {
    return MBAPMViewPageRenderDetectTypeText;
}

- (UIView *)detectViewForAPM {
    return self.view;
}

- (NSString *)pageNameForAPM {
    return @"apm_render_text_test";
}

@end
