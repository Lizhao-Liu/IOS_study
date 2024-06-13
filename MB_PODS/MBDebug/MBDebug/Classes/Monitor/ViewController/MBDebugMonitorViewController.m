//
//  MBDebugMonitorViewController.m
//  MBDebug
//
//

#import "MBDebugMonitorViewController.h"
#import "MBDebugMonitorSwitchViewController.h"
#import "MBDebugScrollItemBar.h"
#import "MBDebugMonitorToolModel.h"
#import "MBDebugMonitorToolManager.h"
#import "MBDebugMonitorPageInfoViewController.h"
@import MBUIKit;
@import Masonry;
@import MBDebugService;


@interface MBDebugMonitorVCTabViewModel : NSObject


@property (nonatomic, copy) NSString *title; // 名称
@property (nonatomic, copy) MBDebugMonitorPanelBlock monitorVCBlock; // 返回需要显示的viewcontroller

@property (nonatomic, assign) BOOL needShowErrorIndicator;

@end

@implementation MBDebugMonitorVCTabViewModel

@end

#define NAVBARHEIGHT 40

#define TOPBARHEIGHT 35

#define LastViewedMonitorPanelMode @"lastViewedMonitorPanelMode"

#define LastViewedMonitorPageIndex @"lastViewedMonitorPageIndex"

@interface MBDebugMonitorViewController ()

@property (nonatomic, strong) NSArray<MBDebugMonitorVCTabViewModel *> *viewModels;
@property (nonatomic, strong) NSMutableArray *monitorTitles;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) MBDebugScrollItemBar *navBar;
@property (nonatomic, strong) UIView *topBar;

@property (nonatomic, assign) BOOL isShowPageDataOnlyMode;
@property (nonatomic, strong) MBDebugMonitorVCTabViewModel *pageInfoViewModel;

@end

@implementation MBDebugMonitorViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShowPageDataOnlyMode = [[NSUserDefaults standardUserDefaults] boolForKey:LastViewedMonitorPanelMode];
    [self renderUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 将正在浏览的tab index缓存到本地
    NSInteger pageIndex = self.navBar.currentIndex;
    [[NSUserDefaults standardUserDefaults] setInteger:pageIndex forKey:LastViewedMonitorPageIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:self.isShowPageDataOnlyMode forKey:LastViewedMonitorPanelMode];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 自动打开上次浏览的tab页面
    NSInteger lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LastViewedMonitorPageIndex];
    self.navBar.currentIndex = lastIndex;
}

- (void)dealloc {
    for(UIViewController *childVC in self.childViewControllers){
        [childVC removeFromParentViewController];
        [childVC.view removeFromSuperview];
    }
}

#pragma mark - UI


- (void)renderUI {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.topBar];
    [self setUpNavBarAndContentScroller];
}

- (void)setUpNavBarAndContentScroller {
    for (int i = 0; i < self.viewModels.count; i++){
        if(self.viewModels[i].monitorVCBlock){
            UIViewController *vc = self.viewModels[i].monitorVCBlock();
            [self addChildViewController:vc];
            vc.view.frame = CGRectMake(i * self.contentView.width, 0, self.contentView.width, self.contentView.height);
            [self.contentView addSubview:vc.view];
        }
    }
    self.contentView.contentSize = CGSizeMake(kScreenWidth * self.monitorTitles.count, CGRectGetHeight(_contentView.frame));
    [self.navBar setupItemTitles:self.monitorTitles relevantScrollView:self.contentView];
    [self updateErrorIndicator];
    [self updateChildVCMode];
    [self.containerView addSubview:self.navBar];
    [self.containerView addSubview:self.contentView];
}

- (void)updateErrorIndicator {
    for (NSInteger i = 0; i < _viewModels.count; i ++) {
        MBDebugMonitorVCTabViewModel *model = _viewModels[i];
        if(model.needShowErrorIndicator){
            [self.navBar showRedDotAtIndex:i];
        } else {
            [self.navBar hideRedDotAtIndex:i];
        }
        [self.navBar hideRedDotAtIndex:self.navBar.currentIndex];
    }
}


- (UIView *)containerView{
    if(!_containerView){
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2 - 150, kScreenWidth, kScreenHeight / 2 + 150)];
    }
    return _containerView;
}


- (UIView *)topBar{
    if(!_topBar){
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.width, TOPBARHEIGHT)];
        _topBar.backgroundColor = [UIColor blackColor];
        
        
        UIButton *switchBtn = [self iconButtonWithTitle:@"监听开关" icon:[UIImage imageNamed:@"monitor_switch"]];
        [switchBtn addTarget:self action:@selector(didClickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:switchBtn];
        [switchBtn mas_makeConstraints: ^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_topBar).mas_offset(-5);
            make.centerY.mas_equalTo(_topBar.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
//        [closeBtn setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [closeBtn addTarget:self action:@selector(didClickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:closeBtn];
        [closeBtn mas_makeConstraints: ^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topBar).mas_offset(5);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(_topBar.mas_height);
        }];
        
        NSString *title = self.isShowPageDataOnlyMode ?  @"查看全部" : @"仅看当前页" ;
        UIButton *pageDataOnlyBtn = [self iconButtonWithTitle:title icon:[UIImage imageNamed:@"type_switch"]];
        [pageDataOnlyBtn addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:pageDataOnlyBtn];
        [pageDataOnlyBtn mas_makeConstraints: ^(MASConstraintMaker *make) {
            make.right.mas_equalTo(switchBtn.mas_left).mas_offset(-5);
            make.centerY.mas_equalTo(_topBar.mas_centerY);
            make.width.mas_equalTo(80);
        }];
    }
    return _topBar;
}


- (UIButton *)iconButtonWithTitle: (NSString *)title icon:(UIImage *)icon {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    return btn;
}

- (MBDebugScrollItemBar *)navBar {
    if(!_navBar){
        _navBar = [[MBDebugScrollItemBar alloc]initWithFrame:CGRectMake(0, self.topBar.bottom, self.containerView.width, NAVBARHEIGHT)];
        _navBar.textFont = [UIFont systemFontOfSize:15.0f];
        _navBar.textNormalColor = [UIColor whiteColor];
        _navBar.textSelectedColor = [UIColor yellowColor];
        _navBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];
        _navBar.itemCountPerScreen = 5;
    }
    return _navBar;
}


- (UIScrollView *)contentView {
    if(!_contentView){
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, kScreenWidth, _containerView.height - NAVBARHEIGHT - TOPBARHEIGHT)];
        _contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
        _contentView.pagingEnabled = YES;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.bounces = NO;
    }
    return _contentView;
}

- (NSMutableArray *)monitorTitles {
    _monitorTitles = [[NSMutableArray alloc] init];
    for (MBDebugMonitorVCTabViewModel *model in self.viewModels){
        [_monitorTitles addObject:model.title];
    }
    return _monitorTitles;
}

- (NSArray<MBDebugMonitorVCTabViewModel *> *)viewModels {
    if(!_viewModels){
        NSArray<MBDebugMonitorToolModel *> *tools = [[MBDebugMonitorToolManager sharedMBDebugMonitorToolManager] monitorTools];
        NSMutableArray *models = @[].mutableCopy;
        if(_isShowPageDataOnlyMode){
            [models addObject:self.pageInfoViewModel];
        }
        for(MBDebugMonitorToolModel *tool in tools){
            MBDebugMonitorVCTabViewModel *model = [[MBDebugMonitorVCTabViewModel alloc] init];
            model.monitorVCBlock = tool.monitorVCBlock;
            model.title = tool.title;
            model.needShowErrorIndicator = tool.needShowErrorIndicator;
            [models addObject:model];
        }
        _viewModels = models;
    }
    return _viewModels;
}

#pragma mark - event handlers

- (void)didClickSwitchBtn {
    UIViewController *monitorSwitchVC = [[MBDebugMonitorSwitchViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:monitorSwitchVC];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didClickCloseBtn {
    if(self.closeViewBlock){
        self.closeViewBlock();
    }
}

- (void)switchMode:(UIButton *)btn {
    self.isShowPageDataOnlyMode = !self.isShowPageDataOnlyMode;
    if(self.isShowPageDataOnlyMode){
        [btn setTitle:@"查看全部" forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"仅看当前页" forState:UIControlStateNormal];
    }
}

- (MBDebugMonitorVCTabViewModel *)pageInfoViewModel {
    if(!_pageInfoViewModel){
        // 创建新的 model
        MBDebugMonitorVCTabViewModel *pageInfoViewModel = [[MBDebugMonitorVCTabViewModel alloc] init];
        pageInfoViewModel.title = @"Info";
        __weak typeof(self) weakSelf = self;
        pageInfoViewModel.monitorVCBlock = ^UIViewController<MBDebugActivityMonitorVCProtocol> * _Nonnull{
            __strong typeof(self) strongSelf = weakSelf;
            return [[MBDebugMonitorPageInfoViewController alloc] initPageInfoVCWithPageVC:strongSelf.currentVC];
        };
        pageInfoViewModel.needShowErrorIndicator = NO;
        _pageInfoViewModel = pageInfoViewModel;
    }
    return _pageInfoViewModel;
}

- (void)setIsShowPageDataOnlyMode:(BOOL)isShowPageDataOnlyMode {
    if(isShowPageDataOnlyMode){
        // 在开始处插入到 viewModels
        NSMutableArray *mutableViewModels = [self.viewModels mutableCopy];
        [mutableViewModels insertObject:self.pageInfoViewModel atIndex:0];
        self.viewModels = [mutableViewModels copy];
    } else {
        NSMutableArray *mutableViewModels = [self.viewModels mutableCopy];
        [mutableViewModels removeObject:self.pageInfoViewModel];
        self.viewModels = [mutableViewModels copy];
    }
    _isShowPageDataOnlyMode = isShowPageDataOnlyMode;
    [self updateUIForCurrentMode];
}

- (void)updateUIForCurrentMode {
    for(UIViewController *childVC in self.childViewControllers){
        [childVC removeFromParentViewController];
        [childVC.view removeFromSuperview];
    }
    [self.navBar removeFromSuperview];
    [self.contentView removeFromSuperview];
    self.navBar = nil;
    self.contentView = nil;
    [self setUpNavBarAndContentScroller];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)updateChildVCMode {
    if(self.isShowPageDataOnlyMode){
        for(UIViewController *vc in self.childViewControllers){
            if([vc conformsToProtocol:@protocol(MBDebugActivityMonitorVCProtocol)]){
                id<MBDebugActivityMonitorVCProtocol> childVC = (id<MBDebugActivityMonitorVCProtocol>)vc;
                [childVC didSwitchToCurrentPageOnlyMode:self.currentPageName];
            }
        }
    } else {
        for(UIViewController *vc in self.childViewControllers){
            if([vc conformsToProtocol:@protocol(MBDebugActivityMonitorVCProtocol)]){
                id<MBDebugActivityMonitorVCProtocol> childVC = (id<MBDebugActivityMonitorVCProtocol>)vc;
                [childVC didSwitchToGlobalMode];
            }
        }
    }
    
}



@end
