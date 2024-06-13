//
//  PluginChannelsWithFlutter.m
//  Runner
//
//  Created by heyAdrian on 2018/9/28.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "PluginChannelsWithFlutter.h"
#import <objc/runtime.h>
#import "BaseChannelModule.h"
#import <JSONKIT/JSONKIT.h>
#import <objc/message.h>
@import HCBNetwork;
@import MBFoundation;

static FlutterMethodChannel *channel;
@implementation PluginChannelsWithFlutter

// TODO: 新flutter引擎需要在适当启动时机调用这个方法注册 channelmethods 插件
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel
                    methodChannelWithName:@"com.wlqq.phantom.plugin.gasstation.merchant/native"
                    binaryMessenger:[registrar messenger]];
    PluginChannelsWithFlutter* instance = [[PluginChannelsWithFlutter alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *callMethod = call.method;
    if (![callMethod containsString:@"/"]) {
        result([self commonErrorMsg:@"flutter channel 调用格式不正确！ 需按照moduleName/method方式调用!"]);
        return;
    }
    NSArray *modules = [callMethod componentsSeparatedByString:@"/"];
    if (!modules || modules.count != 2) {
        result([self commonErrorMsg:@"flutter channel 调用格式不正确！ 需按照moduleName/method方式调用!"]);
        return;
    }
    NSString *moduleName = modules[0];
    NSString *methodName = modules[1];
    if (moduleName.length == 0 || methodName.length == 0) {
        result([self commonErrorMsg:@"flutter channel 调用格式不正确！ 请检查module或者method名称字段!"]);
        return;
    }
    id ModuleClass = NSClassFromString(moduleName);
    if (!ModuleClass) {
        result([self commonErrorMsg:[NSString stringWithFormat:@"flutter channel 没有实现%@,请检查！", moduleName]]);
        return;
    }
    
    SEL initSel = NSSelectorFromString(@"initWithCall:fromChannel:onResult:");
    id moduleExample = [[NSClassFromString(moduleName) alloc]init];
    if ([moduleExample respondsToSelector:initSel]) {
        moduleExample = ((id (*)(id, SEL, FlutterMethodCall*, FlutterMethodChannel*, FlutterResult))objc_msgSend)(moduleExample, initSel, call, channel, result);
    }
    
    NSString *methodNameWithArguments =[NSString stringWithFormat:@"%@:", methodName];
    SEL selector = NSSelectorFromString(methodNameWithArguments);
    if ([moduleExample respondsToSelector:selector]) {
        NSMutableArray *arguments = [NSMutableArray array];
        // 以下代码和之前的默认设计保持一致，如需改动需要和flutter沟通确认：
        if(call.arguments){
            // call.arguments 历史逻辑默认为NSDictionary类型，是因为flutter传入的是map类型
            NSDictionary *originalArguments = (NSDictionary *)call.arguments;
            // 获取字典中的所有键，并按照从小到大顺序排序，是因为flutter是以数字序号作为key传入的
            NSArray *sortedKeys = [originalArguments allKeys];
            sortedKeys = [sortedKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
               return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            for (NSString *key in sortedKeys) { // fix：保障参数顺序为flutter传入的原始顺序
                id value = [originalArguments mb_objectForKeyIgnoreNil:key];
                [arguments addObject:value];
            }
        } else {
            arguments = nil;
        }
        ((void (*)(id, SEL, NSArray *)) objc_msgSend)(moduleExample, selector, [arguments copy]);
        return;
    } else {
        result(FlutterMethodNotImplemented);
        return;
    }
}

- (NSString *)commonErrorMsg:(NSString *)message {
    NSDictionary *dic = @{@"failure" : @{@"errorCode" : @"-1000000", @"errorMsg" : message}};
    return [dic JSONStringHCB];
}

+ (void)invokeFlutterMethod:(NSString *)methodeName arguments:(id)arguments {
    if (!channel) {
        return;
    }
    [channel invokeMethod:methodeName arguments:arguments];
}

@end
