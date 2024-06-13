//
//  MBDebugFPSOscillogramViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugFPSOscillogramViewController.h"
#import "MBDebugOscillogramView.h"
#import "MBDebugFPSOscillogramWindow.h"
#import "MBDebugFPSUtil.h"
@import MBUIKit;

@interface MBDebugFPSOscillogramViewController ()

@property (nonatomic, strong) MBDebugFPSUtil *fpsUtil;

@end

@implementation MBDebugFPSOscillogramViewController



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title {
    return @"帧率检测";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"60";
}

- (void)closeBtnClick {
    [[MBDebugFPSOscillogramWindow shareInstance] hide];
}

- (void)startRecord{
    if (!_fpsUtil) {
        _fpsUtil = [[MBDebugFPSUtil alloc] init];
        __weak typeof(self) weakSelf = self;
        [_fpsUtil addFPSBlock:^(NSInteger fps) {
            // 0~60   对应 高度0~_oscillogramView.doraemon_height
            [weakSelf.oscillogramView addHeightValue:fps*weakSelf.oscillogramView.height/60. andTipValue:[NSString stringWithFormat:@"%zi",fps]];
        }];
    }
    [_fpsUtil start];
}

- (void)endRecord{
    if (_fpsUtil) {
        [_fpsUtil end];
    }
    [self.oscillogramView clear];
}
@end
