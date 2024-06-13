//
//  UIView+TMSLoading.m
//  TMSBaseModule
//
//  Created by zht on 2021/6/1.
//

#import "UIView+TMSLoading.h"
@import MBCommonUILib;

@implementation UIView (TMSLoading)

- (void)tms_startLoading{
    [self mb_startLoading];
}
- (void)tms_endLoading{
    [self mb_endLoading];
}

- (void)tms_endLoadingWithTip:(NSString *)tip{
    
    [self mb_endLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBGTipView showTipString:tip];
    });
}

@end
