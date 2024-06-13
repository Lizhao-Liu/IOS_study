//
//  MBAPMWakeupsExceptionSectionModel.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/3/14.
//

#import "MBAPMWakeupsExceptionSectionModel.h"

@interface MBAPMWakeupsExceptionSectionModel ()

@property (nonatomic, strong, readwrite) NSMutableArray *mutableRecordedWakeups;

@property (nonatomic, assign) NSInteger recordedWakeupsSum;

@end


@implementation MBAPMWakeupsExceptionSectionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"mutableRecordedWakeups": @"recordedWakeups"
    };
}

- (instancetype)init {
    self = [super init];
    if(self){
        _mutableRecordedWakeups = [NSMutableArray array];
        _recordedWakeupsSum = 0;
    }
    return self;
}

- (void)addRecordedWakeups:(NSInteger)wakeups {
    if(wakeups > 0) {
        [_mutableRecordedWakeups addObject:@(wakeups)];
        _recordedWakeupsSum = _recordedWakeupsSum + wakeups;
    }
}

- (void)endRecording {
    self.endTime = [NSDate date];
    self.isRecording = NO;
}

- (void)startRecording {
    self.startTime = [NSDate date];
    self.isRecording = YES;
}

- (NSArray *)recordedWakeups {
    return [self.mutableRecordedWakeups copy];
}

- (CGFloat)averageWakeups {
    CGFloat avg = self.recordedWakeupsSum / self.recordedWakeups.count;
    return avg;
}

- (void)reset {
    self.startTime = nil;
    self.endTime = nil;
    self.mutableRecordedWakeups = [NSMutableArray array];
    self.recordedWakeupsSum = 0;
}

@end
