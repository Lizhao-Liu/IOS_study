//
//  GasStationWalletTokenRequest.h
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HCBError;

@interface GasStationWalletTokenRequest : NSObject

+(void)reqWalletTokenWithStationID:(NSString *)stationId
                 onCompleteBlock:(void (^)(NSString *token))completeBlock
                   onFailedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
