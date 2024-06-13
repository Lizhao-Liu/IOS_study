//
//  HCBAboutUsVC.m
//  GasStationBiz
//
//  Created by ty on 2017/11/18.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBAboutUsVC.h"
#import "config.h"

@interface HCBAboutUsVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblAboutApp;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

@end

@implementation HCBAboutUsVC

- (instancetype)init {
    return [super initWithNibName:@"HCBAboutUsVC" bundle:KBUNDLE_PT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"关于我们"];
    _imgLogo.layer.cornerRadius = 3.f;
    _imgLogo.layer.masksToBounds = YES;
    [self setupUIInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUIInfo {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    _lblAboutApp.text = [NSString stringWithFormat:@"%@ %@", appName, appVersion];
}
@end
