//
//  BaseChannelModule.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "BaseChannelModule.h"

@implementation BaseChannelModule

- (instancetype)initWithCall:(FlutterMethodCall *)call fromChannel:(FlutterMethodChannel *)channel onResult:(FlutterResult)result {
    self = [super init];
    if (self) {
        _call = call;
        _channel = channel;
        _result = result;
    }
    return self;
}

@end
