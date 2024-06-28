//
//  MBContainerEvent.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/29.
//

#import "MBContainerEvent.h"

@implementation MBContainerEvent

- (instancetype)initWithName:(NSString *)name userInfo:(nullable NSDictionary *)info {
    self = [super init];
    if (self) {
        _eventName = name;
        _params = info;
    }
    return self;
}

@end
