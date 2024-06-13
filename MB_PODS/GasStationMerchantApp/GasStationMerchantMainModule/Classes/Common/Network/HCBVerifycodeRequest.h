//
//  HCBVerifycodeRequest.h
//  GasStationBiz
//
//  Created by ty on 2017/11/20.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCBError;

@interface HCBVerifycodeRequest : NSObject

//登录验证码
+ (void)reqLoginVerifyCodeWithMobileNum:(NSString *)mobileNum
                        onCompleteBlock:(void (^)(BOOL result))completeBlock
                          onFailedBlock:(void (^)(HCBError *error))failedBlock;
//更换绑定手机号验证码
+ (void)reqModifyMobileBindingVerifyCodeWithMobileNum:(NSString *)stationId
                                      onCompleteBlock:(void (^)(NSDictionary *dic))completeBlock
                                        onFailedBlock:(void (^)(HCBError *error))failedBlock;
@end
