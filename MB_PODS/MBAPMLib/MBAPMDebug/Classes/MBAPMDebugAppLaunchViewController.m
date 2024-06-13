//
//  MBAPMDebugAppLaunchViewController.m
//  AliyunOSSiOS
//
//  Created by xp on 2020/7/29.
//

#import "MBAPMDebugAppLaunchViewController.h"
@import MBAPMLib;
#import <YYModel/NSObject+YYModel.h>

@interface MBAPMDebugAppLaunchViewController ()

@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation MBAPMDebugAppLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"App启动耗时检测";
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    } else {
#endif
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.infoLabel];
    NSArray<MBAPMMetric *> *array = [[MBAPMDataCache sharedInstance]getCachedMetrics:MBAPMPerformanceTypeAppLaunch];
    if(array.count >= 1) {
        MBAPMAppLaunchMetric *metric = (MBAPMAppLaunchMetric *)array[0];
        [self.infoLabel setText: [metric yy_modelToJSONString]];
    }
}

- (UILabel *)infoLabel {
    if(!_infoLabel) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:24];
        _infoLabel.numberOfLines = 10;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _infoLabel.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _infoLabel.textColor = [UIColor labelColor];
        }
    }
    return _infoLabel;
}



@end
