//
//  YMMRouterDebugErrorViewController.m
//  AFNetworking
//
//  Created by yc on 2019/12/3.
//

#import "YMMRouterDebugErrorViewController.h"

@interface YMMRouterDebugErrorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) YMMRouterDebugClearErrorBlock clearBlock;

@end

@implementation YMMRouterDebugErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"404 URL";
    [self.view addSubview:self.tableView];
    

    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithTitle:@"清楚记录"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clearError)];
    
    self.navigationItem.rightBarButtonItem = clearButton;
    [clearButton setTintColor:[UIColor redColor]];
}

- (void)clearError {
    self.errorSchemes = nil;
    [self.tableView reloadData];
    if (_clearBlock) {
        _clearBlock();
    }
}

- (void)clearErrorSchemes:(YMMRouterDebugClearErrorBlock)clearBlock {
    _clearBlock = clearBlock;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.errorSchemes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMMRouterDebugErrorViewControllerCell"];
    cell.textLabel.text = [self.errorSchemes objectAtIndex:indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YMMRouterDebugErrorViewControllerCell"];
    }
    return _tableView;
}

@end
