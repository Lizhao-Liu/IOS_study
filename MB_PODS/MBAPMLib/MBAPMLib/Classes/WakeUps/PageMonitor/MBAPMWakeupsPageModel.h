//
//  MBAPMWakeupsPageMetrics.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsPageModel : NSObject

@property (nonatomic, strong) NSString *pagePointer; // 页面指针地址，用于区分不同对象

@property (nonatomic, strong) NSString *pageName;

@property (nonatomic, assign) CGFloat peakWakeups;

@property (nonatomic, assign) CGFloat averageWakeupsPerSec;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) NSInteger totalWakeups;

@property (nonatomic, strong) NSDate *enterTime;

@property (nonatomic, strong) NSDate *exitTime;

@property (nonatomic, assign) NSTimeInterval excludedDuration;

@property (nonatomic, assign) NSInteger excludedWakeups;

+ (instancetype)pageModelWithPageName:(NSString *)pageName pagePointer:(NSString *)pagePointer;

- (void)startWithInitialWakeups:(NSInteger)initialWakeups;

- (void)finishWithFinalWakeups:(NSInteger)finalWakeups;

- (void)updateWakeupsRecord:(NSInteger)wakeups;

@end

NS_ASSUME_NONNULL_END
