//
//  MBAPMEventTimeTrackMgrPro.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/4/7.
//

#import "MBAPMEventTimeTrackMgrPro.h"
#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMPageViewTrackTask.h"
#import "MBAPMEventPageviewTrackResult.h"
@import MBAPMServiceLib;

@interface MBAPMEventTimeTrackMgrPro()

@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSString *> *mapDic;

@end

@implementation MBAPMEventTimeTrackMgrPro

// MARK: - Public Methods
+ (id<MBAPMEventTimeTrack> _Nonnull)createTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString * _Nullable)path {
    id<MBAPMEventTimeTrack> timeTrack = [self getTrackWithContainer:container path:path trackID:nil];
    if (!timeTrack) {
        timeTrack = [[MBAPMPageViewTrackTask alloc]initWithTrackRecord:[MBAPMEventPageviewTrackResult new]];
        [MBAPMEventTimeTrackMgr saveTask:timeTrack];
    }
    [self updateTrack:timeTrack container:container path:path];
    return timeTrack;
}

+ (id<MBAPMEventTimeTrack> _Nullable)getTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID {
    return [MBAPMEventTimeTrackMgr getTrack:[self trackIDWithContainer:container path:path trackID:trackID]];
}

+ (BOOL)removeWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID {
    if ([container respondsToSelector:@selector(setMbapm_pageTrackId:)]) {
        [container setMbapm_pageTrackId:@""];
    }
    return [MBAPMEventTimeTrackMgr removeTrack:[self trackIDWithContainer:container path:path trackID:trackID]];
}

// MARK: - Private Methods
+ (NSString *)mapKeyWithContainer:(id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString *)path {
    return [NSString stringWithFormat:@"%p%@", container, path];
}

+ (NSString *)trackIDWithContainer:(id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString *)path trackID:(NSString * _Nonnull)trackID {
    @synchronized (mgr) {
        NSString *result = nil;
        // 优先使用 trackID
        if (trackID
            && [trackID isKindOfClass:[NSString class]]
            && trackID.length > 0) {
            result = trackID;
            return result;
        }
        // 有path 从path表查trackID，若无，读vc trackid
        if (path
            && [path isKindOfClass:[NSString class]]
            && path.length > 0) {
            result = [[[self sharedInstance] mapDic] valueForKey:[self mapKeyWithContainer:container path:path]];
            if (!result
                && [container respondsToSelector:@selector(mbapm_pageTrackId)]) {
                result = container.mbapm_pageTrackId;
            }
            
        } else {
            if (!result
                && [container respondsToSelector:@selector(mbapm_pageTrackId)]) {
                result = container.mbapm_pageTrackId;
            }
        }
        return result;
    }
}

+ (void)updateTrack:(id<MBAPMEventTimeTrack>)track container:(id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString *)path {
    @synchronized (mgr) {
        NSString *key = [self mapKeyWithContainer:container path:path];
        if (key) {
            [self sharedInstance].mapDic[key] = [track getTrackId];
            [track setPath:path];
            [track setContainer:container];
        }
        
        if ([container respondsToSelector:@selector(setMbapm_pageTrackId:)]) {
            [container setMbapm_pageTrackId:[track getTrackId]];
        }
    }
}
// MARK: - Property Methods
- (NSMutableDictionary<NSString *, NSString *> *)mapDic {
    if (!_mapDic) {
        _mapDic = [NSMutableDictionary new];
    }
    return _mapDic;
}

static MBAPMEventTimeTrackMgrPro *mgr;
+ (MBAPMEventTimeTrackMgrPro *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [MBAPMEventTimeTrackMgrPro new];
    });
    return mgr;
}

@end
