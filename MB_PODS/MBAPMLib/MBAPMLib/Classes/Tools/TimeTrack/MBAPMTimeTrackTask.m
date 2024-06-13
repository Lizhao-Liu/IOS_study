//
//  MBAPMTimeTrackTask.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/8.
//

#import "MBAPMTimeTrackTask.h"
#import <pthread/pthread.h>
#import "MBAPMTimeUtil.h"
#import "MBAPMLogDef.h"


@interface MBAPMTimeTrackTask()

@property (nonatomic, strong) MBAPMTimeTrackModel *trackModel;
@property (nonatomic, assign) UInt64 threadID;
@property (nonatomic, copy) TimeTrackTotalBlock totalTimeBlock;
@property (nonatomic, copy) TimeTrackRangeBlock rangeTimeBlock;
@property (nonatomic, copy) TimeTrackDividedBlock dividedTimeBlock;
@property (nonatomic, assign) NSRange timePointRange;
@property (nonatomic, assign) MBAPMTimeTrackTaskStatus taskStatus;

@end

@implementation MBAPMTimeTrackTask

@synthesize extraData;

- (instancetype)init {
    if(self = [super init]) {
        _taskStatus = MBAPMTimeTrackTaskStatusInit;
    }
    return self;
}


#pragma mark - public methodx
- (BOOL)begin {
    if(self.taskStatus == MBAPMTimeTrackTaskStatusStarted) {
        return NO;
    }
    self.taskStatus = MBAPMTimeTrackTaskStatusStarted;
    self.threadID = [self getCurrentThreadID];
    self.trackModel.beginTime = [MBAPMTimeUtil currentTimestamp];
    MBAPMTimeTrackPoint *point = [MBAPMTimeTrackPoint new];
    point.pointTime = [MBAPMTimeUtil currentTimestamp];
    point.pointTag = kMBAPM_TIMETRACK_POINTTAG_BEGIN;
    [self.trackModel.pointDict MBAPMSort_setObject:point forKey:point.pointTag];
    return YES;
}

- (BOOL)markPoint:(NSString *)pointTag {
    if(![self checkSameThread]) {
        MBAPMWarning(@"markPoint can't be called in different thread");
    }
    if(!pointTag) {
        MBAPMWarning(@"pointTag can't be nil in markPoint function");
    }
    if(self.taskStatus != MBAPMTimeTrackTaskStatusStarted) {
        return NO;
    }
    MBAPMTimeTrackPoint *point = [MBAPMTimeTrackPoint new];
    point.pointTime = [MBAPMTimeUtil currentTimestamp];
    point.pointTag = pointTag;
    [self.trackModel.pointDict MBAPMSort_setObject:point forKey:pointTag];
    return YES;
}

- (BOOL)abort {
    return NO;
}

- (BOOL)end {
    return [self end:kMBAPM_TIMETRACK_POINTTAG_END];
}

- (BOOL)end:(NSString *)endTag {
    if(![self checkSameThread]) {
        MBAPMWarning(@"end can't be called in different thread");
    }
    if(self.taskStatus != MBAPMTimeTrackTaskStatusStarted) {
        return NO;
    }
    self.taskStatus = MBAPMTimeTrackTaskStatusStopped;
    self.trackModel.endTime = [MBAPMTimeUtil currentTimestamp];
    MBAPMTimeTrackPoint *point = [MBAPMTimeTrackPoint new];
    point.pointTime = [MBAPMTimeUtil currentTimestamp];
    point.pointTag = kMBAPM_TIMETRACK_POINTTAG_END;
    [self.trackModel.pointDict MBAPMSort_setObject:point forKey:endTag];
    if(self.totalTimeBlock) {
        self.totalTimeBlock([self.trackModel getTotalTime]);
    }
    if(self.rangeTimeBlock) {
        self.rangeTimeBlock([self.trackModel getTotalTime], [self.trackModel getTimeBetweenPoints:self.timePointRange]);
    }
    if(self.dividedTimeBlock) {
        self.dividedTimeBlock([self.trackModel getTotalTime],[self.trackModel getTimeDividedByPoints]);
    }
    _trackModel = nil;
    return YES;
}

- (void)caculateTotal:(TimeTrackTotalBlock)result {
    if(![self checkSameThread]) {
        MBAPMWarning(@"caculateTotal can't be called in different thread");
    }
    self.totalTimeBlock = result;
}

- (void)caculateWithRange:(NSRange)range withResultBlock:(TimeTrackRangeBlock)result {
    if(![self checkSameThread]) {
        MBAPMWarning(@"caculateWithRange can't be called in different thread");
    }
    self.timePointRange = range;
    self.rangeTimeBlock = result;
}

- (void)caculateDividedByPoints:(TimeTrackDividedBlock)result {
    if(![self checkSameThread]) {
        MBAPMWarning(@"caculateWithTags can't be called in different thread");
    }
    self.dividedTimeBlock = result;
}

#pragma mark - private method

- (UInt64) getCurrentThreadID {
    __uint64_t threadId=0;
    if (pthread_threadid_np(0, &threadId)) {
        threadId = pthread_mach_thread_np(pthread_self());
    }
    return threadId;
}

- (BOOL)checkSameThread {
    UInt64 currentThreadID = [self getCurrentThreadID];
    if(currentThreadID == self.threadID) {
        return YES;
    }
    return NO;
}

#pragma mark - property method
- (MBAPMTimeTrackModel *)trackModel {
    if(!_trackModel) {
        _trackModel = [MBAPMTimeTrackModel new];
        _trackModel.pointDict = [NSMutableDictionary new];
    }
    return _trackModel;
}

@end
