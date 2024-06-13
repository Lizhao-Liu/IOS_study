//
//  GasStationMerchantMainModule.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/11.
//

#import "GasStationMerchantMainModule.h"
@import YMMRouterLib;
@import MBFoundation;
@import MBUIKit;
#import "GasStationRouterCommonHandler.h"
#import "GasStationActivityRouterFilter.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface GasStationMerchantMainModule ()

// APP是否启动完成 YES:是
@property (nonatomic) BOOL beInMain;

// app跳转链接目标页面
@property (nonatomic, strong) NSURL *linkUrl;

@end

@moduleEX(GasStationMerchantMainModule)

#pragma mark - YMMModuleProtocol Method

+ (nonnull NSString *)moduleName {
    return @"GasStationMerchant";
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.beInMain = NO;
        self.linkUrl = nil;
        // 监听app到了主页
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configAppInMain) name:YMMAppDidLoadMainPageNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// iOS9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self handleOpenUrl:url.absoluteURL];
    return YES;
}


// app根据链接跳转
- (void)handleOpenUrl:(NSURL *)url {
    if ([NSString mb_isNilOrEmpty:[url host]]) {
        return;
    }
    // 首先记录等待打开的链接
    self.linkUrl = url;
    
    // 如果app还在启动中，直接return
    if (!self.beInMain) {
        return;
    }
    
    if (self.linkUrl) {
        // 如果app已经启动完成，则打开对应链接
        [self routeControllerWithUrl:self.linkUrl];
        // 销毁当前跳转链接
        self.linkUrl = nil;
    }
}

// app启动完成已经到了主页
- (void)configAppInMain {
    // 首先设置app已经启动到主页状态
    self.beInMain = YES;
    
    // 如果没有等待打开的链接，直接return
    if (self.linkUrl == nil) {
        return;
    }
    
    // 如果有等待打开的链接，则打开对应的链接
    [self routeControllerWithUrl:self.linkUrl];
    // 销毁当前跳转链接
    self.linkUrl = nil;
}


- (void)routeControllerWithUrl:(NSURL *)url {
    // 外部跳转
    [YMMRouterCenter pushWithUrl:url
                          params:nil
              fromViewController:[UIViewController mb_currentViewController]];
}


- (NSArray<YMMRouter *> *)routers {
    NSArray *defaultSchemes = @[@"ymm", @"ymm-driver", @"ymm-consignor", @"wlqq", @"wlqq.driver", @"wlqq.consignor", @"wlqq.consignor.launch"];
    
    YMMRouter *scanRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                   hostPattern:@"codescanner"];
    YMMRouterTable *scanTable = [[YMMRouterTable alloc] init];
    GasStationRouterCommonHandler *routerCommonHandler = [[GasStationRouterCommonHandler alloc] init];
    [scanTable registerHandler:routerCommonHandler forPathPattern:@"/codescanner"];
    [scanTable registerHandler:routerCommonHandler forPathPattern:@"/rich_scan"];
    [scanTable registerHandler:routerCommonHandler forPathPattern:@"/scan"];
    [scanRouter addRouterTable:scanTable];
    
    YMMRouterTable *activityTable = [[YMMRouterTable alloc] init];
    [activityTable registerHandler:routerCommonHandler forPathPattern:@"^/\\S+$"];
    YMMRouter *activityRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                       hostPattern:@"activity"];
    [activityRouter addRouterTable:activityTable];
    [activityRouter addFilter:[GasStationActivityRouterFilter new]];
    
    return @[scanRouter, activityRouter];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (@available(iOS 14.5, *)) { //1294期苹果应用市场审核被拒，添加追踪用户信息权限弹窗
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {}];
    }
}


@end
