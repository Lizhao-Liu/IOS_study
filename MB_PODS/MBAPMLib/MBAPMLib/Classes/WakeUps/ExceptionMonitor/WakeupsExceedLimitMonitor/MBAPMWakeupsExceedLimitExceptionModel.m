//
//  MBAPMWakeupsExceedLimitExceptionModel.m
//  MBAPMLib
//
//  Created by zhao on 2024/3/13.
//

#import "MBAPMWakeupsExceedLimitExceptionModel.h"
@import YYModel;

@implementation MBAPMWakeupsExceedLimitExceptionModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        _wakeupsSampled = 0;
        _wakeupsDurationSampled = 0;
        _averageWakeups = 0;
    }
    return self;
}
- (void)startSectionRecording {
    MBAPMWakeupsExceptionSectionModel *section = [MBAPMWakeupsExceptionSectionModel new];
    [section startRecording];
    self.sectionInRecording = section;
    [self.recordedSections addObject:self.sectionInRecording];
}

- (void)endSectionRecording {
    [self.sectionInRecording endRecording];
    self.sectionInRecording = nil;
}

- (void)addSectionData:(NSInteger)data {
    [self.sectionInRecording addRecordedWakeups:data];
}

- (void)reset {
    self.wakeupsSampled = 0;
    self.wakeupsDurationSampled = 0;
    self.averageWakeups = 0;
    self.recordedSections = nil;
    self.sectionInRecording = nil;
}

- (NSMutableArray<MBAPMWakeupsExceptionSectionModel *> *)recordedSections {
    if(!_recordedSections){
        _recordedSections = [NSMutableArray array];
    }
    return _recordedSections;
}


@end
