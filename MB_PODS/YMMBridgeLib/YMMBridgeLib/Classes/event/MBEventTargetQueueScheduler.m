//
//  MBEventTargetQueueScheduler.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import "MBEventTargetQueueScheduler.h"
#import "MBEventScheduler+Private.h"

@interface MBEventTargetQueueScheduler()

@property (nonatomic, strong, readonly) dispatch_queue_t queue;

@end

@implementation MBEventTargetQueueScheduler

#pragma mark Lifecycle

- (instancetype)initWithName:(NSString *)name targetQueue:(dispatch_queue_t)targetQueue {
    NSCParameterAssert(targetQueue != NULL);

    if (name == nil) {
        name = [NSString stringWithFormat:@"com.mb.TargetQueueScheduler(%s)", dispatch_queue_get_label(targetQueue)];
    }

    dispatch_queue_t queue = dispatch_queue_create(name.UTF8String, DISPATCH_QUEUE_SERIAL);
    if (queue == NULL) return nil;

    dispatch_set_target_queue(queue, targetQueue);
    
    _queue = queue;
    
    return [super initWithName:name];
}

#pragma mark - scheduler

- (void)schedule:(void (^)(void))block {
    NSCParameterAssert(block != NULL);

    dispatch_async(self.queue, ^{
        @autoreleasepool {
            block();
        }
    });
}

@end
