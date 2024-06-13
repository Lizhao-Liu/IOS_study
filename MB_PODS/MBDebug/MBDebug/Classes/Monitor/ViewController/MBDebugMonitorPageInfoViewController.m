//
//  MBDebugMonitorPageInfoViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/9/21.
//

#import "MBDebugMonitorPageInfoViewController.h"
#import "MBDebugMonitorLogCellViewModel.h"
#import "MBDebugMonitorPageInfoSectionCell.h"
#import "MBDebugMonitorToolManager.h"
#import "MBDebugMonitorToolModel.h"
@import MBDebugService;
@import Masonry;

@interface MBDebugMonitorPageInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, strong) UIViewController *pageVC;

@property (nonatomic, strong) NSArray<MBDebugMonitorPageInfoModel *> *pageInfoSections;

@end

@implementation MBDebugMonitorPageInfoViewController

- (instancetype)initPageInfoVCWithPageVC:(UIViewController *)pageVC {
    self = [super init];
    if(self){
        _pageVC = pageVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderUI];
}

// 当前页面信息数据
- (NSArray<MBDebugMonitorPageInfoModel *> *)pageInfoSections {
    if(!_pageInfoSections){
        NSArray<MBDebugMonitorToolModel *> *tools = [[MBDebugMonitorToolManager sharedMBDebugMonitorToolManager] monitorTools];
        NSMutableArray *models = @[].mutableCopy;
        for(MBDebugMonitorToolModel *tool in tools){
            if(tool.pageInfoBlock && tool.pageInfoBlock(_pageVC) != nil){
                NSArray<MBDebugMonitorPageInfoModel *> *infos = tool.pageInfoBlock(_pageVC);
                [models addObjectsFromArray:infos];
            }
        }
        _pageInfoSections = models;
    }
    return _pageInfoSections;
}


- (void)renderUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pageInfoSections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MBDebugMonitorPageInfoSectionCellIdentifier";
    MBDebugMonitorPageInfoSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MBDebugMonitorPageInfoSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
       
    MBDebugMonitorPageInfoModel *model = [self.pageInfoSections objectAtIndex:indexPath.row];
    [cell configureWithModel:model];
    
    return cell;
}


- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.allowsSelection = NO;
        
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

- (void)didSwitchToCurrentPageOnlyMode:(NSString *)pageName {
    
}

- (void)didSwitchToGlobalMode {
    
}



@end
