//
//  YMMPodFileViewController.m
//  YMMDebug_Example
//
//  Created by sunwei on 2018/9/21.
//  Copyright © 2018年 zhejunshen. All rights reserved.
//

#import "YMMPodFileViewController.h"
@import Masonry;
@import MBUIKit;
#import <YYText/YYTextView.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
@import MBFoundation;

@interface YMMPodFileViewController () <UITextFieldDelegate, YYTextViewDelegate>

@property (nonatomic, strong) UISegmentedControl *fileControl;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) NSArray <NSTextCheckingResult *> *results;
@property (nonatomic, assign) NSInteger currentScrollResultIndex;
@property (nonatomic, strong) YYTextView *textView;
@end

@implementation YMMPodFileViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[IQKeyboardManager sharedManager] disabledToolbarClasses] addObject:[self class]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.textView];
    UIBarButtonItem *copyItem = [[UIBarButtonItem alloc] initWithTitle:@"一键复制" style:UIBarButtonItemStyleDone target:self action:@selector(didClickCopyItem:)];
    self.navigationItem.rightBarButtonItem = copyItem;
    self.navigationItem.titleView = self.fileControl;
    
    CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(statusBarHeight+navBarHeight+10);
        make.right.mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(statusBarHeight+navBarHeight+10);
        make.left.mas_offset(10);
        make.right.mas_equalTo(self.searchButton.mas_left).mas_offset(-10);
        make.height.mas_equalTo(44);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_equalTo(self.searchTextField.mas_bottom).mas_offset(20);
    }];
    
    self.currentScrollResultIndex = -1;
    
    [self reloadOriginTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segment {
    [self.view endEditing:YES];
    [self searchTextFieldDidChanged];
}

- (void)didClickCopyItem:(UIBarButtonItem *)item {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.textView.text;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"复制成功" message:@"贴给研发童鞋看看？(#^.^#)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [controller addAction:ok];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)reloadOriginTextView {
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont systemFontOfSize:12],
    };
    NSString *content = self.fileControl.selectedSegmentIndex == 0 ? ([MBPluginInfos podfileContent] ?: @"") : ([MBPluginInfos manfiestContent] ?: @"");
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    self.textView.attributedText = attributedString;
}

- (void)keyboardWillShown:(NSNotification *)notification {
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = [[notification.userInfo  objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:duration animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-height);
        }];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
        }];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *whitespace = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (![string isEqualToString:whitespace]) {
        return NO;
    }
    return YES;
}

- (void)searchTextFieldDidChanged {
    [self reloadOriginTextView];
    
    NSString *searchText = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *string = self.textView.attributedText.string;
    NSRange stringRange = NSMakeRange(0, string.length);
    
    NSError __autoreleasing *e = nil;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    NSRegularExpression *exp = [[NSRegularExpression alloc] initWithPattern:[NSString stringWithFormat:@"%@", searchText] options:NSRegularExpressionCaseInsensitive error:&e];
    
    NSString *searchCountString = @"0/0 NEXT";
    self.results = [exp matchesInString:string options:NSMatchingReportProgress range:stringRange];
    BOOL isValid = self.results.count && searchText.length;
    
    if (isValid) {
        for (NSTextCheckingResult *result in self.results) {
            [mutableAttributedString setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSBackgroundColorAttributeName: [UIColor systemGreenColor]} range:result.range];
        }
        searchCountString = [NSString stringWithFormat:@"1/%ld NEXT", self.results.count];
        // 默认滚动到首个匹配结果所在行
        NSTextCheckingResult *firstResult = self.results[0];
        [self scrollToRange:firstResult.range];
    }
    
    self.searchButton.enabled = isValid;
    [self.searchButton setTitle:searchCountString forState:UIControlStateNormal];
    self.textView.attributedText = mutableAttributedString;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}

- (void)scrollToRange:(NSRange)range {
    [self.textView scrollRangeToVisible:range];
}

- (void)didClickNextButton:(UIButton *)btn {
    [self.searchTextField resignFirstResponder];
    self.currentScrollResultIndex++;
    if (self.currentScrollResultIndex >= self.results.count) {
        self.currentScrollResultIndex = 0;
    }
    
    NSTextCheckingResult *result = self.results[self.currentScrollResultIndex];
    [self scrollToRange:result.range];
    [self.searchButton setTitle:[NSString stringWithFormat:@"%ld/%ld NEXT", self.currentScrollResultIndex+1,self.results.count] forState:UIControlStateNormal];
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.editable = NO;
    }
    return _textView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"支持大小写模糊搜索";
        _searchTextField.delegate = self;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchTextField.returnKeyType = UIReturnKeyDone;
        _searchTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchTextField.layer.cornerRadius = 4;
        _searchTextField.layer.borderWidth = 1;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
        _searchTextField.leftView = view;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchButton setTitle:@"0/0 NEXT" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[UIColor systemBlueColor].image forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[UIColor lightGrayColor].image forState:UIControlStateDisabled];
        _searchButton.frame = CGRectMake(0, 0, 100, 44);
        _searchButton.layer.cornerRadius = 4;
        _searchButton.layer.masksToBounds = YES;
        _searchButton.enabled = NO;
        [_searchButton addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UISegmentedControl *)fileControl {
    if (!_fileControl) {
        _fileControl = [[UISegmentedControl alloc] initWithItems:@[@"Podfile", @"Manfiest.lock"]];
        _fileControl.frame = CGRectMake(0, 0, 200, 44);
        _fileControl.selectedSegmentIndex = 0;
        [_fileControl setBackgroundImage:[UIColor systemGrayColor].image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_fileControl setBackgroundImage:[UIColor systemBlueColor].image forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_fileControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _fileControl;
}

@end
