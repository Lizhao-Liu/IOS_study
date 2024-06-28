//
//  MBEventTargetQueueScheduler.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import "MBEventScheduler.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBEventTargetQueueScheduler : MBEventScheduler

- (instancetype)initWithName:(nullable NSString *)name targetQueue:(dispatch_queue_t)targetQueue;

@end

NS_ASSUME_NONNULL_END
