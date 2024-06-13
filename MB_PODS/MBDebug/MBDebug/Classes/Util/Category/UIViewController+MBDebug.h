//
//  UIViewController+MBDebug.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MBDebug)

+ (UIViewController *)topPresentedVC;

+ (BOOL)presentDebugVC:(UIViewController *)debugVC;

+ (BOOL)dismissDebugVC:(UIViewController *)debugVC;

@end

NS_ASSUME_NONNULL_END
