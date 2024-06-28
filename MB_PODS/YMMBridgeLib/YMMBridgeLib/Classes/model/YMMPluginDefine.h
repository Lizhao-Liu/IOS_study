//
//  YMMPluginDefine.h
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/25.
//  Copyright © 2019 尹成. All rights reserved.
//

#ifndef YMMPluginDefine_h
#define YMMPluginDefine_h

/// 注册bridge协议版本枚举
typedef NS_OPTIONS(NSUInteger, MBBridgeRegisterProtocolOption) {
    MBBridgeRegisterProtocolOption_V1 = 1 << 0,// v1版本
    MBBridgeRegisterProtocolOption_V2 = 1 << 1,// v2版本
};

/// 调用bridge 版本枚举
typedef NS_ENUM(NSUInteger, MBPluginRequestProtocol) {
    MBPluginRequestProtocol_None = 0,// 不支持的协议版本
    MBPluginRequestProtocol_V1 = 1,  // v1
    MBPluginRequestProtocol_V2 = 2   // v2
};

/**
 方法路由执行结果
 
 - YMMPluginCode_Success: 处理成功
 - YMMPluginCode_NoSupport: 不支持的请求
 - YMMPluginCode_UnknownError: 未知错误
 - YMMPluginCode_ResultError: 处理函数返回类型错误
 - YMMPluginCode_CustomError: 自定义错误
 - YMMPluginCode_ParamsError: 处理函数参数错误
 - YMMPluginCode_NopermissionError: 访问者没有权限
 */
typedef NS_ENUM(NSUInteger, YMMPluginCode) {
    YMMPluginCode_Success = 0,
    YMMPluginCode_NoSupport = 1,
    YMMPluginCode_CustomError = 4,
    YMMPluginCode_ParamsError = 5,
    //2、3为内部保留code，外部不应使用
    YMMPluginCode_UnknownError = 2,
    YMMPluginCode_ResultError = 3,
    YMMPluginCode_NopermissionError = 11,
    YMMPluginCode_BizMethodError = 99, // 方法定义不合法, 方法实现存在问题
};

typedef NS_ENUM(NSInteger, MBBridgeLibCode) {
    MBBridgeLibCode_Success = 0,              /// 成功
    MBBridgeLibCode_NoSupport = -10,           /// 不支持的调用
    MBBridgeLibCode_NopermissionError = -11,  /// 访问者没有权限
    MBBridgeLibCode_NoProtocolError = -12,    /// 不支持的协议版本
    MBBridgeLibCode_BizMethodError = -30,    /// 方法定义不合法, 方法实现存在问题
    MBBridgeLibCode_InternalError = -50,      /// 框架内部错误
};

//error define
static NSString * const kYMMPluginError_ModuleNoFound = @"不支持的请求(无对应实现类)";
static NSString * const kYMMPluginError_ModuleLoadFail = @"不支持的请求(对象初始化失败)";
static NSString * const kYMMPluginError_ProtocolNoFound = @"不支持的请求(协议未遵守)";
static NSString * const kYMMPluginError_ProtocolMethodNoFound = @"不支持的请求(协议方法未实现)";
static NSString * const kYMMPluginError_ParamsError = @"参数错误";
static NSString * const kYMMPluginError_CustomError = @"失败";
static NSString * const kYMMPluginError_NotFindMethodError = @"无对应方法实现";
static NSString * const kYMMPluginError_Nopermission = @"访问者无权限";
static NSString * const kYMMPluginError_NoProtocol = @"不支持的协议版本";
static NSString * const kYMMPluginError_InternalError = @"bridge框架内部错误";
//success define
static NSString * const kYMMPluginSuccess = @"成功";

typedef NS_ENUM(NSUInteger, MBBridgeAccessLevel) {
    MBBridgeAccessLevelWarning = 0,         // 以 Toast 形式提示警告
    MBBridgeAccessLevelError = 1            // 直接返回“无权限”错误码
};

#endif /* YMMPluginDefine_h */
