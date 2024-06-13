//
//  MBAPMDebugListItemCell.m
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import "MBAPMDebugListItemCell.h"

@interface MBAPMDebugListItemCell()

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *valueLabel1;
@property (nonatomic, strong) UILabel *valueLabel2;

@end

@implementation MBAPMDebugListItemCell

- (UILabel *)name {
    if(!_name) {
        CGFloat height = 32;
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.font = [UIFont systemFontOfSize:16];
        _name.numberOfLines = 2;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        _name.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _name.textColor = [UIColor labelColor];
        }
    }
    return _name;
}

- (UILabel *)valueLabel1 {
    if(!_valueLabel1) {
        CGFloat height = 32;
        _valueLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, self.frame.size.width, height)];
        _valueLabel1.textAlignment = NSTextAlignmentLeft;
        _valueLabel1.font = [UIFont systemFontOfSize:16];
        _valueLabel1.numberOfLines = 2;
        _valueLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
        _valueLabel1.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _valueLabel1.textColor = [UIColor labelColor];
        }
    }
    return _valueLabel1;
}

- (UILabel *)valueLabel2 {
    if(!_valueLabel2) {
        CGFloat height = 50;
        _valueLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, height)];
        _valueLabel2.textAlignment = NSTextAlignmentLeft;
        _valueLabel2.font = [UIFont systemFontOfSize:16];
        _valueLabel2.numberOfLines = 2;
        _valueLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
        _valueLabel2.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _valueLabel2.textColor = [UIColor labelColor];
        }
    }
    return _valueLabel2;
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
        [self addSubview:self.name];
        [self addSubview:self.valueLabel1];
        [self addSubview:self.valueLabel2];
    }
    return self;
}

- (void)updateCell:(NSString *)name value1:(NSString *)value1 value2:(NSString *)value2{
    [self.name setText:name];
    [self.valueLabel1 setText:value1];
    [self.valueLabel2 setText:value2];
}

@end
