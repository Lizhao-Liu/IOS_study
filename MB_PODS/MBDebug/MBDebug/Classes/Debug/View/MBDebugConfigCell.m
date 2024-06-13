//
//  MBDebugConfigCell.m
//  MBDebug
//
//  Created by Lizhao on 2022/11/17.
//

#import "MBDebugConfigCell.h"
#import "MBDebugEntryManager.h"
@import MBUIKit;

@interface MBDebugConfigCell()

@property (nonatomic, strong) UISwitch *switchBtn;

@end

@implementation MBDebugConfigCell

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
        [self updateSwitchStatus];
        [_switchBtn addTarget:self action:@selector(touchSwitchBtn) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (void)touchSwitchBtn {
    if([MBDebugEntryManager sharedMBDebugEntryManager].debugWindowIsClosed){
        [[MBDebugEntryManager sharedMBDebugEntryManager] initDebugWindow];
    } else {
        [[MBDebugEntryManager sharedMBDebugEntryManager] removeDebugWindow];
    }
    [self updateSwitchStatus];
}

- (void)updateSwitchStatus {
    _switchBtn.on = [MBDebugEntryManager sharedMBDebugEntryManager].debugWindowIsClosed ? NO : YES;
    self.textLabel.text = [MBDebugEntryManager sharedMBDebugEntryManager].debugWindowIsClosed? @"debug悬浮窗已关闭" : @"debug悬浮窗已开启";
}

@end

