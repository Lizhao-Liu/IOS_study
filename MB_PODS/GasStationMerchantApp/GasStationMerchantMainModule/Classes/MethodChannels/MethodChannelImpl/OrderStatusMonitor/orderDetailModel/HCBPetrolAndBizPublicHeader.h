//
//  HCBPetrolAndBizPublicHeader.h
//  Pods
//
//  Created by Yongyou on 25/04/2018.
//

#ifndef HCBPetrolAndBizPublicHeader_h
#define HCBPetrolAndBizPublicHeader_h

typedef  NS_ENUM(NSInteger, HCBPetrolPayChannel) {
    HCBPetrolPayChannel_Person = 1,//个人支付
    HCBPetrolPayChannel_OilCard = 2,//加油物资单
    HCBPetrolPayChannel_Enterprise = 3,//企业支付
    HCBPetrolPayChannel_Other = 99//其它
};

typedef NS_ENUM(NSInteger, HCBPetrolEnergySourceType) {
    
    HCBPetrolEnergySourceType_Oil = 1,//油品
    HCBPetrolEnergySourceType_Lng = 2//LNG
};

typedef NS_ENUM(NSInteger, HCBEnergyType) {
    
    oil_HCBEnergyType = 1,//油
    lng_HCBEnergyType = 2//LNG
};


#endif /* HCBPetrolAndBizPublicHeader_h */
