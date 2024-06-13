//
//  MBDebugMonitorToolsEntryHandler.m
//  AAChartKit
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugMonitorToolsEntryHandler.h"
#import "MBDebugMonitorViewController.h"
#import "MBDebugMonitorToolManager.h"
#import "MBDebugDefine.h"
#import "MBDebugMonitorToolModel.h"
#import "MBDebugAlertStateManager.h"
@import MBUIKit;
@import Masonry;
@import MBFoundation;
@import MBDoctorService;

#define RedDotStateProperty @"isRedDotVisible"

@interface MBDebugMonitorToolsEntryHandler ()

@property (nonatomic, weak) MBDebugMonitorViewController *monitorVC;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, strong) UIView *monitorEntryView;

@end


@serviceEX(MBDebugMonitorToolsEntryHandler, MBDebugEntryServiceProtocol)

@synthesize entryTitle;
@synthesize entryView;
@synthesize isHidden;
@synthesize handleBlock;

+ (BOOL)singleton {
    return YES;
}

- (instancetype)init{
    self = [super init];
    if(self){
        [self registerRedDotObserver];
    }
    return self;
}

- (void)registerRedDotObserver {
    [[MBDebugAlertStateManager sharedMBDebugAlertStateManager] addObserver:self forKeyPath:RedDotStateProperty options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [[MBDebugAlertStateManager sharedMBDebugAlertStateManager]removeObserver:self forKeyPath:RedDotStateProperty];
}

- (NSString *)entryTitle {
    return @"数据监控";
}

- (UIView *)entryView {
    return self.monitorEntryView;
}

- (BOOL)isHidden {
    return NO;
}

- (void)entryToolDidLoad {
    [[MBDebugMonitorToolManager sharedMBDebugMonitorToolManager] installMonitorTools];
}

- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        if([vc isKindOfClass:[UIAlertController class]]){
            [MBProgressHUD showToastAddedTo:[UIApplication sharedApplication].delegate.window image:nil labelText:@"请先关闭弹窗" hideAfterDelay:2 isTapToHideEnable:YES withGroupId:0];
            return;
        }
        if(self.monitorVC){
            [self hideMonitorPanel];
        } else {
            self.presentingViewController = vc;
            [self showMonitorPanel];
        }
    };
}

- (UIView *)monitorEntryView {
    if(!_monitorEntryView){
        UIView *bgView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        bgView.cornerRadius = 8;
        bgView.clipsToBounds = NO;
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        UIImageView *entryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        entryView.backgroundColor = [UIColor clearColor];
        entryView.image = [UIImage imageNamed:@"history_trans"];
        [bgView addSubview:entryView];
        [entryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
        }];
        _monitorEntryView = bgView;
        if([MBDebugAlertStateManager sharedMBDebugAlertStateManager].isRedDotVisible){
            [self.monitorEntryView ft_showRedDotAtCenterOffset:CGPointMake(20, -20) withImage:nil];
        } else {
            [self.monitorEntryView ft_hideRedDotView];
        }
    }
    return _monitorEntryView;
}


#pragma mark - event handlers

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:RedDotStateProperty]) {
        NSNumber *isRedDotVisableNum = change[NSKeyValueChangeNewKey];
        BOOL isRedDotVisable = [isRedDotVisableNum boolValue];
        if(isRedDotVisable){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.monitorEntryView ft_showRedDotAtCenterOffset:CGPointMake(20, -20) withImage:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.monitorEntryView ft_hideRedDotView];
            });
        }
    }
}

- (void)hideMonitorPanel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    _monitorVC = nil;
}

- (void)showMonitorPanel{
    MBDebugMonitorViewController *monitorVC = [[MBDebugMonitorViewController alloc] init];
    _monitorVC = monitorVC;
    _monitorVC.currentVC = [UIViewController mb_currentViewController] ; // 为弹起的监听数据面板设置当前页面vc（弱引用） 用于切换到pageonly模式下生成当前vc信息数据
    _monitorVC.currentPageName = [[UIViewController mb_currentViewController] getJournalPageName]; // 为弹起的监听数据面板设置当前页面名称，与vc绑定，用于过滤监听事件数据
    __weak typeof(self) weakSelf = self;
    _monitorVC.closeViewBlock = ^{
        __strong typeof(self) self = weakSelf;
        [self hideMonitorPanel];
    };
    _monitorVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.presentingViewController presentViewController:self.monitorVC animated:YES completion:nil];
}

@end
