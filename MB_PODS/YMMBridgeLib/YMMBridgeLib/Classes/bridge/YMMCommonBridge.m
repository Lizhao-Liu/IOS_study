//
//  YMMCommonBridge.m
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/25.
//  Copyright © 2019 尹成. All rights reserved.
//

#import "YMMCommonBridge.h"
#import "YMMPluginRequest.h"
#import "YMMPluginManager.h"

@implementation YMMCommonBridge

- (void)performBridge:(NSDictionary *)bridgeInfo callBack:(YMMBridgeCallBack)callBack {
    [self performBridge:bridgeInfo
              container:nil
               callBack:callBack];
    /*
    YMMPluginRequest *pluginRequest = [[YMMPluginRequest alloc] init];
    pluginRequest.module = [bridgeInfo objectForKey:@"module"];
    NSString *bizName = [bridgeInfo objectForKey:@"business"];
    if ([bizName isKindOfClass:[NSString class]] && bizName.length > 0) {
        pluginRequest.business = [bridgeInfo objectForKey:@"business"];
    }
    pluginRequest.method = [bridgeInfo objectForKey:@"method"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([bridgeInfo objectForKey:@"params"] &&
        [[bridgeInfo objectForKey:@"params"] isKindOfClass:[NSDictionary class]]) {
        [params addEntriesFromDictionary:[bridgeInfo objectForKey:@"params"]];
    }
    
    if ([bridgeInfo objectForKey:@"source"]) {
        pluginRequest.source = [bridgeInfo objectForKey:@"source"];
    } else {
        pluginRequest.source = NSStringFromClass([self class]);
    }
    // 来源字段拼入参数部分
    [params setValue:pluginRequest.source forKey:@"mbBridgeFrom"];
    pluginRequest.params = params;
    
    [[YMMPluginManager shared] performPlugin:pluginRequest
                                    callBack:^(YMMPluginResponse *response) {
                                        if (callBack) {
                                            //TODO: model -> dict ,then test
                                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                            if (response) {
                                                if (response.data) {
                                                    NSMutableDictionary *methodRespons = [NSMutableDictionary dictionary];
                                                    [methodRespons setValue:@(response.data.code) forKey:@"code"];
                                                    [methodRespons setValue:response.data.reason forKey:@"reason"];
                                                    [methodRespons setValue:response.data.data forKey:@"data"];
                                                    [dict setValue:methodRespons forKey:@"data"];
                                                }
                                                [dict setValue:@(response.code) forKey:@"code"];
                                                [dict setValue:response.reason forKey:@"reason"];
                                            }
                                            callBack(dict);
                                        }
                                    }];
     */
}

- (void)performBridge:(NSDictionary *)bridgeInfo
            container:(nullable id<MBBridgeContainer>)container
             callBack:(YMMBridgeCallBack)callBack {
    
    YMMPluginRequest *pluginRequest = [self createPluginRequest];
    [self assembleRequest:pluginRequest withInfo:bridgeInfo container:container];
    
    if (pluginRequest.protocol == MBPluginRequestProtocol_V2) {
        
        [self performCommonBridge:pluginRequest callBack:callBack];
        return;
    }
    
    [[YMMPluginManager shared] performPlugin:pluginRequest
                                    callBack:^(YMMPluginResponse *response) {
                                        if (callBack) {
                                            //TODO: model -> dict ,then test
                                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                            if (response) {
                                                if (response.data) {
                                                    NSMutableDictionary *methodRespons = [NSMutableDictionary dictionary];
                                                    [methodRespons setValue:@(response.data.code) forKey:@"code"];
                                                    [methodRespons setValue:response.data.reason forKey:@"reason"];
                                                    [methodRespons setValue:response.data.data forKey:@"data"];
                                                    [dict setValue:methodRespons forKey:@"data"];
                                                }
                                                [dict setValue:@(response.code) forKey:@"code"];
                                                [dict setValue:response.reason forKey:@"reason"];
                                            }
                                            callBack(dict);
                                        }
                                    }];
}

#pragma mark - private method
- (void)performCommonBridge:(YMMPluginRequest *)request
                   callBack:(YMMBridgeCallBack)callBack {
    
    [[YMMPluginManager shared] performCommonBridge:request callBack:^(MBPluginResponse * _Nonnull response) {
        if (callBack) {
            callBack([self convertResult:response]);
        }
    }];
}

- (NSDictionary *)convertResult:(MBPluginResponse *)response {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (response) {
        if (response.data) {
            [dict setValue:response.data forKey:@"data"];
        }
        [dict setValue:@(response.code) forKey:@"code"];
        [dict setValue:response.reason forKey:@"reason"];
    }
    return dict;
}

- (void)assembleRequest:(YMMPluginRequest *)pluginRequest
               withInfo:(NSDictionary *)bridgeInfo
              container:(nullable id<MBBridgeContainer>)container {
    
    pluginRequest.module = [bridgeInfo objectForKey:@"module"];
    NSString *bizName = [bridgeInfo objectForKey:@"business"];
    if ([bizName isKindOfClass:[NSString class]] && bizName.length > 0) {
        pluginRequest.business = [bridgeInfo objectForKey:@"business"];
    }
    pluginRequest.method = [bridgeInfo objectForKey:@"method"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([bridgeInfo objectForKey:@"params"] &&
        [[bridgeInfo objectForKey:@"params"] isKindOfClass:[NSDictionary class]]) {
        [params addEntriesFromDictionary:[bridgeInfo objectForKey:@"params"]];
    }
    
    if ([bridgeInfo objectForKey:@"source"]) {
        pluginRequest.source = [bridgeInfo objectForKey:@"source"];
    } else {
        pluginRequest.source = @"native";
    }
    // 来源字段拼入参数部分
    [params setValue:pluginRequest.source forKey:@"mbBridgeFrom"];
    pluginRequest.params = params;
    
    NSNumber *ver = [bridgeInfo objectForKey:@"protocol"];
    if (ver != nil && [ver respondsToSelector:@selector(integerValue)]) {
        pluginRequest.protocol = [ver integerValue];
    }
    
    // 业务bundle名
    if ([bridgeInfo objectForKey:@"bundleName"]) {
        pluginRequest.bundleName = [bridgeInfo objectForKey:@"bundleName"];
    }
    
    // 业务bundle版本号
    if ([bridgeInfo objectForKey:@"bundleVersion"]) {
        pluginRequest.bundleVersion = [bridgeInfo objectForKey:@"bundleVersion"];
    }
    
    // 调用者
    if ([bridgeInfo objectForKey:@"visitor"]) {
        pluginRequest.visitor = [bridgeInfo objectForKey:@"visitor"];
    }
    
    // 容器对象
    pluginRequest.container = container;
}

- (YMMPluginRequest *) createPluginRequest {
    YMMPluginRequest *pluginRequest = [[YMMPluginRequest alloc] init];
    return pluginRequest;
}

@end
