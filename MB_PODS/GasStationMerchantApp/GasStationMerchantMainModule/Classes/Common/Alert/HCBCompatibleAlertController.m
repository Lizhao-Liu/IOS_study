//
//  HCBCompatibleAlertController.m
//  NewDriver4iOS
//
//  Created by AugustineReinhardt on 16/6/14.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "HCBCompatibleAlertController.h"

#define iOS_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS_8_LATER     (iOS_System_Version >= 8.0)

typedef void(^HCBCompatibleAlertActionHandler)(HCBCompatibleAlertAction *action);

@interface HCBCompatibleAlertAction ()

@property (nonatomic, copy) HCBCompatibleAlertActionHandler hander;

@end

@implementation HCBCompatibleAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(HCBCompatibleAlertActionStyle)style handler:(void (^)(HCBCompatibleAlertAction * _Nonnull))handler {
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(HCBCompatibleAlertActionStyle)style handler:(void (^)(HCBCompatibleAlertAction * _Nonnull))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _hander = handler;
    }
    return self;
}

@end

typedef void(^HCBCompatibleTextFieldConfigurationHandler)(UITextField *textField);

@interface HCBCompatibleAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UIAlertController *alertController;
@property (nonatomic, weak) UIAlertView *alertView;
@property (nonatomic, weak) UIActionSheet *actionSheet;

@property (nonatomic, strong) NSArray<HCBCompatibleTextFieldConfigurationHandler> *textFieldConfigurationHandlers;

@end

@implementation HCBCompatibleAlertController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(HCBCompatibleAlertControllerStyle)preferredStyle; {
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)alertTitle message:(NSString *)alertMessage preferredStyle:(HCBCompatibleAlertControllerStyle)preferredStyle {
    if (self = [super init]) {
        _alertTitle = alertTitle;
        _alertMessage = alertMessage;
        _preferredStyle = preferredStyle;
    }
    return self;
}

- (void)showAlert {
    if (iOS_8_LATER) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[self currentViewController] presentViewController:self animated:NO completion:^{
            [self showAlertController];
        }];
    } else {
        [self currentViewController].modalPresentationStyle = UIModalPresentationCurrentContext;
        [[self currentViewController] presentViewController:self animated:NO completion:^{
            [self currentViewController].modalPresentationStyle = UIModalPresentationFullScreen;
            [self showAlertView];
        }];
    }
}

- (void)addAction:(HCBCompatibleAlertAction *)action {
    NSMutableArray<HCBCompatibleAlertAction *> *tempArray = [NSMutableArray arrayWithArray:self.actions];
    [tempArray addObject:action];
    _actions = [NSArray arrayWithArray:tempArray];
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    NSMutableArray<HCBCompatibleTextFieldConfigurationHandler> *tempArray = [NSMutableArray arrayWithArray:self.textFieldConfigurationHandlers];
    [tempArray addObject:configurationHandler];
    _textFieldConfigurationHandlers = [NSArray arrayWithArray:tempArray];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    HCBCompatibleAlertAction *action = self.actions[buttonIndex];
    
    if (action.hander) {
        action.hander(action);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    HCBCompatibleAlertAction *action = self.actions[buttonIndex];
    
    if (action.hander) {
        action.hander(action);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Private Methods
- (void)showAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.alertTitle message:self.alertMessage preferredStyle:[self alertControllerStyleWithStyle:self.preferredStyle]];
    _alertController = alertController;
    
    for (HCBCompatibleAlertAction *hcb_action in self.actions) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:hcb_action.title style:[self alertActionStyleWithStyle:hcb_action.style] handler:^(UIAlertAction * _Nonnull action) {
            if (hcb_action.hander) {
                hcb_action.hander(hcb_action);
            }
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [alertController addAction:action];
    }
    
    for (HCBCompatibleTextFieldConfigurationHandler handler in self.textFieldConfigurationHandlers) {
        [alertController addTextFieldWithConfigurationHandler:handler];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertView {
    if (self.preferredStyle == HCBCompatibleAlertControllerStyleAlert) {
        HCBCompatibleAlertAction *cancelAction = nil;
        NSMutableArray<HCBCompatibleAlertAction *> *otherActions = [NSMutableArray array];
        for (HCBCompatibleAlertAction *action in self.actions) {
            if (HCBCompatibleAlertActionStyleCancel == action.style) {
                cancelAction = action;
            } else {
                [otherActions addObject:action];
            }
        }
        
        NSMutableArray<HCBCompatibleAlertAction *> *temp = [NSMutableArray array];
        if (cancelAction) {
            [temp addObject:cancelAction];
        }
        if (otherActions.count) {
            [temp addObjectsFromArray:otherActions];
        }
        _actions = [NSArray arrayWithArray:temp];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:self.alertTitle message:self.alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        _alertView = alertView;
        
        for (NSInteger i = 0; i < self.actions.count; i++) {
            [alertView addButtonWithTitle:self.actions[i].title];
        }
        
        if (cancelAction) {
            alertView.cancelButtonIndex = 0;
        }
        
        if (self.textFieldConfigurationHandlers.count == 1) {
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            self.textFieldConfigurationHandlers[0]([alertView textFieldAtIndex:0]);
        } else if (self.textFieldConfigurationHandlers.count == 2) {
            alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            tf1.placeholder = nil;
            UITextField *tf2 = [alertView textFieldAtIndex:1];
            tf2.placeholder = nil;
            tf2.secureTextEntry = NO;
            self.textFieldConfigurationHandlers[0](tf1);
            self.textFieldConfigurationHandlers[1](tf2);
        } else if (self.textFieldConfigurationHandlers.count > 2) {
            alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            NSMutableArray<HCBCompatibleTextFieldConfigurationHandler> *tempArray = [NSMutableArray arrayWithArray:self.textFieldConfigurationHandlers];
            [tempArray removeObjectsInRange:NSMakeRange(2, tempArray.count-2)];
            _textFieldConfigurationHandlers = [NSArray arrayWithArray:tempArray];
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            tf1.placeholder = nil;
            UITextField *tf2 = [alertView textFieldAtIndex:1];
            tf2.placeholder = nil;
            tf2.secureTextEntry = NO;
            self.textFieldConfigurationHandlers[0](tf1);
            self.textFieldConfigurationHandlers[1](tf2);
        }
        
        [alertView show];
    } else if (self.preferredStyle == HCBCompatibleAlertControllerStyleActionSheet) {
        
        //暂存cancel、destrutive
        HCBCompatibleAlertAction *cancelAction = nil;
        HCBCompatibleAlertAction *destructiveAction = nil;
        NSMutableArray<HCBCompatibleAlertAction *> *defaultActions = [NSMutableArray array];
        for (HCBCompatibleAlertAction *action in self.actions) {
            if (HCBCompatibleAlertActionStyleCancel == action.style) {
                cancelAction = action;
            } else if (HCBCompatibleAlertActionStyleDestructive == action.style) {
                destructiveAction = action;
            } else {
                [defaultActions addObject:action];
            }
        }
        
        //重新构造self.actions
        NSMutableArray<HCBCompatibleAlertAction *> *temp = [NSMutableArray array];
        if (destructiveAction) {
            [temp addObject:destructiveAction];
        }
        if (defaultActions.count) {
            [temp addObjectsFromArray:defaultActions];
        }
        if (cancelAction) {
            [temp addObject:cancelAction];
        }
        _actions = [NSArray arrayWithArray:temp];
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:self.alertTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        _actionSheet = actionSheet;
        
        for (NSInteger i = 0; i < self.actions.count; i++) {
            [actionSheet addButtonWithTitle:self.actions[i].title];
        }
        
        if (destructiveAction) {
            actionSheet.destructiveButtonIndex = 0;
        }
        
        if (cancelAction) {
            actionSheet.cancelButtonIndex = self.actions.count - 1;
        }
        
        [actionSheet showInView:self.view];
    }
}

- (UIAlertControllerStyle)alertControllerStyleWithStyle:(HCBCompatibleAlertControllerStyle)style {
    switch (style) {
        case HCBCompatibleAlertControllerStyleActionSheet:
            return UIAlertControllerStyleActionSheet;
        case HCBCompatibleAlertControllerStyleAlert:
            return UIAlertControllerStyleAlert;
        default:
            break;
    }
}

- (UIAlertActionStyle)alertActionStyleWithStyle:(HCBCompatibleAlertActionStyle)style {
    switch (style) {
        case HCBCompatibleAlertActionStyleDefault:
            return UIAlertActionStyleDefault;
            break;
        case HCBCompatibleAlertActionStyleCancel:
            return UIAlertActionStyleCancel;
        case HCBCompatibleAlertActionStyleDestructive:
            return UIAlertActionStyleDestructive;
        default:
            break;
    }
}

- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

- (void)dealloc {
    NSLog(@"---------controller has been dealloc!!!---------");
    NSLog(@"%@", _alertController);
    NSLog(@"%@", _alertView);
    NSLog(@"%@", _actionSheet);
}

@end
