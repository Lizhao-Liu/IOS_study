//
//  MBRunloopStateLagDetector.m
//  MBAPMLib
//
//  Created by xp on 2020/8/15.
//

#import "MBRunloopStateLagDetector.h"
#import <mach/mach_types.h>
#import <mach/mach.h>
#import <mach/task_info.h>
#import "MBAPMCallStackUtil.h"
#import "MBAPMLogDef.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMBacktraceLogger.h"
#import "MBAPMMainThreadStackMgr.h"

static const int kDeadLagThreadshold = 5 * 1000; //卡死时长阀值
static const int kLongLagThreadshold = 3 * 1000; //长卡顿时长阀值
//多次短卡顿检测时长，频繁短卡顿定义为5s内发生5次300ms以上，3s以下短卡顿
static const int kShortLagThreadshold = 300; //单次短卡顿时长阈值
static const int kShortLagTimeIntervalThreadshold = 5 * 1000; //频繁短卡顿检测时长
static const int kShortLagCountThreadshold = 5; //短卡顿发生次数
static const int kCheckRunloopTimeInterval = 100; //检查Runloop状态时间间隔
static const int kDetectSleepTime = 300; //App不在前台，检测线程每次休眠时长
static const int KDetectDelayTime = 4000; //检测线程延时启动时长，避免对app启动造成影响
//Runloop阻塞3次以内每次获取堆栈，阻塞次数在4～30次，每隔3次获取一次堆栈，阻塞次数31～50，每隔5次获取一次堆栈，超过50次不再获取堆栈，避免频繁获取堆栈
static const int kLagCountThreadshold = 3;
static const int kLagCountLongThreadshold = 5;

//定义卡顿检测状态
typedef NS_ENUM(NSUInteger, MBAPMLagAnalysisStatus) {
    MBAPMLagAnalysisStatusUnfinished, //短卡顿检测未结束
    MBAPMLagAnalysisStatusTimeout, //短卡顿检测超时
    MBAPMLagAnalysisStatusUnLag, //没有检测到卡顿
    MBAPMLagAnalysisStatusLag //检测到卡顿
};

@interface MBRunloopStateLagDetector() {
    MBAPMMainThreadStackMgr *_mainThreadStackMgr; //管理线程堆栈
    NSTimeInterval _lastTimeDelta; //记录上次runloop阻塞时长
    NSUInteger _LagCount; //runloop阻塞次数
    NSUInteger _shortLagCount; //一个检测周期内短卡顿次数
    BOOL _hasLagDead; //是否检测到卡死
    dispatch_queue_t _catchBacktraceQueue; //堆栈获取队列，堆栈获取放到子线程中
}

@property (nonatomic, assign) BOOL isApplicationInActive;
@property (nonatomic, strong) dispatch_semaphore_t dispatchSemaphore;
@property (nonatomic, assign) CFRunLoopActivity runLoopActivity;
@property (nonatomic, assign) CFRunLoopObserverRef runLoopObserver;
@property (nonatomic, copy) MBAPMLagDetectCallback callback;
@property (nonatomic, assign) BOOL isStopped;
@property (nonatomic, assign) NSTimeInterval lagStartTime; //记录卡顿开始时间点
@property (nonatomic, assign) NSTimeInterval onceLagTotalTime; //每次卡顿总时长


@end


@implementation MBRunloopStateLagDetector

#pragma mark public method
- (instancetype)init {
    if(self = [super init]) {
        [self setupDetector];
    }
    return self;
}

- (void)setupDetector {
    _isApplicationInActive = YES;
    _isStopped = YES;
    _hasLagDead = NO;
    _lastTimeDelta = 0;
    _LagCount = 0;
    _shortLagCount = 0;
    _lagStartTime = 0;
    _onceLagTotalTime = 0;
    _catchBacktraceQueue = dispatch_queue_create("com.mb.apm.lagdetector", DISPATCH_QUEUE_SERIAL);
    _mainThreadStackMgr = [[MBAPMMainThreadStackMgr alloc]initWithCycleArrayCount:20];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)startLagDetector:(MBAPMLagDetectCallback)callback{
    if(!self.isStopped) {
        //防止重复调用
        return;
    }
    MBAPMLogInfo(@"start lag detector");
    _isStopped = NO;
    self.callback = callback;
    self.dispatchSemaphore = dispatch_semaphore_create(0);
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallback, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, KDetectDelayTime * NSEC_PER_MSEC), dispatch_get_global_queue(0, 0), ^{
        while (!self.isStopped) {
            if(self.isApplicationInActive) {
                NSTimeInterval startTime = [MBAPMTimeUtil currentTimestamp];
                if(self.lagStartTime == 0) {
                    //只有一次检测周期结束才需要重置检测开始时间
                    self.lagStartTime = startTime;
                }
                //通过信号量控制每隔kCheckRunloopTimeInterval长时间检测runloop状态，如果状态没有发生变化则会出现超时
                dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, kCheckRunloopTimeInterval * NSEC_PER_MSEC));
                if(self.isStopped) {
                    return;
                }
                NSTimeInterval currentTime = [MBAPMTimeUtil currentTimestamp];
                NSTimeInterval timeDelta = currentTime - startTime;//记录runloop单次阻塞耗时
                [self analysisLag:timeDelta];
            } else {
                usleep(kDetectSleepTime);
            }
        }
    });
}

- (void)stopLagDetector {
    if(!self.isStopped) {
        return;
    }
    MBAPMLogInfo(@"stop lag detector");
    _isStopped = YES;
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(self.runLoopObserver);
    self.runLoopObserver = NULL;
}

#pragma mark private method

///分析runloop状态，如果runloop状态卡在kCFRunLoopBeforeSources或者kCFRunLoopAfterWaiting，说明发生了卡顿，同时累计卡顿时长，并捕获主线程堆栈
-(void)analysisLag:(NSTimeInterval) timeDelta {
    if (self.runLoopActivity == kCFRunLoopBeforeSources || self.runLoopActivity == kCFRunLoopAfterWaiting) {
        if (timeDelta < kCheckRunloopTimeInterval) {
            if (_lastTimeDelta >= kCheckRunloopTimeInterval) {
                //当次卡顿时长小于阀值，但上次卡顿时长大于阈值，需要累计卡顿时长
                [self appendLagTime:timeDelta];
            }
        } else if (timeDelta >= kCheckRunloopTimeInterval) {
            [self appendLagTime:timeDelta];
            if (++_LagCount) {
                if (_LagCount <= 3) {
                    [self recordBackStackTrace];
                } else if (_LagCount <= 30) {
                    if (_LagCount % kLagCountThreadshold == 0) {
                        [self recordBackStackTrace];
                    }
                } else if (_LagCount <= 50) {
                    if (_LagCount %  kLagCountLongThreadshold == 0) {
                        [self recordBackStackTrace];
                    }
                } else {
                    if(!_hasLagDead) {
                        MBAPMLogInfo(@"卡顿次数过多，次数：%lu", (unsigned long)_LagCount);
                        _hasLagDead = YES;
                        [self analysisLagStatus];
                    }
                }
            }
        }
        _lastTimeDelta = timeDelta;
    } else if (self.runLoopActivity == kCFRunLoopBeforeWaiting) {
        //runloop状态变为kCFRunLoopBeforeWaiting，说明runloop进入空闲状态，可以开始分析卡顿时长和卡顿类型
        _hasLagDead = NO;
        MBAPMLagAnalysisStatus analysisStatus = [self analysisLagStatus];
        [self resetDetectStatus];//重置每次卡顿检测状态数据
        if(analysisStatus != MBAPMLagAnalysisStatusUnfinished) {
            [self resetLagStatus];//重置每次卡顿周期状态数据
        }
    }
}

/// 分析卡顿状态，根据每种卡顿的满足条件，将卡顿进行归类
- (MBAPMLagAnalysisStatus)analysisLagStatus {
    if (_LagCount > 0) {
        MBAPMLogInfo(@"OnceLagTotalTime = %f, lagCount = %lu", _onceLagTotalTime, (unsigned long)_LagCount);
    }
    NSTimeInterval currentTime = [MBAPMTimeUtil currentTimestamp];
    NSTimeInterval detectTotalTime = currentTime - _lagStartTime;//每次卡顿结束时距离卡顿开始时长，用于判断频繁短卡顿的时间区间限制
    MBAPMLagType lagType = MBAPMLagTypeNull;
    if (_onceLagTotalTime >= kDeadLagThreadshold) {
        lagType = MBAPMLagTypeDead;//发生卡死
    } else if (_onceLagTotalTime >= kLongLagThreadshold) {
        lagType = MBAPMLagTypeLong; //发生长卡顿
    } else if (_onceLagTotalTime >= kShortLagThreadshold) {
        _shortLagCount++;
        MBAPMLogInfo(@"lag time = %lu, detect total time  = %f", (unsigned long)_shortLagCount, detectTotalTime);
        if (detectTotalTime <= kShortLagTimeIntervalThreadshold) {
            if(_shortLagCount >= kShortLagCountThreadshold) {
                lagType = MBAPMLagTypeShort; //发生频繁短卡顿
            } else {
                MBAPMLogInfo(@"analysisLagStatus unfinished");
                return MBAPMLagAnalysisStatusUnfinished;
            }
        } else {
            MBAPMLogInfo(@"analysisLagStatus timeout");
            return MBAPMLagAnalysisStatusTimeout;
        }
    } else {
        if (_shortLagCount == 0) {
            return MBAPMLagAnalysisStatusUnLag;
        } else {
            if (detectTotalTime >= kShortLagTimeIntervalThreadshold) {
                return MBAPMLagAnalysisStatusUnLag;
            } else {
                return MBAPMLagAnalysisStatusUnfinished;
            }
        }
    }
    NSTimeInterval apmLagStartTime = self.lagStartTime;
    NSTimeInterval apmLagTotalTime = detectTotalTime;
    if (lagType != MBAPMLagTypeNull) {
        MBAPMSymbolicatedBacktraceStack *callStack = [self analysisLagBacktrace];
        MBAPMLogInfo(@"lagType = %lu, lagStartTime = %f, totalLagTime = %f", (unsigned long)lagType, apmLagStartTime, apmLagTotalTime);
        MBAPMLogInfo(@"lag callStack:\n %@", callStack.keyFunction);
        if(self.callback) {
            self.callback(MBAPMReportChannelAPMLib, lagType, callStack.wholeStack, callStack.keyFunction, apmLagStartTime, apmLagTotalTime, @{}, 0);
        }
    }
    return MBAPMLagAnalysisStatusLag;
}

/// 获取主线程堆栈
- (void) catchMainThreadBacktrace {
    MBAPMBacktraceStack *backtraceStack = [MBAPMBacktraceLogger mbapm_backtraceAddressOfMainThread];
    if (backtraceStack == NULL) {
        return;
    }
    if (backtraceStack->stack != NULL && backtraceStack->count != 0) {
        [_mainThreadStackMgr addThreadStack:backtraceStack->stack andStackCount:backtraceStack->count];
    }
    free(backtraceStack);
}


/// 分析卡顿期间获取到主线程堆栈，获取频次最高的堆栈和关键方法
- (MBAPMSymbolicatedBacktraceStack *) analysisLagBacktrace {
    MBAPMBacktraceStack *pointStack = [_mainThreadStackMgr getPointStack];
    if(pointStack == NULL) {
        return nil;
    }
    MBAPMSymbolicatedBacktraceStack *backtraceStack = [MBAPMBacktraceLogger mbapm_backtraceOfMainThreadWithStack:pointStack];
    if(pointStack != NULL) {
        free(pointStack);
    }
    MBAPMLogInfo(backtraceStack.wholeStack);
    return backtraceStack;
}

- (void)recordBackStackTrace {
    dispatch_async(_catchBacktraceQueue, ^{
        [self catchMainThreadBacktrace];
    });
}

- (void)appendLagTime:(NSTimeInterval)timeDelta {
    _onceLagTotalTime += timeDelta;
}

- (void)resetDetectStatus {
    _lastTimeDelta = 0;
    _LagCount = 0;
    _onceLagTotalTime = 0;
}

- (void)resetLagStatus {
    _lagStartTime = 0;
    _shortLagCount = 0;
    if(_mainThreadStackMgr) {
        [_mainThreadStackMgr clearThreadStacks];
    }
}


static void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    MBRunloopStateLagDetector *lagDetector = (__bridge MBRunloopStateLagDetector *)info;
    lagDetector.runLoopActivity = activity;
    if(lagDetector.isApplicationInActive) {
        dispatch_semaphore_t semaphore = lagDetector.dispatchSemaphore;
        dispatch_semaphore_signal(semaphore);
    }
}

#pragma mark - Notification Action
- (void)applicationDidBecomeActive {
    MBAPMLogInfo(@"become active");
    _isApplicationInActive = YES;
}

- (void)applicationDidEnterBackground {
    MBAPMLogInfo(@"enter background");
    _isApplicationInActive = NO;
}

@end
