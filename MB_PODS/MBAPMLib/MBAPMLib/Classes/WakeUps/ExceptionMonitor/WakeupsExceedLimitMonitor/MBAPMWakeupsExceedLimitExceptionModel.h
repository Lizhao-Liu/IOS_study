//
//  MBAPMWakeupsExceedLimitExceptionModel.h
//  MBAPMLib
//
//  Created by zhao on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "MBAPMWakeupsExceptionSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsExceedLimitExceptionModel : NSObject

@property (nonatomic, assign) NSInteger wakeupsDurationSampled;
@property (nonatomic, assign) NSInteger wakeupsSampled;
@property (nonatomic, assign) CGFloat averageWakeups;
@property (nonatomic, strong, nullable) NSMutableArray<MBAPMWakeupsExceptionSectionModel *> *recordedSections; //当前监控周期内异常分段
@property (nonatomic, strong, nullable) MBAPMWakeupsExceptionSectionModel* sectionInRecording; //记录正在发生的异常分段


- (void)reset;
- (void)startSectionRecording;
- (void)endSectionRecording;
- (void)addSectionData:(NSInteger)data;

@end

NS_ASSUME_NONNULL_END
