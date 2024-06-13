//
//  HCBScanMaskView.m
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "HCBScanMaskView.h"

@implementation HCBScanMaskView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    //半透明区域
    UIRectFill(rect);
    
    //透明的区域
    CGRect holeRection = scanFrame(pWith, pWith);

    
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [[UIColor clearColor] setFill];
    UIRectFill(holeiInterSection);
}

@end
