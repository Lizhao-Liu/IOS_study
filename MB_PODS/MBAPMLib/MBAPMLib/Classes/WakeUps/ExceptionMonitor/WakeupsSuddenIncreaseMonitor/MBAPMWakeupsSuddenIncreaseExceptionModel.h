//
//  MBAPMWakeupsSuddenIncreaseExceptionModel.h
//  MBAPMLib
//
//  Created by zhaozhao on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "MBAPMDoctorEventModel.h"
#import "MBAPMWakeupsExceptionSectionModel.h"
@import MBDoctorService;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsSuddenIncreaseExceptionModel : MBAPMWakeupsExceptionSectionModel

@property (nonatomic, strong) MBAPMDoctorEventModel *actionModel;

@end

NS_ASSUME_NONNULL_END
