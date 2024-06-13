//
//  MBAPMRenderMonitor.h
//  MBAPMLib
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMRenderMonitor : MBAPMPlugin


- (id<MBAPMEventTrack>)startTrack:(id<MBAPMViewPageProtocol>)viewPage;

- (id<MBAPMEventTimeTrack>)startEventTimeTrack:(id<MBAPMViewPageProtocol>)viewPage;

- (id<MBAPMEventTrack>)startTrackWithPageContext:(MBAPMViewPageContext *)pageContext;

- (void)startPagePerformanceTrack:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)stopPagePerformanceTrack:(MBAPMViewPageContext * _Nonnull)pageContext;

@end

NS_ASSUME_NONNULL_END
