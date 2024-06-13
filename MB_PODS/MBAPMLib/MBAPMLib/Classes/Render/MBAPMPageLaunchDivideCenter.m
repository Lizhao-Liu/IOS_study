//
//  MBAPMPageLaunchDivideCenter.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/4/11.
//

#import "MBAPMPageLaunchDivideCenter.h"
#import "MBAPMViewPageContext.h"
#import "MBAPMEventTimeTrackMgrPro.h"
#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMLogDef.h"
#import "UIViewController+MBAPMRenderMonitor.h"
#import "MBAPMNetworkDateManager_Private.h"
#import "MBAPMNetworkDateManager.h"
#import "MBAPMTimeUtil.h"
#import "MBDeviceInfo.h"
#import "MBAPMRenderDetector.h"
#import "MBAPMWhiteScreenCounter.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMPageViewTrackTask.h"
#import <objc/runtime.h>

@import MBFoundation;
@import MBAPMServiceLib;

static NSString *kAssociatedIsLoadedKey;
static NSString *kAssociatedIsAppearKey;

@interface UIViewController (MBAPMPageLaunchDivideCenter)

@property (nonatomic, assign) BOOL isLoadedFlag;
@property (nonatomic, assign) BOOL isAppearFlag;
@property (nonatomic, assign) BOOL isDidAppearFlag;
@property (nonatomic, assign) BOOL isDisappearFlag;

@end

@implementation UIViewController (MBAPMPageLaunchDivideCenter)
- (BOOL)isLoadedFlag {
    return [objc_getAssociatedObject(self, &kAssociatedIsLoadedKey) boolValue];
}

- (void)setIsLoadedFlag:(BOOL)isLoadedFlag {
    objc_setAssociatedObject(self, &kAssociatedIsLoadedKey, @(isLoadedFlag), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAppearFlag {
    return [objc_getAssociatedObject(self, &kAssociatedIsAppearKey) boolValue];
}

- (void)setIsAppearFlag:(BOOL)isAppearFlag {
    objc_setAssociatedObject(self, &kAssociatedIsAppearKey, @(isAppearFlag), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isDidAppearFlag {
    return [objc_getAssociatedObject(self, @selector(isDidAppearFlag)) boolValue];
}

- (void)setIsDidAppearFlag:(BOOL)isDidAppearFlag {
    objc_setAssociatedObject(self, @selector(isDidAppearFlag), @(isDidAppearFlag), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isDisappearFlag {
    return [objc_getAssociatedObject(self, @selector(isDisappearFlag)) boolValue];
}

- (void)setIsDisappearFlag:(BOOL)isDisappearFlag {
    objc_setAssociatedObject(self, @selector(isDisappearFlag), @(isDisappearFlag), OBJC_ASSOCIATION_ASSIGN);
}

@end

@import MBUIKit;
@import MBDoctorService;
@import MBAPMServiceLib;
#import <TypedJSON/TypedJSON.h>

@interface MBViewLayoutStateModel : NSObject

@property (nonatomic, weak) id<MBAPMEventTimeTrack> track;
@property (nonatomic, assign) BOOL isViewChange;
@property (nonatomic, assign) NSUInteger noChangeTimes;
@property (nonatomic, assign) BOOL firstChecked;
@property (nonatomic, assign) NSUInteger timerTimes;
@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, assign) BOOL parentIsContainer;
@property (nonatomic, assign) BOOL pageSuccessed; // 通过其他手段判定的开屏成功；例如八宫格判定
@property (nonatomic, assign) BOOL enteredBackground; // 通过其他手段判定的开屏成功；例如八宫格判定
@property (nonatomic, assign) UInt64 lastUpdateTimestamp; // view最后一次更新时间

@end

@implementation MBViewLayoutStateModel
@end

@interface MBAPMPageLaunchDivideCenter () <MBUIKitHookAppliactionObserverProrocol, MBUIKitHookViewControllerObserverProrocol, MBUIKitHookViewObserverProrocol> {
    BOOL _currentPageIsLoading;
}
@property (strong, nonatomic) NSThread *timerThread;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMapTable<UIViewController *, MBViewLayoutStateModel *> *viewMap;

@property (strong, nonatomic) NSSet<Class> *blackCls;

@end

@interface MBAPMPageLaunchDivideCenter ()

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, assign) BOOL didLaunchHome;

@end

@implementation MBAPMPageLaunchDivideCenter

+ (BOOL)shouldIgnore:(UIViewController *)vc {
    return [[self sharedInstance] shouldIgnore:vc];
}

- (BOOL)shouldIgnore:(UIViewController *)vc {
    return [_blackCls containsObject:vc.class];
}

// MARK: - Public Methods
- (void)startMonitor {
    if (![MBDeviceInfo canEnableMonitor]) {
        return;
    }
    
    NSArray *clsArray = @[@"_UIAlertControllerTextFieldViewController",
                          @"UIApplicationRotationFollowingController",
                          @"UIAlertController",
                          @"UICompatibilityInputViewController",
                          @"UIInputWindowController",@"UISystemKeyboardDockController",
                          @"UIKeyboardCandidateGridCollectionViewController",
                          @"mbAppStructureViewController",
                          @"mbAppStructureFilterEditViewController",
                          @"UIPredictionViewController",
                          @"UICandidateViewController",
                          @"_UIRemoteInputViewController",
                          @"_JXCategoryListContainerViewController",
                          @"UISystemInputAssistantViewController",
                          @"UIEditingOverlayViewController",
                          @"DoraemonStatusBarViewController",
                          @"MBPushRoateVC",
                          @"UIViewController",
                          @"UINavigationController"];
    NSMutableSet * clsSet = [[NSMutableSet alloc] init];
    [clsArray enumerateObjectsUsingBlock:^(NSString* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cls = NSClassFromString(obj);
        if (cls) {
            [clsSet addObject:cls];
        }
    }];
    _blackCls = clsSet;
    
    _enabled = YES;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(timerStart) object:nil];
        [_timerThread start];
    });
}

- (void)stopMonitor {
    _enabled = NO;
    [self timerStop];
}

- (BOOL)currentPageIsLoading {
    if (_enabled) {
        return _currentPageIsLoading;
    }
    return NO;
}

- (void)beginRouterWithViewController:(UIViewController *)controller {
    NSString *pageName = [self getPageIdOnMainThread:controller];
    [self setCurrentPageBeginLoading:pageName];
}

// MARK: - Private Methods

- (NSString *)getPageIdOnMainThread:(UIViewController *)vc {
    __block NSString *pageName;
    if ([NSThread isMainThread]) {
        pageName = [MBDoctorVCUtil getPageName:vc];
        if (!pageName) {
            pageName = [MBDoctorVCUtil getPageClassName:vc];
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            pageName = [MBDoctorVCUtil getPageName:vc];
            if (!pageName) {
                pageName = [MBDoctorVCUtil getPageClassName:vc];
            }
        });
    }
    return pageName;
}

- (void)setCurrentPageBeginLoading:(NSString *)pageName {
    _currentPageIsLoading = YES;
    
    [[MBAPMNetworkDateManager sharedInstance] startPageLoadPageName:pageName];
}

- (void)setPageEndLoading:(NSString *)pageName {
    _currentPageIsLoading = NO;
    
    [[MBAPMNetworkDateManager sharedInstance] endPageLoadPageName:pageName];
}

- (void)timerStart {
    static dispatch_once_t once2;
    dispatch_once(&once2, ^{
        [[NSThread currentThread] setName:@"com.apm.thread.MBAPMPageLaunchDivideCenter"];
        double timeInterval = 0.05;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        [_timer fire];
    });
}

- (void)timerStop {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerAction {
    __block NSArray *objects;
    if ([NSThread isMainThread]) {
        objects = [[[_viewMap
                   mutableCopy]
                  objectEnumerator]
                 allObjects];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            objects = [[[_viewMap
                       mutableCopy]
                      objectEnumerator]
                     allObjects];
        });
    }
    
    if (!objects) {
        return;
    }
    // check
    [objects enumerateObjectsUsingBlock:^(MBViewLayoutStateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.timerTimes += 1;
        if (_isBackground) {
            obj.enteredBackground = YES;
            [obj.track updateExternalEnv:MBAPMEventTimeTrackTaskExternalEnv_enterBackground];
        }
        if (obj.track.container
            && [obj.track.container isKindOfClass:[UIViewController class]]) {
            // is class
        } else {
            return;
        }
        UIViewController *vc = (UIViewController *)obj.track.container;
        // 检测10秒超时
        if (obj.timerTimes == (NSUInteger)([self pageDivideTimeout] / 50)) {
            NSString *pageName = [self getPageIdOnMainThread:(UIViewController *)obj.track.container];
            [self setPageEndLoading:pageName];
            NSArray *urlInfos = [[MBAPMNetworkDateManager sharedInstance] urlsInfoOfThePageName:pageName];
            UInt64 time = [[MBAPMNetworkDateManager sharedInstance] totalTimeOfThePageName:pageName];
            UInt64 begin = [[MBAPMNetworkDateManager sharedInstance] beginTimeOfThePageName:pageName];
            [obj.track section:@"page_network" beginAt:begin endAt:(begin + time) sectionType:(MBAPMEventTimeSectionType_COCURRENT) withExtra:nil];
            NSDictionary *dic = @{@"urlInfos": urlInfos, @"tags": @{@"success": @(@(obj.pageSuccessed).integerValue), @"detect_result": @(obj.enteredBackground ? -2 : -1)}};
            [obj.track setAssociatedData:dic];
            [obj.track end:@"" withExtra:nil];
               
            if ([vc isDisappearFlag] == NO
                && self.delegate
                && [self.delegate respondsToSelector:@selector(pageDidEndLaunchMonitor:controller:moduleInfo:duration:)]) {
                
                // 页面九宫格判定成功则不进行白屏检测
                if (!obj.pageSuccessed) {
                    if (self.apmConfiguration.pageDivideMonitorEnteredBackground == NO && obj.enteredBackground) {
                        // 不白屏检测
                    } else {
                        if ([[MBAPMCurrentPageInfo currentPageName] isEqualToString:pageName]) {
                            [self.delegate pageDidEndLaunchMonitor:pageName controller:vc moduleInfo:obj.track.moduleInfo duration:obj.timerTimes * 50];
                        }
                    }
                } else {
                    // 没有白屏
                    [[MBAPMWhiteScreenCounter shared] notWhiteScreen:pageName techStack:obj.track.moduleInfo.bundleType];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_viewMap removeObjectForKey:(UIViewController *)obj.track.container];
            });
            *stop = YES;
        }
        
        if (obj.track.container && ([@[@"MBWebViewController", @"LifeCycleThreshViewController"] containsObject:NSStringFromClass(obj.track.container.class)] || ([obj.track.container isKindOfClass:UIViewController.class] && [MBDoctorVCUtil isContainerVC:(UIViewController *)obj.track.container]))) {
            // h5页面和thresh页面使用自己的检测机制
            return;
        }
        // 检测first/second layout
        if (obj.isViewChange == YES) {
            obj.noChangeTimes = 0;
            obj.isViewChange = NO;
//            NSLog(@"eventTimeTrack track = %p, view发生变化，重置noChangeTimes", obj.track);
        } else {
            obj.noChangeTimes += 1;
//            NSLog(@"eventTimeTrack track = %p, view没发生变化，noChangeTimes = %lu", obj.track, obj.noChangeTimes);
            if (obj.noChangeTimes == 5) {
//                NSLog(@"eventTimeTrack track = %p, view没发生变化达到5次", obj.track);
                if (obj.firstChecked == NO) {
                    [self firstLayoutData:obj];
                    
                } else {
                    [obj.track section:kMBAPMEventTimeTrack_Page_Second_Layout endAt:obj.lastUpdateTimestamp > 0?obj.lastUpdateTimestamp: [MBAPMTimeUtil currentTimestamp] withExtra:nil];
                    
                    if (_isBackground) {
                        [self receiveIdle:obj];
                    } else {
                        [self beginTTICheck:obj];
                        
                        // 没有白屏
                        NSString *pageName = [self getPageIdOnMainThread:(UIViewController *)obj.track.container];
                        [[MBAPMWhiteScreenCounter shared] notWhiteScreen:pageName techStack:obj.track.moduleInfo.bundleType];
                    }
                }
            }
        }
    }];
}

- (NSUInteger)pageDivideTimeout {
    NSUInteger time = 10000;
    if (self.apmConfiguration.pageDivideMonitorTimeout > 3000) {
        time = self.apmConfiguration.pageDivideMonitorTimeout;
    }
    return time;
}

- (void)beginTTICheck:(MBViewLayoutStateModel *)model {
    NSNotification *noti = [NSNotification notificationWithName:@"MBAPMPageLaunchDivideNotiNSPostWhenIdle" object:model];
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostWhenIdle];
}

- (void)receiveIdle:(MBViewLayoutStateModel *)model {
    NSString *pageName = [self getPageIdOnMainThread:(UIViewController *)model.track.container];
    [self setPageEndLoading:pageName];
    
    if (model && model.track) {
        if (model.parentIsContainer) {

            [model.track endIsolatedSection:kMBAPMEventTimeTrack_Page_Appear withExtra:nil];
        }
        NSArray *urlInfos = [[MBAPMNetworkDateManager sharedInstance] urlsInfoOfThePageName:pageName];
        UInt64 time = [[MBAPMNetworkDateManager sharedInstance] totalTimeOfThePageName:pageName];
        UInt64 begin = [[MBAPMNetworkDateManager sharedInstance] beginTimeOfThePageName:pageName];
        NSDictionary *dic = @{@"urlInfos": urlInfos, @"tags": @{@"success": @(@(1).integerValue), @"detect_result": @(model.enteredBackground ? -2 : 1)}};
        [model.track section:@"page_network" beginAt:begin endAt:(begin + time) sectionType:(MBAPMEventTimeSectionType_COCURRENT) withExtra:nil];
        [model.track setAssociatedData:dic];
        [model.track end:kMBAPMEventTimeTrack_Page_Interactive_Prepare withExtra:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_viewMap removeObjectForKey:(UIViewController *)model.track.container];
        });
    }
}

- (void)receiveViewDidLoad:(UIViewController *)controller {
    if ([self shouldIgnore:controller]) {
        return;
    }
    BOOL isContainerVC = [MBDoctorVCUtil isContainerVC:controller];
    if (isContainerVC) {
        return;
    }
//    NSLog(@"eventTimeTrack viewDidLoad, viewController = %@", controller);
    
    // 继承 parentViewController 的 track id
    NSString *parentTrackId = [self getPageCurrentTrackId:controller];
    
    // 获取不到生成新的track id，并且调用begin
    id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgrPro getTrackWithContainer:controller path:nil trackID:parentTrackId];
    if (!trackTask) {
        trackTask = [MBAPMEventTimeTrackMgrPro createTrackWithContainer:controller path:nil];
        // TOOD: 附加参数
        [trackTask begin:nil];
        
        NSString *pageName = [self getPageIdOnMainThread:controller];
        [self setCurrentPageBeginLoading:pageName];
    }
    if (!isContainerVC) {
        // 是否关闭
        if (!_enabled) {
            return;
        }
        if (controller.isLoadedFlag) {
            return;
        }
        controller.isLoadedFlag = YES;
        
        __weak typeof(self) weakSelf = self;
        __weak typeof (controller) weakController = controller;
        [trackTask setCompleteBlock:^(BOOL result, NSString * _Nullable msg,  id<MBAPMEventTimeTrackRecordProtocol> _Nonnull timeTrackResult) {
            if (!result) {
                MBAPMWarning(@"event time truck fails: %@", msg);
            }
            [weakSelf reportEventTimeTrackResult:timeTrackResult success:result];
            
            
            [MBAPMEventTimeTrackMgrPro removeWithContainer:weakController path:nil trackID:timeTrackResult.trackID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_viewMap removeObjectForKey:weakController];
            });
        }];
        // 打点
        [trackTask section:kMBAPMEventTimeTrack_Page_View_Prepare withExtra:nil];
    }
}

- (NSString *)getPageCurrentTrackId:(UIViewController *)controller {
    NSString *parentTrackId = [controller mbapm_pageTrackId];;
    UIViewController *tempVC = controller;
    while (tempVC.parentViewController) {
        if ([tempVC.parentViewController conformsToProtocol:@protocol(MBUITabBarControllerProtocol)] ||
            [tempVC.parentViewController isKindOfClass:[UINavigationController class]]) {
            parentTrackId = [tempVC.parentViewController mbapm_pageTrackId];
            [tempVC.parentViewController setMbapm_pageTrackId:@""];
            if (parentTrackId
                && parentTrackId.length > 0) {
                [controller setMbapm_pageTrackId:parentTrackId];
                break;
            }
        }
        tempVC = tempVC.parentViewController;
    }
    if (!_didLaunchHome) {
        UIViewController *tempVC = controller;
        while (tempVC.parentViewController) {
            BOOL isHome = NO;
            if ([tempVC.parentViewController conformsToProtocol:@protocol(MBUITabBarControllerProtocol)] &&
                [(id<MBUITabBarControllerProtocol>)[tempVC parentViewController] selectedViewController] == tempVC) {
                isHome = YES;
                
            } else if
                (([tempVC.parentViewController isKindOfClass:[UINavigationController class]] &&
                  [tempVC.parentViewController.parentViewController conformsToProtocol:@protocol(MBUITabBarControllerProtocol)] &&
                  [(id<MBUITabBarControllerProtocol>)[tempVC.parentViewController parentViewController] selectedViewController] == tempVC.parentViewController)
                 ) {
                    isHome = YES;
                }
            
            if (isHome) {
                id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgrPro getTrackWithContainer:controller path:nil trackID:nil];
                if (trackTask) {
                    if (trackTask && trackTask.container && [trackTask.container respondsToSelector:@selector(setMbapm_isFirstHomePage:)]) {
                        [trackTask.container setMbapm_isFirstHomePage:YES];
                    }
                    _didLaunchHome = YES;
                }
            }
            tempVC = tempVC.parentViewController;
        }
    }
    return parentTrackId;
}

- (void)receiveViewWillAppear:(UIViewController *)controller {
    if (!_enabled) {
        return;
    }
    if ([self shouldIgnore:controller]) {
        return;
    }
    BOOL isContainerVC = [MBDoctorVCUtil isContainerVC:controller];
    /// 在viewDidLoad里面addChildViewController会出现receiveViewDidLoad中的isContainerVC判断能够通过，但是receiveViewWillAppear中isContainerVC条件通过不了的情况，导致创建的task无法移除问题
    if (isContainerVC) {
        /// 删除已经创建的trackTask
        [MBAPMEventTimeTrackMgrPro removeWithContainer:controller path:nil trackID:nil];
        return;
    }
    
    // 继承 parentViewController 的 track id
    NSString *parentTrackId = [self getPageCurrentTrackId:controller];
    
    // 获取不到生成新的track id，并且调用begin
    id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgrPro getTrackWithContainer:controller path:nil trackID:parentTrackId];
//    NSLog(@"eventTimeTrack viewWillAppear track = %p, viewController = %@", trackTask, controller);
    BOOL parentIsContainerVC = NO;
    if ([controller.parentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *parentVC = (UINavigationController *)controller.parentViewController;
        if (controller == parentVC.viewControllers.firstObject) {
            parentIsContainerVC = [MBDoctorVCUtil isContainerVC:controller.parentViewController.parentViewController];
        }
    } else {
        parentIsContainerVC = [MBDoctorVCUtil isContainerVC:controller.parentViewController];
    }
    if (parentIsContainerVC) {
        // 补 page_appear 点
        [trackTask beginIsolatedSection:kMBAPMEventTimeTrack_Page_Appear sectionType:MBAPMEventTimeSectionType_COCURRENT withExtra:nil];
    }
    if (!trackTask) {
        return;
    }
    
    [self startFirstLayoutCheck:trackTask superIsContainerVC:parentIsContainerVC];
}

- (void)receiveViewDidAppear:(UIViewController *)controller {
    if (!_enabled) {
        return;
    }
    if ([self shouldIgnore:controller]) {
        return;
    }
    BOOL isContainerVC = [MBDoctorVCUtil isContainerVC:controller];
    if (isContainerVC) {
        return;
    }
    
    MBViewLayoutStateModel * obj = [_viewMap objectForKey:controller];
    
    __weak typeof(self) weakSelf = self;
    [[[MBAPMRenderPageInfo alloc] createOne] getViewMeshingHitCount:controller.view completion:^(NSUInteger current, NSUInteger total) {
        if (current / (CGFloat)total > 1 / 6.0) {
            obj.pageSuccessed = YES;
            id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgrPro getTrackWithContainer:controller path:nil trackID:nil];
            NSLog(@"eventTimeTrack getViewMeshingHitCount track = %p", trackTask);
            [weakSelf firstLayoutData:obj];
        }
    }];
}

- (void)firstLayoutData:(MBViewLayoutStateModel *)obj {
    obj.firstChecked = YES;
    // TODO: 新增一个方法，偏移200 ms
    UInt64 accuracyEndTimestamp = obj.lastUpdateTimestamp > 0?obj.lastUpdateTimestamp:[MBAPMTimeUtil currentTimestamp];
    [obj.track section:kMBAPMEventTimeTrack_Page_First_Layout endAt:accuracyEndTimestamp withExtra:nil];
}

- (void)startFirstLayoutCheck:(id<MBAPMEventTimeTrack>)trackTask {
    [self startFirstLayoutCheck:trackTask superIsContainerVC:NO];
}

- (void)startFirstLayoutCheck:(id<MBAPMEventTimeTrack>)trackTask superIsContainerVC:(BOOL)isContainerVC {
//    NSLog(@"eventTimeTrack startFirstLayoutCheck track = %p", trackTask);
    // 记录和开始 页面渲染检测
    MBViewLayoutStateModel * model = [MBViewLayoutStateModel new];
    model.track = trackTask;
    model.parentIsContainer = isContainerVC;
    if (trackTask.container
        && [trackTask.container isKindOfClass:[UIViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->_viewMap) {
                self->_viewMap = [[NSMapTable alloc] initWithKeyOptions:(NSPointerFunctionsWeakMemory) valueOptions:NSPointerFunctionsStrongMemory capacity:0];
            }
//            NSLog(@"eventTimeTrack startFirstLayoutCheck add to viewmap track = %p", trackTask);
            [self->_viewMap setObject:model forKey:(UIViewController *)trackTask.container];
        });
        // TODO: 1.如果存在栈内跳转，viewMap维护存在问题
    }
}

- (void)reportEventTimeTrackResult:(id<MBAPMEventTimeTrackRecordProtocol>)trackResult success:(BOOL)success {
    id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgrPro getTrackWithContainer:nil path:nil trackID:trackResult.trackID];
    if (!trackTask.container) {
        return;
    }
    
    MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
    performance.performanceType = MBDoctorPerformanceTypePageRender;
    performance.metricName = @"performance.pageview";
    performance.metricType = MBDoctorMetricTypeGauge;
    performance.metricValue = [trackResult getTotalElapsedTime];
    
    NSArray *urlInfos;
    if (trackTask.associatedData) {
        NSString *metricName = trackTask.associatedData.tj.string(@"metricName").value;
        NSString *scenario = trackTask.associatedData.tj.string(@"scenario").value;
        NSDictionary *tags = trackTask.associatedData.tj.dictionary(@"tags").value;
        urlInfos = trackTask.associatedData.tj.array(@"urlInfos").arrayValue;
        performance.journalModel = metricName;
        performance.journalScenario = scenario;
        performance.tags = tags;
    }
    NSMutableDictionary *tagsDic = [NSMutableDictionary dictionaryWithDictionary:performance.tags];
    if ([trackTask.container isKindOfClass:[UIViewController class]]) {
        UIViewController *container = (UIViewController *)trackTask.container;
        NSString *pageName = [self getPageIdOnMainThread:container];
        NSString *pageClassName = [MBDoctorVCUtil getPageClassName:container];
        if (![performance.tags.allKeys containsObject:@"page_id"] || [performance.tags[@"page_id"] length] == 0) {
            tagsDic[@"page_id"] = pageName;
        }
        if (![performance.tags.allKeys containsObject:@"page_path"] || [performance.tags[@"page_path"] length] == 0) {
            tagsDic[@"page_path"] = trackTask.path;
        }
        tagsDic[@"page_className"] = pageClassName;
        tagsDic[@"success"] = @(@(success).integerValue);
        tagsDic[@"detect_type"] = @"auto";
        NSString *version = [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionNumber] ?: @"";
        tagsDic[@"apm_version"] = version;
    }
    performance.tags = tagsDic;
    performance.metricSections = [trackResult getSectionsDict];
    
    BOOL enterBackground = trackTask.env & MBAPMEventTimeTrackTaskExternalEnv_enterBackground;
    if (![tagsDic containsObjectForKey:@"detect_result"] && enterBackground) {
        tagsDic[@"detect_result"] = @(-2);
        performance.tags = tagsDic;
    }
    
    if (self.apmConfiguration.pageDivideMonitorEnteredBackground == NO && enterBackground) {
        return;
    }
    
    NSMutableDictionary *extraData = [NSMutableDictionary new];
    NSDictionary *wholeExt = [trackResult getWholeExt];
    if (wholeExt) {
        [extraData addEntriesFromDictionary:wholeExt];
    }
    NSDictionary *sectionsExt = [trackResult getSectionsExt];
    if (sectionsExt) {
        [extraData setObject:sectionsExt forKey:@"sections_ext"];
    }
    performance.ext = extraData;
    if (urlInfos) {
        performance.attrs = @{@"network_requests": urlInfos};
    }
    if (self.reportBlock) {
        self.reportBlock(performance, trackTask.moduleInfo);
    }
}

- (void)receiveViewAddItem:(UIView *)view {
    __block NSArray *keys;
    if ([NSThread isMainThread]) {
        keys = [[[_viewMap
                   mutableCopy]
                  keyEnumerator]
                 allObjects];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            keys = [[[_viewMap
                       mutableCopy]
                      keyEnumerator]
                     allObjects];
        });
    }
    if (!keys) {
        return;
    }
    
    [keys
     enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.view) {
            MBViewLayoutStateModel *model = [_viewMap objectForKey:obj];
            if ([view isDescendantOfView:obj.view]) {
                model.isViewChange = YES;
                model.lastUpdateTimestamp = [MBAPMTimeUtil currentTimestamp];
//                NSLog(@"eventTimeTrack track = %p, view match %@, isViewChange = %d, lastUpdateTimestamp = %llu", model.track, view, model.isViewChange, model.lastUpdateTimestamp);
                *stop = YES;
            }
        }
    }];
}

- (void)receiveControllerDealloc:(UIViewController *)controller {
    [MBAPMEventTimeTrackMgrPro removeWithContainer:controller path:nil trackID:nil];
}


// MARK: - Protocal Methods

- (void)enterBackground {
    if (!_enabled) {
        return;
    }
    _isBackground = YES;
    [[MBAPMEventTimeTrackMgr getAllTasks] enumerateObjectsUsingBlock:^(id<MBAPMEventTimeTrack>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MBAPMPageViewTrackTask class]]) {
            [(MBAPMEventTimeTrackTask *)obj updateExternalEnv:MBAPMEventTimeTrackTaskExternalEnv_enterBackground];
        }
    }];
}

- (void)enterForeground {
    if (!_enabled) {
        return;
    }
    _isBackground = NO;
    // TODO: 开屏完成之前退后台进前台开屏时长会加上后台时间
}

- (void)isIdleNoti:(NSNotification *)noti {
    if (!_enabled) {
        return;
    }
    [self receiveIdle:noti.object];
}

- (void)mbuikit_didAddSubview:(UIView *)view {
    if (!_enabled) {
        return;
    }
    [self receiveViewAddItem:view];
}

- (void)mb_uiViewControllerViewDidLoad:(UIViewController *)controller {
    if (!_enabled) {
        return;
    }
    [self receiveViewDidLoad:controller];
}

- (void)mb_uiViewController:(UIViewController *)controller viewWillAppear:(BOOL)animated {
    if (!_enabled) {
        return;
    }
    if (controller.isAppearFlag == YES) {
        return;
    }
    controller.isAppearFlag = YES;
    [self receiveViewWillAppear:controller];
}

- (void)mb_uiViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated {
    if (!_enabled) {
        return;
    }
    if (controller.isDidAppearFlag == YES) {
        return;
    }
    controller.isDidAppearFlag = YES;
    [self receiveViewDidAppear:controller];
}

- (void)mb_uiViewController:(UIViewController *)controller viewDidDisappear:(BOOL)animated {
    if (!_enabled) {
        return;
    }
    if (controller.isDisappearFlag == YES) {
        return;
    }
    controller.isDisappearFlag = YES;
}

- (void)mb_uiViewControllerDealloc:(UIViewController *)controller {
    if (!_enabled) {
        return;
    }
    [self receiveControllerDealloc:controller];
}

// MARK: - viewMap
- (void)selfGetViewMap {
    
}


// MARK: - Property Methods

static MBAPMPageLaunchDivideCenter *mgr;
+ (MBAPMPageLaunchDivideCenter *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [MBAPMPageLaunchDivideCenter new];
        MBUIKitHookControllerAddObserver(mgr);
        MBUIKitHookViewAddObserver(mgr);
        [NSNotificationCenter.defaultCenter addObserver:mgr selector:@selector(isIdleNoti:) name:@"MBAPMPageLaunchDivideNotiNSPostWhenIdle" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:mgr selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:mgr selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    return mgr;
}

@end
