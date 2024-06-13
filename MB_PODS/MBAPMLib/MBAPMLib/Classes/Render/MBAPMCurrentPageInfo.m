//
//  MBAPMCurrentPageInfo.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/5/8.
//

#import "MBAPMCurrentPageInfo.h"
#import "MBAPMPageLaunchDivideCenter.h"
@import MBUIKit;
@import MBDoctorService;
/// 在主线程操作
///
/// 内部调用保证：viewDidLoad，pageLoad/pagePathSet，viewAppear
///
@interface MBAPMCurrentPageInfo() <MBUIKitHookViewControllerObserverProrocol>

// 一级page，一般是native page
@property (atomic, copy) NSString *pageName;
// native class name
@property (atomic, copy) NSString *pageClassName;

// 二级page，一般是，容器栈内切换后的page，例如h5栈内跳转的
@property (atomic, copy) NSString *subPageName;

// page path
@property (atomic, copy) NSString *pagePath;

// is loading
@property (atomic, assign) BOOL pageIsLoading;

@end

@implementation MBAPMCurrentPageInfo

// MARK: - interface
+ (NSString *)currentPageName {
    __block NSString *pageName;
    pageName = [[self sharedInstance] currentPageName];
    if (!pageName) {
        pageName = [[MBDoctorGlobalPV shared] lastPage];
    }
    return pageName;
}

+ (NSString *)noMainThreadCurrentPageName {
    NSString *pageName = [[MBDoctorGlobalPV shared] lastPage];
    return pageName;
}

+ (NSString *)currentPageClassName {
    __block NSString *className;
    className = [[self sharedInstance] pageClassName];
    return className;
}

+ (NSString *)currentPagePath {
    __block NSString *pagePath;
    pagePath = [[self sharedInstance] pagePath];
    return pagePath;
}

+ (BOOL)currentPageIsLoading {
    __block BOOL pageIsLoading;
    pageIsLoading = [[self sharedInstance] pageIsLoading];
    return pageIsLoading;
}

// MARK: - protocal method
- (void)mb_uiViewControllerViewDidLoad:(UIViewController *)controller {
    NSString *pageID = [MBDoctorVCUtil getPageName:controller];
    if (![self.pageName isEqualToString:pageID]) {
        self.pagePath = nil;
        self.pageIsLoading = NO;
    }
    self.pageName = pageID;
    self.pageClassName = [MBDoctorVCUtil getPageClassName:controller];
    self.pageIsLoading = [[MBAPMPageLaunchDivideCenter sharedInstance] currentPageIsLoading];
}

- (void)mb_uiViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated {
    NSString *pageID = [MBDoctorVCUtil getPageName:controller];
    self.pageName = pageID;
    self.pageClassName = [MBDoctorVCUtil getPageClassName:controller];
    self.subPageName = nil;
    self.pageIsLoading = [[MBAPMPageLaunchDivideCenter sharedInstance] currentPageIsLoading];
}

// MARK: - private
- (NSString *)currentPageName {
    if (self.subPageName.length > 0) {
        return self.subPageName;
    }
    return self.subPageName;
}

// MARK: -
+ (MBAPMCurrentPageInfo *)sharedInstance {
    static MBAPMCurrentPageInfo * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBAPMCurrentPageInfo alloc] init];
        MBUIKitHookControllerAddObserver(_manager);
    });
    return _manager;
}

@end

@implementation MBAPMCurrentPageInfo (Private)

// MARK: - private interface
- (void)viewLoadUpdatePageID:(NSString *)pageName {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.subPageName = pageName;
        if (![self.subPageName isEqualToString:pageName]) {
            self.pagePath = nil;
            self.pageIsLoading = NO;
        }
        self.pageIsLoading = [[MBAPMPageLaunchDivideCenter sharedInstance] currentPageIsLoading];
    });
}

- (void)viewLoadUpdatePagePath:(NSString *)pagePath {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_pagePath = pagePath;
    });
}

@end
