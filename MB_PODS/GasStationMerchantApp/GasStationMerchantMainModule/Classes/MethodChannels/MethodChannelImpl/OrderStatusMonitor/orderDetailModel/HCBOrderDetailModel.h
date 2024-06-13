//
//  HCBOrderDetailModel.h
//  GasStationBiz
//
//  Created by ty on 2017/11/3.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBBaseJSONModel.h"
#import "HCBPetrolAndBizPublicHeader.h"

@interface HCBOrderDetailModel : HCBBaseJSONModel

@property (nonatomic, strong) NSString *gasStationName;//油站名称
@property (nonatomic, strong) NSString *countDownMillis;
@property (nonatomic, strong) NSString *settleAmount;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *buyerMobile;
@property (nonatomic, strong) NSString *oilName;
@property (nonatomic, strong) NSString *goodsAmount;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *printCount;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *workerName;
@property (nonatomic, strong) NSString *businessCouponAmount;
@property (nonatomic, strong) NSString *paymentCouponAmount;
@property (nonatomic, strong) NSString *oilCode;
@property (nonatomic, strong) NSString *dutyId;
@property (nonatomic, strong) NSString *buyerName;
@property (nonatomic, strong) NSString *orderStatusName;
@property (nonatomic, strong) NSString *workerMobile;
@property (nonatomic, strong) NSString *refundingAmount;
@property (nonatomic, strong) NSString *oilOriginAmount;
@property (nonatomic, strong) NSString *discountRate;
@property (nonatomic, strong) NSString *buyerCouponAmount;
@property (nonatomic, strong) NSString *refundedAmount;
@property (nonatomic, strong) NSString *oilGunNo;
@property (nonatomic, strong) NSString *billNote;
@property (nonatomic, strong) NSString *payChannelText;
@property (nonatomic) HCBEnergyType energySourceType;
@property (nonatomic, strong) NSString *buyerPayAmount;//司机付款
@property (nonatomic, strong) NSString *hcbDiscount;//货车帮补贴
@property (nonatomic, assign) long     merchantCouponAmount; //优惠券

//企业支付新增
@property (nonatomic,assign) HCBPetrolPayChannel payChannel;//支付方式

@property (nonatomic, copy) NSString *salePrice; //零售价

@property (nonatomic, copy) NSString *costPrice; //采购价




@end
