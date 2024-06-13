//
//  MBAPMNetworkInterceptorManager.h
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBAPMNetworkInterceptorManagerDelegate <NSObject>
- (BOOL)shouldIntercept;

- (void)networkInterceptorDidReceiveData: (NSData *)data
                                response: (NSURLResponse *)response
                                 request: (NSURLRequest *)request
                                   error: (NSError *)error
                               startTime: (NSTimeInterval)startTime;
@end

@protocol MBAPMNetworkWeakDelegate <NSObject>

typedef NS_ENUM(NSUInteger, MBAPMWeakNetType) {
    #pragma mark - 弱网选项对应
    // 断网
    MBAPMWeakNetwork_Break,
    // 超时
    MBAPMWeakNetwork_OutTime,
    // 限网
    MBAPMWeakNetwork_WeakSpeed,
    //延时
    MBAPMWeakNetwork_Delay
};

- (NSInteger)weakNetSelecte;

- (NSUInteger)delayTime;

- (void)handleWeak:(NSData *)data isDown:(BOOL)is;

@end

@interface MBAPMNetworkInterceptorManager : NSObject
@property (nonatomic, assign) BOOL shouldIntercept;

@property (nonatomic, weak) id<MBAPMNetworkWeakDelegate> weakDelegate;

+ (instancetype)shareInstance;

- (void)addDelegate:(id<MBAPMNetworkInterceptorManagerDelegate>) delegate;
- (void)removeDelegate:(id<MBAPMNetworkInterceptorManagerDelegate>)delegate;
- (void)updateInterceptStatusForSessionConfiguration: (NSURLSessionConfiguration *)sessionConfiguration;
- (void)handleResultWithData: (NSData *)data
                    response: (NSURLResponse *)response
                     request: (NSURLRequest *)request
                       error: (NSError *)error
                   startTime: (NSTimeInterval)startTime;
@end

NS_ASSUME_NONNULL_END
