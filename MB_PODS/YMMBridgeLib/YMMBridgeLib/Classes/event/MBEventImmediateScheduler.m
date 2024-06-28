//
//  MBEventImmediateScheduler.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import "MBEventImmediateScheduler.h"
#import "MBEventScheduler+Private.h"

@implementation MBEventImmediateScheduler

#pragma mark Lifecycle

- (instancetype)init {
    return [super initWithName:@"com.mb.containerEvent.immediateScheduler"];
}

#pragma mark scheduler

- (void)schedule:(void (^)(void))block {
    NSCParameterAssert(block != NULL);
    block();
}

@end
