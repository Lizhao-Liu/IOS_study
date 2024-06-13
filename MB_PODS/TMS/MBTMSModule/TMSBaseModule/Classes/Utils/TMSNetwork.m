//
//  TMSNetwork.m
//  TMSBaseModule
//
//  Created by zht on 2021/5/8.
//

#import "TMSNetwork.h"
#import "TMSUserManager.h"
#import "TMSCommonMacros.h"
#import "NSURL+TMSURL.h"
@import MBCommonUILib;
@import MBProjectConfig;
@import YYModel;
@import MBFoundation;
@import MBNetworkLib;

@implementation TMSNetwork

#pragma mark - 初始化

+ (TMSNetwork *)shared {
    
    static TMSNetwork *sharedNetwork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = TMSNetwork.new;
    });
    return sharedNetwork;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self setNetworkConfigWithUrl:nil];
    }
    
    return self;
}

#pragma mark - 设置域名

/// @param url 域名
- (void)setNetworkConfigWithUrl:(nullable NSString *)url {
    
    if (![NSString mb_isNilOrEmpty:url]&&[NSURL tms_URLWithString:url]) {
        
        if (![url hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"https://%@",url];
        }
        _baseUrl = url;
        return;
    }
    
    MBNetworkEnvironment networkType = [MBAppDelegate projectConfig].currentNetworkEnv;
    
    NSString *tempUrl = @"";
    switch (networkType) {
        case MBNetworkEnvironmentDev:
            tempUrl = @"https://dev-api.tms8.com";
            break;
        case MBNetworkEnvironmentQA:
            tempUrl = @"https://qa-api.tms8.com";
            break;
        case MBNetworkEnvironmentPrepublish:
            tempUrl = @"https://api.tms8.com";
        case MBNetworkEnvironmentProduct:
            tempUrl = @"https://api.tms8.com";
        default:
            break;
    }
    
    _baseUrl = tempUrl;
}

- (NSArray<NSString *> *)tmsHosts {
    return @[@"https://dev-api.tms8.com", @"https://qa-api.tms8.com", @"https://api.tms8.com"];
}

- (NSArray<NSString *> *)tmsPaths {
    return @[
        @"saas-tms-trans",
        @"yzg-saas-trans-app",
        @"yzg-match-app",
        @"yzg-saas-permission-app",
        @"yzg-saas-analysis-app",
        @"yzg-saas-message-app",
        @"yzg-saas-financial-app",
        @"yzg-saas-process-engine-app",
        @"yzg-saas-common-setting-app",
        @"yzg-saas-price-app"
    ];
}


#pragma mark - GET、POST

/// get请求
/// @param apiPath 接口路径
/// @param params 参数
/// @param expectClass 返回值类型
/// @param onSuccess 成功回调
/// @param onFailed 失败回调
+ (void)getWithPath:(NSString *)apiPath
             params:(nullable NSDictionary *)params
        expectClass:(nullable Class)expectClass
          onSuccess:(nullable void(^)(id __nullable result))onSuccess
           onFailed:(nullable void(^)(MBGNetworkError *error))onFailed {
    
    [self requestWithMethod:MBBaseNetworkRequestMethodGET
                       path:apiPath
                     params:params
                expectClass:expectClass
                  onSuccess:onSuccess
                   onFailed:onFailed];
    
}

/// post请求
/// @param apiPath 接口路径
/// @param params 参数
/// @param expectClass 返回值类型
/// @param onSuccess 成功回调
/// @param onFailed 失败回调
+ (void)postWithPath:(NSString *)apiPath
              params:(nullable NSDictionary *)params
         expectClass:(nullable Class)expectClass
           onSuccess:(nullable void(^)(id __nullable result))onSuccess
            onFailed:(nullable void(^)(MBGNetworkError *error))onFailed {
    
   [self requestWithMethod:MBBaseNetworkRequestMethodPOST
                      path:apiPath
                    params:params
               expectClass:expectClass
                 onSuccess:onSuccess
                  onFailed:onFailed];
    
}

#pragma mark - Handle Error Code

+ (void)handleErrorWithCode:(NSInteger)code message:(NSString *)errorMsg{
    
    if ([TMSNetwork shared].tokenInvalidAlertShowing) {
        return;
    }
    [TMSNetwork shared].tokenInvalidAlertShowing = YES;
    
    //310010表示（登录态失效，需要重新登录）
    if (code == 310010) {
        
        MBGAlertView *alert = [MBGAlertView tipsViewWithTitle:TMSMSG_TIPTITLE message:@"账号的登录状态已过期，请重新登录" actionButton:TMSMSG_IKNOW];
        [alert addConfirmAction:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TMSKEY_NOTI_USERLOGOUT_WILL object:nil];
            [TMSNetwork shared].tokenInvalidAlertShowing = NO;
        }];
        [alert show];
    }
    //600009表示（租户到期，需要重新登录）
    else if (code == 600009){
        
        if ([NSString mb_isNilOrEmpty:errorMsg]) {
            return;
        }
        
        NSString *phone = [errorMsg componentsSeparatedByString:@"联系客服"].lastObject;

        if ([NSString mb_isNilOrEmpty:phone]) {
            return;
        }
        
        BOOL isLogin = TMSUserManager.sharedTMSUserManager.isLogin;
        
        MBGAlertView *alert = [MBGAlertView tipsViewWithTitle:@"温馨提示" message:errorMsg cancelButton:@"关闭" actionButton:@"联系客服"];
        [alert addCancelAction:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TMSKEY_NOTI_USERLOGOUT_WILL object:@{@"needlogout":@(isLogin)}];
            [TMSNetwork shared].tokenInvalidAlertShowing = NO;
        }];
        [alert addConfirmAction:^{
            [phone makePhoneCall];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:TMSKEY_NOTI_USERLOGOUT_WILL object:@{@"needlogout":@(isLogin)}];
                [TMSNetwork shared].tokenInvalidAlertShowing = NO;
            });
        }];
        [alert show];
    }
}

#pragma mark - Private Methods

+(void)requestWithMethod:(MBBaseNetworkRequestMethod)method
                    path:(NSString *)apiPath
                  params:(nullable NSDictionary *)params
             expectClass:(nullable Class)expectClass
               onSuccess:(nullable void(^)(id __nullable result))onSuccess
                onFailed:(nullable void(^)(MBGNetworkError *error))onFailed {
    
    MBGNetworkRequest *request = [[MBGNetworkRequest alloc] init];

    if (![NSString mb_isNilOrEmpty:TMSNetwork.shared.baseUrl]) {
        request.baseUrl = TMSNetwork.shared.baseUrl;
    }

    if (![apiPath hasPrefix:@"/"]) {
        apiPath = [NSString stringWithFormat:@"/%@",apiPath];
    }

    request.path = apiPath;
    request.method = method;
    request.isDefaultDataLogic = NO;

    NSDictionary *httpHeaderFields = params[@"tms_header"];
    if(httpHeaderFields&&[httpHeaderFields isKindOfClass:NSDictionary.class]&&httpHeaderFields.allKeys.count>0) {
        request.httpHeaderFields = httpHeaderFields;
        NSMutableDictionary *tempParamDic = [NSMutableDictionary dictionaryWithDictionary:params];
        [tempParamDic removeObjectForKey:@"tms_header"];
        params = [tempParamDic copy];
    }

    request.params = params;
    request.responseModelClass = nil;
    
    [request startWithSuccess:^(MBGNetworkRequest * _Nonnull request, id  _Nonnull responseObj) {
        [self handleResponse:responseObj error:nil expectClass:expectClass onSuccess:onSuccess onFailed:onFailed];
    } failure:^(MBGNetworkRequest * _Nonnull request, MBGNetworkError * _Nonnull error) {
        [self handleResponse:nil error:error expectClass:expectClass onSuccess:onSuccess onFailed:onFailed];
    }];
}

+ (void)handleResponse:(id)responseObj
                 error:(MBGNetworkError *)error
           expectClass:(nullable Class)expectClass
             onSuccess:(nullable void(^)(id __nullable result))onSuccess
              onFailed:(nullable void(^)(MBGNetworkError *error))onFailed {
    
    if(error){
        !onFailed?:onFailed(error);
    }
    
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
            return;
        }
        
        //返回类型不存在的时候，直接把原始数据扔出来，由业务自己去判断成功或者失败
        if (!expectClass) {
            !onSuccess?:onSuccess(responseDict);
            return;
        }
        
        //10000表示成功
        if (responseCode == 10000) {
            id data = [responseDict mb_objectForKey:@"data"];
            if ([expectClass conformsToProtocol:@protocol(YYModel)] && data) {
                data = [expectClass yy_modelWithJSON:data];
            }
            
            if ([data isKindOfClass:expectClass]) {
                !onSuccess?:onSuccess(data);
            }
            else {
                !onFailed?:onFailed([MBGNetworkError.alloc initWithDomain:MBGNetworkErrorResponseDomain code:MBGNetworkErrorCodeResponseBussinessAgreementError message:@"返回数据与期望数据不同" userInfo:responseDict]);
            }
        } else {
            NSString *errMsg = [responseDict mb_stringForKey:@"msg"];
            if(!errMsg){
                errMsg = [responseDict mb_stringForKey:@"message"];
            }
            
            !onFailed?:onFailed([MBGNetworkError.alloc initWithDomain:MBGNetworkErrorResponseDomain code:responseCode message:errMsg userInfo:responseDict]);
        }
        
    }
}


@end
