//
//  YMMRouterDebugMonitor.m
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import "YMMRouterDebugMonitor.h"
#import "YMMRouterDebugEventMonitorManager.h"
#import "YMMRouterDebugMonitorDataSource.h"
#import "MBRouterDebugMonitorDefine.h"
@import YMMModuleLib;
@import YMMRouterLib;
@import MBDebug;
@import MBFoundation;

@serviceEX(YMMRouterDebugMonitor, MBDebugMonitorServiceProtocol)
@synthesize title;
@synthesize monitorVCBlock;
@synthesize isMonitoring;
@synthesize monitorStatusChangedBlock;

- (NSString *)title {
    return MBRouterDebugMonitorTitle;
}

- (MBDebugMonitorPanelBlock)monitorVCBlock {
    return ^(){
        MBDebugActivityMonitorDefaultViewController *vc = [[MBDebugActivityMonitorDefaultViewController alloc] initWithDataSource:[YMMRouterDebugMonitorDataSource sharedDataSource]];
        return vc;
    };
}

- (void)monitorToolDidLoad {
    [YMMRouterDebugEventMonitorManager sharedInstance];
}

- (BOOL)isMonitoring {
    return [YMMRouterDebugEventMonitorManager sharedInstance].isMonitoring;
}

- (MBDebugMonitorPageInfoBlock)pageInfoBlock {
    return ^NSArray<MBDebugMonitorPageInfoModel *> * _Nullable(UIViewController *pageVC) {
        NSString *pageUrlOfPageVC= pageVC.mbNavPageInfo.topPageUrl;
        if(!pageUrlOfPageVC){
            return nil;
        }
        MBDebugMonitorPageInfoModel *pageInfoModel = [[MBDebugMonitorPageInfoModel alloc] init];
        pageInfoModel.sectionTitle = @"路由信息";
        pageInfoModel.sectionDict = @{@"url":[pageUrlOfPageVC mb_decodeURI]};
        return @[pageInfoModel];
    };
}


- (MBDebugMonitorStatusChangedBlock)monitorStatusChangedBlock {
    return ^(BOOL isOn){
        if(isOn){
            [[YMMRouterDebugEventMonitorManager sharedInstance] startMonitorRouterEvent];
        } else {
            [[YMMRouterDebugEventMonitorManager sharedInstance] stopMonitorRouterEvent];
            [[YMMRouterDebugMonitorDataSource sharedDataSource] clear];
        }
    };
}

@end

