//
//  HCBHostChangeVC.m
//  Runner
//
//  Created by heyAdrian on 2018/10/22.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "HCBHostChangeVC.h"
#import "HCBHostChangeCell.h"
#import "HCBNetworkGasStationHostProvider.h"
#import "config.h"
@import Masonry;
@import MBFoundation;

@interface HCBHostChangeVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSources;
@end

@implementation HCBHostChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color_gray_MC3;
    self.title = @"切换Host";
    [self setupHostDatas];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"HCBHostChangeCell" bundle:KBUNDLE_PT] forCellReuseIdentifier:[HCBHostChangeCell reuseID]];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
    }];
    
}

- (void)setupHostDatas {
    _dataSources = [NSMutableArray array];
    HCBNetworkGasStationHostProvider *provider = [HCBNetworkGasStationHostProvider new];
    NSDictionary *hosts = [provider hostMapForEnv:[HCBNetworkDataManager shareDataManager].serverEnv_type];
    for (NSString *key in hosts) {
        HCBHostChangeModel *model = [[HCBHostChangeModel alloc]initWithHostName:key hostUrl:[hosts mb_objectForKeyIgnoreNil:key]];
        [_dataSources addObject:model];
    }
}

- (void)refreshHost {
    [self setupHostDatas];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCBHostChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:[HCBHostChangeCell reuseID]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HCBHostChangeModel *model = _dataSources[indexPath.row];
    [cell setupWithHostModel:model];
    YMM_Weakify(self, weakSelf)
    cell.changeHostHandler = ^(NSString * _Nonnull hostName, NSString * _Nonnull hostUrl) {
        YMM_Strongify(weakSelf, strongSelf)
        if (hostUrl.length == 0) {
            [MBProgressHUD showToastAddedTo:strongSelf.view imageName:nil labelText:@"新服务地址不可为空！"];
            return ;
        }
        [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES text:@"请稍等..."];
        [HCBNetworkGasStationHostProvider updateHost:hostUrl withHostName:hostName];
        [self refreshHost];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    };
    cell.changeDefaultHostHandler = ^{
        [HCBNetworkGasStationHostProvider restoreHost:model.hostName forEnv:[HCBNetworkDataManager shareDataManager].serverEnv_type];
        [self refreshHost];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




@end
