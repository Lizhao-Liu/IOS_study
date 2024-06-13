//
//  HCBLoginRequest.h
//  GasStationBiz
//
//  Created by ty on 2017/10/31.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCBError;

@interface HCBLoginRequest : NSObject
+(void)reqLogin:(NSString *)userName
            code:(NSString *)code
    withTimeOut:(NSTimeInterval)timeOut
onCompleteBlock:(void (^)(NSDictionary *))completeBlock
  onFailedBlock:(void (^)(HCBError *))failedBlock;

+(void)reqRelogin:(NSString *)userName
              pwd:(NSString *)pwd
      withTimeOut:(NSTimeInterval)timeOut
  onCompleteBlock:(void (^)(NSDictionary *))completeBlock
    onFailedBlock:(void (^)(HCBError *))failedBlock;

//获取账号信息
+(void)reqUserInfoWithCompleteBlock:(void (^)(NSDictionary *))completeBlock
                      onFailedBlock:(void (^)(HCBError *))failedBlock;


//更换绑定手机号
+(void)reqModifyMobileWithNewMobileNum:(NSString *)newMobile
                            verifyCode:(NSString *)verifyCode
                       onCompleteBlock:(void (^)(NSDictionary *))completeBlock
                         onFailedBlock:(void (^)(HCBError *))failedBlock;

//登出
+(void)reqLoginOutWithCompleteBlock:(void (^)(NSDictionary *))completeBlock
                      onFailedBlock:(void (^)(HCBError *))failedBlock;

//注册重登陆方法
+(void)setupReloginFunc:(NSString *)userName
                    pwd:(NSString *)pwd
            withTimeOut:(NSTimeInterval)timeOut
        onCompleteBlock:(void (^)(NSDictionary *))completeBlock
          onFailedBlock:(void (^)(HCBError *))failedBlock;
@end
