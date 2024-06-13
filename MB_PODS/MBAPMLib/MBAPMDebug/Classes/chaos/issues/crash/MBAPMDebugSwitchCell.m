//
//  MBAPMDebugSwitchCell.m
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import "MBAPMDebugSwitchCell.h"

@interface MBAPMDebugSwitchCell()

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong) UISwitch *cellSwitch;

@end

@implementation MBAPMDebugSwitchCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor systemBackgroundColor];
        } else {
#endif
            self.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
        [self addSubview:self.label];
        [self addSubview:self.cellSwitch];
        
    }
    return self;
}

- (void)setLabelText:(NSString *)labelText {
    [self.label setText:labelText];
}

- (void)setSwitchState:(BOOL)isON {
    [self.cellSwitch setOn:isON];
}

- (UISwitch *)cellSwitch {
    if(!_cellSwitch) {
        _cellSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.frame.size.width - 100, 20, 100, 100)];
        _cellSwitch.on = NO;
        [_cellSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _cellSwitch;
}

- (UILabel *)label {
    if(!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width - 100, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:16];
        _label.numberOfLines = 1;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _label.textColor = [UIColor labelColor];
        }
    }
    return _label;
}

- (void)switchChanged:(UISwitch *)cellSwitch {
    if(self.delegate && [self.delegate respondsToSelector:@selector(switchChanged:cellTag:)]) {
        [self.delegate switchChanged:cellSwitch.on cellTag:self.tag];
    }
}



@end
