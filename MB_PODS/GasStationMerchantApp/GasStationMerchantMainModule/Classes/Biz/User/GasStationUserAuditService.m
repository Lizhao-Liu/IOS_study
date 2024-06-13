//
//  GasStationUserAuditService.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/13.
//

#import "GasStationUserAuditService.h"
@import YMMAuditService;
@import YMMModuleLib;

@interface GasStationUserAuditService () <YMMUserAuditServiceAPIProtocol>
@end

@serviceEX(GasStationUserAuditService, YMMUserAuditServiceAPIProtocol)

@synthesize authStatusModel;

// 1294期: 能源商户app迁移至新宿主，此处加上YMMUserAuditServiceAPIProtocol service实现以避免编译报错
- (YMMUserAuthStatusModel *)authStatusModel {
    return [YMMUserAuthStatusModel new];
}
@end


