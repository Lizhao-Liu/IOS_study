//
//  HCBLoginVC.m
//  GasStationBiz
//
//  Created by ty on 2017/10/9.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBLoginVC.h"

#import "HCBLoginRequest.h"
#import "HCBVerifycodeRequest.h"
#import "HCBUserManager.h"
#import "HCBStationModel.h"
#import "HCBStationManager.h"
#import "config.h"

@import MBDoctorService;
@import MBProgressHUD;
@import MBUIKit;
@import MBFoundation;
@import HCBNetwork;
@import YMMUserModuleService;

@interface HCBLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *txfPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txfSecurityCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSecurityCode;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (nonatomic, strong) NSTimer *pollingTimer;
@property (nonatomic) NSInteger countDownTime;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end

@implementation HCBLoginVC

- (instancetype)init {
    return [super initWithNibName:@"HCBLoginVC" bundle:KBUNDLE_PT];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)setupUI {
    _btnSecurityCode.layer.cornerRadius = 3.f;
    _btnSecurityCode.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 3.f;
    _btnLogin.layer.masksToBounds = YES;
    
    _txfPhoneNum.layer.cornerRadius = 3.f;
    _txfPhoneNum.layer.masksToBounds = YES;
    _txfSecurityCode.layer.cornerRadius = 3.f;
    _txfSecurityCode.layer.masksToBounds = YES;
    
    _txfPhoneNum.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    _txfPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    _txfSecurityCode.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    _txfSecurityCode.leftViewMode = UITextFieldViewModeAlways;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _lblVersion.text = [NSString stringWithFormat:@"%@ %@", appName, appVersion];
    
    if (@available(iOS 13.0, *)) {
        _txfPhoneNum.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        _txfSecurityCode.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupVerifyTime {
    
    _countDownTime = 60;
    _pollingTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(cycleTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_pollingTimer forMode:NSRunLoopCommonModes];
}

- (void)stopVerifyTime {
    
    if ([_pollingTimer isValid]) {
        [_pollingTimer invalidate];
        _pollingTimer = nil;
    }
}

- (void)cycleTimerAction:(NSTimer *)timer {
    
    NSString *tmpStr = [NSString stringWithFormat:@"重新发送%ld", _countDownTime];
    [_btnSecurityCode setTitle:tmpStr forState:UIControlStateNormal];
    [_btnSecurityCode setEnabled:NO];
    _btnSecurityCode.alpha = 0.6f;
    _countDownTime--;
    if (_countDownTime == 0) {
        
        [self stopVerifyTime];
        [_btnSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnSecurityCode setEnabled:YES];
        _btnSecurityCode.alpha = 1.f;
        _countDownTime = 60;
    }
}

- (BOOL)checkLoginInfo:(NSString *)mobile code:(NSString *)code {
    
    NSString *msg = @"";
    if (mobile.length < 1) {
        
        msg = @"请输入手机号";
    }
    else if (code.length < 1) {
        
        msg = @"请输入验证码";
    }
    
    if (msg.length > 0) {
        
        [MBProgressHUD showToastAddedTo:self.view imageName:nil labelText:msg];
    }
    
    return msg.length < 1;
}

- (void)dealloc {
    
    [self stopVerifyTime];
}

#pragma mark - click event
- (IBAction)clickGetVerifycode:(id)sender {
    
    NSString *phoneNum = _txfPhoneNum.text;
    if (phoneNum.length > 0) {
        
        [self reqLoginVerifyCodeWithPhoneNum:phoneNum];
    }
    else {
        
        [MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"请输入手机号"];
    }
}

- (IBAction)clickLoginBtn:(id)sender {
    
    NSString *phoneNum = _txfPhoneNum.text;
    NSString *securityCode = _txfSecurityCode.text;
    BOOL isOK = [self checkLoginInfo:phoneNum code:securityCode];
    
    if (isOK) {
     
        [self reqLoginWithPhoneNum:phoneNum verifyCode:securityCode];
    }
    [MBDoctorUtil tapWithPageName:@"gas_login_compile" elementId:@"home_login" extra:nil];
    
}

- (void)closeLoginView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - req
- (void)reqLoginWithPhoneNum:(NSString *)phoneNum verifyCode:(NSString *)verifyCode {
    YMM_Weakify(self, weakSelf)
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES text:@"正在登录..."];
    [[HCBUserManager shareManager] userLoginWithMobile:phoneNum
                                                  code:verifyCode
                                       onCompleteBlock:^(BOOL isSuccess, NSString *errorMsg) {
                                           if (isSuccess) {
                                               [weakSelf reqUserInfo];
                                           } else {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                           }
                                       }];
}

- (void)reqLoginVerifyCodeWithPhoneNum:(NSString *)phoneNum {
    
    YMM_Weakify(self, weakSelf)
    [weakSelf setupVerifyTime];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HCBVerifycodeRequest reqLoginVerifyCodeWithMobileNum:phoneNum onCompleteBlock:^(BOOL result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showToastAddedTo:weakSelf.view imageName:nil labelText:@"验证码已发送"];
    } onFailedBlock:^(HCBError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showToastAddedTo:weakSelf.view imageName:nil labelText:@"验证码发送失败"];
    }];
}

- (void)reqUserInfo {
    
    YMM_Weakify(self, weakSelf)
    [HCBLoginRequest reqUserInfoWithCompleteBlock:^(NSDictionary *dic) {
        
        [HCBStationManager shareManager].stationModel = [[HCBStationModel alloc] initWithDictionary:dic error:nil];
        [[HCBStationManager shareManager].stationModel saveToUserDefaults];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        //统一通知规范
        [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLoginNotification object:nil];
        [weakSelf closeLoginView];
         
    } onFailedBlock:^(HCBError *error) {
        [[HCBStationManager shareManager].stationModel clearCache];
        [[HCBUserManager shareManager].currentUser clearUserDefaults];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (NSString *)ymm_pageName {
    return @"gas_login_compile";
}

@end
