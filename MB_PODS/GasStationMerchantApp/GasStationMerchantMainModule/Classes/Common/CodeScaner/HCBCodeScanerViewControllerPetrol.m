//
//  HCBCodeScanerViewController.m
//  ios4driver
//
//  Created by yangtianyin on 16/1/4.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "HCBCodeScanerViewControllerPetrol.h"
#import "HCBCodeScanView.h"
#import "HCBAlertController.h"
#import "HCBCompatibleAlertController.h"

#define scanerWidth 250.f
#define scanerHeight 250.f

@interface HCBCodeScanerViewControllerPetrol ()<HCBCodeScanViewDelegate>

@property (nonatomic, strong) HCBCodeScanView *scanView;


@end

@implementation HCBCodeScanerViewControllerPetrol



#pragma mark - PV
- (NSString *)setupPVCurrentPageName {
    return @"scan";
}

- (void)viewDidLoad {
   [super viewDidLoad];

    [self initTitle:@"扫一扫"];
    if (self.isShowBackBtn == YES) {
        
        [self initBackButton:@""];
    }
    
    [self createScanView];
    
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}

-(void)createScanView {
    
    if ([HCBCodeScanView checkCameraIsVisible] == YES) {
        
        self.scanView = [[HCBCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        self.scanView.delegate = self;
        [self.view addSubview:self.scanView];
    }
    else {
        
        NSString *title = @"无法使用你的相机";
        NSString *message = @"请确保你已允许应用使用你的相机。你可以在系统设置 > 隐私 > 相机 中找到这些选项。";
        NSString *cancelTitle = @"好的";
        NSString *settingTitle = @"设置";
        
#ifdef DEBUG
        HCBAlertController *alertController = [HCBAlertController alertControllerWithTitle:title message:message preferredStyle:HCBAlertControllerStyleAlert];
        HCBAlertAction *cancelAction = [HCBAlertAction actionWithTitle:cancelTitle style:HCBAlertActionStyleCancel handler:nil];
        
        HCBAlertAction *settingAction = [HCBAlertAction actionWithTitle:settingTitle style:HCBAlertActionStyleDefault handler:^(HCBAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:settingAction];
        
        [self alert_presentViewController:alertController animated:YES completion:nil];
#else
        HCBCompatibleAlertController *alertController = [HCBCompatibleAlertController alertControllerWithTitle:title message:message preferredStyle:HCBCompatibleAlertControllerStyleAlert];

        HCBCompatibleAlertAction *cancelAction = [HCBCompatibleAlertAction actionWithTitle:cancelTitle style:HCBCompatibleAlertActionStyleCancel handler:nil];

        HCBCompatibleAlertAction *settingAction = [HCBCompatibleAlertAction actionWithTitle:settingTitle style:HCBCompatibleAlertActionStyleDefault handler:^(HCBCompatibleAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:settingAction];

        [alertController showAlert];
#endif
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if (self.scanView != nil) {
        
        [self.scanView beginScanLine];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.scanView removeScanLine];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
}


#pragma mark - HCBCodeScanView delegate
-(void)codeScanResult:(NSString *)scanCode {

    //wlqq://payment/{"QrCode":"PGibWKRsmbjxJQJ2"}
    if (![scanCode containsString:@"wlqq://payment/"]) {
        return;
    }
    
    NSArray *tArray = [scanCode componentsSeparatedByString:@"payment/"];
    
    if (tArray.count > 1) {
        
        NSData *stringData = [tArray[1] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
         HCBScanResultType type = HCBScanResultType_None;
        if ([[[dic allKeys] firstObject] isEqualToString:@"QrCode"]) {
            type = HCBScanResultType_Person;
        } else if ([[[dic allKeys] firstObject] isEqualToString:@"GasCardPayQrCode"]) {
            type = HCBScanResultType_Enterprise; 
        } else if ([[[dic allKeys] firstObject] isEqualToString:@"TruckTeamQrCode"]) {
            type = HCBScanResultType_OilCard;
        }
        
        !_actionAfterScan ? : _actionAfterScan(type, scanCode);
    }
}


@end
