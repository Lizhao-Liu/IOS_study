//
//  MBAPMFPSDetector.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/7/13.
//

#import "MBAPMFPSDetector.h"
#import "MBAPMFPSUtil.h"
#import "MBAPMFPSDataManager.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMPageLaunchDivideCenter.h"

#import <objc/runtime.h>

@import MBUIKit;
@import MBDoctorService;

@interface UIViewController (MBAPMFPSDetector)

@end

@implementation UIViewController (MBAPMFPSDetector)

- (BOOL)fps_hasAppearFlag {
    return [objc_getAssociatedObject(self, @selector(fps_hasAppearFlag)) boolValue];
}

- (void)setFps_hasAppearFlag:(BOOL)hasAppearFlag {
    objc_setAssociatedObject(self, @selector(fps_hasAppearFlag), @(hasAppearFlag), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface MBAPMFPSDetector() <MBUIKitHookViewControllerObserverProrocol, MBUIKitHookScrollViewObserverProrocol> {
    id<MBAPMFPSDetectorDelegate> _delegate;
    BOOL _enable;
    BOOL _isBackground;
}
@end

@implementation MBAPMFPSDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        MBUIKitHookControllerAddObserver(self);
        
        __block NSString * scrollUUID = nil;
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopEntry | kCFRunLoopExit, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            if (activity == kCFRunLoopEntry) {
                scrollUUID = [[[NSUUID alloc] init] UUIDString];
                [self mb_scrollDidScroll:scrollUUID];
            } else {
                [self mb_scrollDidEndScroll:scrollUUID];
            }
        });
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, (__bridge CFStringRef)UITrackingRunLoopMode);
        __weak typeof(self) weakSelf = self;
        [[MBAPMFPSUtil sharedInstance] startFPSMonitor:^(CGFloat fps) {
            [weakSelf mb_fps:fps];
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)startDetectWithDelegate:(id<MBAPMFPSDetectorDelegate>)delegate {
    _enable = YES;
    _delegate = delegate;
}

- (void)stopDetect {
    _enable = NO;
}

//MARK: - private

- (void)pageEnd:(UIViewController *)controller {
    __block NSString *pageClassName = [MBDoctorVCUtil getPageClassName:controller] ?: [MBAPMCurrentPageInfo currentPageClassName];
    __block NSString *pageName = [MBDoctorVCUtil getPageName:controller] ?: [MBAPMCurrentPageInfo currentPageName] ?: pageClassName;
    __block NSString *pagePath = [MBAPMCurrentPageInfo currentPagePath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *pageKey = [NSString stringWithFormat:@"%p", controller];
        MBAPMFPSDataResponse *response = [[MBAPMFPSDataManager sharedInstance] pageFps:pageKey];
        response.pageClassName = pageClassName;
        response.pagePath = pagePath;
        if (response && self->_delegate && [self->_delegate respondsToSelector:@selector(pageFpsAvg:fpsData:moduleInfo:)]) {
            MBModuleInfo *moduleInfo = [[MBModuleInfo alloc] init];
            moduleInfo.moduleName = @"app";
            moduleInfo.subModuleName = @"apm";
            [self->_delegate pageFpsAvg:pageName fpsData:response moduleInfo:moduleInfo];
        }
    });
}

- (void)scrollEnd:(NSString *)scrollUUID {
    __block NSString *pageClassName = [MBAPMCurrentPageInfo currentPageClassName];
    __block NSString *pageName = [MBAPMCurrentPageInfo currentPageName] ?: pageClassName;
    __block NSString *pagePath = [MBAPMCurrentPageInfo currentPagePath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MBAPMFPSDataResponse *response = [[MBAPMFPSDataManager sharedInstance] pageScrollFps:scrollUUID];
        response.pageClassName = pageClassName;
        response.pagePath = pagePath;
        response.pageName = pageName;
        if (response && self->_delegate && [self->_delegate respondsToSelector:@selector(scrollFps:fpsData:moduleInfo:)]) {
            MBModuleInfo *moduleInfo = [[MBModuleInfo alloc] init];
            moduleInfo.moduleName = @"app";
            moduleInfo.subModuleName = @"apm";
            [self->_delegate scrollFps:pageName fpsData:response moduleInfo:moduleInfo];
        }
    });
}

//MARK: - fps
- (void)enterBackground {
    if (!_enable) {
        return;
    }
    _isBackground = YES;
    [[MBAPMFPSDataManager sharedInstance] didEnterBackground];
}

- (void)enterForeground {
    if (!_enable) {
        return;
    }
    _isBackground = NO;
    [[MBAPMFPSDataManager sharedInstance] willEnterForeground];
}

//MARK: - MBUIKitHookViewControllerObserverProrocol
- (void)mb_uiViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated {
    if (!_enable) { return; }
    if ([controller fps_hasAppearFlag]) {
        return;
    }
    BOOL shouldIgnore = [MBAPMPageLaunchDivideCenter shouldIgnore:controller];
    if (shouldIgnore) {
        return;
    }
    MBModuleInfo *moduleInfo = [[MBModuleInfo alloc] init];
    moduleInfo.moduleName = @"app";
    moduleInfo.subModuleName = @"apm";
    [[MBAPMFPSDataManager sharedInstance] receivePageViewAppear:[NSString stringWithFormat:@"%p", controller] moduleInfo:moduleInfo];
}

- (void)mb_uiViewController:(UIViewController *)controller viewWillDisappear:(BOOL)animated {
    if (!_enable) { return; }
    if ([controller fps_hasAppearFlag]) {
        return;
    }
    [controller setFps_hasAppearFlag:YES];
    BOOL shouldIgnore = [MBAPMPageLaunchDivideCenter shouldIgnore:controller];
    if (shouldIgnore) {
        return;
    }
    NSString *pageKey = [NSString stringWithFormat:@"%p", controller];
    [[MBAPMFPSDataManager sharedInstance] receivePageViewDisappear:pageKey];
    
    [self pageEnd:controller];
}



//MARK: - fps block
- (void)mb_fps:(CGFloat)fps {
    if (!_enable) { return; }
    if (_isBackground) { return; }
//    NSLog(@"😁%f: %d %s😁\n%@", fps, __LINE__, __FUNCTION__, self);
    [[MBAPMFPSDataManager sharedInstance] receiveFps:fps];
}

//MARK: - Track Observer
- (void)mb_scrollDidScroll:(NSString *)scrollUUID {
    if (!_enable) { return; }
    [[MBAPMFPSDataManager sharedInstance] receiveViewScrollBegin:scrollUUID];
}

- (void)mb_scrollDidEndScroll:(NSString *)scrollUUID {
    if (!_enable) { return; }
    [[MBAPMFPSDataManager sharedInstance] receiveViewScrollEnd:scrollUUID];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollEnd:scrollUUID];
    });
}
@end
