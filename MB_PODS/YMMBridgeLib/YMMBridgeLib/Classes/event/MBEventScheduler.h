//
//  MBEventScheduler.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The priority for the scheduler.
///
/// RACSchedulerPriorityHigh       - High priority.
/// RACSchedulerPriorityDefault    - Default priority.
/// RACSchedulerPriorityLow        - Low priority.
/// RACSchedulerPriorityBackground - Background priority.
typedef enum : long {
    MBEventSchedulerPriorityHigh = DISPATCH_QUEUE_PRIORITY_HIGH,
    MBEventSchedulerPriorityDefault = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    MBEventSchedulerPriorityLow = DISPATCH_QUEUE_PRIORITY_LOW,
    MBEventSchedulerPriorityBackground = DISPATCH_QUEUE_PRIORITY_BACKGROUND,
} MBEventSchedulerPriority;

@interface MBEventScheduler : NSObject

+ (MBEventScheduler *)immediateScheduler;

+ (MBEventScheduler *)mainThreadScheduler;

- (void)schedule:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
