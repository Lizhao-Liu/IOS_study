//
//  YMMViewController.m
//  YMMRouterModule
//
//  Created by knop on 03/06/2019.
//  Copyright (c) 2019 knop. All rights reserved.
//

#import "YMMViewController.h"
@import MBRouterDebug;
@import YMMRouterLib;

@interface YMMViewController ()

@end

@implementation YMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)debugAction:(UIButton *)sender {
    YMMRouterDebugViewController *debugVC = [[YMMRouterDebugViewController alloc] init];
    [self.navigationController pushViewController:debugVC animated:YES];
}

@end
