//
//  TTViewController.m
//  SampleApp
//
//  Created by Lizhao on 2022/8/19.
//  Copyright © 2022 dequanzhu. All rights reserved.
//

#import "TTViewController.h"

@interface TTViewController ()

@end

@implementation TTViewController

#define DeviceHeight [[UIScreen mainScreen] bounds].size.height
#define DeviceWidth [[UIScreen mainScreen] bounds].size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
  
    self.view.frame = CGRectMake(self.view.frame.origin.x, DeviceHeight / 2, DeviceWidth, DeviceHeight / 2);
//    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
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
