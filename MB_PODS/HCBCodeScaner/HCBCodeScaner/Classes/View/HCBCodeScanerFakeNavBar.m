//
//  HCBCodeScanerFakeNavBar.m
//  HCBPetrol-PetrolPodsBundle
//
//  Created by Li Trevor on 2018/12/12.
//

#import "HCBCodeScanerFakeNavBar.h"
#import "UIImage+HCBCodeScanerExtension.h"
@import MBUIKit;

@interface HCBCodeScanerFakeNavBar ()

@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation HCBCodeScanerFakeNavBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        if (@available(iOS 8.2, *)) {
            _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        } else {
            _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setLeftButtons:(NSArray<UIButton *> *)leftButtons {
    if (_leftButtons) {
        [_leftButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    _leftButtons = leftButtons;
    [_leftButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self addSubview:obj];
    }];
    [self setNeedsLayout];
}

- (void)setRightButtons:(NSArray<UIButton *> *)rightButtons {
    if (_rightButtons) {
        [_rightButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    _rightButtons = rightButtons;
    [_rightButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self addSubview:obj];
    }];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    __block CGFloat left = 10;
    __block CGFloat right = 10;
    if (_leftButtons) {
        [_leftButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [obj sizeToFit];
            obj.height = MAX(40, obj.height);
            if (obj.width < 40) {
                obj.width = 40;
            }
            obj.x = left;
            obj.centerY = self.height - 22;
            left += obj.width + 10;
        }];
    }

    if (_rightButtons) {
        [_rightButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [obj sizeToFit];
            obj.height = MAX(40, obj.height);
            if (obj.width < 40) {
                obj.width = 40;
            }
            obj.right = self.width - right;
            obj.centerY = self.height - 22;
            right -= obj.width - 10;
        }];
    }

    if (_titleLabel) {
        CGFloat space = self.width - MAX(left, right) * 2;
        _titleLabel.size = CGSizeMake(space, 44);
        _titleLabel.centerX = self.width / 2.f;
        _titleLabel.bottom = self.height;
    }
}

- (void)addPopBackButtonForViewController:(UIViewController *)aViewController {
    _viewController = aViewController;
    if (self.popBackButton && [[self.leftButtons firstObject] isEqual:self.popBackButton]) {
        return;
    }
    if (!self.popBackButton) {
        _popBackButton = [UIButton new];
        [_popBackButton setImage:[[UIImage imageNamed_CodeScaner:@"back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _popBackButton.imageView.tintColor = [UIColor whiteColor];
        [_popBackButton addTarget:self action:@selector(onPressPopBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    NSMutableArray *tmp = self.leftButtons.mutableCopy;
    if (!tmp) {
        tmp = @[].mutableCopy;
    }
    [tmp removeObject:_popBackButton];
    [tmp insertObject:_popBackButton atIndex:0];
    self.leftButtons = tmp.copy;
}

- (void)onPressPopBackButtonAction {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
