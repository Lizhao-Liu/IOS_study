//
//  MBDebugMonitorDetailViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/8/7.
//

#import "MBDebugMonitorDetailViewController.h"
@import YYText;
@import MBUIKit;
@import Masonry;

@interface MBDebugMonitorDetailViewController ()

@property (nonatomic, strong) YYTextView *detailTextView;

@end


@implementation MBDebugMonitorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createLayouts];
    [self initData];
}

- (void)createUI{
    self.title = @"详细信息";
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightBtn:)];
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:self.detailTextView];
}

- (void)createLayouts{
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-5);
    }];
}

- (void)initData{
    self.detailTextView.text = [NSString stringWithFormat:@"\n时间戳：%@\n\n调用来源：\n%@\n\n数据如下：\n%@", self.model.timeStr, self.model.sourceStr, self.model.detailStr];
}

- (void)didClickRightBtn:(UIBarButtonItem *)sender{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.detailTextView.text];
    [MBProgressHUD showToastAddedTo:[UIApplication sharedApplication].delegate.window  successWithText:@"复制成功"];
}

#pragma mark - lazyInit

- (YYTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [[YYTextView alloc] init];
        _detailTextView.textColor = [UIColor whiteColor];
        _detailTextView.font = [UIFont systemFontOfSize:14];
        _detailTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _detailTextView.editable = NO;
    }
    return _detailTextView;
}
@end
