//
//  TMSMainPageFactory.m
//  MBTMSModule
//
//  Created by Lizhao on 2023/12/21.
//

#import "TMSMainPageFactory.h"
#import "TMSBaseModule.h"
#import "MBTMSModule-Swift.h"
#import "TMSUserManager.h"
@import MBMainContainerLib;
@import YMMUserModuleService;
@import YMMRouterLib;
@import MBAPMLib;
@import MBUIKit;
@import MBConfigCenter;

@interface TMSMainPageFactory()

@property (nonatomic, copy) changeRootVCBlock changeRootVCBlock;
@property (nonatomic, strong) UIViewController *rootTabBarVC;

@end

@implementation TMSMainPageFactory

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIViewController *)createMainPageWithChangeRootVCBlock:(changeRootVCBlock)changeRootVCBlock {
    self.changeRootVCBlock = changeRootVCBlock;
    [self registerNotifications];
    return [self getCurrentRootVC];
    
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootVC) name:MBUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootVC) name:MBUserLogoutNotification object:nil];
}

- (void)switchRootVC {
    if (self.changeRootVCBlock) {
        self.changeRootVCBlock([self getCurrentRootVC]);
    }
}

- (UIViewController *)getCurrentRootVC {
    UIViewController * currentRootVC = nil;
    if([TMSUserManager sharedTMSUserManager].isLogin){
        currentRootVC = self.rootTabBarVC; // 如果接收到登录通知，则跳转到tabbar vc
    } else {
        currentRootVC = [self getLoginVC]; // 如果接收到登出通知，则跳转到登录界面
    }
    return currentRootVC;
}

- (UIViewController *)rootTabBarVC {
    if(!_rootTabBarVC){
        _rootTabBarVC = [[MBCustomTabBarController alloc] init];
    }
    return _rootTabBarVC;
}

-(UIViewController *)getLoginVC {
    TMSNewLoginVC *loginVC = [[TMSNewLoginVC alloc] init];
    return loginVC;
}


@end
