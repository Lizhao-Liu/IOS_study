//
//  ViewController.m
//  MBDebug
//
//  Created by Ymm on 2019/10/18.
//  Copyright © 2019 YMM. All rights reserved.
//

#import "ViewController.h"
#import "MBDebugTestViewController.h"
#import "MBDebugManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *debugButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.debugButton];
}

- (UIButton *)debugButton {
    if (!_debugButton) {
        _debugButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _debugButton.frame = CGRectMake(0, 100, 150, 50);
        _debugButton.backgroundColor = [UIColor orangeColor];
        [_debugButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_debugButton setTitle:@"Debug面板跳转" forState:UIControlStateNormal];
        [_debugButton addTarget:self action:@selector(debugAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _debugButton;
}

- (void)debugAction:(id)sender {
    MBDebugTestViewController *vc = [[MBDebugTestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *presentedVC = screenWindow.rootViewController;
    
    while (presentedVC.presentedViewController)
    {
        presentedVC = presentedVC.presentedViewController;
    }
    [presentedVC presentViewController:nav animated:YES completion:nil];
}

@end
