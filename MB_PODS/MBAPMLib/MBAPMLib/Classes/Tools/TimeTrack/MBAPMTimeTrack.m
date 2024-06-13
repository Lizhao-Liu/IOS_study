//
//  MBAPMTimeTrack.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/8.
//

#import "MBAPMTimeTrack.h"
#import "MBAPMTimeTrackTask.h"

@interface MBAPMTimeTrack() {
    dispatch_queue_t _concurrent_queue;
}

@property (nonatomic, strong) NSMutableDictionary<NSString *,  MBAPMTimeTrackTask *> *taskMap;

@property (nonatomic, strong) NSMutableDictionary<NSString *,  NSString *> *eventTrackMap;

@end

@implementation MBAPMTimeTrack

#pragma mark - lifeCycle method
- (instancetype)init {
    self = [super init];
    if(self) {
        _concurrent_queue = dispatch_queue_create("com.mbapm.timetrack", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


#pragma mark - public method

+ (instancetype)shared {
    static MBAPMTimeTrack *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MBAPMTimeTrack new];
    });
    return instance;
}

- (MBAPMTimeTrackTask *)createTask:(NSString *)eventID {
    return [self createNewTask:eventID];
}

- (void)begin:(NSString *)eventID {
    MBAPMTimeTrackTask *task = [self createNewTask:eventID];
    [self setTask:task];
    [task begin];
}

- (void)markPoint:(NSString *)eventID withPointTag:(NSString *)tag {
    MBAPMTimeTrackTask *task = [self taskForEventId:eventID];
    if(task) {
        [task markPoint:tag];
    }
}

- (void)end:(NSString *)eventID {
    MBAPMTimeTrackTask *task = [self taskForEventId:eventID];
    if(task) {
        [task end];
    }
    [self removeTask:task];
}

- (void)end:(NSString *)eventID withEndTag:(NSString *)endTag {
    MBAPMTimeTrackTask *task = [self taskForEventId:eventID];
    if(task) {
        [task end:endTag];
    }
    [self removeTask:task];
}

- (void)caculate:(NSString *)eventID withRange:(NSRange)range withResultBlock:(TimeTrackRangeBlock)result {
    MBAPMTimeTrackTask *task = [self taskForEventId:eventID];
    if(task) {
        [task caculateWithRange:range withResultBlock:result];
    }
}

- (void)caculateTotal:(NSString *)eventID withResultBlock:(TimeTrackTotalBlock)result {
    MBAPMTimeTrackTask *task = [self taskForEventId:eventID];
    if(task) {
        [task caculateTotal:result];
    }
}

- (void)caculateDividedByPoints:(NSString *)eventID withResultBlock:(TimeTrackDividedBlock)result {
    MBAPMTimeTrackTask *task = [self taskForEventId:eventID];
    if(task) {
        [task caculateDividedByPoints:result];
    }
}

#pragma mark - private method

- (MBAPMTimeTrackTask *)createNewTask:(NSString *)eventID {
    NSString *trackID = [self generateUUID];
    MBAPMTimeTrackTask *task = [MBAPMTimeTrackTask new];
    task.eventID = eventID;
    task.trackID = trackID;
    return task;
}


- (NSString *)generateUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(uuidString);
    CFRelease(puuid);
    return result;
}

- (MBAPMTimeTrackTask *)taskForTrackId:(NSString *)trackID {
    __block MBAPMTimeTrackTask *task;
    dispatch_sync(_concurrent_queue, ^{
        task = [self.taskMap objectForKey:trackID];
    });
    return task;
}

- (MBAPMTimeTrackTask *)taskForEventId:(NSString *)eventID {
    __block MBAPMTimeTrackTask *task;
    dispatch_sync(_concurrent_queue, ^{
        NSString *trackID = [self.eventTrackMap objectForKey:eventID];
        if(trackID) {
            task = [self.taskMap objectForKey:trackID];
        }
    });
    return task;
}

- (void)setTask:(MBAPMTimeTrackTask *)task {
    dispatch_barrier_sync(_concurrent_queue, ^{
        [self.taskMap setObject:task forKey:task.trackID];
        [self.eventTrackMap setObject:task.trackID forKey:task.eventID];
    });
}

- (void)removeTask:(MBAPMTimeTrackTask *)task {
    if(!task || !task.trackID || !task.eventID) {
        return;
    }
    dispatch_barrier_sync(_concurrent_queue, ^{
        [self.taskMap removeObjectForKey:task.trackID];
        [self.eventTrackMap removeObjectForKey:task.eventID];
    });
}

#pragma mark - property method
- (NSMutableDictionary<NSString *,MBAPMTimeTrackTask *> *)taskMap {
    if(!_taskMap) {
        _taskMap = [NSMutableDictionary new];
    }
    return _taskMap;
}

- (NSMutableDictionary<NSString *,NSString *> *)eventTrackMap {
    if(!_eventTrackMap) {
        _eventTrackMap = [NSMutableDictionary new];
    }
    return _eventTrackMap;
}

@end
