//
//  MBDebugTestViewController.m
//  MBDebug
//
//  Created by Ymm on 2019/11/13.
//  Copyright © 2019 YMM. All rights reserved.
//

#import "MBDebugTestViewController.h"
#import "MBDebugManager.h"

@interface MBDebugTestViewController ()

@end

@implementation MBDebugTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Debug入口页";
    [[MBDebugManager sharedMBDebugManager] initEntryView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
