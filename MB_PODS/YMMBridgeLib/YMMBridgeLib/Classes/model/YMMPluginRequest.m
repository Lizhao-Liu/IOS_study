//
//  YMMPluginRequest.m
//  GoodTransport
//
//  Created by 尹成 on 2019/2/24.
//  Copyright © 2019 Yunmanman. All rights reserved.
//

#import "YMMPluginRequest.h"
#import "YMMPluginDefine.h"

@implementation YMMPluginRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _protocol = MBPluginRequestProtocol_V1;
    }
    return self;
}

- (BOOL)avaliableRequest {
    return (self.module && self.method);
}

@end

