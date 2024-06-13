//
//  TMSBridgeURLHandler.m
//  MBTMSModule
//
//  Created by Lizhao on 2023/12/18.
//

#import "TMSBridgeNetworkRequestAdapter.h"
#import "TMSNetwork.h"
#import "NSURL+TMSURL.h"
@import MBNetworkLib;
@import YMMBridgeModuleService;
@import MBDoctorService;

@interface TMSBridgeNetworkRequestAdapter ()<MBBridgeNetworkRequestAdapterProtocol>

@end

@implementation TMSBridgeNetworkRequestAdapter

// 注意： tms的网络请求bridge存在特殊历史遗留特殊逻辑
- (NSDictionary *)appProcessedParamsWithOriginalParams:(NSDictionary *)params {
    NSMutableDictionary *newParams = [params mutableCopy];
    NSString *url = [params mb_stringForKey:@"url"];
    
    NSMutableDictionary *headers = [params mb_dictionaryForKey:@"headers"].mutableCopy;
    if(headers && headers.count > 0){ // 1. 判断 header
        id urlNameInHeaders =  [headers mb_objectForKey:@"url_name"];
        if(urlNameInHeaders){
            NSString *urlName = [self getUrlNameFromHeaders:urlNameInHeaders];
            if(urlName && [urlName isEqualToString:@"tms"]){
                newParams[@"url"] = [self appProcessedUrl:url];
            }
            [headers removeObjectForKey:@"url_name"];
            newParams[@"headers"] = headers;
        }
    } else if ([self isTMSRequestWithUrl:url]){ // 2. 判断 url
        newParams[@"url"] = [self appProcessedUrl:url];
    } else if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]){ // 3. 判断 host
        NSString *host = [NSURL tms_URLWithString:url].host;
        if([TMSNetwork.shared.tmsHosts containsObject:host]){
            newParams[@"url"] = [self appProcessedUrl:url];
        }
    }
    return newParams.copy;
}

- (BOOL)isTMSRequestWithUrl:(NSString *)url {
    NSArray<NSString *> *tmsPaths = [TMSNetwork shared].tmsPaths;
    for (NSString *tmsPath in tmsPaths){
        if(url && [url containsString:tmsPath]){
            return YES;
        }
    }
    return NO;
}

- (NSString *)getUrlNameFromHeaders:(id)urlNameInHeaders {
    NSString *urlName;
    if([urlNameInHeaders isKindOfClass:[NSArray class]]){
        NSArray *urlNames = (NSArray *)urlNameInHeaders;
        if(urlNames.count > 0 && [urlNameInHeaders[0] isKindOfClass:[NSString class]]){
            urlName = (NSString *)urlNameInHeaders[0];
        }
    } else if ([urlNameInHeaders isKindOfClass:[NSString class]]){
        urlName = (NSString *)urlNameInHeaders;
    }
    return urlName;
}

- (NSString *)appProcessedUrl:(NSString *)originalURL {
    if ([originalURL hasPrefix:@"http"] || [originalURL hasPrefix:@"https"]) {
        originalURL = [NSURL tms_URLWithString:originalURL].path;
    }

    if (![originalURL hasPrefix:@"/"]) {
        originalURL = [NSString stringWithFormat:@"/%@",originalURL];
    }

    NSString *processedURL = [NSString stringWithFormat:@"%@%@",TMSNetwork.shared.baseUrl, originalURL];

    
    MBDoctorEventCustom *event = [[MBDoctorEventCustom alloc] initWithPlatform:MBDoctorPlatformHubble];
    event.metricType = MBDoctorMetricTypeCounter;
    event.metricValue = 1;
    event.metricName = @"tms_request_change_host_monitor";
    NSString *path =  [NSURL tms_URLWithString:processedURL].path ?: @"";
    event.tags = @{@"path": path};
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(MBDoctorContext.new, MBDoctorServiceProtocol);
    [service doctor:event];
    
    return processedURL;
}


- (BOOL)shouldInterceptResponse:(id)responseObj {
    if([responseObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSInteger responseCode = [responseDict mb_integerForKey:@"code"];
        //310010表示（登录态失效，需要重新登录），600009表示（租户到期，需要重新登录）
        if(responseCode == 310010 || responseCode == 600009) {
            NSString *errMsg = [responseDict mb_stringForKey:@"msg"];
            if(!errMsg){
                errMsg = [responseDict mb_stringForKey:@"message"];
            }
            
            [TMSNetwork handleErrorWithCode:responseCode message:errMsg];
            return YES;
        }
        return NO;
    }
    return NO;
}


@end
