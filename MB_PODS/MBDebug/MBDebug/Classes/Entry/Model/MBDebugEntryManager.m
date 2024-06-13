//
//  MBDebugEntryManager.m
//  Pods
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugEntryManager.h"
#import "MBDebugEntryItemModel.h"
@import MBDebugService;
@import MBUIKit;
@import YMMModuleLib;

#define debugEntryItemWidth 40
#define debugEntryItemHeight 40
#define debugEntryItemMargin 10
#define debugWindowMarginRight 20
#define debugWindowMarginTop 20

@interface MBDebugEntryManager ()<UIGestureRecognizerDelegate> {
    CGPoint _startTouch;
}

@property (nonatomic, strong) NSMutableArray *currentEntryTools;

@property (nonatomic, strong) UIWindow *debugWindow;
@property (nonatomic, strong) UIView *debugEntryView;

@end

@implementation MBDebugEntryManager

DEFINE_SINGLETON_FOR_CLASS(MBDebugEntryManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentEntryTools = [[NSMutableArray alloc] init];
        [self installEntryTools];
    }
    return self;
}

- (void)initDebugWindow {
    // 设置悬浮窗frame
    UIWindow *screenWindow = [UIApplication sharedApplication].delegate.window;
    CGRect frame = self.debugEntryView.frame;
    frame.origin.x =  CGRectGetWidth(screenWindow.frame) - CGRectGetWidth(frame) - debugWindowMarginRight;
    frame.origin.y = debugWindowMarginTop;
    self.debugWindow = [[UIWindow alloc] initWithFrame:frame];
    [self.debugWindow addSubview:self.debugEntryView];
    // 保持悬浮窗显示在最前面
    self.debugWindow.windowLevel = UIWindowLevelAlert+1;
    _debugWindowIsClosed = NO;
    [self showDebugWindow];
}

- (void)removeDebugWindow {
    [self.debugWindow removeAllSubviews];
    self.debugWindow = nil;
    _debugWindowIsClosed = YES;
}

- (void)showDebugWindow {
    if(_debugWindowIsClosed) return;
    self.debugWindow.hidden = NO;
}

- (void)hideDebugWindow {
    if(_debugWindowIsClosed) return;
    self.debugWindow.hidden = YES;
}

#pragma mark - private methods

- (void)installEntryTools {
    NSArray<id<MBDebugEntryServiceProtocol>> *serviceList = (NSArray<id<MBDebugEntryServiceProtocol>> *)[[MBService shared] servicesForProtocol:@protocol(MBDebugEntryServiceProtocol) fromContext:nil];
    if(serviceList){
        for (id<MBDebugEntryServiceProtocol> service in serviceList){
            if(service && [service respondsToSelector:@selector(entryToolDidLoad)]){
                [service entryToolDidLoad];
            }
            if(service && !service.isHidden){
                MBDebugEntryItemModel *entryItem = [[MBDebugEntryItemModel alloc] init];
                entryItem.entryTitle = service.entryTitle;
                if([[self keyEntryTools] containsObjectForKey:entryItem.entryTitle]){
                    entryItem.priority = [[[self keyEntryTools] objectForKey:entryItem.entryTitle] integerValue];
                }
                if([service respondsToSelector:@selector(entryView)] && service.entryView){
                    [entryItem setUpBtnView:service.entryView withHandleBlock:service.handleBlock];
                } else if ([service respondsToSelector:@selector(entryIcon)] && service.entryIcon){
                    [entryItem setUpBtnIcon:service.entryIcon withHandleBlock:service.handleBlock];
                    entryItem.entryButton.frame = CGRectMake(0, 0, debugEntryItemWidth, debugEntryItemHeight);
                } else {
                    [entryItem setUpDefaultBtnWithHandleBlock:service.handleBlock];
                }
                
                [self.currentEntryTools addObject:entryItem];
            }
        }
    }
    [self sortEntryTools];
    [self setUpEntryView];
}

- (void)setUpEntryView {
    CGFloat startY = 0;
    CGFloat width = 0;
    for(MBDebugEntryItemModel *entryItem in self.currentEntryTools){
        CGRect currFrame = entryItem.entryButton.frame;
        currFrame.origin.y = startY;
        entryItem.entryButton.frame = currFrame;
        startY = startY + debugEntryItemHeight + debugEntryItemMargin;
        width = MAX(entryItem.entryButton.size.width, width);
        [self.debugEntryView addSubview:entryItem.entryButton];
    }
    CGRect frame = self.debugEntryView.frame;
    frame.size.height = startY - debugEntryItemMargin;
    frame.size.width = width;
    self.debugEntryView.frame = frame;
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    CGPoint touchPoint = [recoginzer locationInView:_debugEntryView];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _startTouch = touchPoint;
    } else if (UIGestureRecognizerStateChanged == recoginzer.state) {
        self.debugWindow.frame = CGRectMake(CGRectGetMinX(self.debugWindow.frame)+(touchPoint.x - _startTouch.x), CGRectGetMinY(self.debugWindow.frame)+(touchPoint.y - _startTouch.y), CGRectGetWidth(self.debugWindow.frame), CGRectGetHeight(self.debugWindow.frame));
    }
}

- (void)sortEntryTools {
    if(self.currentEntryTools.count > 1) {
        NSArray *entryItems = [self.currentEntryTools sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            MBDebugEntryItemModel *model1, *model2;
            model1 = (MBDebugEntryItemModel *)obj1;
            model2 = (MBDebugEntryItemModel *)obj2;
            if(model1.priority < model2.priority){
                return (NSComparisonResult)NSOrderedDescending;
            } else if(model2.priority < model1.priority){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        [self.currentEntryTools removeAllObjects];
        [self.currentEntryTools addObjectsFromArray:entryItems];
    }
}

#pragma mark - getters

- (NSArray *)debugEntryTools {
    return self.currentEntryTools;
}


- (UIView *)debugEntryView {
    if(!_debugEntryView){
        _debugEntryView = [[UIView alloc] initWithFrame:CGRectZero];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
        pan.delegate = self;
        [_debugEntryView addGestureRecognizer:pan];
    }
    return _debugEntryView;
}

- (NSDictionary *)keyEntryTools {
    return @{
        kMBDebugEntryItemDefaultPerformanceDetection:@(MBDebugEntryItemPriorityCritical),
        kMBDebugEntryItemDefaultMonitorLog:@(MBDebugEntryItemPriorityImportant),
        kMBDebugEntryItemDefaultDebugTools:@(MBDebugEntryItemPriorityImportant)
    };
}


@end
