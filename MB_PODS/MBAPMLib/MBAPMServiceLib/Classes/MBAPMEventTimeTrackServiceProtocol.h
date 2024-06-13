//
//  MBAPMEventTimeTrackServiceProtocol.h
//  MBAPMServiceLib
//
//  Created by xp on 2023/6/8.
//

#import <Foundation/Foundation.h>
#import "MBAPMEventTimeTrack.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBAPMEventTimeTrackContainerProtocol <NSObject>

@optional

@property (nonatomic, copy, readwrite) NSString * mbapm_pageTrackId;

@property (nonatomic, assign, readwrite) BOOL mbapm_isFirstHomePage;

@end


@protocol MBAPMEventTimeTrackServiceProtocol <NSObject>

/// 创建MBAPMEventTimeTrack对象
- (id<MBAPMEventTimeTrack> _Nonnull)createTrack;

/// 获取MBAPMEventTimeTrack对象
/// @param trackID track唯一标识，通过createTrack可以获得到
- (id<MBAPMEventTimeTrack> _Nullable)getTrack:(NSString * _Nonnull)trackID;

/// 移除MBAPMEventTimeTrack对象
/// @param trackID track唯一标识，通过createTrack可以获得到
- (BOOL)removeTrack:(NSString * _Nonnull)trackID;


/// 创建MBAPMEventTimeTrack对象
/// @param container 调用方容器对象
/// @param path h5等路径，可以结合container确定唯一的页面track对象
- (id<MBAPMEventTimeTrack> _Nonnull)createTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString * _Nullable)path;


/// 获取MBAPMEventTimeTrack对象
/// @param container 调用方容器对象
/// @param path h5等路径，可以结合container确定唯一的页面track对象。有path的情况下忽略trackID
/// @param trackID track唯一标识，通过createTrack可以获得到
- (id<MBAPMEventTimeTrack> _Nullable)getTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID;

/// 移除MBAPMEventTimeTrack对象
/// @param container 调用方容器对象
/// @param path h5等路径，可以结合container确定唯一的页面track对象。有path的情况下忽略trackID
/// @param trackID track唯一标识，通过createTrack可以获得到
- (BOOL)removeWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID;


@end

NS_ASSUME_NONNULL_END
