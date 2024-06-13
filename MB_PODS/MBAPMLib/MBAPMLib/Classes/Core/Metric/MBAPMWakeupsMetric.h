//
//  MBAPMWakeupsMetric.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsMetric : MBAPMMetric

@property (nonatomic, strong) NSDictionary *tags;

@property (nonatomic, strong) NSDictionary *attrs;

@end

NS_ASSUME_NONNULL_END
