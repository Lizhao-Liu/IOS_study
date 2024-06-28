//
//  HCBCodeScanerFakeNavBar.h
//  HCBPetrol-PetrolPodsBundle
//
//  Created by Li Trevor on 2018/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCBCodeScanerFakeNavBar : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray<UIButton *> *leftButtons;
@property (nonatomic, strong) NSArray<UIButton *> *rightButtons;
@property (nonatomic, strong) UIButton *popBackButton;

- (void)addPopBackButtonForViewController:(UIViewController *)aViewController;

@end

NS_ASSUME_NONNULL_END
