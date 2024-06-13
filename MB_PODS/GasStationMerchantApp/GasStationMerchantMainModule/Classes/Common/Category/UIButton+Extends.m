//
//  UIButton+Extends.m
//  NewDriver4iOS
//
//  Created by wangjueMBP on 16/3/17.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "UIButton+Extends.h"

@implementation UIButton (Extends)
- (void)extendResponseAreaWithExtendEdge:(UIEdgeInsets)extendEdge
{
    CGPoint center = self.center;
    self.frame = CGRectMake(0, 0, self.frame.size.width + extendEdge.left + extendEdge.right, self.frame.size.height + extendEdge.top + extendEdge.bottom);
    self.center = center;
    self.imageEdgeInsets = extendEdge;
}
@end
