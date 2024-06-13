//
//  HCBAlertController.h
//  HCBAlertController
//
//  Created by AugustineReinhardt on 16/7/7.
//  Copyright © 2016年 Reinhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HCBAlertActionStyle) {
    HCBAlertActionStyleDefault = 0,
    HCBAlertActionStyleCancel,
    HCBAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, HCBAlertControllerStyle) {
    HCBAlertControllerStyleActionSheet = 0,
    HCBAlertControllerStyleAlert,
    HCBAlertControllerStyleCustomizableActionSheet,
    HCBAlertControllerStyleCustomizableAlert
};

@interface HCBAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(HCBAlertActionStyle)style handler:(void (^ __nullable)(HCBAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) HCBAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface HCBAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(HCBAlertControllerStyle)preferredStyle;
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title attributedMessage:(nullable NSAttributedString *)attributedMessage preferredStyle:(HCBAlertControllerStyle)preferredStyle;

- (void)addAction:(HCBAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@property (nullable, nonatomic, copy) NSString *alertTitle;
@property (nullable, nonatomic, copy) NSString *alertMessage;
@property (nonatomic, readonly) HCBAlertControllerStyle preferredStyle;

@end

@interface HCBAlertControllerActionView : UIView
@end

@interface HCBAlertControllerAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface HCBAlertControllerModalTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>
@end

@interface HCBNativeAlertController : HCBAlertController
@end
@interface HCBCustomizableAlertController : HCBAlertController
@end

@interface UIViewController (HCBAlertController)

- (void)alert_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
