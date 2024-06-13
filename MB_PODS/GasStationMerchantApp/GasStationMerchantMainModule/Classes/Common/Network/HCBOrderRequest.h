//
//  HCBOrderRequest.h
//  GasStationBiz
//
//  Created by ty on 2017/11/3.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCBError;

@interface HCBOrderRequest : NSObject

//订单详情
+(void)reqOrderDetailWithOrderNo:(NSString *)orderNo
                 onCompleteBlock:(void (^)(NSDictionary *dic))completeBlock
                   onFailedBlock:(void (^)(HCBError *error))failedBlock;


@end
