//
//  MBAPMNetworkInterceptorManager.m
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import "MBAPMNetworkInterceptorManager.h"
#import "MBAPMNSURLProtocol.h"

static MBAPMNetworkInterceptorManager *instance = nil;

@interface MBAPMNetworkInterceptorManager()

@property (nonatomic, strong) NSHashTable *delegates;
@end

@implementation MBAPMNetworkInterceptorManager

- (NSHashTable *)delegates {
    if (_delegates == nil) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

- (void)addDelegate:(id<MBAPMNetworkInterceptorManagerDelegate>) delegate {
    [self.delegates addObject:delegate];
    [self updateURLProtocolInterceptStatus];
}

- (void)removeDelegate:(id<MBAPMNetworkInterceptorManagerDelegate>)delegate {
    [self.delegates removeObject:delegate];
    [self updateURLProtocolInterceptStatus];
}
    
+ (instancetype)shareInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[MBAPMNetworkInterceptorManager alloc] init];
    });
    return instance;
}

- (BOOL)shouldIntercept {
    // 当有对象监听 拦截后的网络请求时，才需要拦截
    BOOL shouldIntercept = NO;
    
    for (id<MBAPMNetworkInterceptorManagerDelegate> delegate in self.delegates) {
        if (delegate.shouldIntercept) {
            shouldIntercept = YES;
        }
    }
    return shouldIntercept;
}

- (void)updateURLProtocolInterceptStatus {
    if (self.shouldIntercept) {
        [NSURLProtocol registerClass:[MBAPMNSURLProtocol class]];
    }else{
        [NSURLProtocol unregisterClass:[MBAPMNSURLProtocol class]];
    }
}

- (void)updateInterceptStatusForSessionConfiguration: (NSURLSessionConfiguration *)sessionConfiguration {
    //BOOL shouldIntercept = [self shouldIntercept];
    if ([sessionConfiguration respondsToSelector:@selector(protocolClasses)]
        && [sessionConfiguration respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: sessionConfiguration.protocolClasses];
        Class protoCls = MBAPMNSURLProtocol.class;
        if ( ![urlProtocolClasses containsObject: protoCls]) {
            [urlProtocolClasses insertObject: protoCls atIndex: 0];
        } else if ([urlProtocolClasses containsObject: protoCls]) {
            [urlProtocolClasses removeObject: protoCls];
        }
        sessionConfiguration.protocolClasses = urlProtocolClasses;
    }
}

- (void)handleResultWithData: (NSData *)data
                    response: (NSURLResponse *)response
                     request: (NSURLRequest *)request
                       error: (NSError *)error
                   startTime: (NSTimeInterval)startTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<MBAPMNetworkInterceptorManagerDelegate> delegate in self.delegates) {
            [delegate networkInterceptorDidReceiveData:data response:response request:request error:error startTime:startTime];
        }
    });
}

@end
