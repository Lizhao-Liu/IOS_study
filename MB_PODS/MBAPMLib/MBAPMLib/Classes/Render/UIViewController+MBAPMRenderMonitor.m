//
//  UIViewController+MBRenderMonitor.m
//  YMMPerformanceModule
//
//  Created by seal on 2020/6/20.
//

#import "UIViewController+MBAPMRenderMonitor.h"
#import "MBAPMPluginManager.h"
#import "MBAPMViewPageContext.h"
#import "MBAPMRenderMonitor.h"
#import "MBAPMMemoryMonitor.h"
#import "MBMemoryLogDetector.h"
#import "MBAPMWakeupsMonitor.h"
#import "MBAPMWakeupsPageMonitor.h"
#import <objc/runtime.h>
@import MBFoundation;

@import UIKit;
@import MBAPMServiceLib;
@import RSSwizzle;
@import MBDoctorService;
@import MBUIKit;


static NSString *kAssociatedRenderMonitorKey;
static NSString *kAssociatedIsLoadedPrivateFlagKey;
static NSString *kAssociatedEventTaskKey;

@interface UIViewController ()
//@property (nonatomic, strong) id<MBAPMEventTrack> autoDetectEventTrack;

@property (nonatomic, assign) BOOL isLoadedPrivateFlag;
@end

@implementation UIViewController (MBRenderMonitor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RSSwizzleInstanceMethod([UIViewController class], @selector(viewDidLoad), RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
            [self renderMonitor_viewDidLoad];
            RSSWCallOriginal();
        }), RSSwizzleModeOncePerClassAndSuperclasses, @"Render_Monitor_viewDidLoad");
        RSSwizzleInstanceMethod([UIViewController class], @selector(viewWillAppear:), RSSWReturnType(void), RSSWArguments(BOOL animated), RSSWReplacement({
            [self renderMonitor_viewWillAppear];
            RSSWCallOriginal(animated);
        }), RSSwizzleModeOncePerClassAndSuperclasses, @"Render_Monitor_viewWillAppear");
        RSSwizzleInstanceMethod([UIViewController class], @selector(viewWillDisappear:), RSSWReturnType(void), RSSWArguments(BOOL animated), RSSWReplacement({
            [self renderMonitor_viewWillDisappear];
            RSSWCallOriginal(animated);
        }), RSSwizzleModeOncePerClassAndSuperclasses, @"Render_Monitor_viewWillDisappear");
        RSSwizzleInstanceMethod([UIViewController class], @selector(viewDidAppear:), RSSWReturnType(void), RSSWArguments(BOOL animated), RSSWReplacement({
            [self renderMonitor_viewDidAppear];
            RSSWCallOriginal(animated);
        }), RSSwizzleModeOncePerClassAndSuperclasses, @"Render_Monitor_viewDidAppear");
        RSSwizzleInstanceMethod([UIViewController class], NSSelectorFromString(@"dealloc"), RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
            [self renderMonitor_dealloc];
            RSSWCallOriginal();
        }), RSSwizzleModeOncePerClassAndSuperclasses, @"Render_Monitor_dealloc");
    });
}

- (void)renderMonitor_viewDidLoad {
    if (!self.isLoadedPrivateFlag) {
        self.isLoadedPrivateFlag = YES;
        MBAPMRenderMonitor *plugin = (MBAPMRenderMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagRenderDetect];
        MBAPMViewPageContext *pageContext = [self getPageContext];
        if (pageContext.detectType == MBAPMViewPageRenderDetectTypeManaul) {
            return;
        }
//        self.autoDetectEventTrack = [plugin startTrackWithPageContext:pageContext];
        
        // memory page load，需要忽略一些系统容器vc
        if ([self conformsToProtocol:@protocol(MBViewPageProtocol)]
            && [self respondsToSelector:@selector(mb_isContainerVC)]) {
            BOOL isContainerVC = [self performSelector:@selector(mb_isContainerVC)];
            if (!isContainerVC) {
                MBAPMMemoryMonitor *memoryPlugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
                [[memoryPlugin memoryLogDetector] didPageLoad:pageContext];
                MBAPMWakeupsMonitor *wakeupsPlugin = (MBAPMWakeupsMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagWakeUps];
                [[wakeupsPlugin pageMonitor] didPageLoad:pageContext];
            }
        } else if ([self mb_needMemoryEventLog]) {
            MBAPMMemoryMonitor *memoryPlugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
            [[memoryPlugin memoryLogDetector] didPageLoad:pageContext];
            MBAPMWakeupsMonitor *wakeupsPlugin = (MBAPMWakeupsMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagWakeUps];
            [[wakeupsPlugin pageMonitor] didPageLoad:pageContext];
        }
    }
}

- (void)renderMonitor_viewWillAppear {
//    if(self.autoDetectEventTrack && [self.autoDetectEventTrack respondsToSelector:@selector(markPoint:)]) {
//        [self.autoDetectEventTrack markPoint:@"viewWillAppear"];
//    }
    MBAPMRenderMonitor *plugin = (MBAPMRenderMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagRenderDetect];
    MBAPMViewPageContext *pageContext = [self getPageContext];
    [plugin startPagePerformanceTrack:pageContext];
    
    MBAPMMemoryMonitor *memoryPlugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
    [[memoryPlugin memoryLogDetector] didPageIn:pageContext];
    
    MBAPMWakeupsMonitor *wakeupsPlugin = (MBAPMWakeupsMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagWakeUps];
    [[wakeupsPlugin pageMonitor] didPageIn:pageContext];
    
}

- (void)renderMonitor_viewDidAppear {
//    if(self.autoDetectEventTrack && [self.autoDetectEventTrack respondsToSelector:@selector(end:)]) {
//        [self.autoDetectEventTrack end:@"viewDidAppear"];
//    }
}

- (void)renderMonitor_viewWillDisappear {
//    if(self.autoDetectEventTrack && [self.autoDetectEventTrack respondsToSelector:@selector(abort)]) {
//        [self.autoDetectEventTrack abort];
//    }
    MBAPMRenderMonitor *plugin = (MBAPMRenderMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagRenderDetect];
    MBAPMViewPageContext *pageContext = [self getPageContext];
    [plugin stopPagePerformanceTrack:pageContext];
    
    MBAPMMemoryMonitor *memoryPlugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
    [[memoryPlugin memoryLogDetector] didPageOut:pageContext];
    
    MBAPMWakeupsMonitor *wakeupsPlugin = (MBAPMWakeupsMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagWakeUps];
    [[wakeupsPlugin pageMonitor] didPageOut:pageContext];
}

- (void)renderMonitor_dealloc {
    MBAPMMemoryMonitor *memoryPlugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
    MBAPMViewPageContext *pageContext = [[MBAPMViewPageContext alloc]init];
    pageContext.className = NSStringFromClass([self class]);
    pageContext.objcetPointer = [NSString stringWithFormat:@"%p", self];
    [[memoryPlugin memoryLogDetector] didPageDealloc:pageContext];
    
    MBAPMWakeupsMonitor *wakeupsPlugin = (MBAPMWakeupsMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagWakeUps];
    [[wakeupsPlugin pageMonitor] didPageDealloc:pageContext];
}

- (BOOL)isLoadedPrivateFlag {
    return [objc_getAssociatedObject(self, &kAssociatedIsLoadedPrivateFlagKey) boolValue];
}

- (void)setIsLoadedPrivateFlag:(BOOL)isLoadedPageDivideFlag {
    objc_setAssociatedObject(self, &kAssociatedIsLoadedPrivateFlagKey, @(isLoadedPageDivideFlag), OBJC_ASSOCIATION_ASSIGN);
}

//- (void)setAutoDetectEventTrack:(id<MBAPMEventTrack>)autoDetectEventTrack {
//    objc_setAssociatedObject(self, &kAssociatedEventTaskKey, autoDetectEventTrack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (id<MBAPMEventTrack>)autoDetectEventTrack {
//    return objc_getAssociatedObject(self, &kAssociatedEventTaskKey);
//}

- (NSString *)mbapm_pageTrackId {
    return objc_getAssociatedObject(self, @selector(mbapm_pageTrackId));
}

- (void)setMbapm_pageTrackId:(NSString *)mbapm_pageTrackId {
    objc_setAssociatedObject(self, @selector(mbapm_pageTrackId), mbapm_pageTrackId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)obtainPageName {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    NSString *pageName = NSStringFromClass([self class]);
    if ([self respondsToSelector:@selector(mb_pageName)]) {
        NSString *ymmPageName = [self performSelector:@selector(mb_pageName)];
        if(![NSString mb_isNilOrEmpty:ymmPageName]) {
            pageName = ymmPageName;
        }
    }
    #pragma clang diagnostic pop
    return pageName;
}

- (MBAPMViewPageContext * _Nonnull)getPageContext {
    MBAPMViewPageContext *pageContext = nil;
    if([self conformsToProtocol:@protocol(MBAPMViewPageProtocol)]) {
        pageContext = [[MBAPMViewPageContext alloc]initWithPageProtocol:(id<MBAPMViewPageProtocol>)self];
    } else {
        pageContext = [[MBAPMViewPageContext alloc]init];
        pageContext.className = NSStringFromClass([self class]);
    }
    if(!pageContext.view) {
        pageContext.view = self.view;
    }
    if([NSString mb_isNilOrEmpty:pageContext.pageName]) {
        pageContext.pageName = [self obtainPageName];
    }
    pageContext.objcetPointer = [NSString stringWithFormat:@"%p", self];
    return pageContext;
}

/// 判断viewController是否需要忽略内存统计
- (BOOL)mb_needMemoryEventLog {
    UIViewController *viewController = self;
    if (!viewController) {
        return NO;
    }
    BOOL flag = NO;
    if ([viewController isKindOfClass:[UINavigationController class]]
        || [viewController isKindOfClass:[UITabBarController class]] || [viewController conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]) {
        flag = NO;
    } else {
        
        NSArray *clsArray = @[@"_UIAlertControllerTextFieldViewController",
                              @"UIApplicationRotationFollowingController",
                              @"UIAlertController",@"UICompatibilityInputViewController",
                              @"UIInputWindowController",@"UISystemKeyboardDockController",
                              @"UIKeyboardCandidateGridCollectionViewController",
                              @"mbAppStructureViewController",
                              @"mbAppStructureFilterEditViewController",
                              @"UIPredictionViewController",
                              @"UISystemInputAssistantViewController"];
        NSString *vcClassStr = NSStringFromClass(viewController.class);
        if ([clsArray containsObject:vcClassStr]) {
            flag = NO;
        } else {
            flag = YES;
        }
    }
    return flag;
}

@end
