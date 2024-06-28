//
//  MBContainerEventCenter.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import <Foundation/Foundation.h>
#import "MBContainerEventDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBContainerEventCenter : NSObject

+ (instancetype)shared;

/**
  任务直接调度
  通知发出在那个线程，接收也在相同线程
 */
- (void)subscribeEvent:(NSString *)eventName
            subscriber:(id)subscriber
                action:(MBEventActionBlock)block;

/**
  任务主线程调度(asyn 异步到主队列执行)
 */
- (void)subscribeEventOnMainThread:(NSString *)eventName
                        subscriber:(id)subscriber
                            action:(MBEventActionBlock)block;

/**
 为订阅者解除事件订阅
 */
- (void)unsubscribeEvent:(NSString *)eventName subscriber:(id)subscriber;

/**
 解订阅当前订阅者所有事件
 */
- (void)unsubscribeAllEvent:(id)subscriber;

/**
 事件发布
 */
- (void)publishEvent:(NSString *)eventName data:(nullable NSDictionary *)params;

// 全局只能有一个此类订阅者, 请勿调用
- (void)subscribeAllEvent:(id)subscriber action:(MBEventActionBlock)block;

@end

NS_ASSUME_NONNULL_END
