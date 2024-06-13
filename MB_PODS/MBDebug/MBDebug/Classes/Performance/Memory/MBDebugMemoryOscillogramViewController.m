//
//  MBDebugMemoryOscillogramViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugMemoryOscillogramViewController.h"
#import "MBDebugMemoryOscillogramWindow.h"
#import "MBDebugMemoryUtil.h"
@import MBUIKit;

@interface MBDebugMemoryOscillogramViewController ()

@end

@implementation MBDebugMemoryOscillogramViewController

- (NSString *)title{
    return @"内存检测";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return [NSString stringWithFormat:@"%zi",[self deviceMemory]];
}

- (void)closeBtnClick{
    [[MBDebugMemoryOscillogramWindow shareInstance] hide];
}

//每一秒钟采样一次内存使用率
- (void)doSecondFunction{
    NSUInteger useMemoryForApp = [MBDebugMemoryUtil useMemoryForApp];
    NSUInteger totalMemoryForDevice = [self deviceMemory];
    
    // 0~totalMemoryForDevice
    [self.oscillogramView addHeightValue:useMemoryForApp*self.oscillogramView.height/totalMemoryForDevice andTipValue:[NSString stringWithFormat:@"%zi",useMemoryForApp]];
}

- (NSUInteger)deviceMemory {
    return 1000;
}

@end
