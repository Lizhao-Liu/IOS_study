//
//  YMMRouterErrorViewController.m
//  AliyunOSSiOS
//
//  Created by Trevor Lee on 2020/9/8.
//

#import "YMMRouterErrorViewController.h"
#import "YMMRouterModule.h"
#import <StoreKit/StoreKit.h>

@import MBProjectConfig;
@import MBCommonUILib;
@import MBUIKit;
@import YMMRouterLib;
@import MBDoctorService;

static NSUInteger const kImageViewClickCountThreshold = 3;

@interface YMMRouterErrorViewController () <MBDoctorPVJournalDelegate>{
    long long _imageViewClickCount;
    NSTimeInterval _clickStartTime;
}

@property (nonatomic, assign) YMMRouterStatus routerResponseCode;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *urlPath;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation YMMRouterErrorViewController

+ (instancetype)pageWithPage:(YMMRouterStatus)responseCode
                   urlString:(NSString *)urlString urlPath:(NSString *)urlPath{
    YMMRouterErrorViewController *vc = [self new];
    vc.routerResponseCode = responseCode;
    vc.urlString = urlString;
    vc.urlPath = urlPath;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    self.title = @"温馨提示";
    UIImage *backBtnImage = [UIImage imageNamed:@"YMMRouterModule.bundle/nav_back"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackBtn:)];
    _imageView = [UIImageView.alloc initWithImage:[UIImage imageWithBundle:@"CommonResource" imageName:@"mb_driver_noData"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewOnClick:)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    _urlLabel = [UILabel mb_LabelWithFont:@12 color:@"CCCCCC" alignment:NSTextAlignmentCenter lines:0];
    NSMutableParagraphStyle *style = NSMutableParagraphStyle.new;
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentCenter;
    _urlLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:_urlString?:@"" attributes:@{NSParagraphStyleAttributeName: style}];
    [self.view addSubview:_urlLabel];
    _urlLabel.hidden = YES;
    _reasonLabel = [UILabel new];
    _reasonLabel.font = [UIFont boldSystemFontOfSize:14];
    _reasonLabel.textColor = [@"666666" mb_colorValue];
    _reasonLabel.textAlignment = NSTextAlignmentCenter;
    _reasonLabel.numberOfLines = 0;
    NSString *reasonText = [NSString stringWithFormat:@"App版本过低(%lu)", (unsigned long)_routerResponseCode];
    if (reasonText.length) {
        _reasonLabel.text = reasonText;
        [_reasonLabel sizeToFit];
    }
    [self.view addSubview:_reasonLabel];
    _tipsLabel = [UILabel mb_LabelWithFont:@12 color:@"A0AEC4" alignment:NSTextAlignmentCenter lines:0 text:@"您可以尝试升级最新的APP版本"];
    [self.view addSubview:_tipsLabel];
    
    _button = [UIButton.alloc initWithFrame:CGRectMake(0, 0, 120, 32)];
    [_button setTitle:@"检查更新" forState:UIControlStateNormal];
    [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _button.backgroundColor = MBColorHex(0xFA871E);
    _button.layer.cornerRadius = 4;
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(onButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _imageView.instantLayouter.centerX(self.view.width/2.f).y(140);
    _urlLabel.instantLayouter.fitsHeight(self.view.width - 80).centerX(_imageView.centerX).bottom(self.view.bottom - 22);
    _reasonLabel.instantLayouter.fitsHeight(self.view.width - 100).y(_imageView.bottom).centerX(_imageView.centerX);
    _tipsLabel.instantLayouter.fitsHeight(self.view.width - 100).y(_reasonLabel.bottom + 6).centerX(_imageView.centerX);
    _button.instantLayouter.centerX(_imageView.centerX).y(_tipsLabel.bottom + 20);
}

- (void)onButtonAction {
    [[YMMRouterCenter shared]performWithURLString:@"ymm://view/about?auto_check=true" completion:^(YMMRouterResponse * _Nullable response) {
        UIViewController *currentVC = [UIViewController mb_currentViewController];
        if (currentVC && response.result && [response.result isKindOfClass:[UIViewController class]]) {
                [currentVC.navigationController pushViewController:response.result animated:YES];
        }
        }];
}

- (void)imageViewOnClick:(UITapGestureRecognizer*)sender {
    // 3s内连续触发3次则显示url
    long long currentTimeStamp = [self currentTimestamp];
    if (currentTimeStamp - _clickStartTime > 3000) {
        _imageViewClickCount = 1;
        _clickStartTime = currentTimeStamp;
    } else {
        _imageViewClickCount++;
        if (_imageViewClickCount >= kImageViewClickCountThreshold) {
            _imageViewClickCount = 0;
            _clickStartTime = 0;
            _urlLabel.hidden = NO;
        }
    }
}

- (void)didClickBackBtn:(UIButton *)sender{
    
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (long long)currentTimestamp {
    struct timeval t;
    gettimeofday(&t,NULL);
    long long dwTime = ((long long)1000000 * t.tv_sec + (long long)t.tv_usec)/1000;
    return dwTime;
}


#pragma mark - MBDoctorPVJournalDelegate

- (MBModuleInfo *)mb_moduleInfo {
    return [[YMMRouterModule getContext] getModuleInfo];
}

- (NSString *)mb_moduleName {
    return @"app";
}

- (nonnull NSString *)mb_pageName {
    return @"app_router_error";
}

- (BOOL)mb_isAutoPV {
    return YES;
}

- (NSDictionary *)mb_journalExtraParams {
    return @{@"errorCode": @(self.routerResponseCode), @"path": self.urlPath?:@""};
}

@end
