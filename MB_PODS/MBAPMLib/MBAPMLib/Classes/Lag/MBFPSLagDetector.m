//
//  MBFPSLagDetector.m
//  MBAPMLib
//
//  Created by xp on 2020/11/6.
//

#import "MBFPSLagDetector.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMCallStackUtil.h"
#import "MBAPMLogDef.h"

static const int kDetectTimeWindow = 3000;
static const int kLagCountThreshold = 5;
static const int kLagDurationMinThreshold = 200;
static const int klagDurationMaxThreshold = 400;

@interface MBFPSLagDetector()

@property (nonatomic, strong) CADisplayLink *dLink;
@property (nonatomic, strong) MBAPMLagDetectCallback callback;


/// 卡顿开始时间
@property (nonatomic, assign) NSTimeInterval detectStartTime;

/// 卡顿时间窗口
@property (nonatomic, assign) int detectTimeWindow;


/// 记录卡顿次数
@property (nonatomic, assign) int lagCount;


/// 卡顿次数阈值
@property (nonatomic, assign) int lagCountThreshold;


/// 卡顿时长最小值
@property (nonatomic, assign) NSTimeInterval lagDurationMinThreshold;


/// 卡顿时长最大值
@property (nonatomic, assign) NSTimeInterval lagDurationMaxThreshold;


/// FPS上一帧时间戳
@property (nonatomic, assign) NSTimeInterval lastTimestamp;

@end

@implementation MBFPSLagDetector

- (instancetype)init {
    if(self = [super init]) {
        _detectTimeWindow = kDetectTimeWindow;
        _lagCountThreshold = kLagCountThreshold;
        _lagDurationMaxThreshold = klagDurationMaxThreshold;
        _lagDurationMinThreshold = kLagDurationMinThreshold;
    }
    return self;
}


- (void)startLagDetector:(MBAPMLagDetectCallback)callback {
    self.callback = callback;
    self.dLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    [self.dLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopLagDetector {
    [self resetCaculate];
    if(self.dLink) {
        [self.dLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)displayLinkCallback:(CADisplayLink *)displayLink {
    if(self.lagCount == 0) {
        self.detectStartTime = [MBAPMTimeUtil currentTimestamp];
    }
    if(self.lastTimestamp == 0) {
        self.lastTimestamp = displayLink.timestamp;
    } else {
        NSTimeInterval duration = (displayLink.timestamp - self.lastTimestamp) * 1000;
        self.lastTimestamp = displayLink.timestamp;
        if(duration >= self.lagDurationMinThreshold && duration <= self.lagDurationMaxThreshold) {
            self.lagCount++;
            MBAPMDebug(@"short lag occurs duration : %f count : %d", duration, self.lagCount);
        } else if(duration > self.lagDurationMaxThreshold){
            [self resetCaculate];
        }
        if(self.lagCount < self.lagCountThreshold) {
            return;
        } else {
            NSTimeInterval currentTime = [MBAPMTimeUtil currentTimestamp];
            NSTimeInterval wholeDuration = currentTime - self.detectStartTime;
            if(wholeDuration <= self.detectTimeWindow) {
                MBAPMDebug(@"frecurency short lag occurs duration : %f", wholeDuration);
                //检测到连续短时崩溃
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    //尽量避免获取堆栈耗时影响检测线程的执行
                    NSString *callStack = [MBAPMCallStackUtil callStackOfMainThread];
                    if(self.callback) {
                        self.callback(MBAPMReportChannelAPMLib, MBAPMLagTypeShort, callStack, @"",  self.detectStartTime, wholeDuration, @{}, 0);
                    }
                });
            }
            [self resetCaculate];
        }
    }
}

- (void)resetCaculate {
    self.lagCount = 0;
    self.detectStartTime = 0;
}

@end
