//
//  GasStationWalletTokenRequest.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/13.
//

#import "GasStationWalletTokenRequest.h"
#import "HCBAPIs.h"
#import "HCBUserManager.h"
@import HCBNetwork;
@import MBProjectConfig;
@import MBFoundation;

// HCB 钱包token
static NSString * const kGasStationUserGetHCBWalletTokenKey = @"token";
static NSString * const kGasStationUserGetHCBWalletUidKey = @"walletUid";

static NSString * const kGasStationUserGetHCBWalletErrorDomain = @"gas_station_merchant_wallet_token_error";

@implementation GasStationWalletTokenRequest

+(void)reqWalletTokenWithStationID:(NSString *)stationId
                 onCompleteBlock:(void (^)(NSString *token))completeBlock
                     onFailedBlock:(void (^)(NSError *error))failedBlock {
    [self reqWalletInfoWithStationID:stationId onCompleteBlock:^(NSDictionary *dic) {
        NSString *hcbWalletToken = dic[kGasStationUserGetHCBWalletTokenKey];
        if(hcbWalletToken && [hcbWalletToken isKindOfClass:[NSString class]]){
            if (completeBlock) {
                completeBlock(hcbWalletToken);
            }
        } else {
            NSError *error = [NSError errorWithDomain:kGasStationUserGetHCBWalletErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"返回wallet token 数据类型错误"}];
            if (failedBlock) {
                failedBlock(error);
            }
        }
    } onFailedBlock:^(HCBError *error) {
        NSError *walletTokenReqFailedError = [NSError errorWithDomain:kGasStationUserGetHCBWalletErrorDomain code:[error.errorCode integerValue] userInfo:@{NSLocalizedDescriptionKey: error.errorMsg}];
        if (failedBlock) {
            failedBlock(walletTokenReqFailedError);
        }
    }];
}

+(void)reqWalletInfoWithStationID:(NSString *)stationId
                  onCompleteBlock:(void (^)(NSDictionary *dic))completeBlock
                    onFailedBlock:(void (^)(HCBError *error))failedBlock {
    HCBRequest *request = [HCBRequest new];
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"MERCHANT");
    [request setApi:req_wallet_token];
    [request setPostValue:stationId forKey:@"gasStationId"];
    [request setPostValue:[MBAppDelegate appInfo].privacyDeviceUUID forKey:@"deviceId"];
    [request setPostValue:@"iOS" forKey:@"deviceType"];
    if([HCBUserManager shareManager].currentUser.ID){
     
        [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
    }
    
    [request setCompletionBlock:^(id content) {
        if (completeBlock) {
            completeBlock(content);
        }
    }];
    
    [request setFailedBlock:^(HCBError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    [request startAsynchronous];
}

@end
