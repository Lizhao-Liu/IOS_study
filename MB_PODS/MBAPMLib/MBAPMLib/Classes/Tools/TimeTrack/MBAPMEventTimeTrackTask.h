//
//  MBAPMEventTimeTrackTask.h
//  MBAPMLib
//
//  Created by xp on 2021/6/15.
//

#import <Foundation/Foundation.h>
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMEventTimeTrackTask : NSObject <MBAPMEventTimeTrack>

- (instancetype)initWithTrackRecord:(id<MBAPMEventTimeTrackRecordProtocol>)record;

@end

NS_ASSUME_NONNULL_END
