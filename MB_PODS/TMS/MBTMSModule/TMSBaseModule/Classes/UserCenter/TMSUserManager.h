//
//  TMSUserManager.h
//  TMSBaseModule
//
//  Created by zht on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import "TMSUserModel.h"
@import MBFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface TMSUserManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(TMSUserManager)

@property (nonatomic, strong, readonly) TMSUserModel * _Nullable userInfo;
@property (nonatomic, strong, readonly) TMSDeviceModel * _Nullable deviceInfo;

/// 当前VC栈内是否包含登录流程VC
@property (nonatomic, assign, readonly) BOOL currentNavStackHasLoginVC;

- (BOOL)isLogin;

/// 更新用户信息
/// @param userModel 用户model
/// @param coverall 是否覆盖整个userInfo，部分接口只返回了用户的局部信息，以及TMSUserModel中存在自定义字段
- (void)updateUserInfoWithModel:(TMSUserModel *)userModel cover:(BOOL)coverall;

- (void)postLoginSuccesseedNotificationWithIsManualLogin:(BOOL)isManualLogin;

- (NSArray *)loginRelatedClasses;

- (Class)getLoginFirstViewControllerClass;

@end

NS_ASSUME_NONNULL_END
