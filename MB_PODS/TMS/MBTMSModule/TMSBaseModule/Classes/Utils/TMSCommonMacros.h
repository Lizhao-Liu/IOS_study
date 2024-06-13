//
//  TMSCommonMacros.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/8.
//

#ifndef TMSCommonMacros_h
#define TMSCommonMacros_h

@import MBLogLib;

#define TMSGetBundle(bundlename) (bundlename.length > 0 ? ([NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundlename ofType:@"bundle"]] ?: [NSBundle mainBundle]) : [NSBundle mainBundle])
#define TMSBundleImage(bundlename,imagename) [UIImage imageNamed:imagename] ?: [UIImage imageNamed:imagename inBundle:TMSGetBundle(bundlename) compatibleWithTraitCollection:nil]
#define TMSLineHeight (1.0f / [UIScreen mainScreen].scale)

#define TMSRelative(a) (roundf((a) * (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) / 750.0f) * [UIScreen mainScreen].scale) / [UIScreen mainScreen].scale)

#ifndef TMSBaseModule_dispatch_main_async_safe
#define TMSBaseModule_dispatch_main_async_safe(block)                                                                               \
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {     \
block();                                                                                                                            \
} else {                                                                                                                            \
dispatch_async(dispatch_get_main_queue(), block);                                                                                   \
}
#endif


/**
 * TMSBaseModule库日志宏
 */
#define TMSBaseModuleLog_Debug(...)                    MBModuleDebug("TMSBaseModule", __VA_ARGS__)
#define TMSBaseModuleLog_Info(...)                     MBModuleInfo("TMSBaseModule", __VA_ARGS__)
#define TMSBaseModuleLog_Warning(...)                  MBModuleWarning("TMSBaseModule", __VA_ARGS__)
#define TMSBaseModuleLog_Error(...)                    MBModuleError("TMSBaseModule", __VA_ARGS__)
#define TMSBaseModuleLog_Fatal(...)                    MBModuleFatal("TMSBaseModule", __VA_ARGS__)


static NSString * const TMSMSG_IKNOW = @"我知道了";//通用的报错提示
static NSString * const TMSMSG_TIPTITLE = @"提示";//通用的报错提示

static NSString * const TMSKEY_STORAGE_USERINFO = @"key_userProfile";//缓存用户信息的key
static NSString * const TMSKEY_STORAGE_USERINFO_GROUP = @"group_storage_document_user";//缓存用户信息的key的分组

static NSString * const TMSKEY_NOTI_USERLOGOUT_WILL = @"NotificationDidLogout";//用户即将退出，此通知发出，还未清空用户数据
static NSString * const TMSKEY_NOTI_USERLOGOUT_DID = @"MBUserLogoutNotification";//用户已经退出，此通知发出，用户数据已清空
static NSString * const TMSKEY_NOTI_USERLOGIN = @"MBUserLoginNotification";//App用户登录成功通知
static NSString * const TMSKEY_NOTI_ENTERMAINPAGE = @"TMSAppDidLoadMainPageNotification";//用户进入主页
static NSString * const TMSKEY_NOTI_TAB_SELECTED_CHANGED = @"TMSTabSelectedChangedNotification";//Tab切换通知


#endif /* TMSCommonMacros_h */
