//
//  TMSWorkBannerModel.m
//  TMSBaseModule
//
//  Created by zht on 2021/5/9.
//

#import "TMSWorkBannerModel.h"

@implementation TMSWorkBannerModel

@end

@implementation TMSWorkFunctionModel

@end

@implementation TMSWorkExpiringRenewalModel

@end

@implementation TMSWorkDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
        @"bannerList" : @"TMSWorkBannerModel",
        @"functionList" : @"TMSWorkFunctionModel"
    };
}

@end

