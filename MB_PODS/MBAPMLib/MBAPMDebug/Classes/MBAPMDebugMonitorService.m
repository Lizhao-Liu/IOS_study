//
//  MBAPMDebugMonitorService.m
//  MBAPMDebug
//
//  Created by Lizhao on 2023/8/10.
//

#import "MBAPMDebugMonitorService.h"
#import "MBAPMDebugMonitorDefine.h"
#import "MBAPMDebugMonitorLogModelFactory.h"
@import MBLogLibDebug;
@import MBDebug;
@import MBFoundation;

@interface MBAPMDebugMonitorDataSource : MBDebugMonitorLogDataSource

+ (instancetype)sharedDataSource;

- (void)unregisterDataSource;

@end

@implementation MBAPMDebugMonitorDataSource

+ (instancetype)sharedDataSource {
    static dispatch_once_t once;
    static MBAPMDebugMonitorDataSource *instance;
    dispatch_once(&once, ^{
        instance = [[MBAPMDebugMonitorDataSource alloc] initWithMonitorTitle:MBAPMDebugMonitorTitle];
        instance.countLimit = 1000; // 自定义最多展示数量
        [instance registerDataSource];
    });
    return instance;
}


- (void)registerDataSource {
    [[MBLogDebugMonitorDataSource sharedDataSource] registerChildDataSource:self predicate:^BOOL(id  _Nonnull object) {
        MBLogDebugMonitorLogModel *model = (MBLogDebugMonitorLogModel *)object;
        NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:model.message];
        NSString *metricName = [MBAPMDebugLogUtils metricNameWithLogDict:contentDict];
        for(NSString *apmAlertIndicator in [MBAPMDebugMonitorLogModelFactory apmAlertIndicators]){
            if([metricName isEqualToString:apmAlertIndicator]){
                return YES;
            }

        }
        return NO;
    } formatter:^id<MBDebugMonitorLogObject> _Nonnull(id  _Nonnull object) {
        MBLogDebugMonitorLogModel *originalObject = (MBLogDebugMonitorLogModel *)object;
        return [MBAPMDebugMonitorLogModelFactory apmLogModelWithLog:originalObject.message time:originalObject.logTime page:originalObject.pageName];
    }];
}


- (void)unregisterDataSource {
    [[MBLogDebugMonitorDataSource sharedDataSource] unregisterChildDataSource:self];
}


@end

@serviceEX(MBAPMDebugMonitorService, MBDebugMonitorServiceProtocol)

@synthesize title;
@synthesize monitorVCBlock;
@synthesize isMonitoring;
@synthesize monitorStatusChangedBlock;
@synthesize pageInfoBlock;

- (NSString *)title {
    return MBAPMDebugMonitorTitle;
}

- (MBDebugMonitorPanelBlock)monitorVCBlock {
    return ^(){
        MBDebugMonitorPanelConfigModel *config = [[MBDebugMonitorPanelConfigModel alloc] init];
        config.tagFilterTitle = @"type";
        config.needShowTagFilter = YES;
        MBDebugActivityMonitorDefaultViewController *vc = [[MBDebugActivityMonitorDefaultViewController alloc] initWithDataSource:[MBAPMDebugMonitorDataSource sharedDataSource] configuration:config];
        return vc;
    };
}

- (void)monitorToolDidLoad {
    [MBAPMDebugMonitorDataSource sharedDataSource];
}

- (BOOL)isMonitoring {
    return [MBAPMDebugMonitorManager defaultManager].isMonitoring;
}


- (MBDebugMonitorStatusChangedBlock)monitorStatusChangedBlock {
    return ^(BOOL isOn){
        [MBAPMDebugMonitorManager defaultManager].isMonitoring = isOn;
    };
}


- (MBDebugMonitorPageInfoBlock)pageInfoBlock {
    return ^(UIViewController *pageVC){
        return [[MBAPMDebugMonitorDataSource sharedDataSource] pageInfosWithPageVC:pageVC];
    };
}

@end

@implementation MBAPMDebugMonitorManager

+ (instancetype)defaultManager {
    static dispatch_once_t once;
    static MBAPMDebugMonitorManager *instance;
    dispatch_once(&once, ^{
        instance = [[MBAPMDebugMonitorManager alloc] init];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:MBAPMDebugMonitorSwitch]) {
            instance.isMonitoring = [[NSUserDefaults standardUserDefaults] boolForKey:MBAPMDebugMonitorSwitch];
        } else {
            instance.isMonitoring = YES;
        }
    });
    return instance;
}


- (void)setIsMonitoring:(BOOL)isOn {
    if(!isOn){
        [[MBAPMDebugMonitorDataSource sharedDataSource] clear];
        [[MBAPMDebugMonitorDataSource sharedDataSource] unregisterDataSource];
    } else {
        [[MBAPMDebugMonitorDataSource sharedDataSource] registerDataSource];
    }
    _isMonitoring = isOn;
    [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey:MBAPMDebugMonitorSwitch];
}

@end
