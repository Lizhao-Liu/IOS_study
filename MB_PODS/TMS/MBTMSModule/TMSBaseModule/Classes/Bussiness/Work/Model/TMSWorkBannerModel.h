//
//  TMSWorkBannerModel.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/9.
//

#import "TMSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMSWorkBannerModel : TMSBaseModel

@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *picUrl;//
@property (nonatomic, copy) NSString *directUrl;//
@property (nonatomic, copy) NSString *orderIndex;//

@end

@interface TMSWorkFunctionModel : TMSBaseModel

@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *icon;//
@property (nonatomic, copy) NSString *protocol;//
@property (nonatomic, copy) NSString *orderIndex;//
@property (nonatomic, copy) NSString *toastMsg;// 拦截提示

@end


/// 即将到期数据模型
/// https://dev-apide.amh-group.com/#/interface?app=yzg-saas-permission-app&api=65234cd2f2b04a188bedf81d
@interface TMSWorkExpiringRenewalModel : TMSBaseModel

@property (nonatomic, assign) BOOL displayBtnFlag; //是否展示即将到期按钮
 
@property (nonatomic, assign) BOOL autoWindowFlag; //是否自动弹出续签弹窗

@property (nonatomic, copy) NSString *popupUrl; // 弹窗路由地址

@end

@interface TMSWorkDataModel : TMSBaseModel

@property (nonatomic, copy) NSArray<TMSWorkFunctionModel *> *functionList;//
@property (nonatomic, copy) NSArray<TMSWorkBannerModel *> *bannerList;//

@end

NS_ASSUME_NONNULL_END
