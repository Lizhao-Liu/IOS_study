//
//  GasStationUserService.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/12.
//

#import "GasStationUserService.h"
@import YMMModuleLib;
@import YMMUserModuleService;
#import "HCBUserManager.h"
#import "HCBStationManager.h"
#import "GasStationWalletTokenRequest.h"
@import HCBNetwork;


@interface GasStationUserService() <YMMUserServiceProtocol>

@end


@serviceEX(GasStationUserService, YMMUserServiceProtocol)
@synthesize userId;
@synthesize loginSuccess;
@synthesize isNewRegisterUser;
@synthesize profileInfo;
@synthesize locationSMSViewController;
@synthesize userInfo;


- (NSString *)userId {
    return [HCBStationManager shareManager].stationModel.userId;
}


- (BOOL)loginSuccess {
    return [HCBUserManager shareManager].currentUser.isLogined;
}

// 1294期: 能源商户app迁移至新宿主，此处加上此方法实现以避免编译报错
/// 判断当前用户是否已登录（替换原 [[YMMDataCenter sharedYMMDataCenter] isLogin]）
/// 不推荐使用此方法判断登录态！
- (BOOL)isLogin {
    return [HCBUserManager shareManager].currentUser.isLogined;
}

// 1294期: 能源商户app迁移至新宿主，此处加上此方法实现以避免编译报错
///满帮金融App 登录用户相关信息
- (MBFinancialUserClientInfo *)mbFinancialUserClientInfo {
    return [MBFinancialUserClientInfo new];
}


@end
