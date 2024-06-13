//
//  MBAPMCPUMetric.h
//  MBAPMLib
//
//  Created by FDW on 2022/5/31.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MBAPMCPUType) {
    MBAPMCPUTypeNormal,     // 正常
    MBAPMCPUTypeException   // 异常
};
// 详细数据见: https://wiki.amh-group.com/pages/viewpage.action?pageId=399105484
@interface MBAPMCPUMetric : MBAPMMetric
@property (nonatomic, assign) MBAPMCPUType launchType;

@property (nonatomic, strong) NSDictionary *tags;

@property (nonatomic, strong) NSDictionary *sections;

@property (nonatomic, strong) NSDictionary *atts;
@end

NS_ASSUME_NONNULL_END
