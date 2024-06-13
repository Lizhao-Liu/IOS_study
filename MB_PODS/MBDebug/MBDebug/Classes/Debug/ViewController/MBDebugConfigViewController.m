//
//  MBDebugConfigViewController.m
//  MBDebug
//
//  Created by Lizhao on 2022/11/17.
//

#import "MBDebugConfigViewController.h"
#import "MBDebugConfigCell.h"
#import "MBDebugSchemeViewController.h"

@import Masonry;

@interface MBDebugConfigViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MBDebugConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[MBDebugConfigCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(MBDebugConfigCell.class)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scheme_cell"];
        cell.textLabel.text = @"Scheme 跳转";
        return cell;
    }
    
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        MBDebugSchemeViewController *schemeVC = [[MBDebugSchemeViewController alloc] init];
        [self.navigationController pushViewController:schemeVC animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
