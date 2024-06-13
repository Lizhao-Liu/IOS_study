//
//  YMMRouterResponse.m
//  Pods-YMMRouterLib_Tests
//
//  Created by Xiaohui on 2019/2/17.
//

#import "YMMRouterResponse.h"

@implementation YMMRouterResponse

- (instancetype)init {
    return [self initWithStatus:YMMRouterStatusSuccess];
}

- (instancetype)initWithStatus:(YMMRouterStatus)status {
    return [self initWithStatus:YMMRouterStatusSuccess
                        request:nil];
}

- (instancetype)initWithStatus:(YMMRouterStatus)status
                       request:(nullable id<YMMRouterRoutable>)routable {
    self = [super init];
    if (self) {
        _status = status;
        _request = routable;
    }
    return self;
}

@end
