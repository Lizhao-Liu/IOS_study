//
//  MBDebugSchemeViewController.m
//  MBDebug
//
//  Created by FDW on 2023/2/17.
//

#import "MBDebugSchemeViewController.h"

@import MBCommonUILib;
@import Masonry;

@interface MBDebugSchemeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *jumpButton;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *curUrl;

@end

@implementation MBDebugSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.textField];
    [self.view addSubview:self.jumpButton];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheme_cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scheme_cell"];
    }
    if (@available(iOS 14.0, *)) {
        UIListContentConfiguration *config = [UIListContentConfiguration cellConfiguration];
        config.text = dic[@"url"];
        config.secondaryText = dic[@"title"];
        cell.contentConfiguration = config;
    } else {
        cell.textLabel.text = dic[@"url"];
        cell.detailTextLabel.text = dic[@"title"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.resultLabel.text = @"";
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *url = dic[@"url"];
    if (![url isEqualToString:_curUrl]) {
        _curUrl = url;
        self.textField.text = _curUrl;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - event response

- (void)jumpAction:(UIButton *)sender {
    NSString *jumpString = self.textField.text;
    if (!jumpString.length) {
        self.resultLabel.text = @"失败";
        return;
    }
    NSURL *url = [NSURL URLWithString:jumpString];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        if (success) {
            self.resultLabel.text = @"成功";
        } else {
            self.resultLabel.text = @"失败";
        }
    }];
}

#pragma mark - getters
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
            @{@"title": @"运满满司机-scheme", @"url": @"ymm-driver://"},
            @{@"title": @"运满满司机-ul", @"url": @"https://unlink.ymm56.com/ymmdriver/"},
            @{@"title": @"运满满货主-scheme", @"url": @"ymm-consignor://"},
            @{@"title": @"运满满货主-ul", @"url": @"https://unlink.ymm56.com/ymmshipper/"},
            @{@"title": @"货车帮司机-scheme", @"url": @"wlqq.driver://"},
            @{@"title": @"货车帮司机-ul", @"url": @"https://unlink.ymm56.com/hcbdriver/"},
            @{@"title": @"货车帮货主-scheme", @"url": @"wlqq.consignor://"},
            @{@"title": @"货车帮货主-ul", @"url": @"https://unlink.ymm56.com/hcbshipper/"},
            @{@"title": @"冷运-scheme", @"url": @"mbccl-consignor://"},
            @{@"title": @"冷运-ul", @"url": @"https://unlink.ymm56.com/cclshipper/"},
            @{@"title": @"短途司机-scheme", @"url": @"mbsd-driver://"},
            @{@"title": @"短途司机-ul", @"url": @"https://unlink.ymm56.com/sddriver/"},
            @{@"title": @"短途货主-scheme", @"url": @"mbsd-consignor://"},
            @{@"title": @"短途货主-ul", @"url": @"https://unlink.ymm56.com/sdshipper/"},
        ].mutableCopy;
    }
    return _dataArray;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor lightGrayColor];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.equalTo(self.view).offset(20 + self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(-20);
        }];
    }
    return _textField;
}

- (UIButton *)jumpButton {
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _jumpButton.backgroundColor = [UIColor blueColor];
        [_jumpButton setTitle:@"跳转" forState:(UIControlStateNormal)];
        [_jumpButton addTarget:self action:@selector(jumpAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.view addSubview:_jumpButton];
        [_jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.top.equalTo(self.textField.mas_bottom).offset(20);
            make.centerX.equalTo(self.view);
        }];
    }
    return _jumpButton;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_resultLabel];
        [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.jumpButton.mas_bottom).offset(20);
            make.height.mas_equalTo(40);
        }];
    }
    return _resultLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.resultLabel.mas_bottom).offset(20);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
        }];
    }
    return _tableView;
}
@end
