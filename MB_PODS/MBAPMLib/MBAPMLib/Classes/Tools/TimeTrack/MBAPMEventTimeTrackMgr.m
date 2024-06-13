//
//  MBAPMEventTimeTrackMgr.m
//  MBAPMLib
//
//  Created by xp on 2021/6/15.
//

#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMEventTimeTrackTask.h"

@import MBAPMServiceLib;


@interface MBAPMEventTimeTrackMgr()

@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, id<MBAPMEventTimeTrack>> *trackDic;

@end

@implementation MBAPMEventTimeTrackMgr

#pragma mark Public Methods

+ (id<MBAPMEventTimeTrack>)createTrack {
    @synchronized (mgr) {
        MBAPMEventTimeTrackTask *task = [MBAPMEventTimeTrackTask new];
        NSString *trackID = [task getTrackId];
        MBAPMEventTimeTrackMgr *mgr = [self sharedInstance];
        [mgr.trackDic setObject:task forKey:trackID];
        return task;
    }
}


+ (id<MBAPMEventTimeTrack>)createTrack:(id<MBAPMEventTimeTrackRecordProtocol>)trackRecord {
    @synchronized (mgr) {
        MBAPMEventTimeTrackTask *task = [[MBAPMEventTimeTrackTask alloc]initWithTrackRecord:trackRecord];
        NSString *trackID = [task getTrackId];
        MBAPMEventTimeTrackMgr *mgr = [self sharedInstance];
        [mgr.trackDic setObject:task forKey:trackID];
        return task;
    }
}

+ (void)saveTask:(id<MBAPMEventTimeTrack>)trackTask {
    @synchronized (mgr) {
        NSString *trackID = [trackTask getTrackId];
        MBAPMEventTimeTrackMgr *mgr = [self sharedInstance];
        [mgr.trackDic setObject:trackTask forKey:trackID];
        return;
    }
}

+ (id<MBAPMEventTimeTrack>)getTrack:(NSString *)trackID {
    if (!trackID || trackID.length == 0) {
        return nil;
    }
    @synchronized (mgr) {
        MBAPMEventTimeTrackMgr *mgr = [self sharedInstance];
        MBAPMEventTimeTrackTask *task = [mgr.trackDic objectForKey:trackID];
        return task;
    }
}

+ (BOOL)removeTrack:(NSString *)trackID {
    if (!trackID || trackID.length == 0) {
        return NO;
    }
    @synchronized (mgr) {
        MBAPMEventTimeTrackMgr *mgr = [self sharedInstance];
        [mgr.trackDic removeObjectForKey:trackID];
        return YES;
    }
}

#pragma mark Property Methods

- (NSMutableDictionary<NSString *,id<MBAPMEventTimeTrack>> *)trackDic {
    if (!_trackDic) {
        _trackDic = [NSMutableDictionary<NSString *, id<MBAPMEventTimeTrack>> new];
    }
    return _trackDic;
}

static MBAPMEventTimeTrackMgr *mgr;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [MBAPMEventTimeTrackMgr new];
    });
    return mgr;
}

+ (NSArray<id<MBAPMEventTimeTrack>> *)getAllTasks {
    @synchronized (mgr) {
        return mgr.trackDic.allValues;
    }
}

@end
