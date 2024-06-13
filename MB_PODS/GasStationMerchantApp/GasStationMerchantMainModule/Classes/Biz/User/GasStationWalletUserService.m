//
//  GasStationWalletUserService.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/15.
//

#import "GasStationWalletUserService.h"
#import "HCBUserManager.h"
#import "HCBStationManager.h"
#import "GasStationWalletTokenRequest.h"
@import YMMModuleLib;
@import MBWalletModuleService;
@import MBFoundation;
@import HCBNetwork;


@interface GasStationWalletUserService() <MBWalletAccessServiceProtocol>

@end


@serviceEX(GasStationWalletUserService, MBWalletAccessServiceProtocol)

@synthesize userId;
@synthesize loginSuccess;

- (NSString *)userId {
     return [HCBStationManager shareManager].stationModel.walletUid;
    
}


- (BOOL)loginSuccess {
    return [HCBUserManager shareManager].currentUser.isLogined;
}

/// 异步获取HCB钱包组件最新token
/// @param completion HCB钱包组件token
- (void)asyncGetHCBWalletTokenWithCompletion:(nullable void(^)(NSError * _Nullable error, id _Nullable walletToken))completion {
     NSString *gasStationId = [HCBStationManager shareManager].stationModel.gasStationId;
    [GasStationWalletTokenRequest reqWalletTokenWithStationID:gasStationId
                                              onCompleteBlock:^(NSString * _Nonnull hcbWalletToken) {
        if(completion){
            //在主线程回调 completion
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, hcbWalletToken);
            });
        }
    }
                                                onFailedBlock:^(NSError * _Nonnull error) {
        // 请求失败，将失败原因封装成 error ，token 为 nil
        if(completion){
            //在主线程回调 completion
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error, nil);
            });
        }
    }];
}

@end
