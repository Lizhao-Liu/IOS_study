//
//  TMSLaunchTaskMainView.m
//  MBTMSModule
//
//  Created by xp on 2023/5/10.
//

#import "TMSLaunchTaskMainView.h"
#import "TMSUserManager.h"
#import "MBTMSModule-Swift.h"
#import "TMSCommonMacros.h"
#import "TMSMainPageFactory.h"
@import MBFoundation;
@import MBLauncherLib;
@import YMMBridgeLib;
@import MBPrivacyService;
@import MBProjectConfig;
@import MBConfigCenterService;
@import MBUIKit;
@import RSSwizzle;
@import AVFoundation;
@import MBMainContainerLib;

typedef void (^RequestAccessBlock)(BOOL granted);


@MBLaunchTaskEX(TMSLaunchTaskMainView)
@interface TMSLaunchTaskMainView() <MBLaunchTask,UITabBarControllerDelegate, MBBridgeContainer>

@property (nonatomic, strong) TMSMainPageFactory *pageFactory;

@end

@implementation TMSLaunchTaskMainView

- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneHome;
}

- (MBLaunchPriority)taskPriority {
    return 0;
}

- (nonnull NSString *)taskName {
    return @"mainview";
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    if (!params.application) {
        NSAssert(self, @"app启动： main view task 缺少application参数！！！");
    }
    
    [[MBTabBarABConfig shared] configUseMBTab];
    [[MBTabBarABConfig shared] configUseSafeArea];
    [self initNavBarStyle];
    
    self.pageFactory = [[TMSMainPageFactory alloc] init];
    YMM_Weakify(self, weakSelf)
    UIViewController *rootVC = [self.pageFactory createMainPageWithChangeRootVCBlock:^(UIViewController *rootVC) {
        [weakSelf changeWindowRootViewController:rootVC onWindow:[params.application.delegate window]];
    }];
    [self showMainViewController:rootVC onWindow:[params.application.delegate window]];
    
    return YES;
}

- (void)showMainViewController:(UIViewController *)mainViewController onWindow:(UIWindow *)window {
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [mainViewController.navigationController setNavigationBarHidden:YES animated:NO];
    [window setRootViewController:navigationVC];
    [window makeKeyAndVisible];
    
    // 保留TMS历史逻辑
    dispatch_async(dispatch_get_main_queue(), ^{
        YMMPluginRequest *request = [YMMPluginRequest new];
        request.method = @"getLocationInfoAsyncWithoutPermission";
        request.module = @"app";
        request.business = @"geo";
        request.container = self;
        [[YMMPluginManager shared]performPlugin:request callBack:^(YMMPluginResponse * _Nonnull response) {}];
    });
}

- (void)changeWindowRootViewController:(UIViewController *)rootViewController onWindow:(UIWindow *)window {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootViewController.navigationController setNavigationBarHidden:YES animated:NO];
    window.rootViewController = nav;
}


- (void)initNavBarStyle{
    // 原TMS LaunchTaskUI 历史设置保留
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mb_colorWithHex:0x333333]}];
    [[UINavigationBar appearance] setTintColor:[UIColor mb_colorWithHex:0x333333]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}



@end
