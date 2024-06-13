//
//  MBAPMWakeupsExceptionCacheUtil.h
//  MBAPMLib
//
//  Created by zhaozhao on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "MBAPMWakeupsExceptionStateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsExceptionStateUtil : NSObject

+ (instancetype)sharedInstance;

- (void)updateExceptionState:(MBAPMWakeupsExceptionStateModel *)state forType:(MBAPMWakeupsExceptionType)type;

- (void)fireCleanTimerForType:(MBAPMWakeupsExceptionType)type;

- (void)checkLastStateAndReportExceptionCrash;

@end

NS_ASSUME_NONNULL_END
