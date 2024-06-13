//
//  TMSUserManager.m
//  TMSBaseModule
//
//  Created by zht on 2021/4/27.
//

#import "TMSUserManager.h"
#import "TMSCommonMacros.h"
#import "TMSNetwork.h"
#import "MBTMSModule-Swift.h"
@import MBStorageLibService;
@import YMMModuleLib;
@import MBNetworkLib;
@import YMMUserModuleService;

@implementation TMSUserManager
@synthesize userInfo = _userInfo;

DEFINE_SINGLETON_FOR_CLASS(TMSUserManager)

- (instancetype)init {
    if (self = [super init]) {
        [self addNotificationObservers];
        _userInfo = [self getUserModelFromStorage];
        _deviceInfo = TMSDeviceModel.new;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 更新userInfo的唯一方法

/// 更新用户信息
/// @param userModel 用户model
/// @param coverall 是否覆盖整个userInfo，部分接口只返回了用户的局部信息，以及TMSUserModel中存在自定义字段
- (void)updateUserInfoWithModel:(TMSUserModel *)userModel cover:(BOOL)coverall{
    
    if (coverall) {
        self.userInfo = userModel;
        return;
    }
    
    
    if (![NSString mb_isNilOrEmpty:userModel.token]) {
        _userInfo.token = userModel.token;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.name]) {
        _userInfo.name = userModel.name;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.userId]) {
        _userInfo.userId = userModel.userId;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.avatar]) {
        _userInfo.avatar = userModel.avatar;
    }
    
    // 为空[] 也要更新数据
    _userInfo.roles = userModel.roles;
    _userInfo.dataList = userModel.dataList;
    
    if (![NSString mb_isNilOrEmpty:userModel.mobile]) {
        _userInfo.mobile = userModel.mobile;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.companyName]) {
        _userInfo.companyName = userModel.companyName;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.companyLogo]) {
        _userInfo.companyLogo = userModel.companyLogo;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.frontEndpoint]) {
        _userInfo.frontEndpoint = userModel.frontEndpoint;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.backEndpoint]) {
        _userInfo.backEndpoint = userModel.backEndpoint;
    }
    
    if (![NSString mb_isNilOrEmpty:userModel.serviceHotline]) {
        _userInfo.serviceHotline = userModel.serviceHotline;
    }

    self.userInfo = _userInfo;
}

#pragma mark - 通知

- (void)addNotificationObservers {
    
    /// 监听App进程结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAppWillTerminalWithNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    /// 监听网络库发出401错误码或者用户手动退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLogoutWithNotification:)
                                                 name:TMSKEY_NOTI_USERLOGOUT_WILL
                                               object:nil];
}

- (void)didReceiveAppWillTerminalWithNotification:(NSNotification *)notification {
    //Nothing,先预留能力
}

- (void)didReceiveLogoutWithNotification:(NSNotification *)notification {
    
    NSDictionary *obj = notification.object;
    
    //手动退出时候需要额外调用logout接口使登录态失效，其他场景不会调用此接口
    if (obj&&[obj isKindOfClass:NSDictionary.class]&&[obj[@"needlogout"] boolValue]) {
        [TMSNetwork postWithPath:@"/yzg-saas-permission-app/yzgApp/user/logout" params:nil expectClass:nil onSuccess:^(id  _Nullable result) {
            [self clearUserInfoAndPostRealLogout];
        } onFailed:^(MBGNetworkError * _Nonnull error) {
            [self clearUserInfoAndPostRealLogout];
        }];
    }
    else{
        [self clearUserInfoAndPostRealLogout];
    }
}

- (void)clearUserInfoAndPostRealLogout{
    
    self.userInfo = nil;
    /// 退出登录通知（最终业务方都要逐个替换成监听此通知）
    [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLogoutNotification object:nil];
}

- (void)postLoginSuccesseedNotificationWithIsManualLogin:(BOOL)isManualLogin{
    NSDictionary *userInfo = @{MBUserLoginNotification_Key_IsManual: @(isManualLogin)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLoginNotification
                                                        object:nil
                                                      userInfo:userInfo];
    
    //TODO: check - RN专用的登录成功通知 新增，之前tms没有这个逻辑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rn-event-emitted" object:@{@"name" : MBUserLoginNotification}];
}

- (BOOL)currentNavStackHasLoginVC {
    UIViewController *vc = [UIViewController mb_currentViewController];
    for (UIViewController *obj in vc.navigationController.viewControllers) {
        if ([[self loginRelatedClasses] containsObject:obj.class]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)loginRelatedClasses {
    return @[[TMSNewLoginVC class]];
}

- (Class)getLoginFirstViewControllerClass {
    return [TMSNewLoginVC class];
}

#pragma mark - 从缓存中存取用户信息

/// 设置TMSUserManager的userInfo，顺便存储
/// @param userInfo 用户模型
- (void)setUserInfo:(TMSUserModel * _Nullable)userInfo{
    
    if (!userInfo || ![userInfo isKindOfClass:TMSUserModel.class]) {
        _userInfo = [TMSUserModel new];
    } else{
        _userInfo = userInfo;
        [TMSNetwork.shared setNetworkConfigWithUrl:userInfo.backEndpoint];
    }
    
    [self setUserModelToStorage:userInfo];
}

- (TMSUserModel *)getUserModelFromStorage{
    
    id<MBStorageProtocol> service = BIND_SERVICE(nil, MBStorageProtocol);
    NSString *userInfoStr = [service getForKey:TMSKEY_STORAGE_USERINFO group:TMSKEY_STORAGE_USERINFO_GROUP];
    return [TMSUserModel yy_modelWithJSON:userInfoStr]?:TMSUserModel.new;
}

- (BOOL)setUserModelToStorage:(TMSUserModel *)userModel{
    
    id<MBStorageProtocol> service = BIND_SERVICE(nil, MBStorageProtocol);
    
    BOOL result = NO;
    
    if (!userModel || ![userModel isKindOfClass:TMSUserModel.class]) {
        result = [service removeForKey:TMSKEY_STORAGE_USERINFO group:TMSKEY_STORAGE_USERINFO_GROUP];
    }
    else{
        result = [service setValue:userModel.yy_modelToJSONString forKey:TMSKEY_STORAGE_USERINFO group:TMSKEY_STORAGE_USERINFO_GROUP];
    }
    
    return result;
}

#pragma mark - 其他

- (BOOL)isLogin{
    
    if (!self.userInfo || [NSString mb_isNilOrEmpty:self.userInfo.token] || [NSString mb_isNilOrEmpty:self.userInfo.userId]) {
        return NO;
    }
    
    return YES;
}

@end
