//
//  MBDebugPerformanceEntryView.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugPerformanceEntryView.h"
#import "MBDebugFPSUtil.h"
#import "MBDebugCPUUtil.h"
#import "MBDebugMemoryUtil.h"
@import Masonry;
@import MBFoundation;
@import MBUIKit;

@interface MBDebugPerformanceEntryView () {
    NSTimer *_timer;
}

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *cpuTipsLabel;

@property (nonatomic, strong) UILabel *memoryTipsLabel;

@property (nonatomic, strong) UILabel *fpsTipsLabel;

@property (nonatomic, strong) MBDebugFPSUtil *fpsUtil;

@end

@implementation MBDebugPerformanceEntryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        self.layer.cornerRadius = 10.f;
        [self addSubview:self.cpuTipsLabel];
        [self.cpuTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        [self addSubview:self.memoryTipsLabel];
        [self.memoryTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cpuTipsLabel.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        [self addSubview:self.fpsTipsLabel];
        [self.fpsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.memoryTipsLabel.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        self.userInteractionEnabled = NO;
//        [self startTimer];
    }
    return self;
}


- (UILabel *)cpuTipsLabel {
    if(!_cpuTipsLabel){
        _cpuTipsLabel = [[UILabel alloc] init];
        _cpuTipsLabel.font = [UIFont systemFontOfSize:8];
        _cpuTipsLabel.numberOfLines = 0;
        _cpuTipsLabel.backgroundColor = [UIColor clearColor];
        _cpuTipsLabel.textAlignment = NSTextAlignmentCenter;
        _cpuTipsLabel.textColor = [UIColor blackColor];
    }
    return _cpuTipsLabel;
}

- (UILabel *)memoryTipsLabel {
    if(!_memoryTipsLabel){
        _memoryTipsLabel = [[UILabel alloc] init];
        _memoryTipsLabel.font = [UIFont systemFontOfSize:8];
        _memoryTipsLabel.numberOfLines = 0;
        _memoryTipsLabel.backgroundColor = [UIColor clearColor];
        _memoryTipsLabel.textAlignment = NSTextAlignmentCenter;
        _memoryTipsLabel.textColor = [UIColor blackColor];
    }
    return _memoryTipsLabel;
}

- (UILabel *)fpsTipsLabel {
    if(!_fpsTipsLabel){
        _fpsTipsLabel = [[UILabel alloc] init];
        _fpsTipsLabel.font = [UIFont systemFontOfSize:8];
        _fpsTipsLabel.numberOfLines = 0;
        _fpsTipsLabel.backgroundColor = [UIColor clearColor];
        _fpsTipsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsTipsLabel.textColor = [UIColor blackColor];
    }
    return _fpsTipsLabel;
}

- (void)dealloc {
    [self stopTimer];
}

- (void)startTimer {
    [self stopTimer];
    _timer = [NSTimer timerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(refreshAppDeviceInfo)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self.fpsUtil start];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
    [_fpsUtil end];
}

- (void)refreshAppDeviceInfo {
    CGFloat cpuUsage = [MBDebugCPUUtil cpuUsageForApp]*100;
    NSString *cpuInfo = [NSString stringWithFormat:@"%.1f%%", cpuUsage];
    UIColor *cpuInfoColor = cpuUsage > 80 ? [UIColor redColor] : [UIColor whiteColor];
    
    NSInteger memoryUsage = [MBDebugMemoryUtil useMemoryForApp];
    NSString *memoryInfo = [NSString stringWithFormat:@"%ldM", memoryUsage];
    UIColor *memoryInfoColor = memoryUsage > 500 ? [UIColor redColor] : [UIColor whiteColor];
    
    // 经过比较，设置 attributedText 比单独设置text/textColor/font 方法执行耗时多 0.1 - 0.5 ms， 故此处移除掉attributedText设置的逻辑
    self.cpuTipsLabel.text = cpuInfo;
    self.cpuTipsLabel.textColor = cpuInfoColor;
    self.memoryTipsLabel.text = memoryInfo;
    self.memoryTipsLabel.textColor = memoryInfoColor;
    self.memoryTipsLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
    self.cpuTipsLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
    
}

- (MBDebugFPSUtil *)fpsUtil {
    if(!_fpsUtil){
        _fpsUtil = [[MBDebugFPSUtil alloc] init];
        YMM_Weakify(self, weakSelf);
        [_fpsUtil addFPSBlock:^(NSInteger fps) {
            YMM_Strongify(weakSelf, strongSelf);
            NSString *fpsTip = [NSString stringWithFormat:@"fps:%ld", fps];
            UIColor *fpsTipColor = fps < 24  ? [UIColor redColor] : [UIColor whiteColor];
            NSAttributedString *attributedFpsTip = [[NSAttributedString alloc] initWithString:fpsTip
                                                                                    attributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:8 weight:UIFontWeightBold],
                NSForegroundColorAttributeName: fpsTipColor
            }];
            strongSelf.fpsTipsLabel.attributedText = attributedFpsTip;
        }];
    }
    return _fpsUtil;
}


@end
