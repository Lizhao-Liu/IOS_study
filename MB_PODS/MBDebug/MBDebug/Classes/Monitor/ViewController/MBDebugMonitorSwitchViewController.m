//
//  MBDebugMonitorSwitchViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/19.
//

#import "MBDebugMonitorSwitchViewController.h"
#import "MBDebugSwitchCell.h"
#import "MBDebugMonitorToolManager.h"
#import "MBDebugMonitorToolModel.h"
#import "MBDebugAlertStateManager.h"
@import MBFoundation;
@import Masonry;
@import MBUIKit;


@interface MBDebugMonitorSwitchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<MBDebugMonitorToolModel *> *monitorTools;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;

@end

@implementation MBDebugMonitorSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.monitorTools.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1){
        return [self headerViewWithName:@"监听提示配置"];
    } else if (section == 0){
        return [self headerViewWithName:@"数据监听开关"];
    }
    return nil;
}

- (UIView *)headerViewWithName:(NSString *)title {
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    UILabel *orderSectionHeaderLabel = [[UILabel alloc] init];
    orderSectionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    orderSectionHeaderLabel.text = title;
    orderSectionHeaderLabel.font = [UIFont boldSystemFontOfSize:14];
    [header addSubview:orderSectionHeaderLabel];
    [orderSectionHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_offset(0);
    }];
    return header;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        MBDebugSwitchCell *cell = [[MBDebugSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(MBDebugSwitchCell.class)];
        YMM_Weakify(self, weakSelf);
        if(self.monitorTools[indexPath.row].monitorStatusChangedBlock){
            cell.switchButtonBlock = ^(BOOL isOn) {
                YMM_Strongify(weakSelf, strongSelf);
                [strongSelf switchBtnAtIndex:indexPath.row withState:isOn];
            };
        } else {
            cell.switchBtnDisabled = YES;
        }
        
        cell.switchBtnOn = self.monitorTools[indexPath.row].monitorStatusBlock();
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.monitorTools[indexPath.row].title;
        return cell;
    } else {
        MBDebugSwitchCell *cell = [[MBDebugSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(MBDebugSwitchCell.class)];
        YMM_Weakify(self, weakSelf);
        cell.switchButtonBlock = ^(BOOL isOn) {
            YMM_Strongify(weakSelf, strongSelf);
            [strongSelf toastSwitch:isOn];
        };
        cell.switchBtnOn = ![MBDebugAlertStateManager sharedMBDebugAlertStateManager].isToastAlertDisabled;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"toast提示开关";
        return cell;
    }
}

- (void)toastSwitch:(BOOL)isOn {
    [MBDebugAlertStateManager sharedMBDebugAlertStateManager].isToastAlertDisabled = !isOn;
}

- (void)switchBtnAtIndex:(NSInteger)index withState:(BOOL)isOn {
    if(self.monitorTools[index].monitorStatusChangedBlock){
        self.monitorTools[index].monitorStatusChangedBlock(isOn);
    }
}

- (void)initView {
    self.title = @"监听开关";
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSArray<MBDebugMonitorToolModel *> *)monitorTools {
    NSArray<MBDebugMonitorToolModel *> *allMonitorTools = [MBDebugMonitorToolManager sharedMBDebugMonitorToolManager].monitorTools;
    return allMonitorTools;
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
