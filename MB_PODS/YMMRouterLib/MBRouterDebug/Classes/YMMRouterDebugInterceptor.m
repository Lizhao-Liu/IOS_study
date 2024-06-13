//
//  YMMRouterDebugInterceptor.m
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import "YMMRouterDebugInterceptor.h"
@import YMMRouterLib;
@import MBUIKit;
@import MBDoctorService;

@interface YMMRouterDebugInterceptor()<YMMRouterCenterInterceptorProtocol>

@property (nonatomic ,copy) NSString *pageName;

@end

@implementation YMMRouterDebugInterceptor{
    dispatch_semaphore_t _semaphore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[YMMRouterCenter shared] addInterceptor:self];
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - YMMRouterCenterInterceptorProtocol

- (BOOL)routerShouldHandle:(nonnull id<YMMRouterRoutable>)routable {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    self.pageName = [[UIViewController mb_currentViewController] getJournalPageName];
    dispatch_semaphore_signal(_semaphore);
    return YES;
}

- (void)routerDidHandle:(nonnull id<YMMRouterRoutable>)routable response:(nonnull YMMRouterResponse *)response {
    if(self.delegate) {
        [self.delegate routerInterceptorDidReceiveRequest:routable response:response atTime:[[NSDate date] timeIntervalSince1970] pageName:self.pageName];
    }
}


@end
