//
//  MBAPMDataReport.h
//  MBAPMLib
//
//  Created by xp on 2020/7/15.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
#import "MBAPMDataExportManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDataReport : NSObject <MBAPMDataExportProtocol>

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithContext:(MBAPMContext *)context;

@end

NS_ASSUME_NONNULL_END
