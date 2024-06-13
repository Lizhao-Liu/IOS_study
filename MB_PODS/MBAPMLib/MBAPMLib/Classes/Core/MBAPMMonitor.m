//
//  MBAPMMonitor.m
//  MBAPMLib
//
//  Created by xp on 2020/7/6.
//

#import "MBAPMMonitor.h"
#import "MBAPMPluginManager.h"
#import "MBAPMAppLaunchMonitor.h"
#import "MBAPMRenderMonitor.h"
#import "MBAPMMemoryMonitor.h"
#import "MBAPMDoctorEventTracker.h"
#import "MBAPMSystemDataGather.h"
#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMContext+RenderMonitor.h"
@import MBAPMServiceLib;
@import MBLogLib;
@import YYModel;
@import MBProjectConfig;

@interface MBAPMMonitor()

@property (nonatomic, strong) MBAPMContext *context;

@end

@implementation MBAPMMonitor

#pragma mark - public method

+ (void)startMonitor:(MBAPMConfiguration *)configuration{
    [[MBAPMAppStateUtil shared] configAppLaunchWithId:[MBAppLaunchInfo launchID]];
    
    MBAPMContext *context = [MBAPMContext createContext];
    context.configuration = configuration;
    [context.allRenderDetectBlockList addObjectsFromArray:context.configuration.renderDetectBlockList];
    context.getLaunchTimeBlock = ^NSDictionary *{
        MBAPMAppLaunchTimeModel *launchTime = [[MBAPMAppLaunchMonitor shareInstance] getAppLaunchTime];
        NSDictionary *dic = @{@"launch_elapsedTime": @(launchTime.elapsedTime), @"launch_endTimestamp": @(launchTime.endTimestamp), @"launch_isMainPage": @(launchTime.isMainPage)};
        return dic;
    };
    [MBAPMMonitor sharedInstance].context = context;
    if(configuration.enableDataGather) {
        [[MBAPMSystemDataGather sharedIntance]startDataGather:configuration.dataGatherFrequency];
    }
    MBAPMPluginManager *manager = [MBAPMPluginManager initWithContext:context];
    [manager startPlugins];
}

+ (instancetype)sharedInstance {
    static MBAPMMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMMonitor alloc]init];
    });
    return instance;
}

+ (void)enableRenderMonitor:(BOOL)enable {
    [[MBAPMPluginManager shared]enablePlugin:enable withTag:MBAPMPluginTagRenderDetect];
}

+ (void)enableCustomLaunchEnding {
    [MBAPMAppLaunchMonitor enableCustomLaunchEnding];
}

+ (void)startAppLaunch:(MBLaunchMode)launchMode launchTags:(NSDictionary *)tags {
    [[MBAPMAppLaunchMonitor shareInstance] startAppLaunch:launchMode launchTags:tags];
}

+ (void)endAppLaunch {
    [[MBAPMAppLaunchMonitor shareInstance] customEndAppLaunch];
}

+ (void)trackDoctorEvent:(__kindof id<MBDoctorEventProtocol>)event context:(__kindof id<MBContextProtocol>)context {
    [[MBAPMDoctorEventTracker sharedInstance] trackEvent:event context:context];
}

- (void)setDelegate:(id<MBAPMDelegate>)delegate {
    [MBAPMMonitor sharedInstance].context.delegate = delegate;
}

- (id<MBAPMEventTimeTrack>)getAppLaunchTrack {
//    MBAPMAppLaunchMonitor *appLaunchPlugin = (MBAPMAppLaunchMonitor *)[[MBAPMPluginManager shared]getPlugin:MBAPMPluginTagAppLaunch];
    return [[MBAPMAppLaunchMonitor shareInstance] getAppLaunchTrack];
}

- (MBAPMAppLaunchTimeModel *)getAppLaunchTime {
    return [[MBAPMAppLaunchMonitor shareInstance] getAppLaunchTime];
}

- (void)aysncGetAppLaunchTime:(MBAPMLaunchTimeCallback)callback {
    return [[MBAPMAppLaunchMonitor shareInstance] asyncGetAppLaunchTime:callback];
}

- (id<MBAPMEventTrack>)startTrack:(id<MBAPMViewPageProtocol>)viewPage {
    MBAPMRenderMonitor *plugin = (MBAPMRenderMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagRenderDetect];
    return [plugin startTrack:viewPage];
}

- (id<MBAPMEventTimeTrack>)startPageRenderTrack:(id<MBAPMViewPageProtocol>)viewPage {
    MBAPMRenderMonitor *plugin = (MBAPMRenderMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagRenderDetect];
    return [plugin startEventTimeTrack:viewPage];
}

- (MBAPMMemoryMonitor *)memoryMonitor {
    return (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
}

- (void)addRenderDetectBlockList:(NSArray<NSString *> *)pageClassNameList {
    [self.context.allRenderDetectBlockList addObjectsFromArray:pageClassNameList];
}


#pragma mark - private method

@end
