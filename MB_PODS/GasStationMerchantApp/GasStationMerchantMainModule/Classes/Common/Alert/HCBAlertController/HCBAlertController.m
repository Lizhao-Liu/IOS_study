//
//  HCBAlertController.m
//  HCBAlertController
//
//  Created by AugustineReinhardt on 16/7/7.
//  Copyright © 2016年 Reinhardt. All rights reserved.
//

#import "HCBAlertController.h"

#define iOS_System_Version                  [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS_8_LATER                         (iOS_System_Version >= 8.0)
#define kScreenWidth                        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                       [UIScreen mainScreen].bounds.size.height
#define kActionSheetMargin                  (10.f)
#define kActionSheetCellDefaultHeight       (57.f)
#define kAlertCellDefaultHeight             (44.f)
#define kAlertViewDefaultWidth              (270.f)
#define kFooterViewDefaultHeight            (57.f)
#define kFooterViewTopMarginDefaultHeight   (8.f)

#pragma mark - CollectionSeparatorView
@interface CollectionSeparatorView : UICollectionReusableView
@end

@implementation CollectionSeparatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    }
    
    return self;
}

@end

#pragma mark - HCBAlertControllerCollectionViewLayout
@interface HCBAlertControllerCollectionViewLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) BOOL isShowFirstRowSeparator;
@property (assign, nonatomic) HCBAlertControllerStyle style;

@end

@implementation HCBAlertControllerCollectionViewLayout
- (instancetype)initWithStyle:(HCBAlertControllerStyle)style showFirstRowSeparator:(BOOL)isShowFirstRowSeparator {
    self = [super init];
    if (self) {
        _style = style;
        _isShowFirstRowSeparator = isShowFirstRowSeparator;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat lineWidth = 0.5f;
    NSMutableArray *decorationAttributes = [[NSMutableArray alloc] initWithCapacity:layoutAttributesArray.count];
    switch (_style) {
        case HCBAlertControllerStyleCustomizableActionSheet: {
            if (_isShowFirstRowSeparator) {
                for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
                    NSIndexPath *indexPath = layoutAttributes.indexPath;
                    UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                    CGRect cellFrame = layoutAttributes.frame;
                    
                    separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, 0.5);
                    separatorAttributes.zIndex = 1000;
                    [decorationAttributes addObject:separatorAttributes];
                }
            } else {
                for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
                    NSIndexPath *indexPath = layoutAttributes.indexPath;
                    if (indexPath.item > 0) {
                        UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                        CGRect cellFrame = layoutAttributes.frame;
                        
                        separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, 0.5);
                        separatorAttributes.zIndex = 1000;
                        [decorationAttributes addObject:separatorAttributes];
                    }
                }
            }
            break;
        }
        case HCBAlertControllerStyleCustomizableAlert: {
            if (layoutAttributesArray.count == 2) {
                if (_isShowFirstRowSeparator) {
                    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
                        NSIndexPath *indexPath = layoutAttributes.indexPath;
                        if (indexPath.item == 0) {
                            UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                            CGRect cellFrame = layoutAttributes.frame;
                            separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width * 2, 0.5);
                            separatorAttributes.zIndex = 1000;
                            [decorationAttributes addObject:separatorAttributes];
                        } else {
                            UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                            CGRect cellFrame = layoutAttributes.frame;
                            separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, lineWidth, cellFrame.size.height);
                            separatorAttributes.zIndex = 1000;
                            [decorationAttributes addObject:separatorAttributes];
                        }
                    }
                } else {
                    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
                        NSIndexPath *indexPath = layoutAttributes.indexPath;
                        if (indexPath.item != 0) {
                            UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                            CGRect cellFrame = layoutAttributes.frame;
                            separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, lineWidth, cellFrame.size.height);
                            separatorAttributes.zIndex = 1000;
                            [decorationAttributes addObject:separatorAttributes];
                        }
                    }
                }
            } else {
                if (_isShowFirstRowSeparator) {
                    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
                        NSIndexPath *indexPath = layoutAttributes.indexPath;
                        UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                        CGRect cellFrame = layoutAttributes.frame;
                        
                        separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, 0.5);
                        separatorAttributes.zIndex = 1000;
                        [decorationAttributes addObject:separatorAttributes];
                    }
                } else {
                    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
                        NSIndexPath *indexPath = layoutAttributes.indexPath;
                        if (indexPath.item > 0) {
                            UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"Separator" withIndexPath:indexPath];
                            CGRect cellFrame = layoutAttributes.frame;
                            
                            separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, 0.5);
                            separatorAttributes.zIndex = 1000;
                            [decorationAttributes addObject:separatorAttributes];
                        }
                    }
                }
            }
        }
        default:
            break;
    }
    return [layoutAttributesArray arrayByAddingObjectsFromArray:decorationAttributes];
}
@end

#pragma mark - HCBAlertControllerActionView
@interface HCBAlertControllerActionView ()

@property (strong, nonatomic) HCBAlertAction *action;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@end

@implementation HCBAlertControllerActionView

- (instancetype)initWithAction:(HCBAlertAction *)action {
    if (self = [super init]) {
        _action = action;
        [self configureViewWithAction];
    }
    
    return self;
}

- (void)configureViewWithAction {
    if (_action.title && _action.title.length > 0) {
        self.textLabel.text = _action.title;
    }
}

- (UIFont *)adjustTextLabelFontWithAction {
    switch (_action.style) {
        case HCBAlertActionStyleDefault: {
            return [UIFont systemFontOfSize:17.f];
        }
        case HCBAlertActionStyleCancel:{
            return [UIFont systemFontOfSize:17.f weight:UIFontWeightSemibold];
        }
        default:
            return [UIFont systemFontOfSize:17.f];
    }
}

#pragma mark Action View Getter && Setter
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.font = [self adjustTextLabelFontWithAction];
        
        [self addSubview:_textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    return _textLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_leftImageView];
        
        [_leftImageView addConstraint:[NSLayoutConstraint constraintWithItem:_leftImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_leftImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [_leftImageView addConstraint:[NSLayoutConstraint constraintWithItem:_leftImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:22.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:12.f]];
    }
    
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_rightImageView];
        
        [_rightImageView addConstraint:[NSLayoutConstraint constraintWithItem:_rightImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_rightImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [_rightImageView addConstraint:[NSLayoutConstraint constraintWithItem:_rightImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:22.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-12.f]];
    }
    
    return _rightImageView;
}

@end

#pragma mark - HCBAlertAction
typedef void(^HCBAlertActionHandler)(HCBAlertAction *action);

@interface HCBAlertAction ()

@property (nonatomic, copy) HCBAlertActionHandler hander;

@end

@implementation HCBAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(HCBAlertActionStyle)style handler:(void (^)(HCBAlertAction * _Nonnull))handler {
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(HCBAlertActionStyle)style handler:(void (^)(HCBAlertAction * _Nonnull))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _hander = handler;
    }
    return self;
}

@end

#pragma mark - HCBAlertController
typedef void(^HCBTextFieldConfigurationHandler)(UITextField *textField);

@interface HCBAlertController ()

@property (nullable, nonatomic, copy) NSAttributedString *alertAttributedMessage;

@property (strong, nonatomic) NSArray<HCBAlertAction *> *actions;
@property (strong, nonatomic) HCBAlertAction *cancelAction;
//@property (strong, nonatomic) HCBAlertControllerModalTransitionDelegate *modalTransitionDelegate;
@property (nonatomic, strong) NSArray<HCBTextFieldConfigurationHandler> *textFieldConfigurationHandlers;

@end

@implementation HCBAlertController

static NSString *const kCellReuseIdentifier = @"AlertControllerCollectionViewCellReuseIdentifier";
static NSString *const kHeaderViewReuseIdentifier = @"AlertControllerCollectionViewHeaderViewReuseIdentifier";
#pragma mark Public
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(HCBAlertControllerStyle)preferredStyle; {
    return [[self alloc] initWithTitle:title message:message attributedMessage:nil preferredStyle:preferredStyle];
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title attributedMessage:(nullable NSAttributedString *)attributedMessage preferredStyle:(HCBAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitle:title message:nil attributedMessage:attributedMessage preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)alertTitle message:(NSString *)alertMessage attributedMessage:(nullable NSAttributedString *)alertAttributedMessage preferredStyle:(HCBAlertControllerStyle)preferredStyle {
    switch (preferredStyle) {
        case HCBAlertControllerStyleActionSheet:
        case HCBAlertControllerStyleAlert:
            self = [[HCBNativeAlertController alloc]init];
            if (self) {
                _alertTitle = alertTitle;
                _alertMessage = alertMessage;
                _alertAttributedMessage = alertAttributedMessage;
                _preferredStyle = preferredStyle;
            }
            return self;
            break;
            
        default:
            self = [[HCBCustomizableAlertController alloc] initWithNibName:@"HCBCustomizableAlertController" bundle:nil];
            if (self) {
                _alertTitle = alertTitle;
                _alertMessage = alertMessage;
                _preferredStyle = preferredStyle;
                // TODO 自定义AlertController attributed string支持
            }
            return self;
            break;
    }
}

- (void)addAction:(HCBAlertAction *)action {
    if (action.style == HCBAlertActionStyleCancel) {
        self.cancelAction = action;
        return;
    }
    NSMutableArray<HCBAlertAction *> *tempArray = [NSMutableArray arrayWithArray:self.actions];
    [tempArray addObject:action];
    _actions = [NSArray arrayWithArray:tempArray];
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    NSMutableArray<HCBTextFieldConfigurationHandler> *tempArray = [NSMutableArray arrayWithArray:self.textFieldConfigurationHandlers];
    [tempArray addObject:configurationHandler];
    _textFieldConfigurationHandlers = [NSArray arrayWithArray:tempArray];
}

#pragma mark Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //处理Style Alert actions数组
    switch (self.preferredStyle) {
        case HCBAlertControllerStyleCustomizableActionSheet:
            break;
        case HCBAlertControllerStyleCustomizableAlert: {
            if (self.cancelAction) {
                if (self.actions.count > 1) {
                    NSMutableArray<HCBAlertAction *> *tempArray = [NSMutableArray arrayWithArray:self.actions];
                    [tempArray addObject:self.cancelAction];
                    _actions = [NSArray arrayWithArray:tempArray];
                } else {
                    NSMutableArray<HCBAlertAction *> *tempArray = [NSMutableArray arrayWithArray:self.actions];
                    [tempArray insertObject:self.cancelAction atIndex:0];
                    _actions = [NSArray arrayWithArray:tempArray];
                }
            }
            break;
        }
        case HCBAlertControllerStyleActionSheet:
        case HCBAlertControllerStyleAlert: {
            if (self.cancelAction) {
                NSMutableArray<HCBAlertAction *> *tempArray = [NSMutableArray arrayWithArray:self.actions];
                [tempArray insertObject:self.cancelAction atIndex:0];
//                [tempArray addObject:self.cancelAction];
                _actions = [NSArray arrayWithArray:tempArray];
            }
        }
        default:
            break;
    }
}
@end

#pragma mark - HCBNativeAlertController
@interface HCBNativeAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>
@end

@implementation HCBNativeAlertController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    switch (self.preferredStyle) {
        case HCBAlertControllerStyleActionSheet:
        case HCBAlertControllerStyleAlert: {
            if (iOS_8_LATER) {
                [self showAlertController];
            } else {
                [self showAlertViewOrActionSheet];
            }
            break;
        }
        default:
            break;
    }
}

- (void)showAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.alertTitle message:self.alertMessage preferredStyle:[self alertControllerStyleWithStyle:self.preferredStyle]];
    
    if (self.alertAttributedMessage) {
        [alertController setValue:self.alertAttributedMessage forKey:@"attributedMessage"];
    }
    
    for (HCBAlertAction *hcb_action in self.actions) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:hcb_action.title style:[self alertActionStyleWithStyle:hcb_action.style] handler:^(UIAlertAction * _Nonnull action) {
            if (hcb_action.hander) {
                [self dismissViewControllerAnimated:NO completion:^{
                    hcb_action.hander(hcb_action);
                }];
            } else {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }];
        [alertController addAction:action];
    }
    
    // 注释代码为添加textField 暂未放开
    for (HCBTextFieldConfigurationHandler handler in self.textFieldConfigurationHandlers) {
        [alertController addTextFieldWithConfigurationHandler:handler];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertViewOrActionSheet {
    if (self.preferredStyle == HCBAlertControllerStyleAlert) {
        HCBAlertAction *cancelAction = nil;
        NSMutableArray<HCBAlertAction *> *otherActions = [NSMutableArray array];
        for (HCBAlertAction *action in self.actions) {
            if (HCBAlertActionStyleCancel == action.style) {
                cancelAction = action;
            } else {
                [otherActions addObject:action];
            }
        }
        
        NSMutableArray<HCBAlertAction *> *temp = [NSMutableArray array];
        if (cancelAction) {
            [temp addObject:cancelAction];
        }
        if (otherActions.count) {
            [temp addObjectsFromArray:otherActions];
        }
        self.actions = [NSArray arrayWithArray:temp];
        
        if (self.alertAttributedMessage) {
            self.alertMessage = self.alertAttributedMessage.string;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:self.alertTitle message:self.alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        for (NSInteger i = 0; i < self.actions.count; i++) {
            [alertView addButtonWithTitle:self.actions[i].title];
        }
        
        if (cancelAction) {
            alertView.cancelButtonIndex = 0;
        }
        
        // 注释代码为添加textField 暂未放开
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
            NSMutableArray<HCBTextFieldConfigurationHandler> *tempArray = [NSMutableArray arrayWithArray:self.textFieldConfigurationHandlers];
            [tempArray removeObjectsInRange:NSMakeRange(2, tempArray.count-2)];
            self.textFieldConfigurationHandlers = [NSArray arrayWithArray:tempArray];
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            tf1.placeholder = nil;
            UITextField *tf2 = [alertView textFieldAtIndex:1];
            tf2.placeholder = nil;
            tf2.secureTextEntry = NO;
            self.textFieldConfigurationHandlers[0](tf1);
            self.textFieldConfigurationHandlers[1](tf2);
        }
        
        [alertView show];
    } else if (self.preferredStyle == HCBAlertControllerStyleActionSheet) {
        
        //暂存cancel、destrutive
        HCBAlertAction *cancelAction = nil;
        HCBAlertAction *destructiveAction = nil;
        NSMutableArray<HCBAlertAction *> *defaultActions = [NSMutableArray array];
        for (HCBAlertAction *action in self.actions) {
            if (HCBAlertActionStyleCancel == action.style) {
                cancelAction = action;
            } else if (HCBAlertActionStyleDestructive == action.style) {
                destructiveAction = action;
            } else {
                [defaultActions addObject:action];
            }
        }
        
        //重新构造self.actions
        NSMutableArray<HCBAlertAction *> *temp = [NSMutableArray array];
        if (destructiveAction) {
            [temp addObject:destructiveAction];
        }
        if (defaultActions.count) {
            [temp addObjectsFromArray:defaultActions];
        }
        if (cancelAction) {
            [temp addObject:cancelAction];
        }
        self.actions = [NSArray arrayWithArray:temp];
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:self.alertTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
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

- (UIAlertControllerStyle)alertControllerStyleWithStyle:(HCBAlertControllerStyle)style {
    switch (style) {
        case HCBAlertControllerStyleActionSheet:
            return UIAlertControllerStyleActionSheet;
        case HCBAlertControllerStyleAlert:
            return UIAlertControllerStyleAlert;
        default:
            return UIAlertControllerStyleAlert;
    }
}

- (UIAlertActionStyle)alertActionStyleWithStyle:(HCBAlertActionStyle)style {
    switch (style) {
        case HCBAlertActionStyleDefault:
            return UIAlertActionStyleDefault;
            break;
        case HCBAlertActionStyleCancel:
            return UIAlertActionStyleCancel;
        case HCBAlertActionStyleDestructive:
            return UIAlertActionStyleDestructive;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    HCBAlertAction *action = self.actions[buttonIndex];
    
    if (action.hander) {
        [self dismissViewControllerAnimated:NO completion:^{
            action.hander(action);
        }];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    HCBAlertAction *action = self.actions[buttonIndex];
    
    if (action.hander) {
        [self dismissViewControllerAnimated:NO completion:^{
            action.hander(action);
        }];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end

#pragma mark - HCBCustomizableAlertController
@interface HCBCustomizableAlertController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *alertControllerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerViewBottomMarginCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerViewCenterYCons;

// Header View
@property (strong, nonatomic) UIView *alertControllerHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerHeaderViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerHeaderViewTitleTopMarginCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerHeaderViewTitleMessageMarginCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertControllerHeaderViewMessageBottomMarginCons;

// Footer View
@property (weak, nonatomic) IBOutlet UIView *alertControllerFooterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FooterViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FooterViewTopMarginCons;
@property (strong, nonatomic) HCBAlertControllerActionView *cancelActionView;

// Action CollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *actionCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionCollectionViewHeightCons;

@property (strong, nonatomic) HCBAlertControllerModalTransitionDelegate *modalTransitionDelegate;

@end

@implementation HCBCustomizableAlertController

#pragma mark Life Circle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _modalTransitionDelegate = [[HCBAlertControllerModalTransitionDelegate alloc]init];
        self.transitioningDelegate = _modalTransitionDelegate;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (self.preferredStyle) {
        case HCBAlertControllerStyleCustomizableActionSheet:{
            [self setupAlertControllerStyleActionSheetHeaderView];
            [self setupAlertControllerStyleActionSheetFooterView];
            [self setupAlertControllerStyleActionSheetActionCollectionView];
            break;
        }
        case HCBAlertControllerStyleCustomizableAlert: {
            [self setupAlertControllerStyleAlertHeaderView];
            [self setupAlertControllerStyleAlertFooterView];
            [self setupAlertControllerStyleAlertActionCollectionView];
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    switch (self.preferredStyle) {
        case HCBAlertControllerStyleCustomizableActionSheet:{
            [self updateAlertControllerStyleActionSheetViewCons];
            [self updateAlertControllerStyleActionSheetHeaderViewCons];
            [self updateAlertControllerStyleActionSheetFooterViewCons];
            [self updateAlertControllerStyleActionSheetActionCollectionViewCons];
            break;
        }
        case HCBAlertControllerStyleCustomizableAlert: {
            [self updateAlertControllerStyleAlertViewCons];
            [self updateAlertControllerStyleAlertHeaderViewCons];
            [self updateAlertControllerStyleAlertFooterViewCons];
            [self updateAlertControllerStyleAlertActionCollectionViewCons];
            break;
        }
        default:
            break;
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    HCBAlertControllerActionView *view = [[HCBAlertControllerActionView alloc]initWithAction:self.actions[indexPath.row]];
    view.frame = cell.bounds;
    
    UIView *highlightBackgroundView = [[UIView alloc]init];
    highlightBackgroundView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    cell.selectedBackgroundView = highlightBackgroundView;
    
    [cell.contentView addSubview:view];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HCBAlertAction *action = self.actions[indexPath.row];
    if ([action isKindOfClass:[HCBAlertAction class]] && action.hander) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                action.hander(action);
            }];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

#pragma mark Setup Action Sheet Views
- (void)setupAlertControllerStyleActionSheetHeaderView {
    self.titleLabel.text = self.alertTitle;
    self.messageLabel.text = self.alertMessage;
}
- (void)setupAlertControllerStyleActionSheetFooterView {
    if (self.cancelAction) {
        _alertControllerFooterView.layer.cornerRadius = 10.f;
        _alertControllerFooterView.hidden = NO;
        
        if (!_cancelActionView) {
            _cancelActionView = [[HCBAlertControllerActionView alloc]initWithAction:self.cancelAction];
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleCancelActionViewPressed:)];
            gesture.minimumPressDuration = 0.001;
            [_cancelActionView addGestureRecognizer:gesture];
            
            [_alertControllerFooterView addSubview:_cancelActionView];
            _cancelActionView.frame = _alertControllerFooterView.bounds;
        }
    } else {
        _alertControllerFooterView.hidden = YES;
    }
}
- (void)setupAlertControllerStyleActionSheetActionCollectionView {
    _actionCollectionView.dataSource = self;
    _actionCollectionView.delegate = self;
    _actionCollectionView.backgroundColor = nil;
    [_actionCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    HCBAlertControllerCollectionViewLayout *layout = [[HCBAlertControllerCollectionViewLayout alloc]initWithStyle:HCBAlertControllerStyleCustomizableActionSheet showFirstRowSeparator:(self.alertTitle != nil || self.alertMessage != nil)];
    [layout registerClass:[CollectionSeparatorView class] forDecorationViewOfKind:@"Separator"];
    layout.itemSize = CGSizeMake(kScreenWidth - 20.f, kActionSheetCellDefaultHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _actionCollectionView.collectionViewLayout = layout;
}

#pragma mark Update Action Sheet Constraints
- (void)updateAlertControllerStyleActionSheetViewCons {
    _alertControllerViewWidthCons.constant = kScreenWidth - 20.f;
    [NSLayoutConstraint deactivateConstraints:@[_alertControllerViewCenterYCons]];
    [NSLayoutConstraint activateConstraints:@[_alertControllerViewBottomMarginCons]];
}

- (void)updateAlertControllerStyleActionSheetHeaderViewCons {
    if (!self.alertTitle && !self.alertMessage) {
        [NSLayoutConstraint deactivateConstraints:@[_alertControllerHeaderViewTitleTopMarginCons,_alertControllerHeaderViewTitleMessageMarginCons,_alertControllerHeaderViewMessageBottomMarginCons]];
        [NSLayoutConstraint activateConstraints:@[_alertControllerHeaderViewHeightCons]];
    } else {
        [NSLayoutConstraint deactivateConstraints:@[_alertControllerHeaderViewHeightCons]];
        [NSLayoutConstraint activateConstraints:@[_alertControllerHeaderViewTitleTopMarginCons,_alertControllerHeaderViewTitleMessageMarginCons,_alertControllerHeaderViewMessageBottomMarginCons]];
    }
}

- (void)updateAlertControllerStyleActionSheetFooterViewCons {
    if (self.cancelAction) {
        _FooterViewHeightCons.constant = kFooterViewDefaultHeight;
        _FooterViewTopMarginCons.constant = kFooterViewTopMarginDefaultHeight;
        
        _cancelActionView.frame = _alertControllerFooterView.bounds;
    } else {
        _FooterViewHeightCons.constant = 0;
        _FooterViewTopMarginCons.constant = 0;
        _alertControllerFooterView.hidden = YES;
    }
}

- (void)updateAlertControllerStyleActionSheetActionCollectionViewCons {
    _actionCollectionViewHeightCons.constant = self.actions.count * kActionSheetCellDefaultHeight;
}

#pragma mark Setup Alert Views
- (void)setupAlertControllerStyleAlertHeaderView {
    if (!self.alertTitle && !self.alertMessage) {
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightSemibold];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.f alpha:1.f];
        self.titleLabel.text = self.alertTitle;
        self.messageLabel.font = [UIFont systemFontOfSize:13.f];
        self.messageLabel.textColor = [UIColor colorWithWhite:0.f alpha:1.f];
        self.messageLabel.text = self.alertMessage;
    }
}
- (void)setupAlertControllerStyleAlertFooterView {
    _alertControllerFooterView.hidden = YES;
}
- (void)setupAlertControllerStyleAlertActionCollectionView {
    _actionCollectionView.dataSource = self;
    _actionCollectionView.delegate = self;
    _actionCollectionView.backgroundColor = nil;
    [_actionCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    HCBAlertControllerCollectionViewLayout *layout = [[HCBAlertControllerCollectionViewLayout alloc]initWithStyle:HCBAlertControllerStyleCustomizableAlert showFirstRowSeparator:(self.alertTitle != nil || self.alertMessage != nil)];
    [layout registerClass:[CollectionSeparatorView class] forDecorationViewOfKind:@"Separator"];
    if (self.actions.count == 2) {
        layout.itemSize = CGSizeMake(kAlertViewDefaultWidth / 2, kAlertCellDefaultHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
    } else {
        layout.itemSize = CGSizeMake(kAlertViewDefaultWidth, kAlertCellDefaultHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
    }
    _actionCollectionView.collectionViewLayout = layout;
}

#pragma mark Update Alert Constraint
- (void)updateAlertControllerStyleAlertViewCons {
    _alertControllerViewWidthCons.constant = kAlertViewDefaultWidth;
    [NSLayoutConstraint deactivateConstraints:@[_alertControllerViewBottomMarginCons]];
    [NSLayoutConstraint activateConstraints:@[_alertControllerViewCenterYCons]];
}

- (void)updateAlertControllerStyleAlertHeaderViewCons {
    if (!self.alertTitle && !self.alertMessage) {
        [NSLayoutConstraint deactivateConstraints:@[_alertControllerHeaderViewTitleTopMarginCons,_alertControllerHeaderViewTitleMessageMarginCons,_alertControllerHeaderViewMessageBottomMarginCons]];
        [NSLayoutConstraint activateConstraints:@[_alertControllerHeaderViewHeightCons]];
    } else {
        _alertControllerHeaderViewTitleTopMarginCons.constant = 36.f;
        _alertControllerHeaderViewTitleMessageMarginCons.constant = 24.f;
        _alertControllerHeaderViewMessageBottomMarginCons.constant = 24.f;
        
        [NSLayoutConstraint deactivateConstraints:@[_alertControllerHeaderViewHeightCons]];
        [NSLayoutConstraint activateConstraints:@[_alertControllerHeaderViewTitleTopMarginCons,_alertControllerHeaderViewTitleMessageMarginCons,_alertControllerHeaderViewMessageBottomMarginCons]];
    }
}

- (void)updateAlertControllerStyleAlertFooterViewCons {
    _FooterViewHeightCons.constant = 0;
    _FooterViewTopMarginCons.constant = 0;
}

- (void)updateAlertControllerStyleAlertActionCollectionViewCons {
    _actionCollectionViewHeightCons.constant = self.actions.count == 2 ? kAlertCellDefaultHeight : self.actions.count * kAlertCellDefaultHeight;
}

#pragma mark HandleCancelActionViewPressed
- (void)handleCancelActionViewPressed:(UILongPressGestureRecognizer *)longPressGeatureRecognizer {
    switch (longPressGeatureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            longPressGeatureRecognizer.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
            break;
        case UIGestureRecognizerStateEnded:
            longPressGeatureRecognizer.view.backgroundColor = nil;
            CGPoint location = [longPressGeatureRecognizer locationInView:longPressGeatureRecognizer.view];
            BOOL touchInside = CGRectContainsPoint(longPressGeatureRecognizer.view.bounds, location);
            if (touchInside) {
                if (self.cancelAction && self.cancelAction.hander) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.cancelAction.hander(self.cancelAction);
                    }];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            longPressGeatureRecognizer.view.backgroundColor = nil;
            break;
        default:
            break;
    }
}

@end

#pragma mark - HCBAlertControllerPresentationController
@interface HCBAlertControllerPresentationController : UIPresentationController
@end

@interface HCBAlertControllerPresentationController ()

@property (strong, nonatomic) UIView *dimmingView;

@end

@implementation HCBAlertControllerPresentationController

- (void)presentationTransitionWillBegin {
    [self.containerView addSubview:[self dimmingView]];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _dimmingView.alpha = 0;
    _dimmingView.center = self.containerView.center;
    _dimmingView.bounds = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _dimmingView.alpha = 1;
    } completion:nil];
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _dimmingView.alpha = 0;
    } completion:nil];
}

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [UIView new];
    }
    
    return _dimmingView;
}

@end

#pragma mark - HCBAlertControllerModalTransitionDelegate
@implementation HCBAlertControllerModalTransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[HCBAlertControllerAnimationController alloc]init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[HCBAlertControllerAnimationController alloc]init];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[HCBAlertControllerPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

#pragma mark - HCBAlertControllerAnimationController
@implementation HCBAlertControllerAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (toViewController.isBeingPresented) {
        [containerView addSubview:toViewController.view];
        CGFloat toViewWidth = containerView.frame.size.width;
        CGFloat toViewHeight = containerView.frame.size.height;
        toViewController.view.center = containerView.center;
        toViewController.view.bounds = CGRectMake(0, 0, toViewWidth, toViewHeight);
        
        if ([toViewController isKindOfClass:[HCBCustomizableAlertController class]]) {
            HCBCustomizableAlertController* alertController = (HCBCustomizableAlertController *)toViewController;
            if (alertController.preferredStyle == HCBAlertControllerStyleCustomizableAlert) {
                alertController.alertControllerView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            } else if (alertController.preferredStyle == HCBAlertControllerStyleCustomizableActionSheet) {
                alertController.view.transform = CGAffineTransformMakeTranslation(0.f, containerView.frame.size.height);
            }
        }
        [containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            toViewController.view.alpha = 1.0f;
            if ([toViewController isKindOfClass:[HCBAlertController class]]) {
                HCBCustomizableAlertController* alertController = (HCBCustomizableAlertController *)toViewController;
                if (alertController.preferredStyle == HCBAlertControllerStyleCustomizableAlert) {
                    alertController.alertControllerView.transform = CGAffineTransformIdentity;
                } else if (alertController.preferredStyle == HCBAlertControllerStyleCustomizableActionSheet) {
                    alertController.view.transform = CGAffineTransformIdentity;
                }
            }
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    }
    
    if (fromViewController.isBeingDismissed) {
        UIView *containerView = [transitionContext containerView];
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            if ([fromViewController isKindOfClass:[HCBAlertController class]]) {
                HCBAlertController* alertController = (HCBAlertController *)fromViewController;
                if (alertController.preferredStyle == HCBAlertControllerStyleCustomizableActionSheet) {
                    alertController.view.transform = CGAffineTransformMakeTranslation(0.f, containerView.frame.size.height);;
                } else if (alertController.preferredStyle == HCBAlertControllerStyleCustomizableAlert) {
                    fromViewController.view.alpha = 0.0f;
                }
            }
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    }
}

@end

#pragma mark - UIViewController (HCBAlertController)
@implementation UIViewController (HCBAlertController)

- (void)alert_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[HCBAlertController class]]) {
        switch (((HCBAlertController *)viewControllerToPresent).preferredStyle) {
            case HCBAlertControllerStyleActionSheet:
            case HCBAlertControllerStyleAlert: {
                if (iOS_8_LATER) {
                    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:viewControllerToPresent animated:NO completion:completion];
                } else {
                    UIViewController *presentingVC = self;
                    UIViewController *root = self;
                    while (root.parentViewController) {
                        root = root.parentViewController;
                    }
                    UIModalPresentationStyle orginalStyle = root.modalPresentationStyle;
                    root.modalPresentationStyle = UIModalPresentationCurrentContext;
                    [presentingVC presentViewController:viewControllerToPresent animated:NO completion:^{
                        root.modalPresentationStyle = orginalStyle;
                    }];
                }
                break;
            }
            case HCBAlertControllerStyleCustomizableActionSheet:
            case HCBAlertControllerStyleCustomizableAlert: {
                [self presentViewController:viewControllerToPresent animated:flag completion:completion];
                break;
            }
        }
    } else {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end
