//
//  MBAPMDebugItemDetailCell.m
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import "MBAPMDebugItemDetailCell.h"

@interface MBAPMDebugItemDetailCell()

@property (nonatomic, strong) UILabel *desLabel;

@end

@implementation MBAPMDebugItemDetailCell

- (UILabel *)desLabel {
    if(!_desLabel) {
        CGFloat height = 128;
        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.font = [UIFont systemFontOfSize:16];
        _desLabel.numberOfLines = 6;
        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _desLabel.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _desLabel.textColor = [UIColor labelColor];
        }
    }
    return _desLabel;
}

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
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,-1,self.frame.size.width, self.frame.size.height + 1)];
        container.clipsToBounds = YES;
        container.layer.borderWidth = 1.0f;
        container.layer.cornerRadius = 2.0f;
        container.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:container];
        [self addSubview:self.desLabel];
    }
    return self;
}


- (void)updateDes:(NSString *)des {
    [self.desLabel setText:des];
}

@end
