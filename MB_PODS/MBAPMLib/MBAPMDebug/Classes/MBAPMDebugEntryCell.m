//
//  MBAPMDebugEntryCell.m
//  MBAPMLib
//
//  Created by xp on 2020/7/29.
//

#import "MBAPMDebugEntryCell.h"

@interface MBAPMDebugEntryCell()

@property (nonatomic, strong) UILabel *name;

@end

@implementation MBAPMDebugEntryCell

- (UILabel *)name {
    if(!_name) {
        CGFloat height = 50;
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = [UIFont systemFontOfSize:24];
        _name.numberOfLines = 2;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        _name.adjustsFontSizeToFitWidth = YES;
        if(@available(iOS 13.0, *)) {
            _name.textColor = [UIColor labelColor];
        }
    }
    return _name;
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
        [self addSubview:self.name];
    }
    return self;
}

- (void)updateCell:(NSString *)name {
    [self.name setText:name];
}


@end
