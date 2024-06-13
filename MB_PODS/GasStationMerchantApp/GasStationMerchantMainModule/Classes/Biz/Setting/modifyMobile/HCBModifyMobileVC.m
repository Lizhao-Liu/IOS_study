//
//  HCBModifyMobileVC.m
//  GasStationBiz
//
//  Created by ty on 2017/11/17.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBModifyMobileVC.h"
#import "HCBLoginRequest.h"
#import "HCBVerifycodeRequest.h"
#import "HCBUserManager.h"
#import "HCBStationManager.h"
#import "config.h"
@import YMMUserModuleService;
@import MBUIKit;
@import MBFoundation;
@import HCBNetwork;

@interface HCBModifyMobileVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblCurMobileNum;
@property (weak, nonatomic) IBOutlet UITextField *tfNewMobileNum;
@property (weak, nonatomic) IBOutlet UITextField *tfSecurityCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSendSecurityCode;

@property (nonatomic, strong) NSTimer *pollingTimer;
@property (nonatomic) NSInteger countDownTime;

@end

@implementation HCBModifyMobileVC

- (instancetype)init {
    return [super initWithNibName:@"HCBModifyMobileVC" bundle:KBUNDLE_PT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改手机"];
    [self setupUI];
    [self setupUIInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 3.f;
    _btnSendSecurityCode.layer.masksToBounds = YES;
    _btnSendSecurityCode.layer.cornerRadius = 3.f;
}

- (void)setupUIInfo {
    
    NSString *curMobile = [HCBUserManager shareManager].currentUser.bindMobile_secure;
    _lblCurMobileNum.text = curMobile;
    
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
    
    NSString *tmpStr = [NSString stringWithFormat:@"重新发送%d", _countDownTime];
    [_btnSendSecurityCode setTitle:tmpStr forState:UIControlStateNormal];
    [_btnSendSecurityCode setEnabled:NO];
    _btnSendSecurityCode.alpha = 0.6f;
    _countDownTime--;
    if (_countDownTime == 0) {
        
        [self stopVerifyTime];
        [_btnSendSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnSendSecurityCode setEnabled:YES];
        _btnSendSecurityCode.alpha = 1.f;
        _countDownTime = 60;
    }
}

- (BOOL)checkSubmitInfo {
    
    NSString *msg = @"";
    NSString *curMobileNum = [HCBUserManager shareManager].currentUser.bindMobile;
    NSString *newMobileNum = _tfNewMobileNum.text;
    NSString *securityCode = _tfSecurityCode.text;
    
    if (newMobileNum.length < 1) {
        
        msg = @"请输入新绑定手机号";
    }
    else if ([newMobileNum isEqualToString:curMobileNum]) {
        
        msg = @"新手机号不能与旧手机号相同";
    }
    else if (securityCode.length < 4) {
        
        msg = @"请输入合法的验证码";
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
- (IBAction)clickedSendVerifyTimeBtn:(id)sender {
    
    [self.view endEditing:YES];
    [self reqGetVerifyCode];
}

- (IBAction)clickedSubmitBtn:(id)sender {
    
    [self.view endEditing:YES];
    BOOL checkInfo = [self checkSubmitInfo];
    
    if (checkInfo) {
        
        NSString *newMobileNum = _tfNewMobileNum.text;
        NSString *verifyCode = _tfSecurityCode.text;
        [self submitModifyMobileNum:newMobileNum verifyCode:verifyCode];
    }
}

#pragma mark - req
- (void)reqGetVerifyCode {
    
    NSString *newMobile = _tfNewMobileNum.text;
    if (newMobile.length < 1) {
        
        [MBProgressHUD showToastAddedTo:self.view imageName:nil labelText:@"请输入手机号"];
        return ;
    }
    NSString *mobileNum = newMobile;
    [MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"验证码已发送"];
    [self setupVerifyTime];
    [HCBVerifycodeRequest reqModifyMobileBindingVerifyCodeWithMobileNum:mobileNum onCompleteBlock:^(NSDictionary *dic) {

    } onFailedBlock:^(HCBError *error) {

        [MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"验证码发送失败"];
    }];
}

- (void)submitModifyMobileNum:(NSString *)mobileNum verifyCode:(NSString *)verifyCode {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES text:@"正在提交请求"];
    YMM_Weakify(self, weakSelf)
    [HCBLoginRequest reqModifyMobileWithNewMobileNum:mobileNum verifyCode:verifyCode onCompleteBlock:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showToastAddedTo:weakSelf.view imageName:nil labelText:@"操作成功"];
        [[HCBUserManager shareManager].currentUser clearUserDefaults];
        [[HCBStationManager shareManager].stationModel clearCache];
        YMM_Strongify(weakSelf, strongSelf)
        !strongSelf.modifySuccessHandler ?: strongSelf.modifySuccessHandler();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLogoutNotification object:nil];
        });
    } onFailedBlock:^(HCBError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showToastAddedTo:weakSelf.view imageName:nil labelText:error.errorMsg];
    }];
}
@end
