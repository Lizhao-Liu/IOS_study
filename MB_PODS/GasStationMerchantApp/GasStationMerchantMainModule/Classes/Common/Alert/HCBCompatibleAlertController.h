//
//  HCBCompatibleAlertController.h
//  NewDriver4iOS
//
//  Created by AugustineReinhardt on 16/6/14.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HCBCompatibleAlertActionStyle) {
    HCBCompatibleAlertActionStyleDefault = 0,
    HCBCompatibleAlertActionStyleCancel,
    HCBCompatibleAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, HCBCompatibleAlertControllerStyle) {
    HCBCompatibleAlertControllerStyleActionSheet = 0,
    HCBCompatibleAlertControllerStyleAlert
};

@interface HCBCompatibleAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(HCBCompatibleAlertActionStyle)style handler:(void (^ __nullable)(HCBCompatibleAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) HCBCompatibleAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface HCBCompatibleAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(HCBCompatibleAlertControllerStyle)preferredStyle;

- (void)addAction:(HCBCompatibleAlertAction *)action;
@property (nonatomic, readonly) NSArray<HCBCompatibleAlertAction *> *actions;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@property (nullable, nonatomic, copy) NSString *alertTitle;
@property (nullable, nonatomic, copy) NSString *alertMessage;
@property (nonatomic, readonly) HCBCompatibleAlertControllerStyle preferredStyle;

- (void)showAlert;

@end

NS_ASSUME_NONNULL_END
