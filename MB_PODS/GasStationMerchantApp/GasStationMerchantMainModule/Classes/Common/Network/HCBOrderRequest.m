//
//  HCBOrderRequest.m
//  GasStationBiz
//
//  Created by ty on 2017/11/3.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBOrderRequest.h"
#import "HCBAPIs.h"
#import "HCBUserManager.h"
@import HCBNetwork;

@implementation HCBOrderRequest

+ (void)reqOrderDetailWithOrderNo:(NSString *)orderNo
                  onCompleteBlock:(void (^)(NSDictionary *dic))completeBlock
                    onFailedBlock:(void (^)(HCBError *error))failedBlock {
    
    HCBRequest *request = [HCBRequest new];
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"jyz");
    [request setApi:req_gasstation_orderdetail];
    [request setPostValue:orderNo forKey:@"orderNo"];
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
