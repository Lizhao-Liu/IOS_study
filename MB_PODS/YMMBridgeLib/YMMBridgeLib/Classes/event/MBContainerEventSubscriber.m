//
//  MBContainerEventSubscriber.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/29.
//

#import "MBContainerEventSubscriber.h"

@implementation MBContainerEventSubscriber

- (instancetype)initWithSubscriber:(id)subscriber
                            action:(MBEventActionBlock)block
                       onScheduler:(MBEventScheduler *)scheduler {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
        _actionBlock = block;
        _scheduler = scheduler;
    }
    return self;
}

@end
