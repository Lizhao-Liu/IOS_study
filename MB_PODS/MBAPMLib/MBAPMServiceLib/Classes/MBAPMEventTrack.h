//
//  MBAPMEventTrack.h
//  MBAPMServiceLib
//
//  Created by xp on 2020/7/27.
//

#ifndef MBAPMEventTrack_h
#define MBAPMEventTrack_h

@class MBAPMTimeTrackResult;

@protocol MBAPMEventTrack <NSObject>

@property (nonatomic, copy, nullable) NSDictionary *extraData;

/// 事件开始
- (BOOL)begin;

/// 事件中间埋点
/// @param pointTag 埋点标记
- (BOOL)markPoint:(NSString * _Nonnull)pointTag;


/// 事件结束
- (BOOL)end;


/// 事件结束
/// @param endTag 结束埋点标记
- (BOOL)end:(NSString * _Nonnull)endTag;

// 中断事件
- (BOOL)abort;

@end


#endif /* MBAPMEventTrack_h */
