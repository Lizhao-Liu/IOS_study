//
//  MBAPMEventTimeTrackMgrPro.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/4/7.
//

#import <Foundation/Foundation.h>
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN


@protocol MBBridgeContainer;

/// 对 MBAPMEventTimeTrackMgr 进行封装
///
/// 1、支持通过path/container直接映射trackid，找到track对象
/// 2、使用create等会绑定trackId到container对象，在remove会清除绑定
/// 3、其他情况，有path的情况，对接到之前没有path的trackid
///
/// 优先级：使用传入的trackid > 通过path找trackid > 通过 container 查找到的trackid
@interface MBAPMEventTimeTrackMgrPro : NSObject

/// 创建MBAPMEventTimeTrack对象
/// @param container 调用方容器对象
/// @param path h5等路径，可以结合container确定唯一的页面track对象
+ (id<MBAPMEventTimeTrack> _Nonnull)createTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol>)container path:(NSString * _Nullable)path;


/// 获取MBAPMEventTimeTrack对象
/// @param container 调用方容器对象
/// @param path h5等路径，可以结合container确定唯一的页面track对象。有path的情况下忽略trackID
/// @param trackID track唯一标识，通过createTrack可以获得到
+ (id<MBAPMEventTimeTrack> _Nullable)getTrackWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID;

/// 移除MBAPMEventTimeTrack对象
/// @param container 调用方容器对象
/// @param path h5等路径，可以结合container确定唯一的页面track对象。有path的情况下忽略trackID
/// @param trackID track唯一标识，通过createTrack可以获得到
+ (BOOL)removeWithContainer:(id<MBAPMEventTimeTrackContainerProtocol> _Nullable)container path:(NSString * _Nullable)path trackID:(NSString * _Nullable)trackID;

@end

NS_ASSUME_NONNULL_END
