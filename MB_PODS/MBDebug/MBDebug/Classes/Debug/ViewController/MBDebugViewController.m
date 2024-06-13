//
//  MBDebugViewController.m
//  MBDebug
//
//  Created by Ymm on 2019/10/18.
//  Copyright © 2019 YMM. All rights reserved.
//

#import "MBDebugViewController.h"
@import Masonry;
@import MBUIKit;
#import "MBDebugToolModel.h"
#import "MBDebugEntryManager.h"
#import "MBDebugToolsManager.h"
#import "MBDebugToolItemCell.h"
@import MBFoundation;

static NSString * const kMBDebugToolItemCellIdentifier = @"MBDebugToolItemCell";

@interface MBDebugViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<MBDebugToolModel *> *dataArray;
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MBDebugViewController

#pragma mark - Life Cycle Method

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"满帮Debug";
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [[MBDebugEntryManager sharedMBDebugEntryManager] hideDebugWindow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [[MBDebugEntryManager sharedMBDebugEntryManager] showDebugWindow];
}

#pragma mark - Property Method

- (UIBarButtonItem *)leftBarItem {
    if (!_leftBarItem) {
        _leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitAction:)];
    }
    return _leftBarItem;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = kViewBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSArray<MBDebugToolModel *> *)dataArray {
    return [[MBDebugToolsManager sharedMBDebugToolsManager] debugTools];
}

#pragma mark - Action Method

- (void)exitAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method

- (void)initView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource Method
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBDebugToolModel *dataModel = [self.dataArray objectAtIndex:indexPath.row];
    return [MBDebugToolItemCell mb_heightForCellWithItem:dataModel contentWidth:0.f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MBDebugToolItemCell createReuseCellForTableView:tableView withCellIdentifier:kMBDebugToolItemCellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MBDebugToolItemCell class]]) {
        MBDebugToolItemCell *itemCell = (MBDebugToolItemCell *)cell;
        MBDebugToolModel *dataModel = [self.dataArray objectAtIndex:indexPath.row];
        [itemCell mb_configWithItemModel:dataModel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MBDebugToolModel *dataModel = [self.dataArray objectAtIndex:indexPath.row];
    if (dataModel) {
        dataModel.handleBlock(self);
    }
}

@end
