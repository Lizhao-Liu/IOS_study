//
//  YMMRouterDebugEventMonitorManager.m
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import "YMMRouterDebugEventMonitorManager.h"
#import "YMMRouterDebugInterceptor.h"
#import "YMMRouterDebugEventModel.h"
#import "YMMRouterDebugMonitorDataSource.h"
#import "MBRouterDebugMonitorDefine.h"
@import MBDebug;
@import MBDoctorService;

@interface YMMRouterDebugEventMonitorManager()<YMMRouterDebugInterceptorDelegate>

@property (strong, nonatomic) YMMRouterDebugInterceptor *interceptor;
@property (nonatomic, assign) NSInteger countLimit;

@end

@implementation YMMRouterDebugEventMonitorManager

+ (YMMRouterDebugEventMonitorManager *)sharedInstance{
    static dispatch_once_t once;
    static YMMRouterDebugEventMonitorManager *instance;
    dispatch_once(&once, ^{
        instance = [[YMMRouterDebugEventMonitorManager alloc] init];
        [instance setUp];
    });
    return instance;
}

- (void)setUp {
    _interceptor = [[YMMRouterDebugInterceptor alloc] init];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:MBRouterDebugMonitorSwitch]) {
        _isMonitoring = [[NSUserDefaults standardUserDefaults] boolForKey:MBRouterDebugMonitorSwitch];
    } else {
        _isMonitoring = YES;
    }
    if(_isMonitoring){
        [self startMonitorRouterEvent];
    } else {
        [self stopMonitorRouterEvent];
    }
}

- (void)setIsMonitoring:(BOOL)isMonitoring {
    _isMonitoring = isMonitoring;
    [[NSUserDefaults standardUserDefaults] setObject:@(isMonitoring) forKey:MBRouterDebugMonitorSwitch];
}

- (void)startMonitorRouterEvent {
    _interceptor.delegate = self;
    self.isMonitoring = YES;
}

- (void)stopMonitorRouterEvent {
    _interceptor.delegate = nil;
    self.isMonitoring = NO;
}
- (void)routerInterceptorDidReceiveRequest: (id<YMMRouterRoutable>)request
                                  response: (YMMRouterResponse *)response
                                    atTime: (NSTimeInterval)time
                                  pageName:(NSString *)pageName {
    YMMRouterDebugEventModel* eventModel = [YMMRouterDebugEventModel configWithRequest:request response:response time:time pageName:pageName];
    MBDebugMonitorLogDataSource* dataSource = [YMMRouterDebugMonitorDataSource sharedDataSource];
    [dataSource addObject:eventModel];
}


@end
