//
//  MBViewController.m
//  MBRouterDebug
//
//  Created by xp on 04/09/2021.
//  Copyright (c) 2021 www.amh-group.com All rights reserved.
//

#import "MBViewController.h"
#import <MBRouterDebug/YMMRouterDebugViewController.h>

@interface MBViewController ()

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self pushViewController:[[YMMRouterDebugViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
