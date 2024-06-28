//
//  MBBridgeContainer.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2020/12/7.
//

#import "MBBridgeContainer.h"

@interface MBBridgeContainerListener ()

- (instancetype)initWithBlock:(nullable DeallocBlock)deallocBlock;

@end

@implementation MBBridgeContainerListener

#pragma mark - lifeCycle method
- (instancetype)initWithBlock:(nullable DeallocBlock)deallocBlock {
    self = [super init];
    if (self) {
        
        _deallocBlock = deallocBlock;
    }
    return self;
}

#pragma mark - public method

+ (MBBridgeContainerListener *)listenDealloc:(nullable DeallocBlock)deallocBlock {
    MBBridgeContainerListener *listener =
    [[MBBridgeContainerListener alloc] initWithBlock:deallocBlock];
    return listener;
}

@end
