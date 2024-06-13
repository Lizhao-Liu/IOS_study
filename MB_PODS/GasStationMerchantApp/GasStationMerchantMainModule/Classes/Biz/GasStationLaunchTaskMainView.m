//
//  GasStationLaunchTaskMainView.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/11.
//

#import "GasStationLaunchTaskMainView.h"
#import "HCBUserManager.h"
#import "HCBBaseNavigationViewController.h"
#import "GasStationHomePageBaseViewController.h"
#import "HCBLoginVC.h"
#import "config.h"
@import MBLauncherLib;
@import HCBUserBasis;
@import IQKeyboardManager;
@import YMMUserModuleService;
@import YMMRouterLib;

@interface GasStationLaunchTaskMainView() <MBLaunchTask>

@property (nonatomic, strong) HCBBaseNavigationViewController *navigationVC;

@end


@MBLaunchTaskEX(GasStationLaunchTaskMainView)


@implementation GasStationLaunchTaskMainView


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
    
    UIWindow *window = [params.application.delegate window];
    
    BOOL login = [HCBUserManager shareManager].currentUser.isLogined || HCBUserBasis.defaultUserBasis.user.isLogin;
    if (login) {
        _navigationVC = [[HCBBaseNavigationViewController alloc] initWithRootViewController:[GasStationHomePageBaseViewController new]];
    } else {
        _navigationVC = [[HCBBaseNavigationViewController alloc] initWithRootViewController:[HCBLoginVC new]];
    }
    [window setRootViewController:_navigationVC];
    [window makeKeyAndVisible];
    
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:NO];
    
    [self registerNotifications];
    
    return YES;
}
- (void)dealloc {
    [self unregisterNotifications];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginSuccess:) name:MBUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutSuccess:) name:MBUserLogoutNotification object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidLoginSuccess:(NSNotification *)notification {
    // 如果是启动阶段自动登录，则直接返回
    BOOL isReloggedIn = [[notification.userInfo objectForKey:kReloginNotificationKey] boolValue];
    if(isReloggedIn) {
        return;
    }
    _navigationVC = [[HCBBaseNavigationViewController alloc] initWithRootViewController:[GasStationHomePageBaseViewController new]];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window setRootViewController:_navigationVC];
    [window makeKeyAndVisible];
}


- (void)userDidLogoutSuccess:(NSNotification *)notification {
    [_navigationVC popToRootViewControllerAnimated:YES];
    [_navigationVC presentViewController:[HCBLoginVC new] animated:YES completion:nil];
}



@end
