#import "HttpWithFlutterPlugin.h"
#import <JSONKIT/JSONKIT.h>
#import "HCBUserManager.h"
@import MBUIKit;
@import HCBNetwork;
@import HCBLoginSDK;
@import MBFoundation;

static NSTimeInterval const kHttpTimeOutInterval = 30.0;

@implementation HttpWithFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.wlqq.plugins/http"
            binaryMessenger:[registrar messenger]];
  HttpWithFlutterPlugin* instance = [[HttpWithFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (![@"post" isEqualToString:call.method] && ![@"uploadFile" isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
        return;
    }
    
    NSString *arguments = (NSString *)call.arguments;
    NSDictionary *dic = [arguments objectFromJSONString];
    NSString *host = dic[@"host"];
    NSString *apiPath = dic[@"apiPath"];
    BOOL isSilent = YES; //NATIVE端都不弹toast，所有弹toast的逻辑都有Flutter端自己控制。
    BOOL isShowHUD = NO;//NATIVE端都不转菊花，所有转菊花的逻辑都有Flutter端自己控制。
    //    TODO:新增参数指定是否需要校验session
    if ([@"post" isEqualToString:call.method]) {
        BOOL isEncrypt = [dic[@"isEncrypt"] boolValue];
        NSMutableDictionary *params = [dic mb_dictionaryForKey:@"textParams"].mutableCopy;
        [HttpWithFlutterPlugin requestWithHost:host api:apiPath params:params isShowToast:!isSilent isShowHUD:isShowHUD isEncrypt:isEncrypt completed:^(id requestResult) {
            if (!requestResult) {
                result(@"");
                return;
            }
            NSDictionary *resultDic = @{@"success" : requestResult};
            result([resultDic JSONStringHCB]);
        } falied:^(HCBError *error) {
            result([HttpWithFlutterPlugin dealWithError:error]);
        }];
    } else if ([@"uploadFile" isEqualToString:call.method]) {
        BOOL isSessionApi = dic[@"isSessionApi"];
        NSMutableDictionary *params = [dic mb_dictionaryForKey:@"textParams"].mutableCopy;
        NSDictionary *fileParams = dic[@"fileParams"];
        [HttpWithFlutterPlugin uploadWithHost:host api:apiPath params:params fileParams:fileParams isShowToast:!isSilent isShowHUD:isShowHUD isSessionApi:isSessionApi completed:^(id requestResult) {
            if (!requestResult) {
                result(@"");
                return;
            }
            NSDictionary *resultDic = @{@"success" : requestResult};
            result([resultDic JSONStringHCB]);
        } falied:^(id error) {
            result([HttpWithFlutterPlugin dealWithError:error]);
        }];
    }
}

#pragma mark - getter setter
+ (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
}
    
+ (void)showHUD:(BOOL)show {
    if (!show) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:[HttpWithFlutterPlugin window] animated:YES text:@"请求中，请稍等..."];
}
    
+ (void)hideHUD:(BOOL)show {
    if (!show) {
        return;
    }
    [MBProgressHUD hideHUDForView:[HttpWithFlutterPlugin window] animated:YES];
}
    
+ (BOOL)isValidString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return false;
    }
    
    return string.length > 0;
}
    
#pragma mark - private

/**
 处理成功数据

 @param content 数据
 @return 返回结果
 */
+ (id)dealWithSuccessContent:(id)content
{
    if (!content) {
        return @"";
    }
    
    if (![content isKindOfClass:[NSDictionary class]] && ![content isKindOfClass:[NSArray class]]) {
        return content;
    }
    
    //兼容iOS和Android返回的数据结构不一致的问题。iOS网络库如果content中返回的不是NSDictionary就会包一层result
    NSDictionary *dic = content;
    
    id resultContent = dic[@"result"];
    if (dic.allKeys.count == 1 && resultContent && ![resultContent isKindOfClass:[NSDictionary class]]) {
        if (resultContent == (id)kCFNull) {
            return @"null";
        }
        if ([resultContent isKindOfClass:[NSArray class]]) {
            return resultContent;
        }
        return [NSString stringWithFormat:@"%@", resultContent];
    }
    return content;
}


/**
 处理失败数据

 @param error 失败error
 @return 返回结果
 */
+ (NSString *)dealWithError:(HCBError *)error
{
    id content = @"";
    if (error) {
        content = @{}.mutableCopy;
//        if(error.errorCode){
//            [content setObject:error.errorCode forKey:@"errorCode"];
//        }
        if(error.errorMsg){
            [content setObject:error.errorMsg forKey:@"errorMsg"];
        }
    }
    
    return [@{@"failure" : content} JSONStringHCB];
}


/**
 普通请求

 @param host 请求host
 @param api 请求api
 @param params 请求参数
 @param isShowToast 是否显示toast
 @param isShowHUD 是否显示菊花
 @param isEncrypt 是否加密
 @param completedHandler 成功
 @param failedHandler 失败
 */
+ (void)requestWithHost:(NSString *)host
                    api:(NSString *)api
                 params:(NSDictionary *)params
            isShowToast:(BOOL)isShowToast
              isShowHUD:(BOOL)isShowHUD
              isEncrypt:(BOOL)isEncrypt
              completed:(void (^)(id))completedHandler
                 falied:(void (^)(HCBError *error))failedHandler
    {
        if (![HttpWithFlutterPlugin isValidString:host] || ![HttpWithFlutterPlugin isValidString:api] || ![params isKindOfClass:[NSDictionary class]]) {
            !failedHandler ? : failedHandler([[HCBError alloc] initWithStatus:@"ParametersError" errorCode:@"-100000" errorMsg:@"parameters is not valid" errorType:HCBErrorType_APP]);
            return;
        }
        
        [HttpWithFlutterPlugin showHUD:isShowHUD];
        HCBRequest *request = [HCBRequest dataRequest:api parameters:params configuration:^(__kindof HCBRequest * _Nonnull request) {
            if (isEncrypt) {
                request.dispatcher_version = HCBNetwrokDispatcher_Version3_0;
                request.encrypt_version = HCBNetwrokEncrypt_Version3;
            } else {
                request.dispatcher_version = HCBNetwrokDispatcher_Version3_0;
                request.encrypt_version = HCBNetwrokEncrypt_None;
            }
            request.host = host;
            request.timeOut = kHttpTimeOutInterval;
            request.notShowToast = !isShowToast;
            if([HCBUserManager shareManager].currentUser.ID){
                [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
            }
        } success:^(__kindof HCBRequest * _Nonnull request, id  _Nullable content) {
            [HttpWithFlutterPlugin hideHUD:isShowHUD];
            !completedHandler ? : completedHandler([HttpWithFlutterPlugin dealWithSuccessContent:content]);
        } failure:^(__kindof HCBRequest * _Nonnull request, HCBError * _Nonnull error) {
            [HttpWithFlutterPlugin hideHUD:isShowHUD];
            !failedHandler ? : failedHandler(error);
        }];
        [request startAsynchronous];
    }

/**
 普通请求
 
 @param host 请求host
 @param api 请求api
 @param params 请求参数
 @param isShowToast 是否显示toast
 @param isShowHUD 是否显示菊花
 @param isSessionApi 是否需要session信息
 @param completedHandler 成功
 @param failedHandler 失败
 */
+ (void)uploadWithHost:(NSString *)host
                   api:(NSString *)api
                params:(NSDictionary *)params
            fileParams:(NSDictionary *)fileParams
           isShowToast:(BOOL)isShowToast
             isShowHUD:(BOOL)isShowHUD
          isSessionApi:(BOOL)isSessionApi
             completed:(void (^)(id))completedHandler
                falied:(void (^)(HCBError *error))failedHandler
{
    if (![HttpWithFlutterPlugin isValidString:host] || ![HttpWithFlutterPlugin isValidString:api] || !fileParams || fileParams.allKeys.count == 0 || ![params isKindOfClass:[NSDictionary class]]) {
        !failedHandler ? : failedHandler([[HCBError alloc] initWithStatus:@"ParametersError" errorCode:@"-100000" errorMsg:@"parameters is not valid" errorType:HCBErrorType_APP]);
        return;
    }
    
    [HttpWithFlutterPlugin showHUD:isShowHUD];
    NSString *dataPath = fileParams[fileParams.allKeys[0]];
    NSData *fileData = [NSData dataWithContentsOfFile:dataPath];
    
    if (!fileData) {//没有找到文件data就返回error
        !failedHandler ? : failedHandler([[HCBError alloc] initWithStatus:@"UploadError" errorCode:@"-100001" errorMsg:@"upload file data is not valid" errorType:HCBErrorType_APP]);
        [HttpWithFlutterPlugin hideHUD:isShowHUD];
        return;
    }
    
    NSString *fileName = [dataPath lastPathComponent];
    NSString *fileKey = fileParams.allKeys[0];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", host, api];
    if (isSessionApi) {
        URLString = [NSString stringWithFormat:@"%@?sid=%@&st=%@", URLString, @([HCBSessionManager sharedManager].session.id), [HCBSessionManager sharedManager].session.token];
    }
    
    HCBUploadRequest *request = [HCBRequest uploadRequest:api URLString:URLString parameters:params configuration:^(__kindof HCBRequest *request) {
        request.notShowToast = !isShowToast;
        request.host = host;
        [request addData:fileData withFileName:fileName andContentType:@"image/jpg" forKey:fileKey];
    } progress:^(int64_t completeUnitCount, int64_t totolUnitCount, double fractionCompleted) {
        
    } success:^(__kindof HCBRequest *request, id content) {
        [HttpWithFlutterPlugin hideHUD:isShowHUD];
        !completedHandler ? : completedHandler([HttpWithFlutterPlugin dealWithSuccessContent:content]);
    } failure:^(__kindof HCBRequest *request, HCBError *error) {
        [HttpWithFlutterPlugin hideHUD:isShowHUD];
        !failedHandler ? : failedHandler(error);
    }];
    [request startAsynchronous];
        
}

@end
