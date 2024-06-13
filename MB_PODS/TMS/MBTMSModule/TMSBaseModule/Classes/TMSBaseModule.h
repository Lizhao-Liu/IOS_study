//
//  TMSBaseModule.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import <WechatOpenSDK/WXApi.h>
@import MBWechatOpenSDK;
@import YMMModuleLib;

NS_ASSUME_NONNULL_BEGIN

@interface TMSBaseModule : NSObject<YMMModuleProtocol, WXApiDelegate>

@end

NS_ASSUME_NONNULL_END
