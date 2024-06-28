//
//  MBBridgeDebugMonitorLogModel.m
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/9/21.
//

#import "MBBridgeDebugMonitorLogModel.h"
@import MBFoundation;
@import YMMBridgeLib;

@interface MBBridgeDebugMonitorLogModel()
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, copy) NSString *bridgeName;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, copy) NSString *requestString;
@property (nonatomic, copy) NSString *responseString;

@property (nonatomic, copy) NSString *bundleName;
@property (nonatomic, copy) NSString *bundleVersion;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *bundleType;
@property (nonatomic, assign) MBPluginRequestProtocol protocol;
@end

@implementation MBBridgeDebugMonitorLogModel

+ (MBBridgeDebugMonitorLogModel *)configWithRequest: (YMMPluginRequest *)request
                                           response: (YMMPluginResponse *)response
                                               time: (NSTimeInterval)time
                                           pageName:(NSString *)pageName {
    
    MBBridgeDebugMonitorLogModel *bridgeLogModel = [[MBBridgeDebugMonitorLogModel alloc] init];
    bridgeLogModel.startTime = time;
    bridgeLogModel.pageName = pageName;
    bridgeLogModel.protocol = request.protocol;
    bridgeLogModel.bundleName = request.bundleName;
    bridgeLogModel.bundleType = request.source;
    bridgeLogModel.bundleVersion = request.bundleVersion;
    bridgeLogModel.moduleName = request.module;
    
    // summary format "Bridge: module.business.method" or "Bridge: module.method"
    NSMutableString *bridgeName = [NSMutableString string];
    if(request.module){
        [bridgeName appendFormat:@"%@", request.module];
    }
    if(request.business){
        [bridgeName appendFormat:@".%@", request.business];
    }
    if(request.method){
        [bridgeName appendFormat:@".%@", request.method];
    }
    bridgeLogModel.bridgeName = bridgeName;
    
    // request string
    NSMutableString *requestString = [NSMutableString string];
    
    [requestString appendFormat:@"Request:\r\nmodule: %@  business: %@  method: %@\n", request.module, request.business, request.method];
    [requestString appendFormat:@"source: %@", request.source];
    if(request.visitor && request.visitor.length>0) {
        [requestString appendFormat:@"  visitor: %@  ", request.visitor];
    }
    if(request.container) {
        [requestString appendFormat:@"  container: %@", [request.container class]];
    }
    
    if(request.protocol == MBPluginRequestProtocol_V1){
        [requestString appendString:@"\nprotocol: V1" ];
    } else {
        [requestString appendString:@"\nprotocol: V2" ];
    }
    
    if(request.params && request.params.count > 0) {
        if( [NSJSONSerialization isValidJSONObject:request.params]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:request.params options:NSJSONWritingPrettyPrinted error:nil];
            NSString *paramsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [requestString appendFormat:@"\r\nparams:\r\n%@\r\n", paramsString];
        } else {
            [requestString appendFormat:@"\r\nparams:\r\n%@\r\n", request.params];
        }
    }
    bridgeLogModel.requestString = requestString;
    
    // response string
    NSMutableString *responseString = [NSMutableString string];
    [responseString appendFormat:@"Response:\r\ncode: %ld  reason: %@  data:", response.code, response.reason];
    [responseString appendFormat:@"\r\n{\r\n  code: %ld  reason: %@\r\n  data: %@\r\n}", response.data.code, response.data.reason, response.data.data];
    bridgeLogModel.responseString = responseString;
    
    // status code
    bridgeLogModel.statusCode = response.data.code;
    
    return bridgeLogModel;

}

- (MBDebugMontiorEventLocatorModel *)locatorModel {
    MBDebugMontiorEventLocatorModel *locatorModel = [MBDebugMontiorEventLocatorModel locatorModelWithPageName:self.pageName];
    locatorModel.bundleName = self.bundleName;
    locatorModel.bundleType = self.bundleType;
    locatorModel.bundleVersion = self.bundleVersion;
    locatorModel.moduleName = self.moduleName;
    return locatorModel;
}

- (MBDebugMonitorPageInfoModel *)pageInfoModel {
    MBDebugMonitorPageInfoModel *pageInfo = [[MBDebugMonitorPageInfoModel alloc] init];
    pageInfo.sectionTitle = @"Bundle 信息";
    NSMutableDictionary *dict = @{}.mutableCopy;
    if(self.bundleName){
        [dict setObject:self.bundleName forKey:@"name"];
    }
    if(self.bundleType){
        [dict setObject:self.bundleType forKey:@"type"];
    }
    if(self.bundleVersion){
        [dict setObject:self.bundleVersion forKey:@"version"];
    }
    if(dict.count == 0){
        return nil;
    }
    pageInfo.sectionDict = dict;
    return pageInfo;
}

- (BOOL)isErrorObject {
    return self.statusCode != 0;
}

- (NSTimeInterval)time {
    return self.startTime;
}

- (NSString *)summary {
    return self.bridgeName;
}

- (NSString *)detail {
    return [NSString stringWithFormat:@"[Request]\n%@\n[Response]\n%@\n", self.requestString, self.responseString];
}

- (NSString *)source {
    NSString *sourceStr = [NSString stringWithFormat:@"%@", self.pageName];
    if(self.bundleName && self.bundleName.length > 0){
        sourceStr = [sourceStr stringByAppendingFormat:@" | %@", self.bundleName];
    }
    if(self.bundleType && self.bundleType.length > 0){
        sourceStr = [sourceStr stringByAppendingFormat:@" | %@", self.bundleType];
    }
    return sourceStr;
}

- (MBDebugMonitorTagModel *)tagModel{
    MBDebugMonitorTagModel *model = [[MBDebugMonitorTagModel alloc] init];
    NSString *statusStr = @"SUCCESS";
    UIColor *statusColor = [UIColor greenColor];
    if(self.statusCode != 0){
        statusStr = [NSString stringWithFormat:@"[%ld]", (long)self.statusCode];
        statusColor = [UIColor redColor];
    }
    model.textColor = statusColor;
    model.tagName = statusStr;
    return model;
}

- (NSString *)searchStr {
    return self.bridgeName;
}

- (NSArray<NSString *> *)attributes {
    if(self.protocol == MBPluginRequestProtocol_V1){
        return @[@"V1"];
    } else if (self.protocol == MBPluginRequestProtocol_V2){
        return @[@"V2"];
    }
    return nil;
}

@end
