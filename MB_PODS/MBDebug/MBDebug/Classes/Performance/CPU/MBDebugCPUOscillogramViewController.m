//
//  MBDebugCPUOscillogramViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugCPUOscillogramViewController.h"
#import "MBDebugCPUOscillogramWindow.h"
#import "MBDebugCPUUtil.h"
@import MBUIKit;

@interface MBDebugCPUOscillogramViewController ()

@end

@implementation MBDebugCPUOscillogramViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return @"CPU检测";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
    [[MBDebugCPUOscillogramWindow shareInstance] hide];
}

//每一秒钟采样一次cpu使用率
- (void)doSecondFunction{
    CGFloat cpuUsage = [MBDebugCPUUtil cpuUsageForApp];
    if (cpuUsage * 100 > 100) {
        cpuUsage = 100;
    }else{
        cpuUsage = cpuUsage * 100;
    }
    // 0~100   对应 高度0~_oscillogramView.doraemon_height
    [self.oscillogramView addHeightValue:cpuUsage*self.oscillogramView.height/100. andTipValue:[NSString stringWithFormat:@"%.f",cpuUsage]];
}

@end
