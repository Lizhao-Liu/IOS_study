//
//  YMMRouterDebugEventModel.m
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import "YMMRouterDebugEventModel.h"
#import <objc/runtime.h>
@import YMMRouterLib;
@import MBFoundation;

@interface YMMRouterDebugEventModel()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *summaryStr;
@property (nonatomic, copy) NSString *requestString;
@property (nonatomic, copy) NSString *responseString;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, copy) NSString *pageName;
@end

@implementation YMMRouterDebugEventModel

+ (YMMRouterDebugEventModel *)configWithRequest: (id<YMMRouterRoutable>)request
                                       response: (YMMRouterResponse *)response
                                           time: (NSTimeInterval)time
                                       pageName:(NSString *)pageName {
    
    YMMRouterDebugEventModel *routerEventModel = [[YMMRouterDebugEventModel alloc] init];
    routerEventModel.url = request.urlString;
    routerEventModel.startTime = time;
    routerEventModel.pageName = pageName;
    
    
    // request info
    NSMutableString *summaryStr = [NSMutableString string];
    [summaryStr appendFormat:@"scheme:  %@   host:  %@\r\npath:  %@", request.scheme, request.host, request.path];
    routerEventModel.summaryStr = [NSString stringWithFormat:@"scheme:  %@   host:  %@\r\npath:  %@", request.scheme, request.host, request.path];
    NSMutableString *requestString = [NSMutableString string];
    [requestString appendFormat:@"Request URL:\r\nscheme:  %@   host:  %@\r\npath:  %@\r\n", request.scheme, request.host, request.path];
    if(request.params && request.params.count>0){
        if( [NSJSONSerialization isValidJSONObject:request.params]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:request.params options:NSJSONWritingPrettyPrinted error:nil];
            NSString *paramsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [requestString appendFormat:@"params:\r\n%@\r\n", paramsString];
        } else {
            [requestString appendFormat:@"params:\r\n%@\r\n", request.params];
        }
    }
    
    if(request.fragment && request.fragment.length>0) {
        [requestString appendFormat:@"fragment:  %@\r\n", request.fragment];
    }
    
    // response info
    NSMutableString *responseString = [NSMutableString string];
    routerEventModel.statusCode = (int)response.status;
    NSString *resultStr;
    if(response.result == nil){
        resultStr = @"NULL";
    } else if([response.result isKindOfClass:[NSNumber class]]){
        resultStr = [NSString stringWithFormat:@"%@", (NSNumber*)response.result];
    } else {
        resultStr = NSStringFromClass([response.result class]);
    }
    [summaryStr appendFormat:@"\nresult: %@  handler: %@", resultStr, response.handler.class];
    [responseString appendFormat:@"Result:  %@\nhandler: %@", resultStr, response.handler.class];
    routerEventModel.requestString = requestString;
    routerEventModel.responseString = responseString;
    routerEventModel.summaryStr = summaryStr;
    return routerEventModel;
}

- (NSTimeInterval)time {
    return self.startTime;
}

- (NSString *)summary {
    return self.summaryStr;
}

- (NSString *)detail {
    NSString *content = [NSString stringWithFormat:@"[Request]\n%@\n[Response]\n%@\n",self.requestString, self.responseString];
    return content;
}

- (MBDebugMonitorTagModel *)tagModel{
    MBDebugMonitorTagModel *model = [[MBDebugMonitorTagModel alloc] init];
    NSString *statusStr = @"SUCCESS";
    UIColor *statusColor = [UIColor greenColor];
    if(self.statusCode != 200){
        statusStr = [NSString stringWithFormat:@"[%ld]", (long)self.statusCode];
        statusColor = [UIColor redColor];
    }
    model.textColor = statusColor;
    model.tagName = statusStr;
    return model;
}

- (NSString *)source {
    if(self.pageName && self.pageName.length > 0){
        return [NSString stringWithFormat:@"page: %@", self.pageName];
    }
    return nil;
}


- (BOOL)isErrorObject {
    return self.statusCode != 200;
}

- (NSString *)searchStr {
    return self.url;
}

- (MBDebugMontiorEventLocatorModel *)locatorModel {
    MBDebugMontiorEventLocatorModel *locatorModel = [MBDebugMontiorEventLocatorModel locatorModelWithPageName:self.pageName];
    return locatorModel;
}
@end
