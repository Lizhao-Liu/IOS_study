//
//  MBDebugToolsEntryHandler.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugToolsEntryHandler.h"
#import "MBDebugViewController.h"
#import "MBDebugToolsManager.h"
@import MBUIKit;
@import Masonry;

@serviceEX(MBDebugToolsEntryHandler, MBDebugEntryServiceProtocol)
@synthesize entryTitle;
@synthesize entryView;
@synthesize isHidden;
@synthesize handleBlock;

- (NSString *)entryTitle {
    return @"调试工具";
}


- (UIView *)entryView {
    UIView *bgView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
    bgView.cornerRadius = 8;
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    UIImageView *entryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    entryView.backgroundColor = [UIColor clearColor];
    UIImage *icon = [UIImage imageNamed:@"setting-tools"];
    entryView.image = icon;
    [bgView addSubview:entryView];
    [entryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    return bgView;
}

- (BOOL)isHidden {
    return NO;
}

- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        MBDebugViewController *debugVC = [[MBDebugViewController alloc] init];
        UINavigationController *debugSettingViewControllerNav = [[UINavigationController alloc] initWithRootViewController:debugVC];
        debugSettingViewControllerNav.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:debugSettingViewControllerNav animated:YES completion:nil];
    };
}

- (void)entryToolDidLoad {
    [[MBDebugToolsManager sharedMBDebugToolsManager] installDebugTools];
}

@end
