//
//  TMSUserModuleDefine.h
//  TMSUserModule
//
//  Created by lzz on 2021/6/23.
//  Copyright © 2021年 lzz. All rights reserved.
//

#ifndef TMSUserModuleDefine_h
#define TMSUserModuleDefine_h

#pragma mark - Macros


#ifndef YMMUserModule_dispatch_main_async_safe
#define YMMUserModule_dispatch_main_async_safe(block)                                                                               \
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {     \
block();                                                                                                                            \
} else {                                                                                                                            \
dispatch_async(dispatch_get_main_queue(), block);                                                                                   \
}
#endif

#pragma mark - Color
// 主题色

#pragma mark - Block



#pragma mark - NSNotification



#pragma mark - Foundation基本数据类型常量



#pragma mark - Schema

// TMS《服务协议》
static NSString * const kYMMUserModuleSchemaUserServiceProtocol = @"https://static.ymm56.com/microweb/#/mw-user-info/protocolView/index?id=140&contentId=487";

// TMS《隐私协议》
static NSString * const kYMMUserModuleSchemaPrivatePolicy = @"https://static.ymm56.com/microweb/#/mw-user-info/protocolView/index?id=141&contentId=484";

// TMS《用户授权协议》
static NSString * const kYMMUserModuleSchemaPrivateAuth = @"https://static.ymm56.com/microweb/#/mw-user-info/protocolView/index?id=148&contentId=548";

// 新用户预约展示
static NSString * const kYMMUserModuleSchemaApplyViewDemo = @"https://static.ymm56.com/microweb/vue.html#/mw-tview/index?key=066998a749";

#pragma mark - 客户端本地字符串常量

static NSString * const kYMMUserModuleLoginAcceptUserProtocolContent = @"我已经阅读并同意《服务协议》《隐私政策》《用户授权协议》";
static NSString * const kYMMUserModuleLoginAcceptUserProtocolUserService = @"《服务协议》";
static NSString * const kYMMUserModuleLoginAcceptUserProtocolPrivacy = @"《隐私政策》";
static NSString * const kYMMUserModuleLoginAcceptUserProtocolAuth = @"《用户授权协议》";


#endif /* TMSUserModuleDefine_h */
