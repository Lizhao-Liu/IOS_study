//
//  MBAPMWakeupsPageMetrics.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import "MBAPMWakeupsPageModel.h"

@interface MBAPMWakeupsPageModel ()

@property (nonatomic, assign) NSInteger initialWakeupsCount;

@property (nonatomic, assign) NSInteger lastPeakWakeups;

@property (nonatomic, assign) NSInteger recordCount;

@end

@implementation MBAPMWakeupsPageModel

- (instancetype)init {
    self = [super init];
    if(self){
        self.lastPeakWakeups = 0;
        self.recordCount = 0;
        self.excludedDuration = 0;
        self.excludedWakeups = 0;
    }
    return self;
}

+ (instancetype)pageModelWithPageName:(NSString *)pageName pagePointer:(NSString *)pagePointer{
    MBAPMWakeupsPageModel *model = [MBAPMWakeupsPageModel new];
    model.pageName = pageName;
    model.pagePointer = pagePointer;
    return model;
}

- (void)startWithInitialWakeups:(NSInteger)initialWakeups {
    self.enterTime = [NSDate date];
    self.initialWakeupsCount = initialWakeups;
}

- (void)finishWithFinalWakeups:(NSInteger)finalWakeups {
    self.exitTime = [NSDate date];
    self.totalWakeups = finalWakeups - self.initialWakeupsCount - self.excludedWakeups;
    [self setUpReportData];
}

- (void)updateWakeupsRecord:(NSInteger)wakeups {
    self.lastPeakWakeups = MAX(wakeups, self.lastPeakWakeups);
}

- (void)setUpReportData {
    self.duration = [self.exitTime timeIntervalSinceDate:self.enterTime] - self.excludedDuration;
    self.averageWakeupsPerSec = self.totalWakeups / self.duration;
    self.peakWakeups = MAX(self.lastPeakWakeups, self.averageWakeupsPerSec);
}

@end
