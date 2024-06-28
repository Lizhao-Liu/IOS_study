//
//  HCBCodeScanerViewController.m
//  ios4driver
//
//  Created by yangtianyin on 16/1/4.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "HCBCodeScanerViewController.h"
#import "HCBCodeScanerView.h"
#import "HCBCodeScaner.h"
#import "HCBCodeScaner_Private.h"
#import "HCBCodeScanerFakeNavBar.h"
#import "UIImage+HCBCodeScanerExtension.h"
@import ScanKitFrameWork;

@import MBUIKit;
@import MBProgressHUD;
@import MBDoctorService;
@import YMMRouterLib;

#import <AVFoundation/AVFoundation.h>

extern __weak HCBCodeScanerViewController *__current_code_scaner_view_controller;

@interface HCBCodeScanerViewController () <HCBCodeScanerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBDoctorPVJournalDelegate>

@property (nonatomic, strong) HCBCodeScanerView *scanView;

@property (nonatomic, assign) BOOL pickerDismissed;
@property (nonatomic, assign) BOOL viewDidAppeared; //触发结果回调时，需要保证push已经完成
@property (nonatomic, strong) NSString *extractResult;
@property (nonatomic, assign) NSTimeInterval pageEnterSec; //记录打开页面的时间
@property (nonatomic, strong) HCBCodeScanerFakeNavBar *fakeNavBar;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIButton *qrcodeButton;

@property (nonatomic, strong) UIView *animatedMask;

@property (assign, nonatomic) BOOL statusBarLight;

- (void)setup;

@end

@implementation HCBCodeScanerViewController

#pragma mark - Overriding

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupFakeNavBar];

    self.view.backgroundColor = [UIColor whiteColor];

    if (!self.qrCodeNavigatorLink) {
        if (self.formatType == MBCodeScanFormatTypeQR) {
            self.fakeNavBar.titleLabel.text = @"二维码扫描";
        } else {
            self.fakeNavBar.titleLabel.text = @"扫一扫";
        }
        
        self.fakeNavBar.titleLabel.textColor = UIColor.whiteColor;
    } else {
        [self setupBottomBar];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVCaptureSessionDidStartRunningNotification) name:AVCaptureSessionDidStartRunningNotification object:nil];

    if (TARGET_IPHONE_SIMULATOR) {
        //模拟器
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textColor = [UIColor blackColor];
        lbl.text = @"设备不支持使用相机";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.numberOfLines = 0;
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.center = self.view.center;
        lbl.bounds = CGRectMake(0, 0, 200, 200);
        [self.view addSubview:lbl];
        return;
    }else{
        //真机
        [self createScanView];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];

    _pageEnterSec = [[NSDate date] timeIntervalSince1970];

    [self.view addSubview:self.animatedMask];
    [self.view bringSubviewToFront:_fakeNavBar];
    [self.view bringSubviewToFront:_bottomBar];
    [MBProgressHUD showHUDAddedTo:_animatedMask animated:YES];
}

- (void)handleAVCaptureSessionDidStartRunningNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionDidStartRunningNotification object:nil];
        [MBProgressHUD hideHUDForView:_animatedMask animated:YES];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.animatedMask.alpha = 0;
        } completion:^(BOOL finished) {
            [self.animatedMask removeFromSuperview];
        }];
    });
}

- (UIView *)animatedMask {
    if (!_animatedMask) {
        _animatedMask = [[UIView alloc] initWithFrame:self.view.bounds];
        _animatedMask.backgroundColor = [UIColor blackColor];
    }
    return _animatedMask;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setStatusBarLight:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    if (_scanView && _pickerDismissed) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scanView beginScanLine];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewDidAppeared = YES;
    [self triggerScanResultHandlerIfReady];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarLight:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    if (_pickerDismissed) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [_scanView removeScanLine];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_pickerDismissed) {
        [self removeScanerViewControllerIfNeeded];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navHeight = 44;
    CGFloat bottomBarHeight = 80;
    if (@available(iOS 11.0, *)) {
        navHeight = self.view.safeAreaInsets.top + navHeight;
        bottomBarHeight = self.view.safeAreaInsets.bottom + bottomBarHeight;
    } else {
        navHeight += 20;
    }
    _fakeNavBar.frame = CGRectMake(0, 0, self.view.width, navHeight);
    [self.view bringSubviewToFront:_fakeNavBar];
    _scanView.headerLabel = self.headerLabel;
    _scanView.frame = self.view.bounds;

    if (_bottomBar) {
        _bottomBar.frame = CGRectMake(0, self.view.height - bottomBarHeight, self.view.width, bottomBarHeight);
        _scanView.height -= bottomBarHeight;

        _scanButton.center = CGPointMake(_bottomBar.width / 4.f, 40);
        _qrcodeButton.center = CGPointMake(_bottomBar.width / 4.f * 3, 40);
    }
}

- (void)setStatusBarAppearence:(BOOL)isLight {
    self.statusBarLight = isLight;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.statusBarLight) {
        return UIStatusBarStyleLightContent;
    }
    else if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Public

- (void)reActive {
    [_scanView beginScanLine];
}

#pragma mark - Private

- (void)setup {
    __current_code_scaner_view_controller = self;
    _viewDidAppeared = NO;
    _pickerDismissed = YES;
}

- (void)setupFakeNavBar {
    _fakeNavBar = [HCBCodeScanerFakeNavBar new];
    [self.view addSubview:_fakeNavBar];

    [_fakeNavBar addPopBackButtonForViewController:self];
    _fakeNavBar.popBackButton.tintColor = UIColor.whiteColor;

//    if ([HCBCodeScaner sharedScaner].allowedChooseFromAlbum) {
        UIButton *libButton = [UIButton new];
        [libButton setTitle:@"相册" forState:UIControlStateNormal];
        [libButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [libButton addTarget:self action:@selector(onChooseFromAlbumAction) forControlEvents:UIControlEventTouchUpInside];
        [_fakeNavBar setRightButtons:@[libButton]];
//    }
}

- (void)setupBottomBar {
    self.bottomBar = [UIView new];
    self.bottomBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomBar];

    _scanButton = [UIButton new];
    [_scanButton setImage:[UIImage imageNamed_CodeScaner:@"icon_scan"] forState:UIControlStateNormal];
    [_scanButton setTitle:@"扫码" forState:UIControlStateNormal];
    _scanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_scanButton setTitleColor:[UIColor colorWithHexString:@"ffd337"] forState:UIControlStateNormal];
    [_scanButton sizeToFit];
    _scanButton.titleEdgeInsets = UIEdgeInsetsMake(_scanButton.imageView.height + 1.5, -_scanButton.imageView.width, -1.5, 0);
    _scanButton.imageEdgeInsets = UIEdgeInsetsMake(-_scanButton.titleLabel.height - 1.5, 0, 1.5, -_scanButton.titleLabel.width);
    [_scanButton sizeToFit];

    _qrcodeButton = [UIButton new];
    [_qrcodeButton setImage:[UIImage imageNamed_CodeScaner:@"icon_QRcode"] forState:UIControlStateNormal];
    [_qrcodeButton setTitle:@"付款码" forState:UIControlStateNormal];
    _qrcodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_qrcodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_qrcodeButton sizeToFit];
    _qrcodeButton.titleEdgeInsets = UIEdgeInsetsMake(_qrcodeButton.imageView.height + 1.5, -_qrcodeButton.imageView.width, -1.5, 0);
    _qrcodeButton.imageEdgeInsets = UIEdgeInsetsMake(-_qrcodeButton.titleLabel.height - 1.5, 0, 1.5, -_qrcodeButton.titleLabel.width);
    [_qrcodeButton sizeToFit];
    [_qrcodeButton addTarget:self action:@selector(onQRcodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_qrcodeButton MB_enlargeClickAreaWithInsets:UIEdgeInsetsMake(30, 0, 30, 0)];
    _scanButton.userInteractionEnabled = NO;
    [self.bottomBar addSubview:_scanButton];
    [self.bottomBar addSubview:_qrcodeButton];
}

- (void)createScanView {
    if ([HCBCodeScanerView checkCameraIsVisible] == YES) {
        if (self.formatType == MBCodeScanFormatTypeQR) {
            _scanView = [[HCBCodeScanerView alloc] initWithFrame:self.view.bounds
                                                   withType:MBScanViewFormatTypeTypeQR];
        } else if (self.formatType == MBCodeScanFormatTypeQRAndBar) {
            _scanView = [[HCBCodeScanerView alloc] initWithFrame:self.view.bounds
                                                   withType:MBScanViewFormatTypeQRAndBar];
        }
        
        _scanView.delegate = self;
        _scanView.enableScale = [HCBCodeScaner sharedScaner].enableScale;
        [self.view addSubview:_scanView];
    } else {
        //以防止下边弹框点了好的后,页面空白
        NSString *msg = @"请确保你已允许应用使用你的相机。你可以在系统设置 > 隐私 > 相机 中找到这些选项。";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:msg forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.center = self.view.center;
        btn.bounds = CGRectMake(0, 0, 200, 200);
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        //弹框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用你的相机" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self popBack];
        }];
        UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self toSetting];
        }];
        [alert addAction:cancel];
        [alert addAction:setting];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)removeScanerViewControllerIfNeeded {
    if (self != __current_code_scaner_view_controller) {
        return;
    }
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) {
            return;
        }
        UINavigationController *nav = __current_code_scaner_view_controller.navigationController;
        if (nav && __current_code_scaner_view_controller != nav.viewControllers.firstObject) {
            if (__current_code_scaner_view_controller == nav.viewControllers.lastObject) {
                [nav popViewControllerAnimated:NO];
            } else {
                NSMutableArray *vcs = nav.viewControllers.mutableCopy;
                [vcs removeObject:__current_code_scaner_view_controller];
                nav.viewControllers = vcs.copy;
            }
        }
    });
}

#pragma mark - Actions

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onQRcodeButtonAction {
    if (self.qrCodeNavigatorLink) {
        __weak typeof(self) weakSelf = self;
        [[YMMRouterCenter shared] performWithURLString:self.qrCodeNavigatorLink
                                                params:@{@"noAnimation": @(YES)}
                                            completion:^(YMMRouterResponse * _Nullable response) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (response.result && [response.result isKindOfClass:[UIViewController class]]) {
                [strongSelf.navigationController pushViewController:response.result animated:YES];
            }
        }];
    }
    // 埋点
    [self tapPayCodeJournal];
}

- (void)onChooseFromAlbumAction {
    __weak typeof(self) wself = self;
    [HCBCodeScanerView checkPhotoLibraryIsVisibleWithCompletion:^(BOOL allowed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (allowed) {
                [wself chooseFromAlbum];
            } else {
                NSString *msg = @"请确保你已允许应用访问你的相册。你可以在系统设置 > 隐私 > 照片 中找到这些选项。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问您的相册" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [self toSetting];
                }];
                [alert addAction:cancel];
                [alert addAction:setting];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
        
    }];
    
    // 埋点
    [self tapPhotoJournal];
}

- (void)chooseFromAlbum {
    [_scanView pauseScanSession];
    [_scanView torchOff];
    _pickerDismissed = NO;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HCBCodeScanerDidClickAlbumNotification object:nil userInfo:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    _pickerDismissed = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image && [image isKindOfClass:[UIImage class]]) {
        [self extractQRCodeFromImage:image];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        self.pickerDismissed = YES;
        [self triggerImageResultsHandlerIfReady];
    }];
}

- (void)extractQRCodeFromImage:(UIImage *)image {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows[0] animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *result = [HCBCodeScaner scanImage:image format:self.formatType];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows[0] animated:YES];
            if (result) {
                self.extractResult = result;
                [self triggerImageResultsHandlerIfReady];
            } else {
                ![HCBCodeScaner sharedScaner].noResultFoundInTargetImageHandler ?: [HCBCodeScaner sharedScaner].noResultFoundInTargetImageHandler(self);
                [self.scanView beginScanLine];
            }
        });
    });
}

- (void)extractQRCodeFromImage_old:(UIImage *)image {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows[0] animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *result = [HCBCodeScaner scanImageWithoutCallback:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows[0] animated:YES];
            if (result) {
                self.extractResult = result;
                [self triggerImageResultsHandlerIfReady];
            } else {
                ![HCBCodeScaner sharedScaner].noResultFoundInTargetImageHandler ?: [HCBCodeScaner sharedScaner].noResultFoundInTargetImageHandler(self);
                [self.scanView beginScanLine];
            }
        });
    });
}

- (void)triggerImageResultsHandlerIfReady {
    BOOL ready = (_extractResult && _pickerDismissed);
    if (!ready) return;
    
    if (_noAutoJump == YES) {
        if (self.resultBlock) {
            self.resultBlock(_extractResult);
        }
        
        [self removeScanerViewControllerIfNeeded];
    } else {
        [[HCBCodeScaner sharedScaner] handleCodeScanResult:_extractResult sender:self];
    }
    
    [self triggerScanSuccessNotificationWithResult:_extractResult extractedFromImage:YES];
    _extractResult = nil;
}

#pragma mark - HCBCodeScanerViewDelegate

- (void)codeScanResult:(NSString *)scanCode {
    _extractResult = scanCode;
    [self triggerScanResultHandlerIfReady];
}

- (void)triggerScanResultHandlerIfReady {
    BOOL ready = (_extractResult && _viewDidAppeared);
    if (!ready) return;
    
    if (_noAutoJump == YES) {
        if (self.resultBlock) {
            self.resultBlock(_extractResult);
        }
        
        [self removeScanerViewControllerIfNeeded];
    } else {
        [[HCBCodeScaner sharedScaner] handleCodeScanResult:_extractResult sender:self];
    }
    
    [self triggerScanSuccessNotificationWithResult:_extractResult extractedFromImage:NO];
    _extractResult = nil;
}

- (void)btnClick:(UIButton *)btn {
    [self toSetting];
}

- (void)toSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    if (![application canOpenURL:settingURL]) {
        return;
    }
    [application openURL:settingURL];
}

#pragma notifications

- (void)triggerScanSuccessNotificationWithResult:(NSString *)result extractedFromImage:(BOOL)flag {
    if (result == nil) {
        return;
    }
    // 扫码成功埋点
    NSMutableDictionary *params = @{@"url": result}.mutableCopy;
    params[@"type"] = flag ? @(2) : @(1);

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeSpend = now - _pageEnterSec;
    _pageEnterSec = now;

    params[@"time"] = @(timeSpend);

    params[@"source"] = [self sourceForScanResult:result];
    
    [self scanSuccessAndJournalWithParams:params];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HCBCodeScanerDidScanedSuccessNotification object:nil userInfo:params];
}

#pragma mark - headerLabel

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [UILabel new];
        _headerLabel.numberOfLines = 0;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.textColor = UIColor.whiteColor;
    }
    return _headerLabel;
}

#pragma mark - 埋点相关
// 扫码成功扫出来内容埋点
- (void)scanSuccessAndJournalWithParams:(NSDictionary *)extraDic {
    [MBDoctorPVJournal tapJournalWithPage:self
                           elementId:@"sweep_out_content"
                               extra:extraDic];
}

// 点击相册按钮埋点
- (void)tapPhotoJournal {
    [MBDoctorPVJournal tapJournalWithPage:self
                                elementId:@"click_album"
                                    extra:@{}];
}

// 点击付款码埋点
- (void)tapPayCodeJournal {
    [MBDoctorPVJournal tapJournalWithPage:self
                                elementId:@"pay_qrcode"
                                    extra:@{}];
}


// pagename
- (NSString *)mb_pageName {
    return @"sao_yi_sao";
}

- (NSString *)mb_moduleName {
    return @"HCBCodeScaner";
}

- (BOOL)mb_isAutoPV {
    return YES;
}

- (NSString *)sourceForScanResult:(NSString *)result {
    /// find source for openURL
    YMMRouterRequest *request = [[YMMRouterRequest alloc] initWithURLString:result];
    if ([request respondsToSelector:@selector(params)]) {
        NSString *source = [request.params valueForKey:@"_source_"];
        if (source) {
            return source;
        }
    }

    /// find source for gas
    NSString *lowercaseStr = result.lowercaseString;
    if ([lowercaseStr rangeOfString:@"scangas"].location != NSNotFound ||
        [lowercaseStr rangeOfString:@"gasstation"].location != NSNotFound ||
        [lowercaseStr rangeOfString:@"gas_station"].location != NSNotFound) {
        return @"GAS";
    }

    /// no source found
    return nil;
}

@end
