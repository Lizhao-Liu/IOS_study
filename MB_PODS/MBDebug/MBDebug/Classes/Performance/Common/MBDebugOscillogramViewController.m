//
//  MBDebugOscillogramViewController.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugOscillogramViewController.h"
#import "MBDebugOscillogramWindowManager.h"
@import MBUIKit;

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

@interface MBDebugOscillogramViewController ()

//每秒运行一次
@property (nonatomic, strong) NSTimer *secondTimer;

@end

@implementation MBDebugOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self title];
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(10,5, titleLabel.width, titleLabel.height);
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake((kInterfaceOrientationPortrait ? kScreenWidth : kScreenHeight)-40, 0, 40, 40);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    _closeBtn = closeBtn;
    
    _oscillogramView = [[MBDebugOscillogramView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+6, (kInterfaceOrientationPortrait ? kScreenWidth : kScreenHeight), 92)];
    _oscillogramView.backgroundColor = [UIColor clearColor];
    [_oscillogramView setLowValue:[self lowValue]];
    [_oscillogramView setHightValue:[self highValue]];
    [self.view addSubview:_oscillogramView];
}

- (NSString *)title{
    return @"";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
}

- (void)startRecord{
    if(!_secondTimer){
        _secondTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_secondTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)doSecondFunction{
    
}

- (void)endRecord{
    if(_secondTimer){
        [_secondTimer invalidate];
        _secondTimer = nil;
        [self.oscillogramView clear];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MBDebugOscillogramWindowManager shareInstance] resetLayout];
    });
}
@end
