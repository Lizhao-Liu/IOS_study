//
//  MBAPMWakeupsExceptionSectionModel.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsExceptionSectionModel : NSObject

@property (nonatomic, strong, nullable) NSDate *startTime;

@property (nonatomic, strong, nullable) NSDate *endTime;

@property (nonatomic, strong, readonly) NSArray *recordedWakeups;

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, assign) CGFloat averageWakeups;

- (void)addRecordedWakeups:(NSInteger) wakeups;

- (void)startRecording;

- (void)endRecording;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
