//
//  MBAPMEventTimeTrackService.m
//  MBAPMServiceLib
//
//  Created by xp on 2023/6/8.
//

#import "MBAPMEventTimeTrackService.h"
#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMEventTimeTrackMgrPro.h"
@import YMMModuleLib;
@import MBAPMServiceLib;
#import "MBAPMPageLaunchDivideCenter.h"
#import "UIViewController+MBAPMRenderMonitor.h"

@interface MBAPMEventTimeTrackService() <YMMServiceProtocol, MBAPMEventTimeTrackServiceProtocol>

@end

@serviceEX(MBAPMEventTimeTrackService, MBAPMEventTimeTrackServiceProtocol)

- (NSString *)serviceName {
    return @"MBAPMEventTimeTrackService";
}

+ (BOOL)singleton {
    return YES;
}


- (id<MBAPMEventTimeTrack> _Nonnull)createTrack {
    return [MBAPMEventTimeTrackMgr createTrack];
}

- (id<MBAPMEventTimeTrack> _Nonnull)createTrackWithContainer:(nonnull id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString * _Nullable)path {
    return [MBAPMEventTimeTrackMgrPro createTrackWithContainer:container path:path];
}

- (id<MBAPMEventTimeTrack> _Nullable)getTrack:(NSString * _Nonnull)trackID {
    return [MBAPMEventTimeTrackMgr getTrack:trackID];
}

- (id<MBAPMEventTimeTrack> _Nullable)getTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID {
    if ([container isKindOfClass:[UIViewController class]]
        && [(UIViewController *)container parentViewController] != nil
        && [[[(UIViewController *)container parentViewController] mbapm_pageTrackId] isEqualToString:trackID]) {
        [(UIViewController *)container setMbapm_pageTrackId:trackID];
        [[(UIViewController *)container parentViewController] setMbapm_pageTrackId:@""];
    }
    
    return [MBAPMEventTimeTrackMgrPro getTrackWithContainer:container path:path trackID:trackID];
}

- (BOOL)removeTrack:(NSString * _Nonnull)trackID {
    return [MBAPMEventTimeTrackMgr removeTrack:trackID];
}

- (BOOL)removeWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID {
    return [MBAPMEventTimeTrackMgrPro removeWithContainer:container path:path trackID:trackID];
}

@end
