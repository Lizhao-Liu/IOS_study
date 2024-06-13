//
//  MBDebugSwitchCell.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugSwitchCell.h"
#ifndef kScreenWidth
#define kScreenWidth        CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

@interface MBDebugSwitchCell ()

@property (nonatomic, strong) UISwitch *switchBtn;

@end

@implementation MBDebugSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.switchBtn];
    }
    return self;
}

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-10-50, 15, 50, 30)];
        _switchBtn.backgroundColor = [UIColor whiteColor];
        [_switchBtn addTarget:self action:@selector(touchSwitchBtn) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (void)setSwitchBtnOn:(BOOL)switchBtnOn {
    _switchBtnOn = switchBtnOn;
    _switchBtn.on = switchBtnOn;
}

- (void)setSwitchBtnDisabled:(BOOL)switchBtnDisabled {
    _switchBtn.enabled = !switchBtnDisabled;
}

- (void)touchSwitchBtn {
    if(self.switchButtonBlock){
        self.switchButtonBlock(self.switchBtn.on);
    }
}

@end
