//
//  UIView+TMSLoading.h
//  TMSBaseModule
//
//  Created by zht on 2021/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TMSLoading)

- (void)tms_startLoading;
- (void)tms_endLoading;
- (void)tms_endLoadingWithTip:(NSString *)tip;

@end

NS_ASSUME_NONNULL_END
