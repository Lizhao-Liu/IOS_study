//
//  TMSMainPageGeneralHandler.m
//  MBTMSModule
//
//  Created by Lizhao on 2023/12/22.
//

#import "TMSMainPageHandler.h"
#import "TMSUserManager.h"
#import "TMSBaseModule.h"
#import "TMSAppStatusManager.h"
#import "TMSCommonMacros.h"
#import "MBTMSModule-Swift.h"
#import "TMSColdLaunchManger.h"
@import MBMainContainerLib;

@interface TMSMainPageHandler()

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL FirstNotification;

@end


@serviceComposeEX(TMSMainPageHandler)

- (instancetype)init {
    if (self = [super init]) {
        self.isFirst = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MBMainPageLifeCycleProtocol


-(void) tabBarControllerWillAppear:(id<MBUITabBarControllerProtocol>)tabBarController
{
    if (self.isFirst == NO) {
        self.isFirst = YES;
        // 冷启动业务
        // TMS 历史逻辑保留
        [[TMSColdLaunchManger sharedTMSColdLaunchManger] handleClodLaunchTaskRequest];
    } else {
        [[TMSAppStatusManager shared] setSchemeOpenAppState:NO];
    }
}

- (void)tabBarControllerDidAppear:(id<MBUITabBarControllerProtocol>)tabBarController{
    if (self.FirstNotification == NO) {
        // TMS 历史逻辑保留
        self.FirstNotification = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:TMSKEY_NOTI_ENTERMAINPAGE object:nil];
    }
    
    [self checkTabPageNeedLoginWithTabBarVC:tabBarController];
}


- (void)tabBarControllerWillRealAppear:(id<MBUITabBarControllerProtocol>)tabBarController {
    [self checkTabPageNeedLoginWithTabBarVC:tabBarController];
}


- (void)checkTabPageNeedLoginWithTabBarVC:(id<MBUITabBarControllerProtocol>)tabBarController {
    if(![TMSUserManager sharedTMSUserManager].isLogin){
        if ([tabBarController conformsToProtocol:@protocol(MBUITabBarControllerProtocol)] &&
            [tabBarController respondsToSelector:@selector(tabModel)]) {
            MBMainTabConfigModel *configModel = ((id<MBBizTabBarVCProtocol>)tabBarController).tabModel;
            NSArray<MBMainTabItem *> *tabList = configModel.tabList;
            if (![tabBarController respondsToSelector:@selector(selectedIndex)]) {
                return;
            }
            NSUInteger index = tabBarController.selectedIndex;
            if (tabList && tabList.count > index && index >= 0) {
                MBMainTabItem *currentItem = tabList[index];
                NSDictionary *params = [MBJsonUtil dictionaryWithJsonString:currentItem.extParam];
                if(params) {
                    id tabPageNeedLoginObj = params[@"tabPageNeedLogin"];
                    if ([tabPageNeedLoginObj isKindOfClass:[NSNumber class]] || [tabPageNeedLoginObj isKindOfClass:[NSString class]]) {
                        BOOL tabPageNeedLogin = [tabPageNeedLoginObj boolValue];
                        if (tabPageNeedLogin) {
                            // 首页tab配置如果extParams中带有tabPageNeedLogin=1，且用户没有登录则需要跳转到登录页面
                            [self presentLoginVC];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - MBMainPageEventProtocol


-(void)tabBar:(id<MBUITabBarControllerProtocol>)tabBarController didSelectedTabItem:(MBMainTabItem *)tabItem
{
    if (![TMSUserManager sharedTMSUserManager].isLogin) {
        NSDictionary *params = [MBJsonUtil dictionaryWithJsonString:tabItem.extParam];
        if(params) {
            id tabPageNeedLoginObj = params[@"tabPageNeedLogin"];
            if ([tabPageNeedLoginObj isKindOfClass:[NSNumber class]] || [tabPageNeedLoginObj isKindOfClass:[NSString class]]) {
                BOOL tabPageNeedLogin = [tabPageNeedLoginObj boolValue];
                if (tabPageNeedLogin) {
                    // 首页tab配置如果extParams中带有tabPageNeedLogin=1，且用户没有登录则需要跳转到登录页面
                    [self presentLoginVC];
                }
            }
        }
    }
    
    if (![tabBarController respondsToSelector:@selector(tabBar)] ||
        ![tabBarController.tabBar respondsToSelector:@selector(items)]) {
        return;
    }
    
    NSArray *tabBarItems = tabBarController.tabBar.items;
    if (tabBarItems.count <= tabBarController.selectedIndex) {
        return;
    }
    
    id<MBBizTabBarItemProtocol>  tabBarItem = (id<MBBizTabBarItemProtocol> )[tabBarController.tabBar tabItemAtIndex:tabBarController.selectedIndex];
    if (tabBarItem.enableAutoHide) {
        [tabBarItem hideBadge:YMMTabBarBadgeType_RedDot | YMMTabBarBadgeType_Number];
    }
    
    // TMS 历史逻辑保留
    TMSBaseModuleLog_Info(@"TAB_SELECTED_VC:%@",tabItem.tabPage);
    [[NSNotificationCenter defaultCenter] postNotificationName:TMSKEY_NOTI_TAB_SELECTED_CHANGED object:nil];
}


- (void)presentLoginVC {
    TMSNewLoginVC *loginVC = [[TMSNewLoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [loginVC.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}



@end
