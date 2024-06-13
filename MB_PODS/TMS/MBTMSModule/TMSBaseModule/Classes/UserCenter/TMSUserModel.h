//
//  TMSUserModel.h
//  TMSBaseModule
//
//  Created by zht on 2021/4/27.
//

#import "TMSBaseModel.h"
#import "TMSMineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMSRoleModel : TMSBaseModel

@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *roleName;//角色名称

@end

@interface TMSUserModel : TMSBaseModel

@property (nonatomic, copy) NSString *token;//token
@property (nonatomic, copy) NSString *name;//姓名
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *avatar;//头像地址
// @property (nonatomic, copy) NSString *roleName;//角色名称 1.0.2之后废弃使用roles
@property (nonatomic, copy) NSArray <TMSRoleModel *> *roles;//多角色
@property (nonatomic, copy) NSString *mobile;//手机号码(脱敏)
@property (nonatomic, copy) NSString *companyName;//公司名称
@property (nonatomic, copy) NSString *companyLogo;//公司logo图片地址
@property (nonatomic, copy) NSString *frontEndpoint;//前端域名
@property (nonatomic, copy) NSString *backEndpoint;//后端域名
@property (nonatomic, copy) NSString *serviceHotline;//公司客服热线

//自定义字段、非接口返回
@property (nonatomic, copy) NSString *nakedMobile;//手机号码
@property (nonatomic, copy) NSArray <TMSMineModel *> *dataList;//设置分区


@end

@interface TMSDeviceModel : TMSBaseModel

@property (nonatomic, copy, readonly) NSString *appversion;
@property (nonatomic, copy, readonly) NSString *appuuid;

@end

NS_ASSUME_NONNULL_END
