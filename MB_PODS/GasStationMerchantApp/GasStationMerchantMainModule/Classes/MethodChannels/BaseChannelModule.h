//
//  BaseChannelModule.h
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseChannelModule : NSObject
@property (nonatomic, strong) FlutterMethodCall *call;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, copy) FlutterResult result;

- (instancetype)initWithCall:(FlutterMethodCall *)call fromChannel:(FlutterMethodChannel *)channel onResult:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
