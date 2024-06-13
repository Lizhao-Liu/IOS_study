//
//  MBDebugActivityMonitorDefaultViewController.m
//  MBDebug
//
//  Created by Lizhao on 2022/11/21.
//

#import "MBDebugActivityMonitorDefaultViewController.h"
#import "MBDebugMonitorLogDataSource.h"
#import "MBDebugMonitorLogCell.h"
#import "MBDebugMonitorLogCellViewModel.h"
#import "MBDebugMonitorDetailViewController.h"
#import "MBDebugMonitorDropDownMenu.h"
@import Masonry;
@import MBUIKit;
#import "MBDebugAlertStateManager.h"

#define kDefaultFilter @"ALL"

@protocol MBDebugActivityMonitorFilterProtocol <NSObject>

- (BOOL)shouldUseFilter;

- (BOOL)shouldIncludeModel:(MBDebugMonitorCellViewModel *)model;

@optional

- (void)setUpFilterItems:(MBDebugMonitorCellViewModel *)model;

@end

@interface MBDebugActivityMonitorKeywordFilter : NSObject<MBDebugActivityMonitorFilterProtocol>

@property (nonatomic, strong) NSString *keyword;

@end

@implementation MBDebugActivityMonitorKeywordFilter

- (instancetype)init {
    self = [super init];
    if(self){
        _keyword = @"";
    }
    return self;
}

- (BOOL)shouldUseFilter {
    if(!_keyword || _keyword.length == 0){
        return NO;
    }
    return YES;
}

- (BOOL)shouldIncludeModel:(MBDebugMonitorCellViewModel *)model {
    NSString *searchStr = [model.originalObject searchStr].lowercaseString;
    return [searchStr containsString:self.keyword];
}

@end

@interface MBDebugActivityMonitorTagFilter : NSObject<MBDebugActivityMonitorFilterProtocol>

@property (nonatomic, strong) NSString *tag;

@property (nonatomic, strong) NSMutableSet *tagSet;

@end

@implementation MBDebugActivityMonitorTagFilter

- (instancetype)init{
    self = [super init];
    if(self){
        _tagSet = [NSMutableSet set];
        _tag = kDefaultFilter;
    }
    return self;
}

- (BOOL)shouldUseFilter {
    if(!_tag || [_tag isEqualToString:kDefaultFilter]){
        return NO;
    }
    return YES;
}

- (BOOL)shouldIncludeModel:(MBDebugMonitorCellViewModel *)model {
    
    NSAssert([model.originalObject conformsToProtocol:@protocol(MBDebugMonitorLogCellObject)], @"%@ must conform to MBDebugMonitorLogCellObject Protocol", model.originalObject);
    MBDebugMonitorLogCellViewModel *viewModel = (MBDebugMonitorLogCellViewModel *)model;
    
    if(![viewModel tagModel] || ![viewModel tagModel].tagName){ // 数据未声明tag
        return NO;
    }
    
    return [[viewModel tagModel].tagName isEqualToString:self.tag];
    
}

- (void)setUpFilterItems:(MBDebugMonitorCellViewModel *)model {
    NSAssert([model.originalObject conformsToProtocol:@protocol(MBDebugMonitorLogCellObject)], @"%@ must conform to MBDebugMonitorLogCellObject Protocol", model.originalObject);
    
    MBDebugMonitorLogCellViewModel *viewModel = (MBDebugMonitorLogCellViewModel *)model;
    
    if(![viewModel tagModel]|| ![viewModel tagModel].tagName){
        return;
    }
    
    [self.tagSet addObject:[viewModel tagModel].tagName];
}

- (NSArray *)filterItems {
    NSMutableArray *filteredItems = _tagSet.allObjects.mutableCopy;
    [filteredItems addObject:kDefaultFilter];
    return filteredItems;
}


@end

@interface MBDebugActivityMonitorSourceFilter : NSObject<MBDebugActivityMonitorFilterProtocol>

@property (nonatomic, strong) NSString *source;

@property (nonatomic, assign) MBDebugMonitorSourceFilterType filterType;

@property (nonatomic, strong) NSMutableSet *sourceSet;

@property (nonatomic, strong) NSArray *filterItems;

@end

@implementation MBDebugActivityMonitorSourceFilter

- (instancetype)init{
    self = [super init];
    if(self){
        _sourceSet = [NSMutableSet set];
        _source = kDefaultFilter;
    }
    return self;
}

- (BOOL)shouldUseFilter {
    if(!self.source || [self.source isEqualToString:kDefaultFilter]){
        return NO;
    }
    return YES;
}

- (BOOL)shouldIncludeModel:(MBDebugMonitorCellViewModel *)model {
    if(!self.source || [self.source isEqualToString:kDefaultFilter]){
        return YES;
    }
    if(![model locatorModel]){
        return NO;
    }
    
    return [[self matchString:model] isEqualToString:self.source];
}

- (NSString *)matchString:(MBDebugMonitorCellViewModel *)model {
    NSString *sourceName;
    switch(self.filterType){
        case MBDebugMonitorPanelSourceFilterWithPageName: {
            sourceName = [model locatorModel].pageName;
            break;
        }
        case MBDebugMonitorPanelSourceFilterWithbundleName:{
            sourceName = [model locatorModel].bundleName;
            break;
        }
        case MBDebugMonitorPanelSourceFilterWithbundleType: {
            sourceName = [model locatorModel].bundleType;
            break;
        }
        case MBDebugMonitorPanelSourceFilterWithModuleName: {
            sourceName = [model locatorModel].moduleName;
            break;
        }
        case MBDebugMonitorPanelSourceFilterWithSubmoduleName: {
            sourceName = [model locatorModel].submoduleName;
            break;
        }
    }
    return sourceName;
}

- (void)setUpFilterItems:(MBDebugMonitorLogCellViewModel *)model {
    if(![model locatorModel] || ![self matchString:model]){
        return;
    }
    
    [self.sourceSet addObject:[self matchString:model]];
}

- (NSArray *)filterItems {
    NSMutableArray *filteredItems = _sourceSet.allObjects.mutableCopy;
    [filteredItems addObject:kDefaultFilter];
    return filteredItems;
}

@end

@interface MBDebugActivityMonitorPageNameFilter : NSObject<MBDebugActivityMonitorFilterProtocol>

@property (nonatomic, strong) NSString *pageName;

@end

@implementation MBDebugActivityMonitorPageNameFilter

- (instancetype)init{
    self = [super init];
    if(self){
        _pageName = nil;
    }
    return self;
}


- (BOOL)shouldUseFilter {
    if(!_pageName){
        return NO;
    }
    return YES;
}

- (BOOL)shouldIncludeModel:(MBDebugMonitorCellViewModel *)model {
    if(!_pageName){
        return YES;
    }
    
    if(![model respondsToSelector:@selector(locatorModel)]){
        return NO;
    }
    
    return [[model locatorModel].pageName isEqualToString:self.pageName];
}

@end


@interface MBDebugActivityMonitorDefaultViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBDebugMonitorDropMenuDelegate>

@property (nonatomic, strong) id<MBDebugMonitorLogDataSourceProtocol> dataSource;
@property (nonatomic, copy) NSArray<MBDebugMonitorCellViewModel *> *filteredItems; //筛选后的展示数据
@property (nonatomic, copy) NSArray<MBDebugMonitorCellViewModel *> *allLogEventArray; //全部数据

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIViewController *presentingVC;

@property (nonatomic, strong) UIButton *clearBtn; //清空button
@property (nonatomic, strong) UIButton *refreshBtn; //刷新button
@property (nonatomic, strong) UIButton *showErrorBtn; //异常数据筛选button

@property (nonatomic, strong) UIButton *tagFilterBtn;
@property (nonatomic, strong) MBDebugMonitorDropDownMenu *tagFilterMenu;
@property (nonatomic, strong) UIButton *sourceFilterBtn;
@property (nonatomic, strong) MBDebugMonitorDropDownMenu *sourceFilterMenu;


@property (nonatomic, strong) MBDebugActivityMonitorTagFilter *tagFilter;
@property (nonatomic, strong) MBDebugActivityMonitorSourceFilter *sourceFilter;
@property (nonatomic, strong) MBDebugActivityMonitorKeywordFilter *keywordFilter;
@property (nonatomic, strong) MBDebugActivityMonitorPageNameFilter *pageNameFilter;
@property (nonatomic, strong) NSMutableArray<id<MBDebugActivityMonitorFilterProtocol>> *filters;


@property (nonatomic, assign) BOOL isShowError;

@property (nonatomic, strong) NSString *tagFilterTitle;
@property (nonatomic, assign) BOOL needShowTagFilter;
@property (nonatomic, strong) NSString *sourceFilterTitle;
@property (nonatomic, assign) BOOL needShowSourceFilter;
@property (nonatomic, assign) MBDebugMonitorSourceFilterType sourceFilterType;

@property (nonatomic, strong) UIView *bottomOperationBar;

@end

@implementation MBDebugActivityMonitorDefaultViewController

- (instancetype)initWithDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)dataSource configuration:(MBDebugMonitorPanelConfigModel *)config {
    self = [self initWithDataSource:dataSource];
    if(self){
        _needShowTagFilter = config.needShowTagFilter;
        _needShowSourceFilter = config.needShowSourceFilter;
        if(_needShowTagFilter){
            _tagFilterTitle = config.tagFilterTitle;
        }
        if(_needShowSourceFilter){
            _sourceFilterTitle = config.sourceFilterTitle;
            _sourceFilterType = config.sourceFilterType;
        }
    }
    return self;
}

- (instancetype)initWithDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)dataSource {
    self = [super init];
    if(self){
        _dataSource = dataSource;
        _isShowError = NO;
        _filters = @[].mutableCopy;
    }
    return self;
}

#pragma mark - life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    [self updateErrorButtonIndicator];
    [self renderUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.needShowTagFilter && self.tagFilterMenu.isPresented){
        [self didClickFilterBtn:self.tagFilterBtn]; // 滑动时隐藏筛选条
    }
    
    if(self.needShowSourceFilter && self.sourceFilterMenu.isPresented){
        [self didClickFilterBtn:self.sourceFilterBtn]; // 滑动时隐藏筛选条
    }
}

- (void)renderUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(5);
        make.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomOperationBar];
    [self.bottomOperationBar mas_makeConstraints: ^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.tableView.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
        make.left.right.mas_equalTo(0);
    }];
}

// table滚回顶部
- (void)scrollToTop {
    if ([self.tableView numberOfRowsInSection:0]) {
       NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:0 inSection:0];
       [self.tableView scrollToRowAtIndexPath:indexPathOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
   }
}

- (void)updateErrorButtonIndicator {
    if([[MBDebugAlertStateManager sharedMBDebugAlertStateManager] shouldShowRedDot:self.dataSource]){
        [self.showErrorBtn ft_showRedDotAtCenterOffset:CGPointMake(30, 10) withImage:nil];
    } else {
        [self.showErrorBtn ft_hideRedDotView];
    }
}

#pragma mark - data processors

- (void)refreshData {
    _allLogEventArray = [self cellModelsWithOriginalObjects:self.dataSource.allObjects];
    [self updateData];
    [self scrollToTop];
}

- (void)refreshErrorData {
    _allLogEventArray = [self cellModelsWithOriginalObjects:self.dataSource.allErrorObjects];
    [self updateData];
    [self scrollToTop];
}

- (void)updateData {
    _filteredItems =  [NSArray arrayWithArray:_allLogEventArray];
    
    NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:_allLogEventArray.count];
    
    for (MBDebugMonitorCellViewModel *model in _allLogEventArray) {
        BOOL shouldInclude = YES;

        for (id<MBDebugActivityMonitorFilterProtocol> filter in self.filters) {
            if ([filter shouldUseFilter] && ![filter shouldIncludeModel:model]) {
                shouldInclude = NO;
                break; // 如果某一个筛选器决定不包含此模型，则跳出循环
            }
        }

        if (shouldInclude) {
            [filteredArray addObject:model];
        }
    }
    
    _filteredItems = [NSArray arrayWithArray:filteredArray];
    [self.tableView reloadData];
}

- (void)clearData {
    [self.dataSource removeObjects:[self originalObjectsWithCellModels:_filteredItems]];
    [self refreshData];
}


- (NSArray<MBDebugMonitorCellViewModel *> *)cellModelsWithOriginalObjects:(NSArray<id<MBDebugMonitorLogObject>>*) originalObjects {
    NSMutableArray *arr = @[].mutableCopy;
    NSMutableSet *tagsSet = [NSMutableSet set];
    NSMutableSet *sourceSet = [NSMutableSet set];
    [originalObjects enumerateObjectsUsingBlock:^(id<MBDebugMonitorLogObject>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj conformsToProtocol:@protocol(MBDebugMonitorLogCellObject)]){
            id<MBDebugMonitorLogCellObject> cellObj = (id<MBDebugMonitorLogCellObject>)obj;
            MBDebugMonitorLogCellViewModel *model = [MBDebugMonitorLogCellViewModel cellModelWithObject:cellObj];
            [arr addObject:model];
            if(self.needShowTagFilter){
                [self.tagFilter setUpFilterItems:model];
            }
            if(self.needShowSourceFilter){
                [self.sourceFilter setUpFilterItems:model];
            }
        }
        else {
            MBDebugMonitorCellViewModel *model = [[MBDebugMonitorCellViewModel alloc] init];
            model.originalObject = obj;
            [arr addObject:model];
        }
    }];
    NSMutableArray *tagsArr = tagsSet.allObjects.mutableCopy;
    [tagsArr addObject:kDefaultFilter];
    
    NSMutableArray *sourceArr = sourceSet.allObjects.mutableCopy;
    [sourceArr addObject:kDefaultFilter];
    return arr;
}

- (NSArray<id<MBDebugMonitorLogObject>>*)originalObjectsWithCellModels:(NSArray<MBDebugMonitorCellViewModel *> *) models {
    NSMutableArray *arr = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(MBDebugMonitorCellViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj.originalObject];
    }];
    return arr;
}


#pragma mark - gesture event handlers

- (void)showErrorData {
    if(!_isShowError){
        _isShowError = YES;
        [self.showErrorBtn ft_hideRedDotView];
        [self refreshErrorData];
        // 读取错误数据，隐藏此模块的小红点提示
        [[MBDebugAlertStateManager sharedMBDebugAlertStateManager] hideRedDot:self.dataSource];
        [self.showErrorBtn setTitle:@"全部" forState:UIControlStateNormal];
    } else {
        _isShowError = NO;
        [self refreshData];
        [self.showErrorBtn setTitle:@"异常" forState:UIControlStateNormal];
    }
}

- (void)didClickFilterBtn:(UIButton *)button {
    MBDebugMonitorDropDownMenu *currentMenu;
    NSArray *currentTitles;
    if (button == self.tagFilterBtn) {
        currentMenu = self.tagFilterMenu;
        currentTitles = self.tagFilter.filterItems;
    } else if (button == self.sourceFilterBtn) {
        currentMenu = self.sourceFilterMenu;
        currentTitles = self.sourceFilter.filterItems;
    } else {
        return;
    }

    CGRect btnFrame = button.frame;
    UIView *containerView = self.view;
    CGRect convertedFrame = [self.bottomOperationBar convertRect:btnFrame toView:containerView];
    if (!currentMenu.isPresented) {
        [currentMenu showDropDownMenu:button withButtonFrame:convertedFrame arrayOfTitle:currentTitles animationDirection:@"up"];
        [containerView addSubview:currentMenu];
    } else {
        [currentMenu hideDropDownMenuWithBtnFrame:convertedFrame];
        [currentMenu removeFromSuperview];
    }
}

- (void)didSelectIndex:(NSInteger)index fromMenu:(MBDebugMonitorDropDownMenu *)menu {
    if([menu isEqual:self.tagFilterMenu]){
        NSString *chosenTag = menu.titleList[index];
        self.tagFilter.tag = chosenTag;
        NSString *title = [NSString stringWithFormat:@"%@:\n%@", self.tagFilterTitle, chosenTag];
        [self.tagFilterBtn setTitle:title forState:UIControlStateNormal];
    } else {
        NSString *chosenSource = menu.titleList[index];
        self.sourceFilter.source = menu.titleList[index];
        NSString *title = [NSString stringWithFormat:@"%@:\n%@", self.sourceFilterTitle, chosenSource];
        [self.sourceFilterBtn setTitle:title forState:UIControlStateNormal];
    }
    [self updateData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MBDebugMonitorCellViewModel *model = [self.filteredItems objectAtIndex:indexPath.row];
    
    // 提供view delegate, 使用 view delegate 自定义 cell
    if(self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:withModel:)]){
        UITableViewCell *cell = [self.viewDelegate tableView:tableView cellForRowAtIndexPath:indexPath withModel:model.originalObject];
        if([cell conformsToProtocol:@protocol(MBDebugActivityMonitorExpandableCellProtocol)]){
            id<MBDebugActivityMonitorExpandableCellProtocol> targetCell = (id<MBDebugActivityMonitorExpandableCellProtocol>) cell;
            __weak typeof(self) weakSelf = self;
            targetCell.unfoldBlock = ^() {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.tableView beginUpdates];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView endUpdates];
            };
        }
        return cell;
    }
    
    // 未提供view delegate，使用默认样式 cell
    if([model isKindOfClass:[MBDebugMonitorLogCellViewModel class]]){
        MBDebugMonitorLogCellViewModel *cellModel = (MBDebugMonitorLogCellViewModel *)model;
        static NSString *identifier = @"MBDebugMonitorLogCell";
        MBDebugMonitorLogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[MBDebugMonitorLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell renderCellWithModel:cellModel];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MBDebugMonitorCellViewModel *model = [self.filteredItems objectAtIndex:indexPath.row];
    
    if(self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:withModel:)]){
        [self.viewDelegate didSelectRowAtIndexPath:indexPath withModel:model.originalObject];
        return;
    }
    
    if([model isKindOfClass:[MBDebugMonitorLogCellViewModel class]]){
        MBDebugMonitorDetailViewController *vc = [[MBDebugMonitorDetailViewController alloc] init];
        vc.model = (MBDebugMonitorLogCellViewModel *)model;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [[UIViewController mb_currentViewController] presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 解决UITableViewCell 的分割线向右偏移15像素问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.filteredItems objectAtIndex:indexPath.row];
    if(self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(heightForMonitorCellAtIndexPath:withModel:)]) {
        return [self.viewDelegate heightForMonitorCellAtIndexPath:indexPath withModel:model];
    }
    return UITableViewAutomaticDimension;
}


# pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(id)sender{
    UITextField *senderTextField = (UITextField *)sender;
    //去除首尾空格
    NSString *textSearchStr = [senderTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].lowercaseString;
    self.keywordFilter.keyword = textSearchStr;
    [self updateData];
}

#pragma mark - MBDebugActivityMonitorVCProtocol

- (void)didSwitchToCurrentPageOnlyMode:(NSString *)pageName {
    self.pageNameFilter.pageName = pageName;
    [self refreshData];
}

- (void)didSwitchToGlobalMode {
    self.pageNameFilter.pageName = nil;
    [self refreshData];
}

# pragma mark - getters

- (UIViewController *)presentingVC {
    if(!_presentingVC) {
        UIWindow *screenWindow = [UIApplication sharedApplication].delegate.window;
        UIViewController *presentedViewController = screenWindow.rootViewController;
        while (presentedViewController.presentedViewController) {
            presentedViewController = presentedViewController.presentedViewController;
        }
        _presentingVC = presentedViewController.presentingViewController;
    }
    return _presentingVC;
}

- (MBDebugMonitorDropDownMenu *)tagFilterMenu {
    if(!_tagFilterMenu){
        _tagFilterMenu = [[MBDebugMonitorDropDownMenu alloc] init];
        _tagFilterMenu.delegate = self;
    }
    return _tagFilterMenu;
}

- (MBDebugMonitorDropDownMenu *)sourceFilterMenu {
    if(!_sourceFilterMenu){
        _sourceFilterMenu = [[MBDebugMonitorDropDownMenu alloc] init];
        _sourceFilterMenu.delegate = self;
    }
    return _sourceFilterMenu;
}

- (UIButton *)showErrorBtn {
    if(!_showErrorBtn) {
        _showErrorBtn = [self createButtonWithTitle:@"异常" action:@selector(showErrorData)];
    }
    return _showErrorBtn;
}

- (UIButton *)clearBtn {
    if(!_clearBtn) {
        _clearBtn = [self createButtonWithTitle:@"清空" action:@selector(clearData)];
    }
    return _clearBtn;
}

- (UIButton *)refreshBtn {
    if(!_refreshBtn) {
        _refreshBtn = [self createButtonWithTitle:@"刷新" action:@selector(refreshData)];
    }
    return _refreshBtn;
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)bottomOperationBar {
    if(!_bottomOperationBar){
        CGFloat padding = 10.f;
        CGFloat tagFilterWidth = self.needShowTagFilter ? 40 : 0;
        CGFloat sourceFilterWidth = self.needShowSourceFilter ? 40 : 0;
        
        UIView *bottomBar = [[UIView alloc] init];
        UITextField *keyWordSearchView = [self defaultKeywordSearchView];
        [bottomBar addSubview:self.tagFilterBtn];
        [bottomBar addSubview:self.sourceFilterBtn];
        [bottomBar addSubview:keyWordSearchView];
        [bottomBar addSubview:self.refreshBtn];
        [bottomBar addSubview:self.clearBtn];
        [bottomBar addSubview:self.showErrorBtn];
        
        [self.tagFilterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(padding);
            make.width.mas_equalTo(tagFilterWidth);
            make.top.bottom.mas_equalTo(0);
        }];

        [self.sourceFilterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tagFilterBtn.mas_right).mas_offset(tagFilterWidth > 0 ? padding : 0);
            make.width.mas_equalTo(sourceFilterWidth);
            make.top.bottom.mas_equalTo(0);
        }];
        
        [self.clearBtn mas_makeConstraints: ^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.right.mas_offset(-padding);
            make.width.mas_equalTo(30);
        }];
        
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.right.mas_equalTo(self.clearBtn.mas_left).mas_offset(-padding);
            make.width.mas_equalTo(30);
        }];
        
        [self.showErrorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.right.mas_equalTo(self.refreshBtn.mas_left).mas_offset(-padding);
            make.width.mas_equalTo(30);
        }];
        
        [keyWordSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (tagFilterWidth == 0 && sourceFilterWidth == 0) {
                // 如果两个按钮都为0，keyWordSearchView靠最左对齐
                make.left.mas_equalTo(padding);
            } else if (sourceFilterWidth > 0) {
                // 如果sourceFilterBtn展示，则根据sourceFilterBtn来确定左边距
                make.left.mas_equalTo(self.sourceFilterBtn.mas_right).mas_offset(5);
            } else {
                // 如果只有tagFilterBtn展示
                make.left.mas_equalTo(self.tagFilterBtn.mas_right).mas_offset(5);
            }
            make.right.mas_equalTo(self.showErrorBtn.mas_left).mas_offset(-5);
            make.height.mas_equalTo(35);
            make.centerY.mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        _bottomOperationBar = bottomBar;
    }
    return _bottomOperationBar;
}


- (UITextField *)defaultKeywordSearchView {
    UITextField *textField = [[UITextField alloc] init];
    NSDictionary *attrs = @{NSForegroundColorAttributeName: UIColor.lightGrayColor};
    NSString *placeHolder = @"搜索关键字";
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:attrs];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor whiteColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (UIButton *)tagFilterBtn {
    if(!_tagFilterBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"%@:\n%@", self.tagFilterTitle, kDefaultFilter];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.numberOfLines = 2;
        [btn addTarget:self action:@selector(didClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _tagFilterBtn = btn;
    }
    return _tagFilterBtn;
}

- (UIButton *)sourceFilterBtn {
    if(!_sourceFilterBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"%@:\n%@", self.sourceFilterTitle, kDefaultFilter];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.numberOfLines = 2;
        [btn addTarget:self action:@selector(didClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sourceFilterBtn = btn;
    }
    return _sourceFilterBtn;
}

- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor grayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        
        // 解决UITableViewCell 的分割线向右偏移15像素问题
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins: UIEdgeInsetsZero];
        }
        
    }
    return _tableView;
}

- (MBDebugActivityMonitorKeywordFilter *)keywordFilter {
    if(!_keywordFilter){
        _keywordFilter =  [[MBDebugActivityMonitorKeywordFilter alloc] init];
        [_filters addObject:_keywordFilter];
    }
    return _keywordFilter;
}

- (MBDebugActivityMonitorTagFilter *)tagFilter {
    if(!_needShowTagFilter){
        return nil;
    }
    if(!_tagFilter){
        _tagFilter =  [[MBDebugActivityMonitorTagFilter alloc] init];
        [_filters addObject:_tagFilter];
    }
    return _tagFilter;
}

- (MBDebugActivityMonitorSourceFilter *)sourceFilter {
    if(!_needShowSourceFilter){
        return nil;
    }
    if(!_sourceFilter){
        _sourceFilter = [[MBDebugActivityMonitorSourceFilter alloc] init];
        _sourceFilter.filterType = self.sourceFilterType;
        [_filters addObject:_sourceFilter];
    }
    return _sourceFilter;
}

- (MBDebugActivityMonitorPageNameFilter *)pageNameFilter {
    if(!_pageNameFilter){
        _pageNameFilter = [[MBDebugActivityMonitorPageNameFilter alloc] init];
        [_filters addObject:_pageNameFilter];
    }
    return _pageNameFilter;
}

@end

@implementation MBDebugMonitorPanelConfigModel

@end

