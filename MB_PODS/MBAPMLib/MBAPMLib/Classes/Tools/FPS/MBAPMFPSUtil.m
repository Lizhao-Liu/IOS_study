//
//  MBAPMFPSUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/8/10.
//

#import "MBAPMFPSUtil.h"
#import <mach/mach_types.h>
#import <mach/mach.h>
#import <mach/task_info.h>

@import MMKV;

static NSString *kMBAPMHighFpsFlugKey = @"kMBAPMHighFpsFlugKey";

@interface MBAPMFPSUtil()

@property (nonatomic, strong) CADisplayLink *dLink;
@property (nonatomic, assign) CFTimeInterval lastTimeStamp;
@property (nonatomic, assign) int runTimes;
@property (nonatomic, copy) NSHashTable *fpsCallbacks;

@property (nonatomic, assign) BOOL isHighFpsFlag;
@property (nonatomic, assign) BOOL isNotHighFpsFlag;
@property (nonatomic, assign) int tryCount;

@end

@implementation MBAPMFPSUtil

+ (MBAPMFPSUtil *)sharedInstance {
    static MBAPMFPSUtil * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBAPMFPSUtil alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fpsCallbacks = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsCopyIn) capacity:2];
    }
    return self;
}

- (void)startFPSMonitor:(MBAPMFPSCallback)callback {
    [self.fpsCallbacks addObject:callback];
    if (self.dLink) { return; }
    
    self.dLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsCount:)];
    if ([self isHighFps]) {
        [self.dLink setPreferredFramesPerSecond:60];
//        NSLog(@"😁%s: %d %s😁%@", __FILE_NAME__, __LINE__, __FUNCTION__, @"on 60");
    }
    [self.dLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)fpsCount:(CADisplayLink *)displayLink {
    if(self.lastTimeStamp == 0) {
        self.lastTimeStamp = self.dLink.timestamp;
    } else {
        self.runTimes ++;
        CFTimeInterval useTime = self.dLink.timestamp - self.lastTimeStamp;
        if(useTime < 1) return;
        if (useTime >= 2 && useTime < 60) {
            for (int i = 0; i < (int)useTime; i++) {
                if(self.fpsCallbacks.count > 0) {
                    for (MBAPMFPSCallback fpsCallback in [self.fpsCallbacks mutableCopy]) {
                        fpsCallback(0);
                    }
                }
            }
            useTime = useTime - (int)useTime;
        }
        self.lastTimeStamp = self.dLink.timestamp;
        float fps = self.runTimes / MAX(useTime, 1);
        self.runTimes = 0;
//        NSLog(@"😁%s: %d %s😁%d %f", __FILE_NAME__, __LINE__, __FUNCTION__, self.tryCount , fps);
        if (!self.isHighFpsFlag && fps > 65) {
            [self setIsHighFps]; // 1
            [self.dLink setPreferredFramesPerSecond:60];
//            NSLog(@"😁%s: %d %s😁%@", __FILE_NAME__, __LINE__, __FUNCTION__, @"high");
//            NSLog(@"😁%s: %d %s😁%@", __FILE_NAME__, __LINE__, __FUNCTION__, @"on 60");
        } else if (!self.isHighFpsFlag && self.tryCount == 200) {
            self.tryCount ++;
            [self setIsNotHighFps]; // 2
//            NSLog(@"😁%s: %d %s😁%@", __FILE_NAME__, __LINE__, __FUNCTION__, @"not high");
        } else if (!(self.isNotHighFpsFlag || self.isHighFpsFlag)) {
            self.tryCount ++;
//            NSLog(@"😁%s: %d %s😁%@", __FILE_NAME__, __LINE__, __FUNCTION__, @"counter");
        }
        
        if(self.fpsCallbacks.count > 0) {
            for (MBAPMFPSCallback fpsCallback in [self.fpsCallbacks mutableCopy]) {
                fpsCallback(fps);
            }
        }
    }
}

- (void)stopFPSMonitor {
    if(self.dLink) {
        [self.dLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

// MARK: - private

- (BOOL)isHighFps {
    NSUInteger value = [[MMKV defaultMMKV] getUInt64ForKey:kMBAPMHighFpsFlugKey];
    self.isHighFpsFlag = value == 1;
    self.isNotHighFpsFlag = value == 2;
    return value == 1;
}

- (void)setIsHighFps {
    self.isHighFpsFlag = YES;
    [[MMKV defaultMMKV] setUInt64:1 forKey:kMBAPMHighFpsFlugKey];
}

- (BOOL)isNotHighFps {
    NSUInteger value = [[MMKV defaultMMKV] getUInt64ForKey:kMBAPMHighFpsFlugKey];
    self.isNotHighFpsFlag = value == 2;
    self.isHighFpsFlag = value == 1;
    return value == 2;
}

- (void)setIsNotHighFps {
    self.isNotHighFpsFlag = YES;
    [[MMKV defaultMMKV] setUInt64:2 forKey:kMBAPMHighFpsFlugKey];
}

@end
