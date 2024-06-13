//
//  MBDebugOscillogramViewController.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <UIKit/UIKit.h>
#import "MBDebugOscillogramView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugOscillogramViewController : UIViewController

@property (nonatomic, strong) MBDebugOscillogramView *oscillogramView;
@property (nonatomic, strong) UIButton *closeBtn;

- (NSString *)title;
- (NSString *)lowValue;
- (NSString *)highValue;
- (void)closeBtnClick;
- (void)startRecord;
- (void)endRecord;
- (void)doSecondFunction;

@end

NS_ASSUME_NONNULL_END
