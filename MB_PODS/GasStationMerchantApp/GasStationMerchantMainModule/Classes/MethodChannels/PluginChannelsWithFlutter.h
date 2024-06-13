//
//  PluginChannelsWithFlutter.h
//  Runner
//
//  Created by heyAdrian on 2018/9/28.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Flutter/Flutter.h>

@interface PluginChannelsWithFlutter : NSObject<FlutterPlugin>

+ (void)invokeFlutterMethod:(NSString *)methodeName arguments:(id _Nullable)arguments;

@end

