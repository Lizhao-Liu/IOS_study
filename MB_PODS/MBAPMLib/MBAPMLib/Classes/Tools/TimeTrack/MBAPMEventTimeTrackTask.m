//
//  MBAPMEventTimeTrackTask.m
//  MBAPMLib
//
//  Created by xp on 2021/6/15.
//

#import "MBAPMEventTimeTrackTask.h"
#import "MBAPMEventTimeTrackResult.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMLogDef.h"
#import <pthread/pthread.h>

@import YYModel;
@import MBAPMServiceLib;
@import YMMModuleLib;
@import MBDoctorService;

typedef NS_ENUM(NSUInteger, MBAPMEventTimeTrackTaskStatus) {
    MBAPMEventTimeTrackTaskStatus_Init,
    MBAPMEventTimeTrackTaskStatus_Started,
    MBAPMEventTimeTrackTaskStatus_Stoped
};

typedef NS_ENUM(NSUInteger, MBAPMEventTimeTrackTaskAction) {
    MBAPMEventTimeTrackTaskAction_Begin,
    MBAPMEventTimeTrackTaskAction_End,
    MBAPMEventTimeTrackTaskAction_Section,
    MBAPMEventTimeTrackTaskAction_Abort
};


@interface MBAPMEventTimeTrackTask() {
    NSMutableDictionary *_associatedData;
    MBAPMEventTimeTrackTaskExternalEnv _env;
}

@property (nonatomic, strong, nonnull) id<MBAPMEventTimeTrackRecordProtocol> trackResult;

@property (nonatomic, strong, nullable) MBModuleInfo *privateModuleInfo;

@property (nonatomic, assign) BOOL hasBegin;

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, assign) UInt64 threadID;

@property (nonatomic, assign) MBAPMEventTimeTrackTaskStatus taskStatus;

@property (nonatomic, assign) BOOL hasReport;

@end



@implementation MBAPMEventTimeTrackTask

@synthesize completeBlock;
@synthesize container;
@synthesize path;
@synthesize env = _env;

- (instancetype)initWithTrackRecord:(id<MBAPMEventTimeTrackRecordProtocol>)record {
    if (self = [super init]) {
        [self initTask: record];
    }
    return self;
}

- (instancetype)init {
    if(self = [super init]) {
        [self initTask: nil];
    }
    return self;
}

- (void)setModuleInfo:(MBModuleInfo *)moduleInfo {
    _privateModuleInfo = moduleInfo;
}

- (MBModuleInfo *)moduleInfo {
    if (_privateModuleInfo) {
        return _privateModuleInfo;
    }
    if ([self.container respondsToSelector:@selector(mb_moduleInfo)]) {
        return [self.container performSelector:@selector(mb_moduleInfo)];
    }
    return nil;
}

- (void)updateExternalEnv:(MBAPMEventTimeTrackTaskExternalEnv)externalEnv {
    _env = _env | externalEnv;
}

#pragma mark MBAPMEventTimeTrack Methods

- (BOOL)begin:(NSDictionary * _Nullable)extData {
    long long beginTime = [MBAPMTimeUtil currentTimestamp];
    return [self begin:extData beginAt:beginTime];
}

- (BOOL)begin:(NSDictionary * _Nullable)extData beginAt:(UInt64)beginTimestamp {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.hasBegin) {
            return;
        }
        strongSelf.hasBegin = YES;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Begin]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task begin: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [strongSelf.trackResult begin:extData beginAt:beginTimestamp];
    });
    return YES;
}

- (BOOL)end:(NSDictionary * _Nullable)extData {
    return [self end:kMBAPM_EVENTTIMETRACK_POINTTAG_END withExtra:extData];
}

- (BOOL)end:(NSString * _Nonnull)lastSectionTag withExtra:(NSDictionary * _Nullable)extData {
    return [self end:lastSectionTag endAt:0 withExtra:extData];
}

- (BOOL)end:(NSString * _Nonnull)lastSectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData {
    if (!lastSectionTag ||lastSectionTag.length == 0) {
        lastSectionTag = kMBAPM_EVENTTIMETRACK_POINTTAG_END;
    }
    long long endTime = [MBAPMTimeUtil currentTimestamp];
    if (endTimeStamp > 0) {
        endTime = endTimeStamp;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_End]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task end: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [self.trackResult end:lastSectionTag endAt:endTime withExtra:extData];
        if ([strongSelf.trackResult validData]) {
            [strongSelf completeTrack:YES msg:nil result:strongSelf.trackResult];
        } else {
            [strongSelf completeTrack:NO msg:@"track result data is invalid" result:nil];
        }
    });
    return YES;
}

- (BOOL)beginIsolatedSection:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData {
    return [self beginIsolatedSection:sectionTag sectionType:MBAPMEventTimeSectionType_SERIAL withExtra:extData];
}

- (BOOL)beginIsolatedSection:(NSString * _Nonnull)sectionTag sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData {
    if (!sectionTag || sectionTag.length == 0) {
        MBAPMWarning(@"sectionTag can't be nil or empty");
        return NO;
    }
    long long sectionBeginTime = [MBAPMTimeUtil currentTimestamp];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Section]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task beginIsolatedSection: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [strongSelf.trackResult beginIsolatedSection:sectionTag beginAt:sectionBeginTime sectionType:type withExtra:extData];
    });
    return YES;
}

- (BOOL)endIsolatedSection:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData {
    if (!sectionTag || sectionTag.length == 0) {
        MBAPMWarning(@"sectionTag can't be nil or empty");
        return NO;
    }
    long long sectionEndTime = [MBAPMTimeUtil currentTimestamp];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Section]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task endIsolatedSection: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [strongSelf.trackResult endIsolatedSection:sectionTag endAt:sectionEndTime withExtra:extData];
    });
    return YES;
}

- (BOOL)section:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData {
    if (!sectionTag || sectionTag.length == 0) {
        MBAPMWarning(@"sectionTag can't be nil or empty");
        return NO;
    }
    
    long long sectionEndTime = [MBAPMTimeUtil currentTimestamp];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Section]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task section: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [strongSelf.trackResult section:sectionTag endAt:sectionEndTime withExtra:extData];
    });
    return YES;
}

- (BOOL)section:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData {
    [self.trackResult sectionBeginFromLastPoint:sectionTag endAt:endTimeStamp withExtra:extData];
    return YES;
}

- (BOOL)section:(NSString *)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp withExtra:(NSDictionary *)extData {
    return [self section:sectionTag beginAt:beginTimestamp endAt:endTimeStamp sectionType:MBAPMEventTimeSectionType_SERIAL withExtra:extData];
}

- (BOOL)section:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData {
    if (!sectionTag || sectionTag.length == 0) {
        MBAPMWarning(@"sectionTag can't be nil or empty");
        return NO;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Section]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task section: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [strongSelf.trackResult section:sectionTag beginAt:beginTimestamp endAt:endTimeStamp sectionType:type withExtra:extData];
    });
    return YES;
}

- (BOOL)section:(NSString *)sectionTag cost:(UInt64)elapsedTime withExtra:(NSDictionary *)extData {
    if (!sectionTag || sectionTag.length == 0) {
        MBAPMWarning(@"sectionTag can't be nil or empty");
        return NO;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Section]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task section: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
        [strongSelf.trackResult section:sectionTag cost:elapsedTime withExtra:extData];
    });
    return YES;
}

- (BOOL)abort {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf checkTaskStatus:MBAPMEventTimeTrackTaskAction_Abort]) {
            [strongSelf completeTrack:NO msg:[NSString stringWithFormat:@"task abort: status is incorrect : %lu", (unsigned long)strongSelf.taskStatus] result:nil];
        }
    });
    return YES;
}

- (NSString * _Nonnull)getTrackId {
    return self.trackResult.trackID;
}


#pragma mark Property Methods
- (id<MBAPMEventTimeTrackRecordProtocol>)trackResult {
    if (!_trackResult) {
        _trackResult = [MBAPMEventTimeTrackResult new];
    }
    return _trackResult;
}

#pragma mark Private Methods
- (void)initTask:(id<MBAPMEventTimeTrackRecordProtocol>)trackRecord {
    _serialQueue = dispatch_queue_create("com.mb.performance.timestatistic", DISPATCH_QUEUE_SERIAL);
    _taskStatus = MBAPMEventTimeTrackTaskStatus_Init;
    _trackResult = trackRecord;
}

- (void)completeTrack:(BOOL)isSuccess msg:(NSString * _Nullable)msg result:(id<MBAPMEventTimeTrackRecordProtocol> _Nullable)resultData {
    if (isSuccess) {
        if (self.hasReport) {
            MBAPMWarning(@"apm time track task repeat: result = %d msg = %@ data = %@", isSuccess, msg, [resultData getSectionsDict]);
            return;
        }
        self.hasReport = YES;
    }
    MBAPMDebug(@"apm time track task: result = %d msg = %@ data = %@", isSuccess, msg, [resultData getSectionsDict]);
    __weak typeof(msg) weakMsg = msg;
    __weak typeof(resultData) weakResultData = resultData;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(msg) strongMsg = weakMsg;
        __strong typeof(resultData) strongResultData = weakResultData;
        if (self.completeBlock) {
            self.completeBlock(isSuccess, strongMsg, strongResultData);
        }
    });
}

// 检查并更新taskStatus，防止各个task重复调用
- (BOOL)checkTaskStatus:(MBAPMEventTimeTrackTaskAction)action {
    switch (action) {
        case MBAPMEventTimeTrackTaskAction_Begin:
            if(self.taskStatus == MBAPMEventTimeTrackTaskStatus_Started) {
                return NO;
            }
            self.taskStatus = MBAPMEventTimeTrackTaskStatus_Started;
            break;
        case MBAPMEventTimeTrackTaskAction_Section:
            if (self.taskStatus < MBAPMEventTimeTrackTaskStatus_Started || self.taskStatus >= MBAPMEventTimeTrackTaskStatus_Stoped) {
                return NO;
            }
            break;
            
        case MBAPMEventTimeTrackTaskAction_End:
            if (self.taskStatus < MBAPMEventTimeTrackTaskStatus_Started || self.taskStatus >= MBAPMEventTimeTrackTaskStatus_Stoped) {
                return NO;
            }
            self.taskStatus = MBAPMEventTimeTrackTaskStatus_Stoped;
            break;
        case MBAPMEventTimeTrackTaskAction_Abort:
            if (self.taskStatus < MBAPMEventTimeTrackTaskStatus_Started || self.taskStatus >= MBAPMEventTimeTrackTaskStatus_Stoped) {
                return NO;
            }
            self.taskStatus = MBAPMEventTimeTrackTaskStatus_Stoped;
            break;
        default:
            ;
    }
    return YES;
}

- (void)setAssociatedData:(NSDictionary *)associatedData {
    @synchronized (self) {
        if (!_associatedData) {
            _associatedData = [NSMutableDictionary new];
        }
        NSMutableDictionary *wholeTags = [NSMutableDictionary dictionaryWithDictionary:[_associatedData objectForKey:@"tags"]?:@{}];
        if (associatedData) {
            [_associatedData addEntriesFromDictionary:associatedData];
        }
        if ([associatedData.allKeys containsObject:@"tags"]
            && [associatedData[@"tags"] isKindOfClass:[NSDictionary class]]
            && [associatedData[@"tags"] count] > 0) {
            [wholeTags addEntriesFromDictionary:associatedData[@"tags"]];
            _associatedData[@"tags"] = wholeTags;
        }
        [self.trackResult updateAssociatedData:_associatedData.copy];
    };
}

- (NSDictionary *)associatedData {
    @synchronized (self) {
        return _associatedData.copy;
    }
}

@end
