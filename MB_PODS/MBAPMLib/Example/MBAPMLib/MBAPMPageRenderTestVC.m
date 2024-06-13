//
//  MBAPMPageRenderTestVC.m
//  MBAPMLib_Example
//
//  Created by xp on 2020/7/28.
//  Copyright © 2020 seal. All rights reserved.
//

#import "MBAPMPageRenderTestVC.h"
#import "MBAPMPageRenderTextVC.h"
#import "MBAPMPageRenderHookVC.h"
#import "MBAPMPageRenderManualVC.h"

@interface MBAPMPageRenderTestVC ()

@end

@implementation MBAPMPageRenderTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"页面渲染检测";
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectTextMethod:(id)sender {
    MBAPMPageRenderTextVC *vc = [[MBAPMPageRenderTextVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectHookMethod:(id)sender {
    MBAPMPageRenderHookVC *vc = [[MBAPMPageRenderHookVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectManualMethod:(id)sender {
    MBAPMPageRenderManualVC *vc = [[MBAPMPageRenderManualVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
