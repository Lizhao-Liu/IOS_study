//
//  MBAPMTrafficMetric.h
//  MBAPMLib
//
//  Created by FDW on 2024/2/26.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN
// https://wiki.amh-group.com/pages/viewpage.action?pageId=789367360
@interface MBAPMTrafficMetric : MBAPMMetric

@property (nonatomic, strong) NSDictionary *tags;

@property (nonatomic, strong) NSDictionary *sections;

@property (nonatomic, strong) NSDictionary *atts;

@end

NS_ASSUME_NONNULL_END
