//
//  MBAPMErrorMetric.h
//  MBLocationLib
//
//  Created by FDW on 2022/9/6.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMErrorMetric : MBAPMMetric

@property (nonatomic, copy) NSString *feature;

@property (nonatomic, copy) NSString *errorDetail;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *stack;

@property (nonatomic, copy, nullable) NSDictionary *attrs;

@end

NS_ASSUME_NONNULL_END
