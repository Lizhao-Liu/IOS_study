//
//  MBAPMService.m
//  MBAPMLib
//
//  Created by xp on 2020/7/27.
//

#import "MBAPMService.h"
#import "MBAPMMonitor.h"
#import "MBAPMMemoryMonitor.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMAppLaunchMonitor.h"
@import YMMModuleLib;


@serviceEX(MBAPMService, MBAPMServiceProtocol)

- (NSString *)serviceName {
    return @"MBAPMService";
}

+ (BOOL)singleton {
    return YES;
}

- (void)startMonitor:(MBAPMConfiguration *)configuration {
    [MBAPMMonitor startMonitor:configuration];
}

- (void)enableCustomLaunchEnding {
    [MBAPMMonitor enableCustomLaunchEnding];
}

- (void)endAppLaunch {
    [MBAPMMonitor endAppLaunch];
}

- (void)enableRenderMonitor:(BOOL)enable {
    [MBAPMMonitor enableRenderMonitor:enable];
}

- (id<MBAPMEventTrack>)startTrack:(id<MBAPMViewPageProtocol>)viewPage {
    return [[MBAPMMonitor sharedInstance]startTrack:viewPage];
}

- (id<MBAPMEventTimeTrack>)startPageRenderTrack:(id<MBAPMViewPageProtocol>)viewPage {
    return [[MBAPMMonitor sharedInstance]startPageRenderTrack:viewPage];
}

- (void)addRenderDetectBlockList:(NSArray<NSString *> *)pageClassNameList {
    return [[MBAPMMonitor sharedInstance] addRenderDetectBlockList:pageClassNameList];
}

- (UInt64)getAppLaunchStartTime {
    return [[MBAPMAppLaunchMonitor shareInstance]getAppLaunchStartTime];
}

// MARK: - 内存相关设置
//直接分发给 执行者

- (void)addClassNamesToLeaksWhitelist:(NSArray *)classNames {
    [[[MBAPMMonitor sharedInstance] memoryMonitor] addClassNamesToLeaksWhitelist:classNames];
}

- (void)setEnableLeaksFinder:(BOOL)enable {
    [[[MBAPMMonitor sharedInstance] memoryMonitor] setEnableLeaksFinder:enable];
}

- (BOOL)isEnableLeaksFinder {
    return [[[MBAPMMonitor sharedInstance] memoryMonitor] isEnableLeaksFinder];
}

- (void)setEnableLeaksAlert:(BOOL)enable {
    [[[MBAPMMonitor sharedInstance] memoryMonitor] setEnableLeaksAlert:enable];
}

- (BOOL)isEnableLeaksAlert {
    return [[[MBAPMMonitor sharedInstance] memoryMonitor] isEnableLeaksAlert];
}

- (void)setEnableCheckRetainCycle:(BOOL)enable {
    [[[MBAPMMonitor sharedInstance] memoryMonitor] setEnableCheckRetainCycle:enable];
}

- (BOOL)isEnableCheckRetainCycle {
    return [[[MBAPMMonitor sharedInstance] memoryMonitor] isEnableCheckRetainCycle];
}

// MARK: - 页面相关
- (NSString * _Nullable)currentPageName {
    return [MBAPMCurrentPageInfo currentPageName];
}
- (NSString * _Nullable)currentPageClassName {
    return [MBAPMCurrentPageInfo currentPageClassName];
}
- (NSString * _Nullable)currentPagePath {
    return [MBAPMCurrentPageInfo currentPagePath];
}
// 若未命中apm内部灰度，返回NO；若在页面加载判断过程中，返回YES，直至判断结束。
- (BOOL)currentPageIsLoading {
    return [MBAPMCurrentPageInfo currentPageIsLoading];
}

@end
