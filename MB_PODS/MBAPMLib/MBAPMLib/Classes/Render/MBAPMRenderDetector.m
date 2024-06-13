//
//  MBAPMRenderDetector.m
//  MBAPMLib
//
//  Created by Seal on 2020/4/9.
//

#import "MBAPMRenderDetector.h"
#import "MBRenderWeakTimer.h"
#import "MBAPMPageRenderMetric.h"
#import "MBAPMLogDef.h"
@import MBDoctorService;

const int TIMELIMIT = 5; //s
const NSTimeInterval TIME_EXCEPTION = 5.1; //s
const int TIMEGAP   = 50; //ms

@interface MBAPMRenderDetector () {
    
    int _firstVerticalGirdLineHeigh;
    int _secondVerticalGirdLineHeigh;
    int _thirdVerticalGirdLineHeigh;
    int _fourthVerticalGirdLineHeigh;
    int _horizonalGirdLineWeight;
    
    int _times;
    NSTimeInterval _beginTimeInterval;
}

@property (nonatomic, strong) MBAPMViewPageContext *pageContext;
@property (nonatomic, strong) MBRenderWeakTimer *timer;
@property (nonatomic, weak) id<MBRenderDetectDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval detectDuration;
@property (nonatomic, strong) NSMutableSet *gridMutableSet;
@property (nonatomic, assign, getter=isReported) BOOL reported;
@property (nonatomic, assign, getter=isDetecting) BOOL detecting;
@property (nonatomic, assign, getter=isTraversing) BOOL traversing;
@property (nonatomic, assign, getter=isDetectStopped) BOOL detectStopped;

@end

@implementation MBAPMRenderDetector
@synthesize extraData;

#pragma mark - Initialize
- (instancetype)initWithPageContext:(MBAPMViewPageContext *)context {
    self = [super init];
    if(self) {
        [self initGridLines];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abort) name:UIApplicationDidEnterBackgroundNotification object:nil];
        self.pageContext = context;
    }
    return self;
}

- (instancetype)initNonePageContext {
    self = [super init];
    if(self) {
        [self initGridLines];
    }
    return self;
}

#pragma mark - Public

- (void)setDetectDelegate:(id<MBRenderDetectDelegate>)delegate {
    self.delegate = delegate;
}

- (BOOL)begin {
    
    if (!self.pageContext || !self.pageContext.view) {
        return NO;
    }
    if (self.isDetecting) {
        return NO;
    }
    self.detecting = YES;
    
    _beginTimeInterval = [self startTimeInterval];
    
    self.timer = [MBRenderWeakTimer scheduledTimerWithTimeInterval:0.05 start:0 target:self selector:@selector(repeatDetect:) userInfo:nil repeats:YES];
    MBAPMLogInfo(@"apm render begin pageName = %@ beginTime = %f",self.pageContext.pageName, _beginTimeInterval);
    return YES;
}

- (BOOL)abort {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isDetectStopped) {
            MBAPMDebug(@"apm render abort pageName = %@ abortTime = %f",self.pageContext.pageName, [self startTimeInterval]);
            [self stop];
        }
    });
    return YES;
}

- (BOOL)markPoint:(NSString *)pointTag {
    return NO;
}

- (BOOL)end {
    return NO;
}

- (BOOL)end:(NSString *)endTag {
    return NO;
}

#pragma mark - Setter & Getter
- (NSMutableSet *)gridMutableSet {
    if (!_gridMutableSet) {
        _gridMutableSet = [NSMutableSet set];
    }
    return _gridMutableSet;
}

#pragma mark - Private
- (void)repeatDetect:(id)userInfo {
    NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
    if([self isOverTimeWithEndTime:endTime]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopWithEndTime:endTime];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self detectWithRootView];
            });
        }
}

- (void)initGridLines {
    
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    BOOL isIphoneXAndLater = (screenHeight >= 812);
    int navigationBarHeight = isIphoneXAndLater ? 88 : 64;
    int tabBarHeight = isIphoneXAndLater ? 34 + 50 : 50;
    int contentHeight = screenHeight - navigationBarHeight - tabBarHeight;
    
    _firstVerticalGirdLineHeigh = navigationBarHeight;
    _secondVerticalGirdLineHeigh = navigationBarHeight + ceil(contentHeight/3);
    _thirdVerticalGirdLineHeigh = navigationBarHeight + ceil(contentHeight/3)*2;
    _fourthVerticalGirdLineHeigh = navigationBarHeight + contentHeight;
    _horizonalGirdLineWeight = ceil(screenWidth/2);
}

- (void)travesalSubviewsWithView: (UIView *)rootView {
    
    if (self.isDetectStopped) {
        return;
    }
    if (rootView == nil || rootView.hidden == YES || rootView.frame.size.height <= 0 || rootView.frame.size.width <= 0) {
        return;
    }
    if ([rootView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)rootView;
        if (label.text.length > 0) {
            BOOL isHit = [self hitGridWithView:label];
            if(isHit && [self isDetectSuccessful]) {
                [self stopWithUploadData];
            }
        }
    } else if ([rootView isKindOfClass:NSClassFromString(@"RCTText")]) {
        BOOL isHit = [self hitGridWithView:rootView];
        if(isHit && [self isDetectSuccessful]) {
            [self stopWithUploadData];
        }
    } else if ([rootView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)rootView;
        NSArray *visibleCells = [tableview.visibleCells mutableCopy];
        if(visibleCells.count != 0) {
            for (UIView *visibleCell in visibleCells) {
                [self travesalSubviewsWithView:visibleCell];
            }
        } else {
            NSArray *subviews = [rootView.subviews mutableCopy];
            for (UIView *subview in subviews) {
                [self travesalSubviewsWithView:subview];
            }
        }
    } else if ([rootView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)rootView;
        NSArray *visibleCells = [collectionView.visibleCells mutableCopy];
        if(visibleCells.count != 0) {
            for (UIView *visibleCell in visibleCells) {
                [self travesalSubviewsWithView:visibleCell];
            }
        }
    } else {
        if (rootView.subviews.count > 0) {
            NSArray *subviews = [rootView.subviews mutableCopy];
            for (UIView *subview in subviews) {
                [self travesalSubviewsWithView:subview];
            }
        }
    }
    if (self.isDetectStopped) {
        return;
    }
}

- (void)detectWithRootView {
    
    if (self.isDetectStopped) {
        return;
    }
    _times++;
    
    NSTimeInterval start = [self durationTimeWithStart: _beginTimeInterval];
    [self travesalSubviewsWithView:self.pageContext.view];
    NSTimeInterval end = [self durationTimeWithStart: _beginTimeInterval];
    NSTimeInterval detectDuration = end - start;
    self.detectDuration += detectDuration;
    
    if ([self isDetectSuccessful]) {
        [self stopWithUploadData];
        return;
    }
}

- (BOOL)hitGridWithView: (UIView *)view {
    
    CGPoint center = [view convertPoint:view.center toView:[self getKeyWindow]];
    CGFloat centerX = center.x;
    CGFloat centerY = center.y;
    if (centerY > _firstVerticalGirdLineHeigh && centerY < _fourthVerticalGirdLineHeigh && centerX > 0 && centerX < [UIScreen mainScreen].bounds.size.width) {
        if (centerY < _secondVerticalGirdLineHeigh) {
            if (centerX < _horizonalGirdLineWeight) {
                [self.gridMutableSet addObject:@"1"];
            } else {
                [self.gridMutableSet addObject:@"2"];
            }
        } else if (centerY < _thirdVerticalGirdLineHeigh) {
            if (centerX < _horizonalGirdLineWeight) {
                [self.gridMutableSet addObject:@"3"];
            } else {
                [self.gridMutableSet addObject:@"4"];
            }
        } else {
            if (centerX < _horizonalGirdLineWeight) {
                [self.gridMutableSet addObject:@"5"];
            } else {
                [self.gridMutableSet addObject:@"6"];
            }
        }
        return YES;
    }
    return NO;
}

- (void)stopWithUploadData {
    NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
    [self stopWithEndTime:endTime];
}

- (void)stopWithEndTime:(NSTimeInterval)endTime {
    if(self.isDetectStopped) {
        return;
    }
    MBAPMLogInfo(@"apm render stopWithEndTime pageName = %@ startTime = %f, endTime = %f isStopped = %d",self.pageContext.pageName, _beginTimeInterval, endTime, self.isDetectStopped);
    NSTimeInterval totalDuration = endTime - _beginTimeInterval;
    BOOL detectResult = [self isDetectSuccessful];
    if (detectResult) {
        [self reportRenderMetric:totalDuration renderResult:YES detectStatus:YES];
    } else {
        [self reportRenderMetric:TIMELIMIT renderResult:NO detectStatus:NO];
    }
    if(totalDuration > TIME_EXCEPTION) {
        MBAPMWarning(@"apm render stop pageName = %@ detectResult = %d render_time %f > %d beginTime = %f endTime = %f detectTimes = %d detectDuration = %f",self.pageContext.pageName, detectResult, totalDuration, TIMELIMIT, _beginTimeInterval, endTime,  _times, _detectDuration);
    }
    [self stop];
}


- (BOOL)stop {
    if(self.isDetectStopped) {
        return NO;
    }
    _detectStopped = YES;
    _detectDuration = 0;
    _times = 0;
    _beginTimeInterval = 0;
    if(_gridMutableSet) {
        [_gridMutableSet removeAllObjects];
        _gridMutableSet = nil;
    }
    self.pageContext = nil;
    self.detecting = NO;
    [self invalidateTimer];
    return YES;
}

- (void)invalidateTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
    
- (BOOL)isOverTime {
    return [self durationTimeWithStart: _beginTimeInterval] > TIMELIMIT;
}

- (BOOL)isOverTimeWithEndTime:(NSTimeInterval)endTime {
    return endTime - _beginTimeInterval > TIMELIMIT;
}

- (BOOL)isDetectSuccessful {
    return self.gridMutableSet.count > 1;
}

- (UIWindow *)getKeyWindow{
    UIWindow *keyWindow = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        keyWindow = [[UIApplication sharedApplication].delegate window];
    }else{
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    return keyWindow;
}

#pragma mark - Timeinterval

- (NSTimeInterval)startTimeInterval {
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    return start;
}

- (NSTimeInterval)durationTimeWithStart: (NSTimeInterval)start {
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval duration = end - start;
    return duration;
}

#pragma mark - MBRenderDetectDelegate

- (void)reportRenderMetric:(NSTimeInterval)timeInterval renderResult:(BOOL)renderResult detectStatus:(BOOL)detectStatus {
    if(self.isReported) {
        return;
    }
    self.reported = YES;
    MBAPMPageRenderMetric *metric = [[MBAPMPageRenderMetric alloc]init];
    metric.performanceType = MBAPMPerformanceTypePageRender;
    metric.metricName = @"performance.pageview";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = self.pageContext.pageName;
    metric.pageType = self.pageContext.renderType;
    metric.detectType = self.pageContext.detectType;
    metric.renderResult = renderResult;
    metric.detectStatus = detectStatus?MBAPMRenderDetectTimeOut:MBAPMRenderDetectSuccess;
    metric.metricValue = (UInt64)(timeInterval * 1000);
    metric.detectTimes = _times;
    metric.detectDuration = (UInt64)(self.detectDuration * 1000);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onRenderDetectFinish:)]) {
        [self.delegate onRenderDetectFinish:metric];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface MBAPMRenderPageInfo ()
@property (nonatomic, copy) void(^singlePageFinish)(NSUInteger current, NSUInteger total);

@end

@implementation MBAPMRenderPageInfo

- (instancetype)createOne {
    return [self initNonePageContext];
}

- (void)getViewMeshingHitCount:(UIView *)view completion:(void (^)(NSUInteger, NSUInteger))completion {
    _singlePageFinish = completion;
    [self travesalSubviewsWithView:view];
}

- (void)stopWithUploadData {
    if (_singlePageFinish) {
        _singlePageFinish(self.gridMutableSet.count, 6);
    }
}


@end
