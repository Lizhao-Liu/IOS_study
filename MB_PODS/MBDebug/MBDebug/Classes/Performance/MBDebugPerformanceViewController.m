//
//  MBDebugPerformanceViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugPerformanceViewController.h"
#import "MBDebugSwitchCell.h"
#import "MBDebugEntryManager.h"
#import "MBDebugOscillogramWindowManager.h"
@import Masonry;

@interface MBDebugPerformanceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray<MBDebugOscillogramWindow *> *windowArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;

@end

@implementation MBDebugPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [[MBDebugEntryManager sharedMBDebugEntryManager] hideDebugWindow];
}

- (void)dealloc {
    [[MBDebugEntryManager sharedMBDebugEntryManager] showDebugWindow];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MBDebugSwitchCell *cell = [[MBDebugSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(MBDebugSwitchCell.class)];
    YMM_Weakify(self, weakSelf);
    cell.switchButtonBlock = ^(BOOL isOn) {
        YMM_Strongify(weakSelf, strongSelf);
        [strongSelf switchBtnAtIndex:indexPath.row withState:isOn];
    };
    cell.switchBtnOn = !self.windowArray[indexPath.row].hidden;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)switchBtnAtIndex:(NSInteger)index withState:(BOOL)isOn {
    NSLog(@"%ld, %d", (long)index, isOn);
    if(isOn){
        [self.windowArray[index] show];
    } else {
        [self.windowArray[index] hide];
    }
    
}


- (void)initView {
    self.title = @"性能检测";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    return [MBDebugOscillogramWindowManager shareInstance].performanceOscillogramWindowTitles;
}

- (NSArray<MBDebugOscillogramWindow *> *)windowArray {
    return [MBDebugOscillogramWindowManager shareInstance].performanceOscillogramWindows;
}


- (UIBarButtonItem *)leftBarItem {
    if (!_leftBarItem) {
        _leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitAction:)];
    }
    return _leftBarItem;
}

- (void)exitAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
