//
//  TMSBaseModule.m
//  TMSBaseModule
//
//  Created by zht on 2021/5/13.
//

#import "TMSBaseModule.h"
#import "TMSBaseRouterHandler.h"
#import "HCBRouterCommonHandler.h"
#import "TMSAppStatusManager.h"
#import "TMSCommonMacros.h"
#import "TMSBridgeNetworkRequestAdapter.h"
@import YMMRouterLib;
@import MBAppBasisModule;
@import MBShareLib;
@import MBMessageCenterLib;
@import YMMBridgeModuleService;
@import MBMainContainerLib;


@moduleEX(TMSBaseModule)

// 注册路由
- (NSArray<YMMRouter *> *)routers
{
    /*  1、异步处理处理  */
    TMSBaseAsyncRouterHandler *asyncHandler = [[TMSBaseAsyncRouterHandler alloc] init];
    
    //注册城市选择路由
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [table registerHandler:asyncHandler forPathPattern:@"/citypicker"];
    
    YMMRouter *cargoRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm"] hostPattern:@"base"];
    [cargoRouter addRouterTable:table];

    /*  2、同步处理处理  */
    TMSBaseSyncRouterHandler *syncHandler = [[TMSBaseSyncRouterHandler alloc] init];

    //注册webview路由
    YMMRouterTable *webTable = [[YMMRouterTable alloc] init];
    [webTable registerHandler:syncHandler forPathPattern:@"/web"];
    
    YMMRouter *webRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm"] hostPattern:@"web"];
    [webRouter addRouterTable:webTable];
    
    //注册app首页路由
    YMMRouterTable *mainTable = [[YMMRouterTable alloc] init];
    [mainTable registerHandler:syncHandler forPathPattern:@"/main"];
    [mainTable registerHandler:syncHandler forPathPattern:@"/mine"];
    [mainTable registerHandler:syncHandler forPathPattern:@"/workbench"];
    
    YMMRouter *mainRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm"] hostPattern:@"tms"];
    [mainRouter addRouterTable:mainTable];
    
    //注册登录路由
    TMSBaseUserSyncRouterHandler *userSyncHandler = [[TMSBaseUserSyncRouterHandler alloc] init];
    YMMRouterTable *userTable = [[YMMRouterTable alloc] init];
    [userTable registerHandler:userSyncHandler forPathPattern:@"/login"];
    YMMRouter *userRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm"] hostPattern:@"user"];
    [userRouter addRouterTable:userTable];
    
    //上传日志
    YMMRouter *logRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm", @"ymm-driver", @"ymm-yy",@"ymm-consignor"]
                                               hostPattern:@"view"];
    YMMRouterTable *logTable = [[YMMRouterTable alloc] init];
    [logTable registerHandler:MBLogUploadLogHandler.new forPathPattern:@"/logupload"];
    [logRouter addRouterTable:logTable];
    

    // 扫一扫
    // 注意：扫一扫路由注册逻辑，在 扫一扫库 HCBCodeScaner  2.2.x 版本之后，会被迁移到HCBCodeScaner中，此处逻辑可考虑移除
    // 参考：https://wiki.amh-group.com/pages/viewpage.action?pageId=814402759
    NSArray *defaultSchemes = @[@"ymm", @"ymm-driver", @"ymm-consignor", @"wlqq", @"wlqq.driver", @"wlqq.consignor", @"wlqq.consignor.launch"];
    YMMRouter *scanRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes hostPattern:@"codescanner"];
    YMMRouterTable *scanTable = [[YMMRouterTable alloc] init];
    HCBRouterCommonHandler *hcbCommonHandle = [[HCBRouterCommonHandler alloc] init];
    [scanTable registerHandler:hcbCommonHandle forPathPattern:@"/codescanner"];
    [scanTable registerHandler:hcbCommonHandle forPathPattern:@"/rich_scan"];
    [scanTable registerHandler:hcbCommonHandle forPathPattern:@"/scan"];
    [scanRouter addRouterTable:scanTable];
    
    // 首页Tab 路由
    MBMainTabGeneralRouter *ymmHandle = [[MBMainTabGeneralRouter alloc] init];
    
    YMMRouter *appRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                  hostPattern:@"app"];
    YMMRouterTable *appTable = [[YMMRouterTable alloc] init];
    [appTable registerHandler:ymmHandle forPathPattern:@"/tab"];
    [appTable registerHandler:ymmHandle forPathPattern:@"/tabindex"];
    [appTable registerHandler:ymmHandle forPathPattern:@"/totab"];
    [appTable registerHandler:ymmHandle forPathPattern:@"/main"];
    [appRouter addRouterTable:appTable];
    
    // 首页Tab快捷路由
    YMMRouter *mainTabRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                      hostPattern:@"main"];
    YMMRouterTable *mainFastRoutertable = [[YMMRouterTable alloc] init];
    [mainFastRoutertable registerHandler:ymmHandle forPathPattern:@"/offshelf"];
    [mainFastRoutertable registerHandler:ymmHandle forPathPattern:@"/onshelf"];
    
    [mainTabRouter addRouterTable:mainFastRoutertable];
    
    return @[cargoRouter,webRouter,mainRouter,logRouter,scanRouter,userRouter, appRouter, mainTabRouter];
}

+ (nonnull NSString *)moduleName {
    return @"TMSBaseModule";
}

- (void)moduleDidSetup {
    [[MBAdapter shared] registerAdapterOfProtocol:@protocol(MBBridgeNetworkRequestAdapterProtocol) usedImplClass:[TMSBridgeNetworkRequestAdapter class]];
}

#pragma mark - UIApplication lifeCycle

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    BOOL isSchemeOpenApp = NO;
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url) {
        isSchemeOpenApp = YES;
    }
    if (!isSchemeOpenApp) {
        NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
        if(bundleId) {
            isSchemeOpenApp = YES;
        }
    }
    if (!isSchemeOpenApp) {
        UILocalNotification * localNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if(localNotify) {
            isSchemeOpenApp = YES;
        }
    }
    if (!isSchemeOpenApp) {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(userInfo) {
            isSchemeOpenApp = YES;
        }
    }
    [[TMSAppStatusManager shared] setSchemeOpenAppState:isSchemeOpenApp];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([MBShareManager mbsharelib_application:app openURL:url options:options]){ // 除微信外其他分享平台回调处理
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if([MBShareManager mbsharelib_application:application continueUserActivity:userActivity restorationHandler:restorationHandler]){ // 除微信外其他分享平台回调处理
        return YES;
    }
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

#pragma mark - WXApiDelegate Method
- (void)onResp:(BaseResp *)resp {
    [[MBShareChannelManager defaultManager] onShareResp:resp forPlatform:MBSharePlatformWechat];
}

#pragma mark - UIApplicationDelegate - Remote/Local Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    TMSBaseModuleLog_Warning(@"[XH]%s", __func__);
    [MBMessageCenterManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    TMSBaseModuleLog_Debug(@"[XH]%s", __func__);
    [MBMessageCenterManager handleNotification:userInfo forApplicationState:application.applicationState isLocalNotification:NO tap:NO];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([[MBMessageCenterManager shared] isAllowedNotification]) {
        TMSBaseModuleLog_Debug(@"[XH]%s", __func__);
        [MBMessageCenterManager handleNotification:userInfo forApplicationState:application.applicationState isLocalNotification:NO tap:NO];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    TMSBaseModuleLog_Debug(@"[XH]%s", __func__);
    [MBMessageCenterManager handleNotification:notification.userInfo forApplicationState:application.applicationState isLocalNotification:YES tap:NO];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    TMSBaseModuleLog_Debug(@"[XH]%s>>>>>>>>error:%@", __func__,error);
    [MBMessageCenterManager didFailToRegisterForRemoteNotificationsWithError:error];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
