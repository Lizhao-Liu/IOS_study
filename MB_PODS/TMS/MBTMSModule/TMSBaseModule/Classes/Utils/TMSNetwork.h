//
//  TMSNetwork.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/8.
//

#import <Foundation/Foundation.h>
@import MBFoundation;
@import MBLogLib;
@import MBBuildPreLib;

/**
 * TMS网络基础库日志宏
 */
#define TMSNetworkLog_Debug(...)                    MBModuleDebug("TMSNetwork", __VA_ARGS__)
#define TMSNetworkLog_Info(...)                     MBModuleInfo("TMSNetwork", __VA_ARGS__)
#define TMSNetworkLog_Warning(...)                  MBModuleWarning("TMSNetwork", __VA_ARGS__)
#define TMSNetworkLog_Error(...)                    MBModuleError("TMSNetwork", __VA_ARGS__)
#define TMSNetworkLog_Fatal(...)                    MBModuleFatal("TMSNetwork", __VA_ARGS__)

NS_ASSUME_NONNULL_BEGIN

/**
 YMM网络Response数据日志输出长度限制，Release包暂定256字节，其余包无限制
 */
static inline NSString *TMSNetworkLog_Response_MaxLengthLimit(id object) {
    NSString *jsonString = [NSJSONSerialization isValidJSONObject:object] ? [MBJsonUtil dictionaryToJson:object] : @"";
    if ([MBFMacro ymm_buildRelease]) {
        jsonString = jsonString.length <= 256 ? jsonString: [jsonString substringToIndex:256];
    }
    return jsonString;
}

@class MBGNetworkError;

@interface TMSNetwork : NSObject

@property(nonatomic) BOOL tokenInvalidAlertShowing;//防止登录态失效之后，仍然会有并发的多个网络请求，导致重复弹窗
@property (nonatomic, copy, readonly) NSString *baseUrl;// 当前域名

@property (nonatomic, copy, readonly) NSArray<NSString *> *tmsHosts;// tms域名
@property (nonatomic, copy, readonly) NSArray<NSString *> *tmsPaths;

+ (TMSNetwork *)shared;

/// 动态域名替换
/// @param url 域名，传nil则用tms默认域名（默认域名又细分三个环境）
- (void)setNetworkConfigWithUrl:(nullable NSString *)url;

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
           onFailed:(nullable void(^)(MBGNetworkError *error))onFailed;

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
            onFailed:(nullable void(^)(MBGNetworkError *error))onFailed;


/**
 处理请求特殊错误code:  310010（登录态失效，需要重新登录），600009（租户到期，需要重新登录）
 @param code 错误码
 @param errorMsg 错误信息
 */
+ (void)handleErrorWithCode:(NSInteger)code message:(NSString *)errorMsg;

@end

NS_ASSUME_NONNULL_END
