//
//  MBAPMFPSDataManager.m
//  AAChartKit-AAChartKitLib
//
//  Created by 别施轩 on 2023/7/11.
//

#import "MBAPMFPSDataManager.h"
#import "MBAPMTimeUtil.h"

@import YMMModuleLib;

@interface MBAPMFPSNode : NSObject
/// 事件类型
/// 1 2 页面出现消失
/// 3 4 页面 launch begin end
/// 5 6 scroll 滑动 begin end
/// 7 8  fps cpu
/// 9 10  enterBack enterFore
@property (nonatomic, assign) NSUInteger event;
@property (nonatomic, strong) NSString *eventIdentifier;
@property (nonatomic, assign) CGFloat fps;
@property (nonatomic, assign) CGFloat cpu;
@property (nonatomic, assign) NSUInteger timestamp;
@property (nonatomic, strong) MBModuleInfo *moduleInfo;
@end

@implementation MBAPMFPSNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timestamp = [MBAPMTimeUtil currentTimestamp];
    }
    return self;
}
@end

@implementation MBAPMFPSDataResponse

@end

@interface MBAPMFPSDataManager () {
    
    dispatch_queue_t _dataQueue;
    NSString *_currentPageName;
    // 原始数据
    NSMutableArray<id> *_dataItems;
    // 页面信息
    NSMutableDictionary <NSString*, NSArray *> *_pageUrlInfoDic;
    NSMutableDictionary <NSString*, NSNumber *> *_pageTimeDic;
    NSMutableDictionary <NSString*, NSNumber *> *_pageBeginTimeDic;
}

@end

@implementation MBAPMFPSDataManager

// MARK: - interface
+ (MBAPMFPSDataManager *)sharedInstance {
    static MBAPMFPSDataManager * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBAPMFPSDataManager alloc] init];
    });
    return _manager;
}

- (void)receivePageViewAppear:(NSString *)pageName moduleInfo:(MBModuleInfo *)moduleInfo {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.eventIdentifier = pageName;
    node.event = 1;
    node.moduleInfo = moduleInfo;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}
- (void)receivePageViewDisappear:(NSString *)pageName {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.eventIdentifier = pageName;
    node.event = 2;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
        
        //清理
        NSUInteger len = self->_dataItems.count - 300;
        if (len > 0 && len < self->_dataItems.count) {
            [self->_dataItems removeObjectsInRange:NSMakeRange(0, len)];
        }
    });
}

- (void)receivePageViewLaunchBegin:(NSString *)pageName {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.eventIdentifier = pageName;
    node.event = 3;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}
- (void)receivePageViewLaunchEnd:(NSString *)pageName {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.eventIdentifier = pageName;
    node.event = 4;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}

- (void)receiveViewScrollBegin:(NSString *)scrollId {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.eventIdentifier = scrollId;
    node.event = 5;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}
- (void)receiveViewScrollEnd:(NSString *)scrollId {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.eventIdentifier = scrollId;
    node.event = 6;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}

- (void)receiveFps:(CGFloat)fps {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.fps = fps;
    node.event = 7;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}
- (void)receiveCpu:(CGFloat)cpu {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.cpu = cpu;
    node.event = 8;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}

- (MBAPMFPSDataResponse *)pageFps:(NSString *)pageName {
    return [self getResponseFromIdentifier:pageName endEvent:2];
}
- (MBAPMFPSDataResponse *)pageLaunchFps:(NSString *)pageName {
    return [self getResponseFromIdentifier:pageName endEvent:4];
}
- (MBAPMFPSDataResponse *)pageScrollFps:(NSString *)scrollId {
    return [self getResponseFromIdentifier:scrollId endEvent:6];
}

- (void)didEnterBackground {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.event = 9;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}

- (void)willEnterForeground {
    MBAPMFPSNode *node = [[MBAPMFPSNode alloc] init];
    node.event = 10;
    dispatch_async(_dataQueue, ^{
        [self->_dataItems addObject:node];
    });
}

// MARK: - private

//fps_detail丢帧评分计算方法：例如{0:12, 1:5, 2:10}，表示这期间：
//有12次绘制的回调间隔小于16ms，没有发生丢帧。
//有5次绘制回调的间隔在 (1~2) * 16ms之间。
//有10次绘制回调的间隔在 (3~6) * 16ms * 22之间。
//假设滑动时长2000ms，则评分为( 0 * 16 * 2^0 * 12 + 1 * 16 * 2^1 * 5 + 2 * 16 * 2^2 * 10) / 27000 = 0.05。0.72*100 = 5。
- (MBAPMFPSDataResponse *)getResponseFromIdentifier:(NSString *)eventIdentifier endEvent:(NSUInteger)event {
    __block NSArray *nodes;
    dispatch_barrier_sync(_dataQueue, ^{
        nodes = [self->_dataItems mutableCopy];
    });
    BOOL shouldHandle = NO;
    
    NSUInteger endT = 0;
    NSUInteger beginT = 0;
    NSUInteger fpsCount0 = 0;
    NSUInteger fpsCount1 = 0;
    NSUInteger fpsCount2 = 0;
    NSUInteger fpsCount3 = 0;
    NSUInteger fpsCount4 = 0;
    NSUInteger fpsCount5 = 0;
    NSUInteger totalFps = 0;
    NSUInteger totalFpsCount = 0;
    NSUInteger cpuCount0 = 0;
    NSUInteger cpuCount1 = 0;
    NSUInteger cpuCount2 = 0;
    NSUInteger cpuCount3 = 0;
    NSUInteger cpuCount4 = 0;
    NSUInteger cpuCount5 = 0;

    MBModuleInfo *moduleInfo;
    for (MBAPMFPSNode *node in [nodes reverseObjectEnumerator]) {
        if (node.event == 9 || node.event == 10) {
            return nil;
        }
        
        if (node.event == event) {
            shouldHandle = [node.eventIdentifier isEqualToString:eventIdentifier];
            if (shouldHandle) {
                endT = node.timestamp;
            } else {
                beginT = node.timestamp;
                moduleInfo = node.moduleInfo;
                break;
            }
        } else if (node.event == event - 1) {
            shouldHandle = NO;
            beginT = node.timestamp;
            break;
        }
        if (!shouldHandle) { continue;}
        if (node.event == 7) {
            totalFps += node.fps;
            totalFpsCount += 1;
            if (60 - node.fps <= 0) {
                fpsCount0 += 1;
            } else if (60 - node.fps <= 2) {
                fpsCount1 += 1;
            } else if (60 - node.fps <= 6) {
                fpsCount2 += 1;
            } else if (60 - node.fps <= 13) {
                fpsCount3 += 1;
            } else if (60 - node.fps <= 24) {
                fpsCount4 += 1;
            } else {
                fpsCount5 += 1;
            }
        } else if (node.event == 8) {
            if (node.cpu <= 5) {
                cpuCount0 += 1;
            } else if (node.cpu <= 10) {
                cpuCount1 += 1;
            } else if (node.cpu <= 20) {
                cpuCount2 += 1;
            } else if (node.cpu <= 40) {
                cpuCount3 += 1;
            } else if (node.cpu <= 80) {
                cpuCount4 += 1;
            } else {
                cpuCount5 += 1;
            }
        }
    }
    if (endT - beginT > 0
        && totalFpsCount >= 1) {
        // go on
    } else {
        return nil;
    }
    CGFloat fpsScore = (0 * 16 * 1 * fpsCount0
                        + 1 * 16 * 2 * fpsCount1
                        + 2 * 16 * 4 * fpsCount2
                        + 3 * 16 * 8 * fpsCount3
                        + 4 * 16 * 16 * fpsCount4
                        + 5 * 16 * 32 * fpsCount5) * 100 / (totalFpsCount * 1000);
    CGFloat fpsAvg = totalFps / totalFpsCount;
    MBAPMFPSDataResponse *response = [[MBAPMFPSDataResponse alloc] init];
    response.duration = endT - beginT;
    response.fpsScore = MIN(fpsScore, 2500);
    response.pageName = eventIdentifier;
    response.fpsAvg = fpsAvg;
    response.fpsData = [NSString stringWithFormat:@"{0:%lu, 1:%lu, 2:%lu, 3:%lu, 4:%lu, 5:%lu}", fpsCount0, fpsCount1, fpsCount2, fpsCount3, fpsCount4, fpsCount5];
    response.cpuData = @"";
    response.moduleInfo = moduleInfo;
    return response;
}

// MARK: - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_queue_create("com.amh-group.mbapmlib.fps.data", NULL);
        _dataQueue = queue;
        _currentPageName = @"";
        _dataItems = [[NSMutableArray alloc] init];
        _pageUrlInfoDic = [[NSMutableDictionary alloc] init];
        _pageTimeDic = [[NSMutableDictionary alloc] init];
        _pageBeginTimeDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
