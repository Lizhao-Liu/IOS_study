//
//  MBAPMEventTimeTrackResult.h
//  AAChartKit
//
//  Created by xp on 2021/6/15.
//

#import <Foundation/Foundation.h>
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

/// 耗时事件跟踪结果
@interface MBAPMEventTimeTrackResult : NSObject <MBAPMEventTimeTrackRecordProtocol>

/// 完整事件
@property (atomic, strong, readonly) MBAPMEventTimeSection *wholeSection;

/// 关联数据，例如app启动时长
@property (atomic, copy, nullable) NSDictionary *associatedData;

/// 事件分段集合
@property (atomic, strong, nullable, readonly) NSMutableDictionary<NSString *, MBAPMBaseEventTimeSection *> *sectionDict;

/// 读写锁并发队列
@property (atomic, strong, readonly) dispatch_queue_t readWriteCocurentQueue;


- (NSDictionary *)getSectionsExt:(NSUInteger)preSectionElapsedTime;

@end


NS_ASSUME_NONNULL_END
